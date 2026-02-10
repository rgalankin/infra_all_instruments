---
id: 20260210103631-03
title: Placeholder-System-Standard — система заглушек для новых проектов
summary: >
  Стандарт системы заглушек (placeholders) для файлов, создаваемых bootstrap-скриптом. Определяет метаданные заглушек, алгоритм распознавания AI, логику заполнения.
type: spec
status: active
tags: [docops/agentops, docops/standard, ai/automation, process/initialization]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-10
updated: 2026-02-10
---
# PLACEHOLDER-SYSTEM-STANDARD — СИСТЕМА ЗАГЛУШЕК

## НАЗНАЧЕНИЕ

Placeholder System — система автоматической инициализации проектов через заглушки (placeholders). При создании нового проекта bootstrap-скрипт создаёт файлы-заглушки с метаданными, которые AI распознаёт и заполняет на основе анализа проекта или диалога с пользователем.

**Цели системы:**
1. Упростить инициализацию новых проектов
2. Автоматизировать создание README, ARCHITECTURE и других entry-point файлов
3. Обеспечить единообразие структуры проектов
4. Помочь AI понять контекст проекта через guided initialization

---

## ТИПЫ ЗАГЛУШЕК

### 1. README.md — описание проекта

**Назначение:** Главная точка входа в проект для людей и AI.

**Метаданные заглушки:**
```yaml
---
# НЕТ YAML frontmatter в README.md!
# Метаданные только в комментариях HTML (не отображаются на GitHub)
---
```

**Формат заглушки:**
```markdown
<!-- PLACEHOLDER: true -->
<!-- PLACEHOLDER_VERSION: 2026-02-10-v1 -->
<!-- PLACEHOLDER_INSTRUCTIONS:
Этот README.md — заглушка, созданная ai-bootstrap.py.

AI ОБЯЗАНА при обнаружении этой заглушки:
1. Прочитать AGENTS.md → извлечь bootstrap_metadata.exclude_from_context_analysis
2. Проанализировать все файлы проекта (кроме исключённых)
3. Если контекста достаточно → заполнить README на основе анализа
4. Если контекста недостаточно → задать вопросы пользователю
5. Убрать HTML-комментарии PLACEHOLDER после заполнения
-->

# {{PROJECT_NAME}}

Краткое описание проекта (заполнить).

## Ключевые возможности

- Функция 1 (заполнить)
- Функция 2 (заполнить)
- Функция 3 (заполнить)

[... остальные разделы ...]
```

**Особенность:** README.md БЕЗ YAML frontmatter (требование GitHub), метаданные в HTML-комментариях.

### 2. ARCHITECTURE.md — структура проекта

**Назначение:** Карта файловой структуры и архитектуры проекта.

**Метаданные заглушки:**
```yaml
---
id: {{ARCHITECTURE_ID}}
title: ARCHITECTURE — {{PROJECT_NAME}}
summary: >
  Архитектура и структура проекта {{PROJECT_NAME}}.
  ЗАГЛУШКА: заполнить после анализа проекта.
type: spec
status: draft
tags: [docops/architecture, project/{{PROJECT_SLUG}}]
source: ai-bootstrap
ai_weight: high
created: {{CREATED_DATE}}
updated: {{UPDATED_DATE}}

# PLACEHOLDER METADATA
placeholder: true
placeholder_version: 2026-02-10-v1
placeholder_instructions: >
  Этот ARCHITECTURE.md — заглушка, созданная ai-bootstrap.py.

  AI ОБЯЗАНА при обнаружении "placeholder: true":
  1. Прочитать AGENTS.md → извлечь exclude_from_context_analysis
  2. Сканировать структуру проекта (tree) → автозаполнить Directory Structure
  3. Проанализировать код → определить Entry Points, технологии
  4. Если README.md заполнен → использовать контекст оттуда
  5. Если контекста недостаточно → задать вопросы пользователю
  6. Заполнить все разделы (Overview, Directory Structure, Entry Points, Components)
  7. Убрать "placeholder: true", поставить "status: active"
  8. Обновить "updated" в YAML
---
```

**Формат заглушки:**
```markdown
# ARCHITECTURE

## Overview

{{PROJECT_NAME}} — {{PROJECT_DESCRIPTION}} (ЗАПОЛНИТЬ)

**Основные технологии:** (ЗАПОЛНИТЬ)
- Technology 1
- Technology 2

**Архитектурный паттерн:** (ЗАПОЛНИТЬ)

## Directory Structure

```
/
├── src/                    # (ЗАПОЛНИТЬ ОПИСАНИЕ)
├── docs/                   # (ЗАПОЛНИТЬ ОПИСАНИЕ)
├── tests/                  # (ЗАПОЛНИТЬ ОПИСАНИЕ)
├── AI/                     # Правила DocOps/AgentOps (создано bootstrap)
├── AGENTS.md               # Коммутатор правил (создано bootstrap)
└── README.md               # Описание проекта
\```

### Назначение директорий

(ЗАПОЛНИТЬ НА ОСНОВЕ АНАЛИЗА)

## Entry Points

(ЗАПОЛНИТЬ — найти main файлы, ключевые модули)

## Key Components

(ЗАПОЛНИТЬ — описать основные компоненты)

## Design Decisions

(ЗАПОЛНИТЬ ПРИ РАЗВИТИИ ПРОЕКТА)
```

### 3. CLAUDE.md — адаптер для Claude Code

**Назначение:** Минимальная заглушка-ссылка на AGENTS.md.

**Метаданные заглушки:**
```yaml
---
id: {{CLAUDE_ID}}
title: CLAUDE.md — инструкции для Claude Code
summary: >
  Адаптер правил для Claude Code. Направляет на AGENTS.md как источник истины.
  ЗАГЛУШКА: минимальная версия, расширять только для Claude-специфичных правил.
type: spec
status: active
tags: [docops/adapters, ai/claude]
source: ai-bootstrap
ai_weight: high
created: {{CREATED_DATE}}
updated: {{UPDATED_DATE}}

# PLACEHOLDER METADATA
placeholder: true
placeholder_version: 2026-02-10-v1
placeholder_instructions: >
  Этот CLAUDE.md — заглушка-адаптер, созданная ai-bootstrap.py.

  AI (Claude) при обнаружении "placeholder: true":
  1. Проверить AGENTS.md → убедиться, что все общие правила там
  2. Если есть Claude-специфичные правила в этом файле (НЕ из template) → оставить их
  3. Если правила применимы для любой AI → перенести в AGENTS.md
  4. Оставить в CLAUDE.md ТОЛЬКО:
     - Ссылку на AGENTS.md
     - Claude-специфичные инструкции (формат вывода, использование инструментов)
  5. Убрать "placeholder: true" после проверки
---
```

**Формат заглушки:**
```markdown
# CLAUDE.MD

## ИСТОЧНИК ИСТИНЫ

`AGENTS.md` (корень проекта) — центральный коммутатор правил. Прочитай его перед любой работой.

## CLAUDE-СПЕЦИФИЧНЫЕ ИНСТРУКЦИИ

(Добавлять только правила, применимые ТОЛЬКО для Claude Code)

### Использование инструментов
- ОБЯЗАТЕЛЬНО использовать Read / Glob / Grep (НЕ cat/grep/find через Bash)
- При массовых проверках — Task с subagent

### Формат вывода
- Краткость и конкретность
- Избегать эмодзи (если пользователь не попросил)

---

**ВАЖНО:** Общие правила проекта находятся в [[AGENTS.md]]. Этот файл — только для Claude-специфичных настроек.
```

---

## МЕТАДАННЫЕ ЗАГЛУШЕК

### Обязательные поля

| Поле | Тип | Описание | Пример |
|------|-----|----------|--------|
| `placeholder` | boolean | Флаг заглушки | `true` |
| `placeholder_version` | string | Версия системы заглушек | `2026-02-10-v1` |
| `placeholder_instructions` | string | Инструкции для AI | См. примеры выше |

### Расположение метаданных

- **README.md**: HTML-комментарии (т.к. нет YAML frontmatter)
- **ARCHITECTURE.md**: YAML frontmatter (дополнительные поля)
- **CLAUDE.md**: YAML frontmatter (дополнительные поля)
- **Другие адаптеры**: по формату файла (YAML для .md, комментарии для .cursorrules)

---

## АЛГОРИТМ РАСПОЗНАВАНИЯ И ЗАПОЛНЕНИЯ

### Шаг 1: Обнаружение заглушки

```python
def is_placeholder(file_path: str) -> bool:
    """Проверить, является ли файл заглушкой."""
    if file_path.endswith('.md'):
        content = read_file(file_path)

        # Проверка YAML frontmatter
        if has_yaml_frontmatter(content):
            yaml_data = parse_yaml(content)
            if yaml_data.get('placeholder') == True:
                return True

        # Проверка HTML-комментариев (для README.md)
        if '<!-- PLACEHOLDER: true -->' in content:
            return True

    return False
```

### Шаг 2: Извлечение инструкций

```python
def get_placeholder_instructions(file_path: str) -> str:
    """Извлечь инструкции для AI из заглушки."""
    content = read_file(file_path)

    # Из YAML frontmatter
    if has_yaml_frontmatter(content):
        yaml_data = parse_yaml(content)
        return yaml_data.get('placeholder_instructions', '')

    # Из HTML-комментариев
    match = re.search(r'<!-- PLACEHOLDER_INSTRUCTIONS:\s*(.*?)\s*-->', content, re.DOTALL)
    if match:
        return match.group(1).strip()

    return ''
```

### Шаг 3: Анализ проекта для контекста

```python
def analyze_project_for_context(project_root: str) -> dict:
    """Проанализировать проект для заполнения заглушек."""

    # 1. Прочитать AGENTS.md
    agents_md = read_file(f"{project_root}/AGENTS.md")
    exclude_patterns = extract_exclude_patterns(agents_md)

    # 2. Сканировать все файлы
    all_files = scan_directory(project_root, recursive=True)

    # 3. Исключить файлы по паттернам
    context_files = []
    for file in all_files:
        if not matches_any_pattern(file, exclude_patterns):
            if not is_ignored_directory(file):  # .git, .venv, node_modules
                context_files.append(file)

    # 4. Проанализировать оставшиеся файлы
    context = {
        'project_name': detect_project_name(context_files),
        'technologies': detect_technologies(context_files),
        'structure': build_directory_tree(project_root),
        'entry_points': find_entry_points(context_files),
        'dependencies': extract_dependencies(context_files),
        'existing_docs': extract_documentation(context_files),
    }

    return context
```

### Шаг 4: Заполнение заглушки

```python
def fill_placeholder(file_path: str, context: dict, user_input: dict = None):
    """Заполнить заглушку на основе контекста и/или пользовательского ввода."""

    template = read_file(file_path)
    instructions = get_placeholder_instructions(file_path)

    # Определить, достаточно ли контекста
    if has_sufficient_context(context):
        # Автозаполнение на основе анализа
        filled_content = auto_fill_from_context(template, context)

        # Подтвердить у пользователя
        user_approval = ask_user(
            f"Я проанализировал проект и заполнил {file_path}. "
            f"Проект: {context['project_name']}, технологии: {context['technologies']}. "
            f"Корректно?"
        )

        if not user_approval:
            # Уточнить у пользователя
            user_input = ask_clarifying_questions(context)
            filled_content = fill_from_user_input(template, user_input)

    else:
        # Недостаточно контекста — задать вопросы
        user_input = ask_initialization_questions()
        filled_content = fill_from_user_input(template, user_input)

    # Убрать метаданные заглушки
    filled_content = remove_placeholder_metadata(filled_content)

    # Обновить YAML (если есть)
    if has_yaml_frontmatter(filled_content):
        filled_content = update_yaml_field(filled_content, 'placeholder', delete=True)
        filled_content = update_yaml_field(filled_content, 'status', 'active')
        filled_content = update_yaml_field(filled_content, 'updated', today())

    # Сохранить
    write_file(file_path, filled_content)
```

### Шаг 5: Вопросы пользователю (при недостатке контекста)

```python
def ask_initialization_questions() -> dict:
    """Задать вопросы пользователю для инициализации проекта."""

    questions = [
        {
            'key': 'project_name',
            'question': 'Как называется проект?',
            'required': True,
        },
        {
            'key': 'project_description',
            'question': 'Краткое описание проекта (1-2 предложения)?',
            'required': True,
        },
        {
            'key': 'key_features',
            'question': 'Основные возможности/функции (3-5 пунктов)?',
            'required': False,
        },
        {
            'key': 'tech_stack',
            'question': 'Технологии и фреймворки?',
            'required': False,
        },
        {
            'key': 'architecture_pattern',
            'question': 'Архитектурный паттерн (MVC, микросервисы, монолит)?',
            'required': False,
        },
    ]

    answers = {}
    for q in questions:
        answer = ask_user(q['question'])
        if answer or q['required']:
            answers[q['key']] = answer

    return answers
```

---

## ИНТЕГРАЦИЯ С AGENTS.MD

### bootstrap_metadata в AGENTS.md

```yaml
---
id: XXXXX
title: AGENTS — правила и режимы проекта
# ... другие поля

bootstrap_metadata:
  version: 2026-02-10-v1

  # Файлы, исключаемые из анализа контекста
  exclude_from_context_analysis:
    - "AI/docops-core__*.md"
    - "AI/docops-standard__*.md"
    - "AI/docops-schema__*.md"
    - "AI/source-allowlist__*.md"
    - "AI/readme-standard__*.md"
    - "AI/architecture-standard__*.md"
    - "AI/agents-format__*.md"
    - "AI/adapters__*.md"
    - "AGENTS.md"

  # Инструкции для AI по заполнению заглушек
  context_analysis_instructions: >
    При заполнении заглушек (README.md, ARCHITECTURE.md, CLAUDE.md):

    1. ИСКЛЮЧИТЬ файлы из списка exclude_from_context_analysis
    2. Проанализировать все остальные файлы проекта:
       - Код (определить язык, фреймворки, зависимости)
       - Конфигурация (package.json, pyproject.toml, Cargo.toml, etc.)
       - Существующие документы (старый README.txt, CONTRIBUTING.md, etc.)
    3. Построить контекст проекта:
       - Название (из package.json или директории)
       - Технологии (из зависимостей и расширений файлов)
       - Структура (tree scan)
       - Entry points (main.py, index.js, cmd/main.go, etc.)
    4. Принять решение:
       - Если контекста достаточно → заполнить автоматически + подтвердить у пользователя
       - Если контекста недостаточно → задать вопросы пользователю
    5. После заполнения:
       - Убрать метаданные "placeholder: true"
       - Обновить "status: draft" → "status: active" (для ARCHITECTURE.md)
       - Обновить "updated" в YAML
---
```

---

## LIFECYCLE ЗАГЛУШКИ

```
┌─────────────────────────────────────────────────────────────┐
│ СОЗДАНИЕ (ai-bootstrap.py)                                  │
│ - Копирует template с placeholders                          │
│ - Генерирует ID, заполняет {{PLACEHOLDERS}}                 │
│ - Помечает "placeholder: true"                              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ ОБНАРУЖЕНИЕ (AI при первом касании проекта)                 │
│ - Читает файл, находит "placeholder: true"                  │
│ - Извлекает placeholder_instructions                        │
│ - Принимает решение: анализировать или спрашивать           │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ АНАЛИЗ (если контекст есть)                                 │
│ - Читает AGENTS.md → exclude_from_context_analysis          │
│ - Сканирует проект (кроме исключённых файлов)               │
│ - Извлекает контекст (название, технологии, структура)      │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ ЗАПОЛНЕНИЕ (автоматически или через диалог)                 │
│ - Если контекста достаточно → автозаполнение                │
│ - Подтверждение у пользователя                              │
│ - Если контекста нет → вопросы пользователю                 │
│ - Заполнение на основе ответов                              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ ФИНАЛИЗАЦИЯ                                                 │
│ - Убрать "placeholder: true"                                │
│ - Обновить "status: draft" → "status: active"               │
│ - Обновить "updated" в YAML                                 │
│ - Заглушка превращается в обычный документ                  │
└─────────────────────────────────────────────────────────────┘
```

---

## ПРИМЕРЫ

### Пример 1: Новый Python-проект

**Файлы после bootstrap:**
```
my-project/
├── AI/                     # rulepack (6 файлов)
├── src/
│   └── main.py            # entry point
├── pyproject.toml         # зависимости
├── AGENTS.md              # коммутатор (без placeholder)
├── README.md              # ЗАГЛУШКА (placeholder: true в HTML-комментах)
├── ARCHITECTURE.md        # ЗАГЛУШКА (placeholder: true в YAML)
└── CLAUDE.md              # ЗАГЛУШКА (placeholder: true в YAML)
```

**AI обнаруживает заглушки:**
1. Читает `README.md` → находит `<!-- PLACEHOLDER: true -->`
2. Читает `AGENTS.md` → извлекает `exclude_from_context_analysis`
3. Сканирует проект:
   - Исключает `AI/*.md`, `AGENTS.md`
   - Находит `src/main.py`, `pyproject.toml`
4. Анализирует:
   - Название: `my-project` (из директории или pyproject.toml)
   - Технологии: `Python 3.11, FastAPI, SQLAlchemy` (из pyproject.toml)
   - Entry point: `src/main.py`
   - Структура: `src/, tests/, docs/`
5. Заполняет `README.md`:
   ```markdown
   # My Project

   REST API для управления задачами на основе FastAPI.

   ## Технологии
   - Python 3.11
   - FastAPI
   - SQLAlchemy

   [... автозаполненные разделы ...]
   ```
6. Спрашивает: "Проверьте заполненный README. Корректно?"
7. После подтверждения → убирает `<!-- PLACEHOLDER: true -->`

### Пример 2: Пустой новый проект

**Файлы после bootstrap:**
```
empty-project/
├── AI/                     # rulepack
├── AGENTS.md
├── README.md              # ЗАГЛУШКА
├── ARCHITECTURE.md        # ЗАГЛУШКА
└── CLAUDE.md              # ЗАГЛУШКА
```

**AI обнаруживает заглушки:**
1. Сканирует проект → находит только AI/ и заглушки
2. Контекста недостаточно
3. Задаёт вопросы:
   - "Как называется проект?"
   - "Краткое описание?"
   - "Основные функции?"
   - "Технологии?"
4. Заполняет на основе ответов
5. Убирает `placeholder: true`

---

## ПРОВЕРКА СООТВЕТСТВИЯ

### Чек-лист для bootstrap-скрипта

- [ ] Создаёт `README.md` с HTML-комментариями `<!-- PLACEHOLDER: true -->`
- [ ] Создаёт `ARCHITECTURE.md` с `placeholder: true` в YAML
- [ ] Создаёт `CLAUDE.md` с `placeholder: true` в YAML
- [ ] Добавляет `bootstrap_metadata` в `AGENTS.md`
- [ ] Заполняет `exclude_from_context_analysis` актуальным списком

### Чек-лист для AI

- [ ] Распознаёт заглушки (YAML `placeholder: true` или HTML-комментарии)
- [ ] Читает инструкции из `placeholder_instructions`
- [ ] Извлекает `exclude_from_context_analysis` из `AGENTS.md`
- [ ] Анализирует проект (исключая указанные файлы)
- [ ] Задаёт вопросы, если контекста недостаточно
- [ ] Заполняет заглушки корректно
- [ ] Убирает `placeholder: true` после заполнения
- [ ] Обновляет `status` и `updated` в YAML

---

## LINKS (INTERNAL)

- [[project-initialization__20260210103631-04|Project-Initialization-Standard]] — полный процесс инициализации проекта
- [[readme-standard__20260210103631-01|README-Standard]] — требования к файлу README.md
- [[architecture-standard__20260210103631-02|ARCHITECTURE-Standard]] — требования к файлу ARCHITECTURE.md
- [[agents-format__20260209220613-05|AGENTS-Format]] — формат AGENTS.md и bootstrap_metadata
- [[adapters__20260209220613-06|Adapters]] — адаптеры под инструменты

---

**Примечание:** Этот стандарт определяет техническую реализацию системы заглушек. Процесс инициализации проекта целиком описан в [[project-initialization__20260210103631-04|Project-Initialization-Standard]].
