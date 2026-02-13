---
id: 20260210103631-01
title: ARCHITECTURE — infra_all_instruments
summary: >
  Архитектура атомарной базы знаний IT-инфраструктуры: железо, софт,
  нейросети, MCP-серверы, интеграции. MOC → категория → карточка.
type: spec
status: active
tags: [docops/architecture, infra/inventory]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-10
updated: 2026-02-11
version: "2.0"
---
# ARCHITECTURE

## OVERVIEW

**infra_all_instruments** — атомарная база знаний всей IT-инфраструктуры. Единый источник истины (Single Source of Truth) для: железа, серверов, софта, нейросетей, MCP-серверов, интеграций и их взаимосвязей.

Это **документационный проект** (база знаний), а не программный. Основной контент — атомарные Markdown-карточки, связанные через Obsidian wikilinks.

**Основные технологии:**
- Markdown — формат всей документации
- Obsidian — навигация и визуализация связей (graph view)
- Node.js — скрипт `mcp-sync.mjs` для синхронизации MCP-конфигов
- YAML frontmatter — метаданные каждого документа (DocOps-стандарт)

**Архитектурный паттерн:** Atomic Documentation. Навигация по трём уровням: MOC (Map of Content) → Категория (_index) → Карточка. Каждый элемент инфраструктуры = отдельная карточка с YAML-метаданными и перекрёстными ссылками.

**Целевая аудитория:** Владелец инфраструктуры (Роман Галанкин), AI-агенты, удалённый AI-агент через Telegram.

## DIRECTORY STRUCTURE

```
/
├── registry__20260210220000-01.md          # TOP-LEVEL MOC (навигация по категориям)
├── docs/
│   ├── hardware/                           # Физические устройства
│   │   └── _index__20260210220000-02.md    # Реестр железа (MOC)
│   ├── infrastructure/                     # Серверы, контейнеры, VPN, домены
│   │   └── _index__20260210220000-03.md    # Реестр инфраструктуры (MOC)
│   ├── tools/                              # Программы и приложения (70+)
│   │   └── _index__20260210220000-04.md    # Реестр инструментов (MOC)
│   ├── neural-networks/                    # Нейросети и AI-модели
│   │   ├── _index__20260210220000-05.md    # Реестр нейросетей (MOC)
│   │   ├── by-type/                        # По типам (LLM, VLM, Embedding...)
│   │   ├── by-provider/                    # По провайдерам (Qwen, Meta...)
│   │   ├── by-runtime/                     # По рантаймам (Ollama, OpenRouter...)
│   │   └── cards/                          # Карточки моделей
│   ├── mcp/                                # MCP-серверы (15+)
│   │   ├── _index__20260210220000-06.md    # Реестр MCP (MOC)
│   │   ├── cards/                          # Карточки серверов
│   │   └── by-tool/                        # Виды по инструментам
│   ├── integrations/                       # Карта связей
│   ├── automation/                         # Скрипты, n8n-воркфлоу
│   ├── analytics/                          # AI-анализ, рекомендации
│   └── guides/                             # Руководства
├── templates/                              # 5 шаблонов карточек
├── scripts/
│   └── mcp-sync.mjs                        # Синхронизация MCP-конфигов
├── AI/                                     # Rulepack DocOps/AgentOps
├── AGENTS.md, CLAUDE.md, README.md
└── ARCHITECTURE.md                         # Этот документ
```

### DIRECTORY PURPOSES

**docs/hardware/** — карточки физических устройств: компьютеры, телефоны, периферия, сети.

**docs/infrastructure/** — серверы (VPS), Docker, VPN (WireGuard), домены/DNS.

**docs/tools/** — программы и приложения (70+), Tier 1-3. Карточки по шаблону `templates/tool-card.md`.

**docs/neural-networks/** — трёхмерная таксономия нейросетей (by-type, by-provider, by-runtime) + карточки моделей.

**docs/mcp/** — MCP-серверы: карточки в cards/ + виды по инструментам в by-tool/.

**docs/integrations/** — карта связей: потоки данных, MCP-топология, n8n-воркфлоу.

**docs/automation/** — скрипты аудита, система сбора информации.

**docs/analytics/** — AI-анализ: аудит дублирования, рекомендации.

**templates/** — 5 шаблонов: tool-card, hardware-card, mcp-server-card, nn-model-card, integration-card.

**scripts/** — mcp-sync.mjs + скрипты аудита (inventory-check.sh, generate-stats.sh).

**AI/** — rulepack DocOps/AgentOps (14 документов).

## ENTRY POINTS

**Для пользователей (навигация MOC → Index → Card):**
- `registry__20260210220000-01.md` — **TOP-LEVEL MOC**, главная точка входа
- `docs/tools/_index__20260210220000-04.md` — реестр инструментов (56 карточек)
- `docs/neural-networks/_index__20260210220000-05.md` — реестр нейросетей (8 карточек)
- `docs/mcp/_index__20260210220000-06.md` — реестр MCP-серверов (16 серверов)
- `docs/hardware/_index__20260210220000-02.md` — реестр железа
- `docs/infrastructure/_index__20260210220000-03.md` — реестр инфраструктуры

**Для AI-агентов:**
- `AGENTS.md` — коммутатор правил (tri-state)
- `CLAUDE.md` — инструкции для Claude Code
- `README.md` — общий контекст проекта
- `ARCHITECTURE.md` — этот документ

**Для скриптов:**
- `scripts/mcp-sync.mjs` — синхронизация MCP-конфигов
- `scripts/inventory-check.sh` — аудит покрытия инструментов
- `scripts/generate-stats.sh` — статистика проекта
- `scripts/link-checker.sh` — проверка wikilinks
- `scripts/yaml-validate.sh` — валидация YAML frontmatter

## KEY COMPONENTS

### КОМПОНЕНТ 1: TOOLING REGISTRY (ГЛАВНЫЙ РЕЕСТР)
- **Назначение:** Полный инвентарь инфраструктуры — серверы, VPN, SaaS, AI, интеграции
- **Файл:** `ВСЯ МОЯ ИНФРАСТРУКТУРА (для LLM)__20260201200225.md`
- **Формат:** Структурированный Markdown с секциями по категориям

### КОМПОНЕНТ 2: ДОКУМЕНТАЦИЯ ИНСТРУМЕНТОВ
- **Назначение:** Детальные справочники по каждому инструменту (настройки, MCP, интеграции)
- **Расположение:** `docs/tools/`
- **Шаблоны:** `templates/tool-card.md` (Tier 1), `templates/tool-card-minimal.md` (Tier 2-3)
- **Инструменты:** 56 карточек (12 Tier 1 + 15 Tier 2 + 20 Tier 3 + специальные)

### КОМПОНЕНТ 3: КАРТА MCP-СЕРВЕРОВ
- **Назначение:** Атомарные карточки MCP-серверов + виды по инструментам
- **Расположение:** `docs/mcp/cards/` (16 карточек), `docs/mcp/by-tool/` (3 вида)
- **Содержание:** Cursor (15 серверов), Warp (5 серверов), Claude Desktop (3 сервера)

### КОМПОНЕНТ 4: MCP SYNC (СКРИПТ СИНХРОНИЗАЦИИ)
- **Назначение:** Автоматическая синхронизация MCP-конфигов между всеми инструментами
- **Технология:** Node.js
- **Файл:** `scripts/mcp-sync.mjs`
- **Приоритет слияния:** Cursor > Claude Code > VS Code > OpenCode > Codex > Claude Desktop
- **Режимы:** `--dry-run`, `--force`, `--status`, `--install` (launchd, каждые 6ч)

## DESIGN DECISIONS

1. **Атомарная архитектура вместо монолита.** Каждый элемент инфраструктуры = отдельная карточка (файл). Монолитный файл `ВСЯ МОЯ ИНФРАСТРУКТУРА` архивирован и заменён на `registry__20260210220000-01.md` (MOC) + атомарные карточки. Причина: масштабируемость, перекрёстные ссылки, навигация через Obsidian graph view.

2. **Трёхуровневая навигация (MOC → Index → Card).** Верхний уровень — единый registry MOC; средний — индексы по категориям (_index); нижний — карточки. Причина: AI-агент может быстро найти нужную карточку за 2 прыжка.

3. **Два шаблона для инструментов.** `tool-card.md` (95 строк, 12 секций) для Tier 1 и `tool-card-minimal.md` (45 строк, 4 секции) для Tier 2-3. Причина: Tier 3 не нуждается в секциях API/MCP/Расширения, но должен иметь полный YAML и таблицу использования.

4. **Архивация legacy с баннерами.** Устаревшие файлы получают `status: archived` + баннер-редирект на актуальную версию. Не удаляются. Причина: сохранение истории, отсутствие битых внешних ссылок.

5. **Скрипт синхронизации MCP.** MCP-конфиги синхронизируются автоматически через `mcp-sync.mjs`, а не вручную. Причина: 6 разных инструментов с разными форматами конфигов — ручная синхронизация ненадёжна.

6. **Никаких секретов в документации.** Указываются только названия переменных окружения, не значения. Причина: репозиторий в Git, безопасность.

7. **Скрипты валидации.** `link-checker.sh` и `yaml-validate.sh` обеспечивают целостность wikilinks и YAML-метаданных. Причина: 535+ ссылок и 160+ файлов невозможно проверить вручную.

## DOCOPS/AGENTOPS INTEGRATION

Проект следует стандарту DocOps/AgentOps:

**Обязательные файлы:**
- `AGENTS.md` — tri-state коммутатор правил
- `CLAUDE.md` — инструкции Claude Code
- `AI/` — rulepack (14 документов стандарта)

**Документация:**
- Все `.md` файлы в `docs/` содержат YAML frontmatter
- Формат именования: `name-slug__YYYYMMDDhhmmss-XX.md`
- Ссылки: формат Obsidian `[[file__ID|label]]`

## LINKS (INTERNAL)

- [[readme-standard|README-Standard]] — стандарт README.md
- [[architecture-standard|ARCHITECTURE-Standard]] — стандарт ARCHITECTURE.md (этот документ следует ему)
- [[docops-standard|DocOps-Standard]] — полная спецификация DocOps
- [[agents-format|AGENTS-Format]] — формат AGENTS.md и tri-state режимы

---

**Note:** Этот ARCHITECTURE.md создан по стандарту [ARCHITECTURE-Standard](AI/architecture-standard__20260210103631-02.md). При изменении структуры проекта ОБЯЗАТЕЛЬНО обновить секции Directory Structure и Entry Points, а также поле `updated` в YAML frontmatter.
