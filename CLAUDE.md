---
id: 20260208112030
title: CLAUDE.MD
status: active
source: roman
ai_weight: normal
tags: [platform/git, platform/markdown, docops/standard, process/docs, process/index]
type: note
summary: Документ представляет собой инструкцию для Claude Code по работе с репозиторием, содержащим базу знаний IT-инфраструктуры. Описывается структура репозитория, навигация и основные компоненты.
created: 2026-02-08
updated: 2026-02-18
---
# CLAUDE.MD

Инструкции для Claude Code при работе с данным репозиторием.

## ЧТО ЭТО ЗА РЕПОЗИТОРИЙ

**Атомарная база знаний IT-инфраструктуры** — единый каталог всего инструментария: софт, железо, нейросети, серверы, MCP-серверы, интеграции и их взаимосвязи. Документационный проект, не программный.

Владелец: Роман Галанкин. Основная машина: iMac Pro 2017 (macOS).

## СТРУКТУРА РЕПОЗИТОРИЯ

### Навигация (точки входа)

- `registry__20260210220000-01.md` — **TOP-LEVEL MOC** (Map of Content), навигация по всем категориям
- `docs/tools/_index__20260210220000-04.md` — реестр инструментов (70+ приложений)
- `docs/neural-networks/_index__20260210220000-05.md` — реестр нейросетей
- `docs/mcp/_index__20260210220000-06.md` — реестр MCP-серверов (15+)
- `docs/hardware/_index__20260210220000-02.md` — реестр железа
- `docs/infrastructure/_index__20260210220000-03.md` — реестр инфраструктуры

### Структура директорий

```
docs/
├── hardware/          # Физические устройства (iMac, iPhone, периферия)
├── infrastructure/    # Серверы, Docker, VPN, домены
├── tools/             # Программы и приложения (56 карточек, Tier 1-3)
├── neural-networks/   # Нейросети: трёхмерная таксономия
│   ├── cards/         #   Карточки моделей (8 шт.)
│   ├── by-type/       #   По типу: LLM, VLM, Embedding, ASR, OCR, Image-gen
│   ├── by-provider/   #   По провайдеру: Qwen, Meta, DeepSeek, Google...
│   └── by-runtime/    #   По рантайму: Ollama, OpenRouter, Groq
├── mcp/               # MCP-серверы (16 серверов)
│   ├── cards/         #   Карточки серверов
│   └── by-tool/       #   Виды по инструментам (Cursor, Warp, Claude Desktop...)
├── integrations/      # Карта связей между инструментами
├── automation/        # Скрипты аудита, n8n-воркфлоу
├── analytics/         # AI-анализ и рекомендации
└── guides/            # Руководства по процессам
templates/             # 6 шаблонов: tool-card, tool-card-minimal, hardware, mcp, nn-model, integration
scripts/               # mcp-sync.mjs, inventory-check.sh, generate-stats.sh, link-checker.sh, yaml-validate.sh
```

### Архивные файлы (status: archived, с баннером-редиректом)

- `ВСЯ МОЯ ИНФРАСТРУКТУРА (для LLM)__20260201200225.md` → `registry__20260210220000-01.md`
- `docs/mcp-servers__20260201200225.md` → `docs/mcp/_index__20260210220000-06.md`
- `docs/tools/neural-networks__20260201232828.md` → `docs/neural-networks/_index__20260210220000-05.md`
- `docs/tools/template.md` → `templates/tool-card__YYYYMMDDHHMMSS-XX.md`

## КЛЮЧЕВЫЕ ПРАВИЛА

- **Никаких секретов**: документируются только *названия* переменных окружения, не значения
- **Source of truth**: локальный диск + Git
- **Markdown — стандарт** всей документации
- **Атомарность**: каждый элемент = отдельная карточка (файл)
- **Ссылочность**: Obsidian wikilinks `[[path|label]]` для навигации
- **Шаблоны обязательны**: при создании карточки использовать шаблон из `templates/`
- **4 статуса жизненного цикла:**
  - `draft` — черновик
  - `active` — актуально, данные полные
  - `needs-update` — карточка есть, но данные устарели/неполны
  - `archived` — архив, не источник истины

## ПРИНЦИП ЕДИНОГО ИСТОЧНИКА

Если для сущности есть **выделенный проект** в `~/Documents/`:
- Карточка в infra_all_instruments = **УКАЗАТЕЛЬ** (идентификация + wikilinks на проект-источник)
- Детальная документация = в проекте-источнике
- **НЕ дублировать** содержимое между указателем и источником
- При изменениях обновлять **ТОЛЬКО** проект-источник; указатель — только при смене идентификации

Текущие указатели:

| Карточка | Проект-источник |
|----------|-----------------|
| VPS Beget | `vps/` |
| VPS ISHosting USA | `infra_vps_usa/` |
| VPS ISHosting VPN | `infra_vpn_germany/` |

Стандарт: DocOps-Standard §11.

## ДОБАВЛЕНИЕ ДОКУМЕНТАЦИИ

### Новый инструмент
1. Определить Tier (1/2/3) → глубина документации
2. Создать карточку в `docs/tools/` по шаблону:
   - Tier 1: `templates/tool-card__YYYYMMDDHHMMSS-XX.md` (полный, 12 секций)
   - Tier 2-3: `templates/tool-card-minimal__YYYYMMDDHHMMSS-XX.md` (лёгкий, 4 секции)
3. Обновить `docs/tools/_index__20260210220000-04.md`
4. Если есть MCP — создать карточку в `docs/mcp/cards/`
5. Обновить перекрёстные ссылки

### Новая нейросеть
1. Создать карточку в `docs/neural-networks/cards/` по `templates/nn-model-card__YYYYMMDDHHMMSS-XX.md`
2. **ОБЯЗАТЕЛЬНО** обновить `docs/neural-networks/_index__20260210220000-05.md`:
   - Добавить модель в соответствующую таблицу (локальные/облачные/self-hosted)
   - Если новый провайдер: добавить в секцию "Облачные Embedding-провайдеры" (или аналогичную)
   - Обновить таблицу "Быстрый выбор по задаче" если модель лучше текущей рекомендации
   - Добавить wikilink на карточку
3. Добавить в соответствующие MOC: by-type, by-provider, by-runtime
4. **ПРОВЕРКА:** убедиться, что ВСЕ уровни навигации обновлены (card → by-type → _index → registry). Если добавляются новые провайдеры, добавить их в секцию "По рантайму" в `_index`

### Новый MCP-сервер
1. Создать карточку в `docs/mcp/cards/` по `templates/mcp-server-card__YYYYMMDDHHMMSS-XX.md`
2. Обновить `docs/mcp/_index__20260210220000-06.md`
3. Обновить `docs/mcp/by-tool/` для соответствующих инструментов

## СКРИПТЫ

```bash
# MCP синхронизация
node scripts/mcp-sync.mjs              # синхронизация
node scripts/mcp-sync.mjs --dry-run    # предпросмотр
node scripts/mcp-sync.mjs --status     # текущее состояние

# Аудит и статистика
bash scripts/inventory-check.sh        # проверка покрытия инструментов
bash scripts/generate-stats.sh         # статистика проекта

# Валидация
bash scripts/link-checker.sh           # проверка wikilinks (0 битых = OK)
bash scripts/yaml-validate.sh          # валидация YAML frontmatter
bash scripts/freshness-check.sh        # проверка свежести карточек (--days N)

# DocOps линтер
python3 ~/Documents/AgentOps/scripts/docops-lint.py ~/Documents/infra_all_instruments --report
```

## КОНТЕКСТ ИНФРАСТРУКТУРЫ

- **VPS Beget** (82.202.129.193) — Docker-стек: n8n, Dify, Traefik, Postgres, ASR, MCP-n8n
- **VPS ISHosting USA** (149.33.4.37) — egress proxy для LLM API, LLM Router, Documentoved
- **VPS ISHosting VPN** (38.244.128.203) — VPN-сервер dual-mode (Reality + XHTTP CDN)
- **n8n** (n8n.fingroup.ru) — движок автоматизаций, очень высокая критичность
- **WireGuard VPN** (10.66.66.0/24) — закрытый доступ к MCP-n8n
- **Ollama** (localhost:11434) — 6 установленных моделей
- **MCP серверы** — 15 в Cursor, 5 в Warp, 3 в Claude Desktop; синхронизация через mcp-sync.mjs
