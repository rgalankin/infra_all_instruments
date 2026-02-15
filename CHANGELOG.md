---
id: 20260214131534
title: CHANGELOG
status: active
source: roman
ai_weight: normal
created: 2026-02-14
updated: 2026-02-14
---
# CHANGELOG

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [UNRELEASED]

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
