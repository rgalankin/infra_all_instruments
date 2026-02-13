#!/bin/bash
# link-checker.sh — Проверка wikilinks в документации
# Использование: bash scripts/link-checker.sh [directory]
#
# Скрипт выполняет:
# 1. Поиск всех [[wikilinks]] в .md файлах
# 2. Проверку существования целевых файлов
# 3. Проверку обратных ссылок (карточки → индексы)
# 4. Итоговый отчёт
#
# Формат wikilinks в репозитории:
#   [[infra_all_instruments/path/to/file__ID|label]]  — полный путь с префиксом
#   [[path/to/file__ID|label]]                         — путь относительно корня репо
#   [[filename__ID|label]]                              — короткое имя (относительно текущей папки)
#   [[path/to/directory|label]]                         — ссылка на директорию

set -euo pipefail

# --- Цвета вывода ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Базовая директория репозитория ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="${1:-$(cd "$SCRIPT_DIR/.." && pwd)}"
REPO_NAME="infra_all_instruments"

# --- Счётчики ---
TOTAL_LINKS=0
BROKEN_LINKS=0
OK_LINKS=0
SKIPPED_LINKS=0
BACKREF_MISSING=0
BACKREF_OK=0
FILES_CHECKED=0

# --- Вспомогательные функции ---
error_msg() { echo -e "  ${RED}✗${NC} $1"; }
ok_msg()    { echo -e "  ${GREEN}✓${NC} $1"; }
warn_msg()  { echo -e "  ${YELLOW}⚠${NC} $1"; }
info_msg()  { echo -e "  ${CYAN}ℹ${NC} $1"; }
section()   { echo -e "\n${BOLD}${YELLOW}=== $1 ===${NC}"; }

# --- Функция: разрешение пути wikilink в файловый путь ---
# Принимает: путь из wikilink, директорию исходного файла
# Возвращает: 0 если файл найден, 1 если нет, 2 если внешняя ссылка (пропуск)
resolve_wikilink() {
    local link_path="$1"
    local source_dir="$2"

    # Шаг 1: Убираем префикс infra_all_instruments/ если присутствует
    local clean_path="$link_path"
    if [[ "$clean_path" == infra_all_instruments/* ]]; then
        clean_path="${clean_path#infra_all_instruments/}"
    fi

    # Шаг 2: Проверяем как абсолютный путь от корня репо

    # 2a: Точное совпадение (файл как есть)
    if [[ -f "$REPO_DIR/$clean_path" ]]; then
        return 0
    fi

    # 2b: С расширением .md
    if [[ -f "$REPO_DIR/$clean_path.md" ]]; then
        return 0
    fi

    # 2c: Это директория
    if [[ -d "$REPO_DIR/$clean_path" ]]; then
        return 0
    fi

    # 2d: Glob-поиск с таймстемпом (файлы формата name__TIMESTAMP.md)
    local glob_results
    glob_results=$(compgen -G "$REPO_DIR/${clean_path}__*.md" 2>/dev/null | head -1) || true
    if [[ -n "$glob_results" ]]; then
        return 0
    fi

    # 2e: Glob-поиск — путь уже содержит __ (может быть неточный таймстемп)
    # Ищем по базовому имени (до __) + любой суффикс
    local base_name
    base_name=$(echo "$clean_path" | sed 's/__[0-9-]*$//')
    if [[ "$base_name" != "$clean_path" ]]; then
        glob_results=$(compgen -G "$REPO_DIR/${base_name}__*.md" 2>/dev/null | head -1) || true
        if [[ -n "$glob_results" ]]; then
            return 0
        fi
    fi

    # Шаг 3: Проверяем как относительный путь от source_dir
    if [[ -f "$source_dir/$clean_path" ]]; then
        return 0
    fi
    if [[ -f "$source_dir/$clean_path.md" ]]; then
        return 0
    fi
    if [[ -d "$source_dir/$clean_path" ]]; then
        return 0
    fi
    glob_results=$(compgen -G "$source_dir/${clean_path}__*.md" 2>/dev/null | head -1) || true
    if [[ -n "$glob_results" ]]; then
        return 0
    fi

    # Шаг 3b: Проверяем как относительный путь от родительской директории source_dir
    # (для ссылок вида cards/xxx из by-type/, by-provider/ и т.п.)
    local parent_dir
    parent_dir="$(dirname "$source_dir")"
    if [[ "$parent_dir" != "$source_dir" ]]; then
        if [[ -f "$parent_dir/$clean_path" ]]; then
            return 0
        fi
        if [[ -f "$parent_dir/$clean_path.md" ]]; then
            return 0
        fi
        if [[ -d "$parent_dir/$clean_path" ]]; then
            return 0
        fi
        glob_results=$(compgen -G "$parent_dir/${clean_path}__*.md" 2>/dev/null | head -1) || true
        if [[ -n "$glob_results" ]]; then
            return 0
        fi
    fi

    # Шаг 4: Для коротких имён (без /) — поиск в source_dir и рекурсивно по репо
    # Obsidian ищет короткие имена по всему vault
    if [[ "$clean_path" != */* ]]; then
        local short_base
        short_base=$(echo "$clean_path" | sed 's/__[0-9-]*$//')
        # Сначала в source_dir
        glob_results=$(compgen -G "$source_dir/${short_base}__*.md" 2>/dev/null | head -1) || true
        if [[ -n "$glob_results" ]]; then
            return 0
        fi
        # Затем рекурсивный поиск по всему репозиторию (Obsidian shortest-path resolution)
        glob_results=$(find "$REPO_DIR" -name "${clean_path}.md" -not -path "*/.git/*" 2>/dev/null | head -1) || true
        if [[ -n "$glob_results" ]]; then
            return 0
        fi
        glob_results=$(find "$REPO_DIR" -name "${short_base}__*.md" -not -path "*/.git/*" 2>/dev/null | head -1) || true
        if [[ -n "$glob_results" ]]; then
            return 0
        fi
    fi

    # Шаг 5: Ссылки на внешние проекты (AgentOps и т.п.) — пропускаем
    if [[ "$link_path" == AgentOps* ]] || [[ "$link_path" == agentops* ]]; then
        return 2  # Код 2 = пропущено (внешняя ссылка)
    fi

    # Не найден
    return 1
}

# --- Функция: обработка одного wikilink ---
# Принимает: target_path, source_dir, rel_file, line_num
process_single_link() {
    local target_path="$1"
    local source_dir="$2"
    local rel_file="$3"
    local line_num="$4"

    TOTAL_LINKS=$((TOTAL_LINKS + 1))

    # Пропускаем заведомо шаблонные/примерные ссылки
    # (плейсхолдеры в templates/, AI/, ARCHITECTURE.md, CLAUDE.md и т.п.)
    case "$target_path" in
        # Шаблонные плейсхолдеры
        *"<"*">"*|*"PROVIDER"*|*"RUNTIME"*|*"RELATED-TOOL"*|*"TOOL-mcp"*|*"file__ID"*)
            SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
            return
            ;;
        # Примеры из документации правил (AI/ файлы)
        "path"|"path/to/file"|"target"|"links"|"ссылок"|"ссылка на карточку")
            SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
            return
            ;;
        # Ссылки содержащие фрагменты кода (скобки, кавычки, запятые)
        *'"'*|*","*|*"bbox"*)
            SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
            return
            ;;
    esac

    # Пропускаем ссылки из шаблонов (templates/) — они по определению содержат плейсхолдеры
    if [[ "$rel_file" == templates/* ]]; then
        local result=0
        resolve_wikilink "$target_path" "$source_dir" || result=$?
        if [[ $result -ne 0 ]]; then
            SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
            return
        fi
    fi

    # Проверяем существование файла
    # Используем || true чтобы set -e не прерывал скрипт при return 1/2
    local result=0
    resolve_wikilink "$target_path" "$source_dir" || result=$?

    if [[ $result -eq 0 ]]; then
        OK_LINKS=$((OK_LINKS + 1))
    elif [[ $result -eq 2 ]]; then
        SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
    else
        BROKEN_LINKS=$((BROKEN_LINKS + 1))
        error_msg "${rel_file}:${line_num} → ${target_path}"
    fi
}

# --- Функция: извлечение и проверка wikilinks из строки ---
# Принимает: строку, директорию файла, относительный путь файла, номер строки
process_line_links() {
    local line="$1"
    local source_dir="$2"
    local rel_file="$3"
    local line_num="$4"

    local remaining="$line"
    while [[ "$remaining" == *'[['* ]]; do
        # Пропускаем текст до [[
        remaining="${remaining#*\[\[}"

        # Находим конец wikilink ]]
        if [[ "$remaining" != *']]'* ]]; then
            break  # Незакрытый wikilink — пропускаем
        fi
        local inner="${remaining%%\]\]*}"
        remaining="${remaining#*\]\]}"

        # Извлекаем путь (часть до | или \|)
        local target_path="$inner"
        if [[ "$inner" == *'|'* ]]; then
            target_path="${inner%%|*}"
            # Убираем trailing backslash (таблицы используют \|)
            target_path="${target_path%\\}"
        fi

        # Убираем пробелы по краям
        target_path="$(echo "$target_path" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        # Пропускаем пустые
        [[ -z "$target_path" ]] && continue

        # Обрабатываем ссылку
        process_single_link "$target_path" "$source_dir" "$rel_file" "$line_num"
    done
}

# --- Функция: проверка всех wikilinks в файле ---
check_file_links() {
    local file="$1"
    local rel_file="${file#$REPO_DIR/}"
    local file_dir
    file_dir="$(dirname "$file")"

    # Быстрая проверка: есть ли вообще wikilinks в файле
    if ! grep -q '\[\[' "$file" 2>/dev/null; then
        return
    fi

    # Проходим по строкам файла
    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Пропускаем строки без wikilinks
        [[ "$line" != *'[['* ]] && continue

        # Обрабатываем все wikilinks в строке
        process_line_links "$line" "$file_dir" "$rel_file" "$line_num"
    done < "$file"
}

# --- Функция: проверка обратных ссылок ---
# Каждая карточка должна содержать ссылку на свой индекс
check_back_references() {
    section "Проверка обратных ссылок (карточки → индексы)"

    # Соответствие директорий карточек и их индексов
    declare -A INDEX_MAP
    INDEX_MAP["docs/tools"]="docs/tools/_index__20260210220000-04"
    INDEX_MAP["docs/mcp/cards"]="docs/mcp/_index__20260210220000-06"
    INDEX_MAP["docs/neural-networks/cards"]="docs/neural-networks/_index__20260210220000-05"

    for card_dir in "docs/tools" "docs/mcp/cards" "docs/neural-networks/cards"; do
        local full_dir="$REPO_DIR/$card_dir"
        local index_path="${INDEX_MAP[$card_dir]}"

        [[ ! -d "$full_dir" ]] && continue

        echo -e "\n  ${CYAN}Директория: ${card_dir}/${NC}"

        for card_file in "$full_dir"/*.md; do
            [[ ! -f "$card_file" ]] && continue
            local card_name
            card_name="$(basename "$card_file")"

            # Пропускаем индексные файлы (_index)
            if [[ "$card_name" == _index* ]]; then
                continue
            fi

            local rel_card="${card_file#$REPO_DIR/}"

            # Ищем в файле ссылку на индекс
            # Проверяем несколько вариантов пути к индексу
            local has_backref=0

            # Вариант 1: полный путь с префиксом infra_all_instruments/
            if grep -q "\[\[.*${index_path}.*\]\]" "$card_file" 2>/dev/null; then
                has_backref=1
            fi

            # Вариант 2: путь без префикса (уже совпадает с index_path, но проверяем явно)
            local short_index="${index_path#infra_all_instruments/}"
            if [[ $has_backref -eq 0 ]] && grep -q "\[\[.*${short_index}.*\]\]" "$card_file" 2>/dev/null; then
                has_backref=1
            fi

            # Вариант 3: просто _index в wikilink (менее строгая проверка)
            if [[ $has_backref -eq 0 ]] && grep -q "\[\[.*_index.*\]\]" "$card_file" 2>/dev/null; then
                has_backref=1
            fi

            if [[ $has_backref -eq 1 ]]; then
                BACKREF_OK=$((BACKREF_OK + 1))
            else
                BACKREF_MISSING=$((BACKREF_MISSING + 1))
                warn_msg "${rel_card} — нет обратной ссылки на индекс"
            fi
        done
    done
}

# =============================================================================
# ОСНОВНАЯ ЛОГИКА
# =============================================================================

echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Link Checker — infra_all_instruments       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo "Дата: $(date '+%Y-%m-%d %H:%M')"
echo "Корень репозитория: $REPO_DIR"

# --- Часть 1: Проверка wikilinks ---
section "Проверка wikilinks"

# Находим все .md файлы и проверяем ссылки
while IFS= read -r md_file; do
    [[ ! -f "$md_file" ]] && continue
    FILES_CHECKED=$((FILES_CHECKED + 1))

    check_file_links "$md_file"
done < <(find "$REPO_DIR" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/.obsidian/*" | sort)

# --- Часть 2: Обратные ссылки ---
check_back_references

# --- Итоговый отчёт ---
section "ИТОГОВЫЙ ОТЧЁТ"

echo ""
echo -e "  ${BOLD}Wikilinks:${NC}"
echo -e "    Файлов проверено:    ${FILES_CHECKED}"
echo -e "    Всего ссылок:        ${TOTAL_LINKS}"
echo -e "    ${GREEN}Корректных:          ${OK_LINKS}${NC}"
if [[ $BROKEN_LINKS -gt 0 ]]; then
    echo -e "    ${RED}Битых:               ${BROKEN_LINKS}${NC}"
else
    echo -e "    ${GREEN}Битых:               0${NC}"
fi
if [[ $SKIPPED_LINKS -gt 0 ]]; then
    echo -e "    ${YELLOW}Пропущено (внешние): ${SKIPPED_LINKS}${NC}"
fi

echo ""
echo -e "  ${BOLD}Обратные ссылки (карточка → индекс):${NC}"
echo -e "    ${GREEN}Есть ссылка:         ${BACKREF_OK}${NC}"
if [[ $BACKREF_MISSING -gt 0 ]]; then
    echo -e "    ${YELLOW}Нет ссылки:          ${BACKREF_MISSING}${NC}"
else
    echo -e "    ${GREEN}Нет ссылки:          0${NC}"
fi

echo ""

# --- Код возврата ---
TOTAL_ERRORS=$((BROKEN_LINKS))
if [[ $TOTAL_ERRORS -gt 0 ]]; then
    echo -e "${RED}Обнаружены битые ссылки: ${TOTAL_ERRORS}${NC}"
    if [[ $BACKREF_MISSING -gt 0 ]]; then
        echo -e "${YELLOW}Отсутствуют обратные ссылки: ${BACKREF_MISSING}${NC}"
    fi
    exit 1
else
    if [[ $BACKREF_MISSING -gt 0 ]]; then
        echo -e "${YELLOW}Предупреждения: отсутствуют обратные ссылки (${BACKREF_MISSING}). Битых ссылок нет.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Все проверки пройдены успешно.${NC}"
    exit 0
fi
