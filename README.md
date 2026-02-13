# infra_all_instruments

Атомарная база знаний IT-инфраструктуры. Единый каталог всего инструментария: софт, железо, нейросети, серверы, MCP-серверы, интеграции и их взаимосвязи.

**Владелец:** Роман Галанкин | **Машина:** iMac Pro 2017 (macOS)

## Статистика

- **~160 файлов** документации
- **56 карточек** инструментов (Tier 1-3)
- **16 MCP-серверов** (Cursor, Warp, Claude Desktop)
- **8 карточек** нейросетей + трёхмерная таксономия
- **535+ wikilinks** для навигации

## Точка входа

**`registry__20260210220000-01.md`** — TOP-LEVEL MOC (Map of Content), навигация по всем категориям.

Навигация трёхуровневая: **MOC → Index → Card**

| Уровень | Файл | Описание |
|---------|------|---------|
| MOC | `registry__20260210220000-01.md` | Навигация по всем категориям |
| Index | `docs/tools/_index__20260210220000-04.md` | Реестр инструментов (56 карточек) |
| Index | `docs/neural-networks/_index__20260210220000-05.md` | Реестр нейросетей (8 карточек) |
| Index | `docs/mcp/_index__20260210220000-06.md` | Реестр MCP-серверов (16 серверов) |
| Index | `docs/hardware/_index__20260210220000-02.md` | Реестр железа |
| Index | `docs/infrastructure/_index__20260210220000-03.md` | Реестр инфраструктуры |

## Структура

```
/
├── registry__20260210220000-01.md       # TOP-LEVEL MOC
├── docs/
│   ├── hardware/                        # Физические устройства
│   ├── infrastructure/                  # Серверы, Docker, VPN, домены
│   ├── tools/                           # Программы и приложения (56 карточек)
│   ├── neural-networks/                 # Нейросети (cards/, by-type/, by-provider/, by-runtime/)
│   ├── mcp/                             # MCP-серверы (cards/, by-tool/)
│   ├── integrations/                    # Карта связей между компонентами
│   ├── automation/                      # Скрипты аудита, n8n-воркфлоу
│   ├── analytics/                       # AI-анализ и рекомендации
│   └── guides/                          # Руководства по процессам
├── templates/                           # 6 шаблонов карточек
├── scripts/                             # Скрипты синхронизации и валидации
├── AI/                                  # Rulepack DocOps/AgentOps
└── AGENTS.md, CLAUDE.md, ARCHITECTURE.md
```

## Добавление документации

### Новый инструмент

1. Определить Tier (1/2/3) — глубина документации
2. Создать карточку в `docs/tools/` по шаблону из `templates/`
   - Tier 1: `templates/tool-card.md` (полный, 95 строк)
   - Tier 2-3: `templates/tool-card-minimal.md` (лёгкий, 45 строк)
3. Обновить `docs/tools/_index__20260210220000-04.md`
4. Если есть MCP — создать карточку в `docs/mcp/cards/`
5. Обновить перекрёстные ссылки

### Новая нейросеть

1. Создать карточку в `docs/neural-networks/cards/` по `templates/nn-model-card.md`
2. Обновить `docs/neural-networks/_index__20260210220000-05.md`
3. Добавить в MOC: by-type, by-provider, by-runtime

## Скрипты

```bash
# MCP синхронизация
node scripts/mcp-sync.mjs              # синхронизация конфигов
node scripts/mcp-sync.mjs --dry-run    # предпросмотр
node scripts/mcp-sync.mjs --status     # текущее состояние

# Аудит и статистика
bash scripts/inventory-check.sh        # проверка покрытия инструментов
bash scripts/generate-stats.sh         # статистика проекта

# Валидация
bash scripts/link-checker.sh           # проверка wikilinks
bash scripts/yaml-validate.sh          # валидация YAML frontmatter

# DocOps линтер
python3 ~/Documents/AgentOps/scripts/docops-lint.py . --report
```

## Контекст инфраструктуры

- **VPS Beget** (82.202.129.193) — Docker-стек: n8n, Dify, Traefik, Postgres, ASR, MCP-n8n
- **VPS Weeceer** (91.218.115.228) — US egress proxy для LLM API
- **n8n** (n8n.fingroup.ru) — движок автоматизаций, критичность: очень высокая
- **WireGuard VPN** (10.66.66.0/24) — закрытый доступ к MCP-n8n
- **Ollama** (localhost:11434) — 6+ установленных моделей

## Безопасность

- В документации **НЕ хранятся** реальные секреты (API keys, пароли, токены)
- Указываются только **названия переменных окружения**, не их значения
- Секреты хранятся только в соответствующих системах (n8n UI, .env файлы и т.д.)

## Связи с другими проектами

- **vps/** — использует информацию о VPS инфраструктуре
- **n8n/** — использует информацию о n8n и workflows
- **Bitrix_Admin/** — использует информацию о Bitrix24 интеграциях
- **Все проекты** — используют общую карту инфраструктуры для понимания контекста

## История

- **2026-02-11:** Довёл до 10/10: миграция legacy, обогащение Tier 3, скрипты валидации
- **2026-02-10:** Трансформация в атомарную базу знаний (156 файлов, 535 wikilinks)
- **2026-02-01:** Создан монолитный реестр инструментов
- **2026-01-27:** Создан проект, перенесена документация из `.vscode/ИНФРАСТРУКТУРА IT/`
- **2026-01-27:** Документированы Cursor, Warp, Claude Desktop, n8n
