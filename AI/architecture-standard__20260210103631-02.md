---
id: 20260210103631-02
title: ARCHITECTURE-Standard — требования к файлу ARCHITECTURE__20260210103632-01.md
summary: >
  Стандарт оформления файла ARCHITECTURE__20260210103632-01.md — карты структуры проекта для людей и AI. Фиксированное имя без ID-суффикса, YAML frontmatter обязателен, стандартные разделы.
type: spec
status: active
tags: [docops/standard, docops/rules, docops/agentops]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-09
updated: 2026-02-09
---
# ARCHITECTURE-STANDARD — ТРЕБОВАНИЯ К ФАЙЛУ ARCHITECTURE.MD

## НАЗНАЧЕНИЕ

`ARCHITECTURE__20260210103632-01.md` — документ, описывающий структуру и архитектуру проекта. Индустриальный стандарт де-факто для open-source проектов (rust-analyzer, VSCode, Flutter, NextJS, Redis).

**Основные функции:**
1. **Directory Structure** — карта файловой структуры проекта (что где находится)
2. **Entry Points** — точки входа в код для разработчиков
3. **High-Level Architecture** — диаграммы и описание компонентов
4. **Design Decisions** — архитектурные решения и их обоснование

---

## ОБЯЗАТЕЛЬНЫЕ ТРЕБОВАНИЯ

### 1. ИМЯ ФАЙЛА — ФИКСИРОВАННОЕ

| Параметр | Значение | Обоснование |
|----------|----------|-------------|
| **Имя** | `ARCHITECTURE__20260210103632-01.md` | Индустриальный стандарт де-факто (awesome-architecture-md, Матклад) |
| **Регистр** | UPPERCASE для корня | Стандартная конвенция для tool-entry файлов |
| **ID-суффикс** | ЗАПРЕЩЁН | `ARCHITECTURE__20260209-01.md` нестандартен и не распознаётся |
| **Расположение** | Корень репозитория | Основное местоположение; альтернатива: `docs/architecture.md` (lowercase) |

**Tool-Entry File Exception:** `ARCHITECTURE__20260210103632-01.md` относится к категории tool-entry файлов и является исключением из правила именования с ID-суффиксами согласно [[agents-format__20260209220613-05|AGENTS-Format]].

### 2. YAML FRONTMATTER — ОБЯЗАТЕЛЕН

**В отличие от README.md**, `ARCHITECTURE__20260210103632-01.md` ДОЛЖЕН содержать YAML frontmatter по стандарту DocOps.

**Обоснование:**
- ARCHITECTURE__20260210103632-01.md — технический документ (не маркетинговый)
- Используется преимущественно разработчиками и AI
- Метаданные критичны для индексации и навигации
- Не отображается автоматически на GitHub (нет проблем с видимостью frontmatter)

**Обязательные поля YAML:**
```yaml
---
id: 20260209224717-01         # ID по стандарту DocOps
title: ARCHITECTURE — ...      # Название документа
summary: >                     # Краткое описание (50-150 символов)
  Архитектура и структура проекта...
type: spec                     # Тип документа (spec для архитектуры)
status: active                 # Статус (active для актуальной архитектуры)
tags: [...]                    # Теги (docops/architecture, project-specific)
source: claude-opus-4-6        # Источник (автор или AI)
ai_weight: high                # Приоритет для AI (high для критичных документов)
created: 2026-02-09            # Дата создания
updated: 2026-02-09            # Дата последнего обновления
---
```

**Особенность:** ID в YAML-заголовке присутствует, но НЕ добавляется в имя файла.

### 3. ОБЯЗАТЕЛЬНЫЕ РАЗДЕЛЫ

| # | Раздел | Описание | Обязательность |
|---|--------|----------|----------------|
| 1 | **Overview** | Краткое описание проекта и архитектуры (1-3 параграфа) | Обязательно |
| 2 | **Directory Structure** | Карта файловой структуры с описанием назначения папок | Обязательно |
| 3 | **Entry Points** | Основные точки входа в код (main файлы, ключевые модули) | Обязательно |
| 4 | **High-Level Architecture** | Диаграммы и описание компонентов | Рекомендуется |
| 5 | **Key Components** | Описание основных компонентов и их взаимодействия | Рекомендуется |
| 6 | **Design Decisions** | Архитектурные решения и trade-offs | Рекомендуется |
| 7 | **Links (internal)** | Ссылки на связанные документы (по стандарту DocOps) | Обязательно при наличии ссылок |

---

## РЕКОМЕНДУЕМАЯ СТРУКТУРА

```markdown
---
id: YYYYMMDDhhmmss-XX
title: ARCHITECTURE — Название проекта
summary: >
  Архитектура и структура проекта [название].
  [Краткое описание основных компонентов]
type: spec
status: active
tags: [docops/architecture, project/название]
source: claude-opus-4-6
ai_weight: high
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# ARCHITECTURE

## Overview

Краткое описание проекта (1-3 параграфа):
- Что это за проект
- Основные технологии и паттерны
- Целевая аудитория разработчиков

## Directory Structure

\`\`\`
/
├── src/                    # Исходный код
│   ├── core/              # Основная бизнес-логика
│   ├── utils/             # Утилиты и хелперы
│   └── api/               # API endpoints
├── docs/                   # Документация
│   ├── ai/                # AI-правила (AGENTS.md, rulepack)
│   └── guides/            # Руководства для разработчиков
├── scripts/                # Скрипты автоматизации
├── tests/                  # Тесты
├── template/               # Шаблоны для bootstrap
├── AGENTS.md               # Конфигурация AI-агентов
├── CLAUDE.md               # Инструкции для Claude Code
├── README.md               # Описание проекта
└── ARCHITECTURE__20260210103632-01.md         # Этот документ
\`\`\`

### Назначение директорий

**src/** — исходный код приложения
- `core/` — основная бизнес-логика, модели, контроллеры
- `utils/` — вспомогательные функции, общие утилиты
- `api/` — API endpoints, роутинг

**docs/** — документация
- `ai/` — правила для AI-инструментов (копируются из template)
- `guides/` — руководства для разработчиков

**scripts/** — автоматизация
- Скрипты для CI/CD, миграций, генерации кода

**tests/** — тестирование
- Unit-тесты, интеграционные тесты

**template/** — шаблоны для новых проектов
- Используется скриптом ai-bootstrap.py

## Entry Points

**Для разработчиков:**
- `src/main.py` — основная точка входа приложения
- `src/core/engine.py` — ядро обработки

**Для AI-инструментов:**
- `AGENTS.md` — коммутатор правил
- `CLAUDE.md` — инструкции для Claude Code
- `README.md` — контекст проекта

**Для тестирования:**
- `tests/test_suite.py` — основной набор тестов

## High-Level Architecture

[Опционально: диаграммы, схемы компонентов]

\`\`\`
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  API Layer  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Core Logic  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Database   │
└─────────────┘
\`\`\`

## Key Components

### Component 1: Название
- **Назначение:** Описание
- **Технологии:** Список
- **Зависимости:** От чего зависит

### Component 2: Название
- **Назначение:** Описание
- **Технологии:** Список

## Design Decisions

### Решение 1: Выбор архитектурного паттерна

**Контекст:** Необходимо было выбрать между монолитом и микросервисами.

**Решение:** Монолитная архитектура с модульной структурой.

**Обоснование:**
- Малый размер команды
- Простота развертывания
- Возможность рефакторинга в микросервисы позже

**Trade-offs:**
- Снижена горизонтальная масштабируемость
- Упрощено тестирование и отладка

## Links (internal)

- [[readme-standard__20260210103631-01|README-Standard]] — стандарт файла README.md
- [[docops-standard__20260209220613-02|DocOps-Standard]] — полный регламент DocOps
- [[agents-format__20260209220613-05|AGENTS-Format]] — формат AGENTS.md
```

---

## ОТЛИЧИЯ ОТ README.MD

| Параметр | ARCHITECTURE__20260210103632-01.md | README.md |
|----------|-----------------|-----------|
| **YAML frontmatter** | ✅ Обязателен (10 полей DocOps) | ❌ ЗАПРЕЩЁН (виден на GitHub) |
| **Аудитория** | Разработчики, AI | Широкая (пользователи, контрибьюторы) |
| **Фокус** | Технические детали, структура | Маркетинг, quick start |
| **Длина** | 500-2000 строк (детальный) | 100-500 строк (краткий) |
| **Обновление** | При изменении архитектуры | При релизах, изменении фич |

---

## ВЗАИМОДЕЙСТВИЕ С AI-ИНСТРУМЕНТАМИ

### CLAUDE CODE
- Читает `ARCHITECTURE__20260210103632-01.md` для понимания структуры проекта
- YAML frontmatter НЕ мешает (Claude парсит Markdown)
- Приоритет для навигации благодаря `ai_weight: high`

### CURSOR AI
- Индексирует `ARCHITECTURE__20260210103632-01.md` при первом открытии проекта
- Использует Directory Structure для рекомендаций размещения файлов

### GITHUB COPILOT
- Читает ARCHITECTURE__20260210103632-01.md как контекст
- Frontmatter игнорируется (не критично, т.к. файл не отображается автоматически)

---

## ПРИМЕРЫ ИЗ ИНДУСТРИИ

### RUST-ANALYZER — ЭТАЛОННЫЙ ПРИМЕР
[GitHub: rust-analyzer/ARCHITECTURE__20260210103632-01.md](https://github.com/rust-lang/rust-analyzer/blob/master/docs/dev/architecture.md)

Структура:
- Overview
- Source Code Organization
- Entry Points
- Code Walk-Through
- Cross-Cutting Concerns

### VSCODE
[GitHub: microsoft/vscode/wiki/Source-Code-Organization](https://github.com/microsoft/vscode/wiki/Source-Code-Organization)

Альтернативное размещение: wiki, но концепция та же.

### FLUTTER ENGINE
[GitHub: flutter/engine/ARCHITECTURE__20260210103632-01.md](https://github.com/flutter/flutter/wiki/The-Engine-architecture)

Детальные диаграммы компонентов и потоков данных.

---

## ПРОВЕРКА COMPLIANCE

### АВТОМАТИЧЕСКАЯ ВАЛИДАЦИЯ (DOCOPS-LINT.PY)

Скрипт проверяет:
- ✅ Наличие `ARCHITECTURE__20260210103632-01.md` в корне репозитория
- ✅ YAML frontmatter присутствует и валиден (10 полей)
- ✅ Обязательные разделы: Overview, Directory Structure, Entry Points
- ✅ Раздел Links (internal) при наличии Obsidian-ссылок

### РУЧНАЯ ПРОВЕРКА

- Все директории из Directory Structure существуют
- Entry Points актуальны (файлы не переименованы/удалены)
- Design Decisions отражают текущее состояние
- `updated` обновлён при изменении архитектуры

---

## МИГРАЦИЯ СУЩЕСТВУЮЩИХ ПРОЕКТОВ

### ЕСЛИ ARCHITECTURE.MD ОТСУТСТВУЕТ

1. Скопировать шаблон из `template/ARCHITECTURE__20260210103632-01.md`
2. Сгенерировать ID: `date +"%Y%m%d%H%M%S"`
3. Заполнить YAML frontmatter (вставить ID, title, summary, tags)
4. Описать Directory Structure (скопировать из `tree` или `ls`)
5. Указать Entry Points
6. Закоммитить в корень репозитория

### ЕСЛИ ЕСТЬ DOCS/ARCHITECTURE.MD (LOWERCASE В ПОДДИРЕКТОРИИ)

**Вариант A:** Переместить в корень с переименованием
```bash
mv docs/architecture.md ARCHITECTURE__20260210103632-01.md
# Добавить YAML frontmatter
# Обновить ссылки в других документах
```

**Вариант B:** Создать ARCHITECTURE__20260210103632-01.md в корне со ссылкой
```markdown
# ARCHITECTURE

Детальная архитектурная документация находится в [docs/architecture.md](docs/architecture.md).
```

---

## РЕКОМЕНДАЦИИ ПО ПОДДЕРЖКЕ

### КОГДА ОБНОВЛЯТЬ ARCHITECTURE.MD

- ✅ Добавление новой директории в проект
- ✅ Изменение структуры модулей
- ✅ Рефакторинг архитектурных компонентов
- ✅ Смена технологического стека
- ❌ Мелкие рефакторинги внутри модулей (не требуют обновления)

### PROGRESSIVE ENRICHMENT

AI-агент (по стандарту DocOps) при касании `ARCHITECTURE__20260210103632-01.md` ОБЯЗАН:
- Проверить актуальность Directory Structure (сверить с `tree`)
- Обновить поле `updated` в YAML
- Дополнить пустые разделы (если есть placeholder)

---

## LINKS (INTERNAL)

- [[readme-standard__20260210103631-01|README-Standard]] — стандарт файла README.md
- [[agents-format__20260209220613-05|AGENTS-Format]] — формат AGENTS.md и tool-entry исключения
- [[docops-standard__20260209220613-02|DocOps-Standard]] — полный регламент DocOps
- [[adapters__20260209220613-06|Adapters]] — список tool-entry файлов для AI-инструментов
