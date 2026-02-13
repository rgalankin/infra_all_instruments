#!/bin/bash
# inventory-check.sh — Аудит установленного ПО vs документация
# Сравнивает текущее состояние системы с задокументированными инструментами
# Использование: bash scripts/inventory-check.sh [--full|--apps|--brew|--ollama|--mcp]

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS_DIR="$REPO_DIR/docs/tools"
MCP_DIR="$REPO_DIR/docs/mcp/cards"
NN_DIR="$REPO_DIR/docs/neural-networks/cards"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

section() { echo -e "\n${YELLOW}=== $1 ===${NC}"; }
ok() { echo -e "  ${GREEN}✓${NC} $1"; }
missing() { echo -e "  ${RED}✗${NC} $1"; }
info() { echo -e "  ${YELLOW}ℹ${NC} $1"; }

# --- Аудит /Applications ---
audit_apps() {
    section "Приложения (/Applications)"

    local documented=0
    local undocumented=0
    local total=0

    while IFS= read -r app; do
        app_name=$(basename "$app" .app)
        total=$((total + 1))

        # Ищем карточку по slug (несколько вариантов)
        slug=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        # Убираем общие префиксы: "google-chrome" → "chrome", "microsoft-word" → "word"
        short_slug=$(echo "$slug" | sed 's/^google-//; s/^microsoft-//; s/^adobe-//; s/^visual-studio-/vs/; s/^zoom\.us$/zoom/')
        if ls "$TOOLS_DIR"/*"$slug"* >/dev/null 2>&1 || ls "$TOOLS_DIR"/*"$(echo "$slug" | tr -d '-')"* >/dev/null 2>&1 || ls "$TOOLS_DIR"/*"$short_slug"* >/dev/null 2>&1; then
            documented=$((documented + 1))
        else
            undocumented=$((undocumented + 1))
            missing "Нет карточки: $app_name"
        fi
    done < <(ls -d /Applications/*.app 2>/dev/null | sort)

    echo ""
    info "Всего приложений: $total"
    ok "Задокументировано: $documented"
    [ "$undocumented" -gt 0 ] && missing "Без карточки: $undocumented" || true
}

# --- Аудит Homebrew ---
audit_brew() {
    section "Homebrew"

    if ! command -v brew &>/dev/null; then
        missing "Homebrew не установлен"
        return
    fi

    local formula_count
    formula_count=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
    local cask_count
    cask_count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')

    ok "Formulae: $formula_count"
    ok "Casks: $cask_count"

    # Проверяем наличие карточки homebrew
    if ls "$TOOLS_DIR"/homebrew* >/dev/null 2>&1; then
        ok "Карточка Homebrew существует"
    else
        missing "Нет карточки Homebrew"
    fi

    # Устаревшие пакеты
    local outdated
    outdated=$(brew outdated 2>/dev/null | wc -l | tr -d ' ')
    if [ "$outdated" -gt 0 ]; then
        info "Устаревших пакетов: $outdated"
        brew outdated 2>/dev/null | while read -r pkg; do
            info "  ↳ $pkg"
        done
    else
        ok "Все пакеты актуальны"
    fi
}

# --- Аудит Ollama ---
audit_ollama() {
    section "Ollama"

    if ! command -v ollama &>/dev/null; then
        missing "Ollama не установлен"
        return
    fi

    local version
    version=$(ollama --version 2>/dev/null | head -1)
    ok "Версия: $version"

    echo "  Установленные модели:"
    local model_count=0
    local undocumented_models=0

    while IFS= read -r line; do
        [ -z "$line" ] && continue
        model_name=$(echo "$line" | awk '{print $1}')
        model_size=$(echo "$line" | awk '{print $3, $4}')
        model_count=$((model_count + 1))

        # Ищем карточку модели (пробуем несколько вариантов slug)
        slug=$(echo "$model_name" | sed 's/:/-/g; s/\.//g')
        base_slug=$(echo "$model_name" | sed 's/:.*//' | sed 's/\.//g')
        if ls "$NN_DIR"/*"$slug"* >/dev/null 2>&1 || ls "$NN_DIR"/*"$base_slug"* >/dev/null 2>&1; then
            ok "$model_name ($model_size)"
        else
            undocumented_models=$((undocumented_models + 1))
            missing "$model_name ($model_size) — нет карточки"
        fi
    done < <(ollama list 2>/dev/null | tail -n +2)

    echo ""
    info "Всего моделей: $model_count"
    [ "$undocumented_models" -gt 0 ] && missing "Без карточки: $undocumented_models" || true
}

# --- Аудит MCP ---
audit_mcp() {
    section "MCP-серверы"

    local card_count
    card_count=$(ls "$MCP_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
    ok "Карточек MCP: $card_count"

    # Проверяем Cursor MCP конфиг
    local cursor_config="$HOME/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"
    local cursor_config2="$HOME/.cursor/mcp.json"

    if [ -f "$cursor_config2" ]; then
        local cursor_servers
        cursor_servers=$(python3 -c "import json; d=json.load(open('$cursor_config2')); print(len(d.get('mcpServers', {})))" 2>/dev/null || echo "?")
        ok "Cursor MCP серверов в конфиге: $cursor_servers"
    fi
}

# --- Основная логика ---
mode="${1:-full}"

echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Inventory Check — infra_all_instruments   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo "Дата: $(date '+%Y-%m-%d %H:%M')"

case "$mode" in
    --apps)   audit_apps ;;
    --brew)   audit_brew ;;
    --ollama) audit_ollama ;;
    --mcp)    audit_mcp ;;
    --full|*) audit_apps; audit_brew; audit_ollama; audit_mcp ;;
esac

echo ""
echo -e "${GREEN}Аудит завершён.${NC}"
