#!/bin/bash
# generate-stats.sh — Статистика базы знаний
# Использование: bash scripts/generate-stats.sh

set -uo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

section() { echo -e "\n${YELLOW}=== $1 ===${NC}"; }
stat() { echo -e "  ${CYAN}$1:${NC} $2"; }

echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Knowledge Base Statistics          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo "Дата: $(date '+%Y-%m-%d %H:%M')"
echo "Репозиторий: $REPO_DIR"

# --- Общая статистика ---
section "Общая статистика"

total_md=$(find "$REPO_DIR" -name "*.md" -not -path "*/.git/*" -not -path "*/node_modules/*" | wc -l | tr -d ' ')
total_lines=$(find "$REPO_DIR" -name "*.md" -not -path "*/.git/*" -not -path "*/node_modules/*" -exec cat {} + 2>/dev/null | wc -l | tr -d ' ')
stat "Всего .md файлов" "$total_md"
stat "Всего строк" "$total_lines"

# --- По директориям ---
section "По директориям"

for dir in hardware infrastructure tools neural-networks mcp integrations automation analytics guides; do
    dirpath="$REPO_DIR/docs/$dir"
    if [ -d "$dirpath" ]; then
        count=$(find "$dirpath" -name "*.md" | wc -l | tr -d ' ')
        stat "docs/$dir" "$count файлов"
    fi
done

# Templates
template_count=$(find "$REPO_DIR/templates" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
stat "templates" "$template_count файлов"

# --- По типам контента ---
section "По типам контента (YAML type:)"

for type in spec index; do
    count=$(grep -rl "^type: $type" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
    stat "type: $type" "$count файлов"
done

# --- По статусам ---
section "По статусам (YAML status:)"

for status in active archived draft needs-update; do
    count=$(grep -rl "^status: $status" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
    [ "$count" -gt 0 ] && stat "status: $status" "$count файлов" || true
done

# --- По стоимости ---
section "По стоимости (YAML cost:)"

for cost_type in free freemium; do
    count=$(grep -rl "^cost:.*$cost_type" "$REPO_DIR/docs/tools" 2>/dev/null | wc -l | tr -d ' ')
    [ "$count" -gt 0 ] && stat "cost: $cost_type" "$count файлов" || true
done
paid_count=$(grep -rl '^cost: "\$' "$REPO_DIR/docs/tools" 2>/dev/null | wc -l | tr -d ' ')
[ "$paid_count" -gt 0 ] && stat "cost: paid" "$paid_count файлов" || true

# --- По критичности ---
section "По критичности"

for crit in high medium low; do
    count=$(grep -rl "^criticality: $crit" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
    [ "$count" -gt 0 ] && stat "criticality: $crit" "$count файлов" || true
done

# --- TODO ---
section "Пробелы (TODO)"

todo_count=$(grep -r "TODO" "$REPO_DIR/docs" 2>/dev/null | grep -v ".git" | wc -l | tr -d ' ')
stat "Строк с TODO" "$todo_count"

# Файлы с TODO
if [ "$todo_count" -gt 0 ]; then
    echo "  Файлы с TODO:"
    grep -rl "TODO" "$REPO_DIR/docs" 2>/dev/null | while read -r f; do
        count=$(grep -c "TODO" "$f" 2>/dev/null || echo 0)
        echo "    ↳ $(basename "$f"): $count TODO"
    done
fi

# --- Ссылки ---
section "Перекрёстные ссылки"

wikilink_count=$(grep -r "\[\[" "$REPO_DIR/docs" 2>/dev/null | grep -v ".git" | wc -l | tr -d ' ')
stat "Строк с wikilinks" "$wikilink_count"

# --- Git ---
section "Git"

if command -v git &>/dev/null && [ -d "$REPO_DIR/.git" ]; then
    commits=$(git -C "$REPO_DIR" log --oneline 2>/dev/null | wc -l | tr -d ' ')
    last_commit=$(git -C "$REPO_DIR" log -1 --format="%h %s" 2>/dev/null)
    stat "Коммитов" "$commits"
    stat "Последний" "$last_commit"
fi

# --- Исторический трекинг (JSONL) ---
section "Исторический трекинг"

STATS_FILE="$REPO_DIR/docs/analytics/stats-history.jsonl"
mkdir -p "$(dirname "$STATS_FILE")"

# Собираем метрики для JSONL
stats_date=$(date '+%Y-%m-%d')
tools_count=$(find "$REPO_DIR/docs/tools" -name "*.md" -not -name "_index*" 2>/dev/null | wc -l | tr -d ' ')
mcp_count=$(find "$REPO_DIR/docs/mcp" -name "*.md" -not -name "_index*" 2>/dev/null | wc -l | tr -d ' ')
nn_count=$(find "$REPO_DIR/docs/neural-networks" -name "*.md" -not -name "_index*" 2>/dev/null | wc -l | tr -d ' ')
active_count=$(grep -rl "^status: active" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
draft_count=$(grep -rl "^status: draft" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
archived_count=$(grep -rl "^status: archived" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')
needs_update_count=$(grep -rl "^status: needs-update" "$REPO_DIR/docs" 2>/dev/null | wc -l | tr -d ' ')

# Записываем JSONL-строку
jsonl_line="{\"date\":\"${stats_date}\",\"total_md\":${total_md},\"tools\":${tools_count},\"mcp\":${mcp_count},\"nn\":${nn_count},\"active\":${active_count},\"draft\":${draft_count},\"archived\":${archived_count},\"needs_update\":${needs_update_count},\"todos\":${todo_count},\"wikilinks\":${wikilink_count}}"
echo "$jsonl_line" >> "$STATS_FILE"
stat "Записано в" "$STATS_FILE"
stat "Строка" "$jsonl_line"

echo ""
echo -e "${GREEN}Статистика сгенерирована.${NC}"
