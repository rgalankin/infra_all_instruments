---
id: 20260214131534
title: CHANGELOG
status: active
source: roman
ai_weight: normal
created: 2026-02-14
updated: 2026-02-15
---
# CHANGELOG

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [UNRELEASED]

### Задачи (Plan v3)
- [ ] #5 macOS-приложения → brew cask (Cursor, Obsidian, Docker, Bitwarden)
- [ ] #6 Мониторинг egress-tunnel Beget → Telegram alert
- [ ] #7 VPN-мониторинг → Telegram alert
- [ ] #8 MCP-sync автоматизация (launchd)
- [ ] #9 Script-center активация (AgentOps)
- [ ] #10 Cross-project link checker
- [ ] #11 n8n-автоматизации
- [ ] #12 Follow-up по ТЗ бэкапов
- [ ] #13 Развернуть Vaultwarden на VPS Beget (self-hosted менеджер паролей)

## [2.3] - 2026-02-15

### CHANGED
- Git credential helper: исправлен формат (убрано двойное экранирование `\!`, добавлен полный путь к gh)
- Ollama: удалены 5 LLM-моделей (~47 GB), оставлена только nomic-embed-text (274 MB) для Obsidian Smart Connections. LLM inference перенесён на ISHosting US
- MCP-секреты: 5 API-ключей мигрированы из plaintext `.env` в macOS Keychain; права `.env` ужесточены до 600
- Claude Code hooks: настроен PostToolUse hook для auto-lint .md файлов при записи (docops-lint.py)
- Карточка Ollama: обновлена (1 модель, 274 MB, категория → Local Embedding)
- 5 карточек нейросетей → status: archived (qwen3-30b, qwen3-coder-30b, deepseek-r1-8b, llama3.1-8b, qwen2.5-coder-1.5b)

### STATS
- Освобождено ~47 GB дискового пространства (Ollama LLM-модели)
- 5 секретов защищены через macOS Keychain

## [2.2] - 2026-02-15

### ADDED
- ТЗ для сисадмина: бэкапы VPS Beget (`docs/guides/sysadmin-task-beget-backups__20260214230000-01.md`)
- ТЗ для сисадмина: бэкапы VPS VPN Germany (`docs/guides/sysadmin-task-vpn-backups__20260214230000-02.md`)

### CHANGED
- Homebrew: обновлены 32 formulae + 1 cask (claude-code 2.1.37 → 2.1.42)
- Удалены дубли: Opera, Firefox (браузеры), PDFelement, UPDF (PDF-редакторы) — карточки archived
- Удалён Slack (501 MB) — карточка archived; Yandex Messenger и Telemost оставлены
- Удалён Football Manager 2024 (5 GB)
- MCP Claude Code: 0 → 15 серверов (синхронизация через AgentOps/mcp-hub/sync.py)
- Реестр MCP обновлён: Claude Code добавлен в сводную таблицу
- Карточка Homebrew: formulae 100 → 103, обновлены версии
- Аудит дублирования: обновлены итоги по браузерам, PDF, мессенджерам
- Рекомендации обновлений: Homebrew помечен как выполненный

### STATS
- Удалено ~7 GB неиспользуемых приложений (Opera, Firefox, PDFelement, UPDF, Slack, Football Manager)
- 15 MCP-серверов синхронизированы в Claude Code глобально

## [2.1] - 2026-02-14

### ADDED
- DocOps-Standard §11: паттерн «указатель + источник истины» для кросс-проектных карточек
- CLAUDE.md: раздел «Принцип единого источника» с таблицей текущих указателей
- Карточка HestiaCP (`docs/tools/hestiacp__20260214225000-01.md`)
- Карточка Cloudflare (`docs/tools/cloudflare__20260214225000-02.md`)
- Карточка IS Smart API (`docs/tools/is-smart__20260214210000-01.md`)
- План оптимизации v2 (`docs/analytics/optimization-plan-v2__20260214220000-01.md`)
- Операционные TODO в карточках VPS Beget и VPS ISHosting VPN Germany
- `link-checker.sh`: поддержка кросс-проектных ссылок в Obsidian vault

### CHANGED
- Реестр доменов: полные DNS-записи credoserv.ru, credoserv.store (новый), kredoserv.ru
- Weeceer cleanup: 12 файлов обновлено — VPS Weeceer (91.218.115.228) → archived, заменён VPS ISHosting USA (149.33.4.37)
- Инфраструктурные карточки (VPS Beget, ISHosting USA, ISHosting VPN) переведены в режим указателей на проекты-источники
- Индексы инфраструктуры и инструментов обновлены
- SSH-алиасы hk/weeceer помечены как устаревшие
- Маршруты LLM API в data-flows обновлены на ISHosting USA

### STATS
- 183 .md файла, ~16 000 строк
- 0 битых ссылок (980 внутренних + 28 кросс-проектных)
- План оптимизации v2: 5/5 фаз завершено

## [2.0] - 2026-02-11

### ADDED — ФАЗА 1: АТОМИЗАЦИЯ
- 5 карточек инфраструктуры (VPS Beget, VPS Weeceer, Docker, Traefik, WireGuard)
- 5 карточек железа (iMac Pro, iPhone, USB-аудио, Rutoken, Wi-Fi)
- 16 карточек MCP-серверов (docs/mcp/cards/) + 3 by-tool вида
- 8 карточек нейросетей (docs/neural-networks/cards/) + 12 MOC-таксономий (by-type, by-provider, by-runtime)
- 4 документа интеграций (n8n-workflows, mcp-topology, data-flows, api-map)

### ADDED — ФАЗА 2: ДОКУМЕНТАЦИЯ ИНСТРУМЕНТОВ (56 КАРТОЧЕК)
- 12 Tier 1 карточек (Obsidian, Continue, Ollama, Telegram, Bitrix24, Docker Desktop, GitHub, Google Drive, Dify, Bitwarden, Raycast, Perplexity)
- 15 Tier 2 карточек (VS Code, Aqua Voice, Soniox, Chrome, Firefox, Safari, Opera, Comet, Yandex Browser, ShadowsocksX-NG, AdGuard VPN, AnyDesk, Mate Translate, Xmind, Sublime Text)
- 20 Tier 3 карточек (WhatsApp, Slack, Megafon и др.)
- 2 специальные карточки (Shell Environment, Homebrew)

### ADDED — ФАЗА 3: АВТОМАТИЗАЦИЯ
- `scripts/inventory-check.sh` — аудит установленного ПО vs документация
- `scripts/generate-stats.sh` — статистика базы знаний
- Документация системы сбора (docs/automation/collection-system)

### ADDED — ФАЗА 4: AI-АНАЛИТИКА
- Аудит дублирования (docs/analytics/redundancy-audit) — 4 PDF, 6 браузеров, 6 мессенджеров
- Рекомендации по обновлениям (28 brew-пакетов, Ollama модели)
- Возможности интеграции (12 рекомендаций: MCP, n8n, новые связи)

### ADDED — ФУНДАМЕНТ (ФАЗА 0)
- Атомарная структура: docs/hardware, infrastructure, neural-networks, mcp, integrations, automation, analytics, guides
- Top-level MOC (registry__20260210220000-01.md) — навигационный хаб
- 9 индексов категорий (_index файлы)
- 5 шаблонов карточек (tool, hardware, mcp-server, nn-model, integration)
- Обновлённый CLAUDE.md с новой структурой

### CHANGED
- Архитектура проекта: от монолитного реестра к атомарной базе знаний
- `ВСЯ МОЯ ИНФРАСТРУКТУРА (для LLM)__20260201200225.md` → status: archived (заменён registry MOC)
- Руководства перенесены в docs/guides/

### STATS
- 156 .md файлов, 15 701 строка
- 84% DocOps-compliant (132/156)
- 128 active, 93 spec, 23 index

## [1.2] - 2026-02-10

### ADDED
- DocOps/AgentOps стандарт (AGENTS.md, AI/ rulepack, 14 правил)
- ARCHITECTURE.md
- README.md (расширенный)
- CHANGELOG.md (этот файл)

## [1.1] - 2026-02-01

### ADDED
- Реестр нейросетей (`docs/tools/neural-networks__20260201232828.md`)
- Все модели Ollama (локальные и cloud)
- Бесплатные модели OpenRouter
- Оценки для русского языка
- MCP сервер конфигурация для Continue IDE (`.continue/mcpServers/`)

## [1.0] - 2026-01-29

### ADDED
- PaddleOCR и Tesseract OCR в раздел AI/OCR
- Docker Desktop (macOS) в контейнеризацию
- Полный список моделей Ollama (7 штук)
- Связи Python → PaddleOCR, Tesseract, Ollama

## [0.9] - 2026-01-27

### ADDED
- Основной файл `ВСЯ МОЯ ИНФРАСТРУКТУРА (для LLM)` — Tooling Registry v1.0
- Документация инструментов: Cursor, Warp, Claude Desktop, n8n
- Карта MCP серверов
- Руководство по сбору информации из скриншотов
- Скрипт mcp-sync.mjs для синхронизации MCP конфигов

---

**Note:** This CHANGELOG follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) standard.
