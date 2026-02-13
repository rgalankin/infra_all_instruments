#!/bin/bash
# yaml-validate.sh — Валидация YAML frontmatter в документации
# Использование: bash scripts/yaml-validate.sh [directory]
#
# Скрипт выполняет:
# 1. Поиск всех .md файлов в docs/
# 2. Проверку наличия YAML frontmatter (между --- маркерами)
# 3. Валидацию обязательных полей: id, title, summary, type, status, source, ai_weight, created, updated
# 4. Валидацию допустимых значений: type, status
# 5. Итоговый отчёт с ошибками и предупреждениями
#
# Допустимые значения:
#   type:      spec, index
#   status:    active, archived, draft, needs-update
#   ai_weight: high, normal, low

set -euo pipefail

# --- Цвета вывода ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Базовая директория ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"
DOCS_DIR="$REPO_DIR/docs"

# --- Счётчики ---
FILES_TOTAL=0
FILES_VALID=0
FILES_WITH_ERRORS=0
FILES_NO_FRONTMATTER=0
TOTAL_ERRORS=0
TOTAL_WARNINGS=0

# --- Допустимые значения ---
ALLOWED_TYPES="spec index"
ALLOWED_STATUSES="active archived draft needs-update"
ALLOWED_AI_WEIGHTS="high normal low"

# --- Обязательные поля ---
REQUIRED_FIELDS="id title summary type status source ai_weight created updated"

# --- Вспомогательные функции ---
error_msg() { echo -e "  ${RED}✗${NC} $1"; }
ok_msg()    { echo -e "  ${GREEN}✓${NC} $1"; }
warn_msg()  { echo -e "  ${YELLOW}⚠${NC} $1"; }
info_msg()  { echo -e "  ${CYAN}ℹ${NC} $1"; }
section()   { echo -e "\n${BOLD}${YELLOW}=== $1 ===${NC}"; }

# --- Функция: проверка, входит ли значение в допустимый список ---
value_in_list() {
    local value="$1"
    local list="$2"
    for allowed in $list; do
        if [[ "$value" == "$allowed" ]]; then
            return 0
        fi
    done
    return 1
}

# --- Функция: извлечение YAML frontmatter из файла ---
# Возвращает содержимое frontmatter (между первой и второй ---)
# Возвращает 1 если frontmatter не найден
extract_frontmatter() {
    local file="$1"
    local in_frontmatter=0
    local frontmatter_started=0
    local line_num=0
    local result=""

    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Первая строка должна быть ---
        if [[ $line_num -eq 1 ]]; then
            if [[ "$line" == "---" ]]; then
                in_frontmatter=1
                frontmatter_started=1
                continue
            else
                return 1  # Нет frontmatter
            fi
        fi

        # Закрывающий ---
        if [[ $in_frontmatter -eq 1 ]] && [[ "$line" == "---" ]]; then
            echo "$result"
            return 0
        fi

        # Собираем строки frontmatter
        if [[ $in_frontmatter -eq 1 ]]; then
            result="${result}${line}"$'\n'
        fi
    done < "$file"

    # Если дошли до конца файла без закрывающего ---
    if [[ $frontmatter_started -eq 1 ]]; then
        return 1  # Незакрытый frontmatter
    fi

    return 1
}

# --- Функция: извлечение значения поля из YAML ---
# Простой парсер для однострочных полей вида "key: value"
# Поддерживает также "key: >", "key: |", key: "value", key: 'value'
get_yaml_value() {
    local frontmatter="$1"
    local field="$2"

    # Ищем строку, начинающуюся с "field:"
    local line
    line=$(echo "$frontmatter" | grep -m1 "^${field}:" 2>/dev/null) || true

    if [[ -z "$line" ]]; then
        return 1  # Поле не найдено
    fi

    # Извлекаем значение после "field: "
    local value="${line#*: }"

    # Если значение — это > или | (multiline), считаем поле заполненным
    if [[ "$value" == ">" ]] || [[ "$value" == "|" ]] || [[ "$value" == ">-" ]]; then
        echo "(multiline)"
        return 0
    fi

    # Убираем кавычки
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"

    # Убираем пробелы
    value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    if [[ -z "$value" ]]; then
        return 1
    fi

    echo "$value"
    return 0
}

# --- Функция: валидация одного файла ---
validate_file() {
    local file="$1"
    local rel_file="${file#$REPO_DIR/}"
    local file_errors=0
    local file_warnings=0

    FILES_TOTAL=$((FILES_TOTAL + 1))

    # Извлекаем frontmatter
    local frontmatter
    frontmatter=$(extract_frontmatter "$file") || {
        FILES_NO_FRONTMATTER=$((FILES_NO_FRONTMATTER + 1))
        TOTAL_WARNINGS=$((TOTAL_WARNINGS + 1))
        warn_msg "${rel_file} — нет YAML frontmatter"
        return
    }

    # Проверяем обязательные поля
    local missing_fields=""
    for field in $REQUIRED_FIELDS; do
        local value
        if ! value=$(get_yaml_value "$frontmatter" "$field"); then
            missing_fields="${missing_fields} ${field}"
            file_errors=$((file_errors + 1))
        fi
    done

    # Сообщаем о пропущенных полях
    if [[ -n "$missing_fields" ]]; then
        error_msg "${rel_file} — отсутствуют поля:${missing_fields}"
    fi

    # Валидация допустимых значений для type
    local type_value
    if type_value=$(get_yaml_value "$frontmatter" "type"); then
        if ! value_in_list "$type_value" "$ALLOWED_TYPES"; then
            error_msg "${rel_file} — недопустимый type: '${type_value}' (допустимо: ${ALLOWED_TYPES})"
            file_errors=$((file_errors + 1))
        fi
    fi

    # Валидация допустимых значений для status
    local status_value
    if status_value=$(get_yaml_value "$frontmatter" "status"); then
        if ! value_in_list "$status_value" "$ALLOWED_STATUSES"; then
            error_msg "${rel_file} — недопустимый status: '${status_value}' (допустимо: ${ALLOWED_STATUSES})"
            file_errors=$((file_errors + 1))
        fi
    fi

    # Валидация допустимых значений для ai_weight
    local ai_weight_value
    if ai_weight_value=$(get_yaml_value "$frontmatter" "ai_weight"); then
        if ! value_in_list "$ai_weight_value" "$ALLOWED_AI_WEIGHTS"; then
            warn_msg "${rel_file} — нестандартный ai_weight: '${ai_weight_value}' (рекомендуемо: ${ALLOWED_AI_WEIGHTS})"
            file_warnings=$((file_warnings + 1))
        fi
    fi

    # Валидация формата дат (created, updated — должны быть YYYY-MM-DD)
    local date_regex='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
    for date_field in created updated; do
        local date_value
        if date_value=$(get_yaml_value "$frontmatter" "$date_field"); then
            if ! [[ "$date_value" =~ $date_regex ]]; then
                warn_msg "${rel_file} — некорректный формат ${date_field}: '${date_value}' (ожидается YYYY-MM-DD)"
                file_warnings=$((file_warnings + 1))
            fi
        fi
    done

    # Валидация id (должен быть непустым, формат: цифры и дефисы)
    local id_value
    if id_value=$(get_yaml_value "$frontmatter" "id"); then
        local id_regex='^[0-9]+-?[0-9]*$'
        if ! [[ "$id_value" =~ $id_regex ]]; then
            warn_msg "${rel_file} — нестандартный формат id: '${id_value}' (ожидается YYYYMMDDHHMMSS-NN)"
            file_warnings=$((file_warnings + 1))
        fi
    fi

    # Обновляем счётчики
    TOTAL_ERRORS=$((TOTAL_ERRORS + file_errors))
    TOTAL_WARNINGS=$((TOTAL_WARNINGS + file_warnings))

    if [[ $file_errors -gt 0 ]]; then
        FILES_WITH_ERRORS=$((FILES_WITH_ERRORS + 1))
    else
        FILES_VALID=$((FILES_VALID + 1))
    fi
}

# =============================================================================
# ОСНОВНАЯ ЛОГИКА
# =============================================================================

echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   YAML Validator — infra_all_instruments     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo "Дата: $(date '+%Y-%m-%d %H:%M')"
echo "Директория docs: $DOCS_DIR"

# Проверяем существование директории docs/
if [[ ! -d "$DOCS_DIR" ]]; then
    error_msg "Директория docs/ не найдена: $DOCS_DIR"
    exit 1
fi

# --- Также проверяем файлы в корне репо (registry и т.п.) ---
section "Проверка корневых .md файлов с frontmatter"

for root_file in "$REPO_DIR"/*.md; do
    [[ ! -f "$root_file" ]] && continue
    local_name="$(basename "$root_file")"

    # Пропускаем файлы без frontmatter по назначению (README, CLAUDE, AGENTS, ARCHITECTURE, CHANGELOG)
    case "$local_name" in
        README.md|CLAUDE.md|AGENTS.md|ARCHITECTURE.md|CHANGELOG.md)
            continue
            ;;
    esac

    # Проверяем только если файл начинается с ---
    if head -1 "$root_file" | grep -q '^---$'; then
        validate_file "$root_file"
    fi
done

# --- Проверка файлов в docs/ ---
section "Проверка docs/"

# Проходим по всем поддиректориям
for subdir in hardware infrastructure tools neural-networks mcp integrations automation analytics guides; do
    local_dir="$DOCS_DIR/$subdir"
    [[ ! -d "$local_dir" ]] && continue

    echo -e "\n  ${CYAN}${subdir}/${NC}"

    # Находим все .md файлы рекурсивно
    while IFS= read -r md_file; do
        [[ ! -f "$md_file" ]] && continue
        validate_file "$md_file"
    done < <(find "$local_dir" -name "*.md" -not -path "*/.git/*" | sort)
done

# --- Итоговый отчёт ---
section "ИТОГОВЫЙ ОТЧЁТ"

echo ""
echo -e "  ${BOLD}Файлы:${NC}"
echo -e "    Всего проверено:     ${FILES_TOTAL}"
if [[ $FILES_VALID -gt 0 ]]; then
    echo -e "    ${GREEN}Валидных:              ${FILES_VALID}${NC}"
fi
if [[ $FILES_WITH_ERRORS -gt 0 ]]; then
    echo -e "    ${RED}С ошибками:            ${FILES_WITH_ERRORS}${NC}"
else
    echo -e "    ${GREEN}С ошибками:            0${NC}"
fi
if [[ $FILES_NO_FRONTMATTER -gt 0 ]]; then
    echo -e "    ${YELLOW}Без frontmatter:       ${FILES_NO_FRONTMATTER}${NC}"
fi

echo ""
echo -e "  ${BOLD}Проблемы:${NC}"
if [[ $TOTAL_ERRORS -gt 0 ]]; then
    echo -e "    ${RED}Ошибки:                ${TOTAL_ERRORS}${NC}"
else
    echo -e "    ${GREEN}Ошибки:                0${NC}"
fi
if [[ $TOTAL_WARNINGS -gt 0 ]]; then
    echo -e "    ${YELLOW}Предупреждения:        ${TOTAL_WARNINGS}${NC}"
else
    echo -e "    ${GREEN}Предупреждения:        0${NC}"
fi

echo ""
echo -e "  ${BOLD}Допустимые значения (справка):${NC}"
echo -e "    type:      ${ALLOWED_TYPES}"
echo -e "    status:    ${ALLOWED_STATUSES}"
echo -e "    ai_weight: ${ALLOWED_AI_WEIGHTS}"

echo ""

# --- Код возврата ---
if [[ $TOTAL_ERRORS -gt 0 ]]; then
    echo -e "${RED}Обнаружены ошибки валидации: ${TOTAL_ERRORS}${NC}"
    exit 1
else
    echo -e "${GREEN}Все проверки пройдены успешно.${NC}"
    exit 0
fi
