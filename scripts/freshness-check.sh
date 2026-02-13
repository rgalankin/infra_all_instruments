#!/bin/bash
# freshness-check.sh — Проверка свежести карточек по полю updated
# Использование: bash scripts/freshness-check.sh [--days N]
#
# Для каждого .md файла в docs/ извлекает поле updated из YAML frontmatter,
# сравнивает с текущей датой и выводит stale-файлы (по умолчанию: > 30 дней).
#
# Совместим с macOS (date -j) и Linux (GNU date).

set -uo pipefail

# --- Цвета ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Параметры ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCS_DIR="$REPO_DIR/docs"
THRESHOLD_DAYS=30

# --- Парсинг аргументов ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --days)
            THRESHOLD_DAYS="$2"
            shift 2
            ;;
        --help|-h)
            echo "Использование: bash scripts/freshness-check.sh [--days N]"
            echo "  --days N    Порог свежести в днях (по умолчанию: 30)"
            exit 0
            ;;
        *)
            # Возможно путь к репозиторию
            REPO_DIR="$1"
            DOCS_DIR="$REPO_DIR/docs"
            shift
            ;;
    esac
done

# --- Вспомогательные функции (из yaml-validate.sh) ---

extract_frontmatter() {
    local file="$1"
    local in_frontmatter=0
    local frontmatter_started=0
    local line_num=0
    local result=""

    while IFS= read -r line; do
        line_num=$((line_num + 1))

        if [[ $line_num -eq 1 ]]; then
            if [[ "$line" == "---" ]]; then
                in_frontmatter=1
                frontmatter_started=1
                continue
            else
                return 1
            fi
        fi

        if [[ $in_frontmatter -eq 1 ]] && [[ "$line" == "---" ]]; then
            echo "$result"
            return 0
        fi

        if [[ $in_frontmatter -eq 1 ]]; then
            result="${result}${line}"$'\n'
        fi
    done < "$file"

    if [[ $frontmatter_started -eq 1 ]]; then
        return 1
    fi

    return 1
}

get_yaml_value() {
    local frontmatter="$1"
    local field="$2"

    local line
    line=$(echo "$frontmatter" | grep -m1 "^${field}:" 2>/dev/null) || true

    if [[ -z "$line" ]]; then
        return 1
    fi

    local value="${line#*: }"

    if [[ "$value" == ">" ]] || [[ "$value" == "|" ]] || [[ "$value" == ">-" ]]; then
        echo "(multiline)"
        return 0
    fi

    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    if [[ -z "$value" ]]; then
        return 1
    fi

    echo "$value"
    return 0
}

# --- Функция: конвертация даты в epoch (кроссплатформенная) ---
date_to_epoch() {
    local date_str="$1"
    if date -j -f "%Y-%m-%d" "$date_str" "+%s" 2>/dev/null; then
        return 0
    elif date -d "$date_str" "+%s" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# --- Основная логика ---

echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Freshness Check — infra_all_instruments    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo "Дата: $(date '+%Y-%m-%d %H:%M')"
echo "Порог: $THRESHOLD_DAYS дней"
echo "Директория: $DOCS_DIR"

if [[ ! -d "$DOCS_DIR" ]]; then
    echo -e "${RED}Директория docs/ не найдена: $DOCS_DIR${NC}"
    exit 1
fi

# Текущая дата в epoch
NOW_EPOCH=$(date "+%s")

# Счётчики
TOTAL=0
FRESH=0
STALE=0
NO_DATE=0

# Массив для stale-файлов (файл|дней_назад|дата)
declare -a STALE_FILES=()

# Также проверяем корневые .md с frontmatter
ALL_FILES=()
while IFS= read -r f; do
    ALL_FILES+=("$f")
done < <(find "$REPO_DIR" -maxdepth 1 -name "*.md" -not -name "README.md" -not -name "CLAUDE.md" -not -name "AGENTS.md" -not -name "ARCHITECTURE.md" -not -name "CHANGELOG.md" | sort)

while IFS= read -r f; do
    ALL_FILES+=("$f")
done < <(find "$DOCS_DIR" -name "*.md" -not -path "*/.git/*" | sort)

for file in "${ALL_FILES[@]}"; do
    [[ ! -f "$file" ]] && continue

    # Проверяем что файл начинается с ---
    first_line=$(head -1 "$file")
    [[ "$first_line" != "---" ]] && continue

    TOTAL=$((TOTAL + 1))
    rel_file="${file#$REPO_DIR/}"

    # Извлекаем frontmatter
    frontmatter=$(extract_frontmatter "$file") || continue

    # Извлекаем updated
    updated_date=$(get_yaml_value "$frontmatter" "updated") || {
        NO_DATE=$((NO_DATE + 1))
        continue
    }

    # Проверяем формат даты
    date_regex='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
    if ! [[ "$updated_date" =~ $date_regex ]]; then
        NO_DATE=$((NO_DATE + 1))
        continue
    fi

    # Конвертируем в epoch
    file_epoch=$(date_to_epoch "$updated_date") || {
        NO_DATE=$((NO_DATE + 1))
        continue
    }

    # Вычисляем разницу в днях
    diff_seconds=$((NOW_EPOCH - file_epoch))
    diff_days=$((diff_seconds / 86400))

    if [[ $diff_days -gt $THRESHOLD_DAYS ]]; then
        STALE=$((STALE + 1))
        STALE_FILES+=("${diff_days}|${updated_date}|${rel_file}")
    else
        FRESH=$((FRESH + 1))
    fi
done

# --- Вывод результатов ---

echo ""
echo -e "${BOLD}Результаты:${NC}"
echo -e "  Всего файлов с frontmatter: ${TOTAL}"
echo -e "  ${GREEN}Свежие (≤ ${THRESHOLD_DAYS} дней):    ${FRESH}${NC}"
if [[ $STALE -gt 0 ]]; then
    echo -e "  ${RED}Устаревшие (> ${THRESHOLD_DAYS} дней): ${STALE}${NC}"
else
    echo -e "  ${GREEN}Устаревшие (> ${THRESHOLD_DAYS} дней): 0${NC}"
fi
if [[ $NO_DATE -gt 0 ]]; then
    echo -e "  ${YELLOW}Без даты updated:          ${NO_DATE}${NC}"
fi

# Вывод stale-файлов, отсортированных по давности
if [[ ${#STALE_FILES[@]} -gt 0 ]]; then
    echo ""
    echo -e "${BOLD}${RED}Устаревшие файлы (отсортированы по давности):${NC}"

    # Сортируем по числу дней (первое поле, числовая сортировка, по убыванию)
    IFS=$'\n' sorted=($(printf '%s\n' "${STALE_FILES[@]}" | sort -t'|' -k1 -rn))
    unset IFS

    for entry in "${sorted[@]}"; do
        days="${entry%%|*}"
        rest="${entry#*|}"
        date="${rest%%|*}"
        file="${rest#*|}"
        echo -e "  ${RED}${days} дн.${NC} (${date}) ${file}"
    done
fi

echo ""

# --- Код возврата ---
if [[ $STALE -gt 0 ]]; then
    echo -e "${YELLOW}Найдено ${STALE} устаревших файлов (порог: ${THRESHOLD_DAYS} дней).${NC}"
    exit 1
else
    echo -e "${GREEN}Все файлы свежие (порог: ${THRESHOLD_DAYS} дней).${NC}"
    exit 0
fi
