---
id: 20260210103631-04
title: Project-Initialization-Standard — инициализация новых проектов
summary: >
  Стандарт процесса инициализации новых проектов через bootstrap-скрипт и AI. Этапы, чек-листы, критерии готовности проекта.
type: process
status: active
tags: [docops/agentops, process/initialization, ai/automation]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-10
updated: 2026-02-10
---
# PROJECT-INITIALIZATION-STANDARD — ИНИЦИАЛИЗАЦИЯ ПРОЕКТОВ

## НАЗНАЧЕНИЕ

Стандарт определяет процесс инициализации новых проектов через систему DocOps/AgentOps. Цель — обеспечить единообразную, быструю и качественную настройку проектов с правилами для AI.

---

## ЭТАПЫ ИНИЦИАЛИЗАЦИИ

### Этап 1: Bootstrap (автоматический)

**Исполнитель:** Пользователь или CI/CD

**Команда:**
```bash
python3 /path/to/AgentOps/template/scripts/ai-bootstrap.py /path/to/new-project
```

**Что происходит:**
1. Копирование rulepack из `template/AI/` в `project/AI/`
2. Генерация уникальных ID для файлов (timestamp-based)
3. Переименование файлов с добавлением ID-суффиксов
4. Переписывание Obsidian-ссылок (замена на ID-версии)
5. Создание `AGENTS.md` с управляемым блоком
6. Создание заглушек: `README.md`, `ARCHITECTURE__20260210103632-01.md`, `CLAUDE.md`

**Результат:**
```
project/
├── AI/                               # 6-8 файлов rulepack с ID
│   ├── docops-core__XXXXX.md
│   ├── docops-standard__XXXXX.md
│   ├── docops-schema__XXXXX.md
│   ├── readme-standard__XXXXX.md
│   ├── architecture-standard__XXXXX.md
│   ├── source-allowlist__XXXXX.md
│   ├── agents-format__XXXXX.md
│   └── adapters__XXXXX.md
├── AGENTS.md                         # Коммутатор правил
├── README.md                         # ЗАГЛУШКА (placeholder: true)
├── ARCHITECTURE__20260210103632-01.md                   # ЗАГЛУШКА (placeholder: true)
└── CLAUDE.md                         # ЗАГЛУШКА (placeholder: true)
```

**Время выполнения:** ~5 секунд

---

### Этап 2: Обнаружение заглушек (AI-driven)

**Исполнитель:** AI (Claude, Cursor, или другой инструмент)

**Триггер:** Первое касание проекта (open, read file, edit)

**Что происходит:**
1. AI читает любой файл проекта (README.md, ARCHITECTURE__20260210103632-01.md, src/)
2. Обнаруживает метаданные `placeholder: true` в YAML или HTML-комментариях
3. Извлекает `placeholder_instructions` из файла
4. Понимает, что проект в состоянии инициализации

**Результат:**
- AI осведомлена о состоянии проекта
- Готова к выполнению инструкций из placeholder

**Время выполнения:** мгновенно

---

### Этап 3: Анализ контекста проекта (AI-driven)

**Исполнитель:** AI

**Алгоритм:**
```
1. Прочитать AGENTS.md
   └─> Извлечь bootstrap_metadata.exclude_from_context_analysis

2. Сканировать проект (рекурсивно)
   └─> Найти все файлы
   └─> Исключить:
       - Файлы из exclude_from_context_analysis (AI/*, AGENTS.md)
       - Стандартные игноры (.git/, .venv/, node_modules/, __pycache__/)

3. Проанализировать оставшиеся файлы:
   a) Определить язык и технологии:
      - package.json → Node.js, зависимости npm
      - pyproject.toml → Python, зависимости pip
      - Cargo.toml → Rust, зависимости cargo
      - go.mod → Go, модули
      - *.js, *.py, *.rs, *.go → расширения файлов

   b) Найти entry points:
      - main.py, __main__.py
      - index.js, server.js, app.js
      - main.go
      - main.rs, lib.rs

   c) Построить структуру директорий:
      - tree scan (только директории с файлами)

   d) Извлечь существующую документацию:
      - README.txt (старый формат)
      - CONTRIBUTING__20260213171958.md
      - docs/*.md

   e) Определить название проекта:
      - Из package.json, pyproject.toml, Cargo.toml (поле name)
      - Из имени директории (fallback)

4. Построить контекст:
   {
     'project_name': 'my-project',
     'technologies': ['Python 3.11', 'FastAPI', 'SQLAlchemy'],
     'entry_points': ['src/main.py'],
     'structure': {
       'src/': 'Source code',
       'tests/': 'Tests',
       'docs/': 'Documentation'
     },
     'existing_docs': {
       'README.txt': '...',
       'docs/api.md': '...'
     },
     'dependencies': [...],
   }

5. Оценить достаточность контекста:
   - Контекста достаточно: project_name И (technologies ИЛИ existing_docs)
   - Контекста недостаточно: пустой проект ИЛИ только code без описания
```

**Результат:**
- Контекст проекта собран
- Решение о стратегии заполнения принято

**Время выполнения:** 5-30 секунд (зависит от размера проекта)

---

### Этап 4: Заполнение заглушек (AI-driven)

**Исполнитель:** AI

#### Вариант A: Автозаполнение (контекста достаточно)

**Алгоритм:**
```
1. Заполнить README.md:
   - Название: из project_name
   - Описание: из existing_docs или краткое описание на основе technologies
   - Технологии: из dependencies
   - Установка: стандартные команды для языка (pip install, npm install)
   - Использование: на основе entry_points
   - Структура: из tree scan

2. Заполнить ARCHITECTURE__20260210103632-01.md:
   - Overview: project_name + technologies
   - Directory Structure: из tree scan с описанием назначения папок
   - Entry Points: из найденных main файлов
   - Technologies: детальный список
   - Key Components: на основе структуры src/

3. Заполнить CLAUDE.md:
   - Минимальная заглушка (ссылка на AGENTS.md)
   - НЕ добавлять лишние правила (только Claude-специфичные, если есть)

4. Подтвердить у пользователя:
   "Я проанализировал проект:
   - Название: my-project
   - Технологии: Python 3.11, FastAPI
   - Entry point: src/main.py

   Заполнил README.md и ARCHITECTURE__20260210103632-01.md на основе анализа.
   Проверьте корректность?"

5. Если пользователь подтверждает:
   └─> Убрать placeholder: true
   └─> Обновить status: draft → active
   └─> Обновить updated в YAML

6. Если пользователь корректирует:
   └─> Задать уточняющие вопросы
   └─> Переписать с учётом feedback
```

#### Вариант B: Диалоговое заполнение (контекста недостаточно)

**Алгоритм:**
```
1. Сообщить пользователю:
   "Проект выглядит новым (пустым).
   Чтобы заполнить README.md и ARCHITECTURE__20260210103632-01.md, мне нужна информация.
   Задам несколько вопросов."

2. Задать вопросы (используя AskUserQuestion):
   a) Как называется проект?
   b) Краткое описание проекта (1-2 предложения)?
   c) Основные возможности/функции (3-5 пунктов)?
   d) Технологии и фреймворки?
   e) Архитектурный паттерн (MVC, микросервисы, монолит)?
   f) Целевая аудитория (пользователи или разработчики)?

3. Заполнить заглушки на основе ответов

4. Показать результат:
   "Заполнил README.md и ARCHITECTURE__20260210103632-01.md на основе ваших ответов.
   Проверьте корректность?"

5. После подтверждения:
   └─> Убрать placeholder: true
   └─> Обновить status/updated
```

**Результат:**
- README.md заполнен
- ARCHITECTURE__20260210103632-01.md заполнен
- CLAUDE.md заполнен (минимальная версия)
- Метаданные placeholder удалены

**Время выполнения:** 30-300 секунд (зависит от диалога)

---

### Этап 5: Финализация (AI-driven)

**Исполнитель:** AI

**Что происходит:**
1. Проверка всех заполненных файлов:
   - README.md: нет placeholder, заполнены все разделы
   - ARCHITECTURE__20260210103632-01.md: нет placeholder, status: active
   - CLAUDE.md: нет placeholder, минимальная версия
2. Обновление метаданных проекта (если используется PROJECT-STATUS.md)
3. Сообщение пользователю:
   "✅ Проект инициализирован!
   - README.md: заполнен
   - ARCHITECTURE__20260210103632-01.md: заполнен
   - AGENTS.md: настроен
   - Правила DocOps/AgentOps: активны

   Готов помогать в развитии проекта!"

**Результат:**
- Проект полностью инициализирован
- Все заглушки заполнены
- AI готова к работе

---

## ЧЕК-ЛИСТ ИНИЦИАЛИЗАЦИИ

### Перед началом

- [ ] Проект находится в Git-репозитории (или инициализирован git)
- [ ] Определена структура проекта (или будет создана)
- [ ] Bootstrap-скрипт доступен

### После bootstrap-скрипта

- [ ] Создана директория `AI/` с 6-8 файлами rulepack
- [ ] Создан `AGENTS.md` с bootstrap_metadata
- [ ] Созданы заглушки: README.md, ARCHITECTURE__20260210103632-01.md, CLAUDE.md
- [ ] Все файлы помечены `placeholder: true`

### После заполнения заглушек (AI)

- [ ] README.md заполнен, нет `placeholder: true`
- [ ] ARCHITECTURE__20260210103632-01.md заполнен, status: active
- [ ] CLAUDE.md заполнен (минимальная версия)
- [ ] Пользователь подтвердил корректность

### Критерии "Проект инициализирован"

- [ ] Все tool-entry файлы заполнены (README, ARCHITECTURE, AGENTS, CLAUDE)
- [ ] Нет файлов с `placeholder: true`
- [ ] AGENTS.md содержит актуальный список правил
- [ ] Directory structure в ARCHITECTURE__20260210103632-01.md соответствует реальной структуре

---

## ТИПЫ ПРОЕКТОВ И ОСОБЕННОСТИ

### Новый пустой проект

**Признаки:**
- Только структура папок (src/, tests/, docs/)
- Нет кода или минимальный boilerplate

**Стратегия:**
- Диалоговое заполнение (вопросы пользователю)
- ARCHITECTURE__20260210103632-01.md с базовой структурой (заполнить позже)

### Новый проект с кодом

**Признаки:**
- Есть code files (*.py, *.js, *.rs)
- Есть package manager files (package.json, pyproject.toml)
- Может быть старый README.txt

**Стратегия:**
- Автозаполнение на основе анализа
- Миграция информации из старого README.txt (если есть)
- Подтверждение у пользователя

### Старый проект (внедрение DocOps/AgentOps)

**Признаки:**
- Зрелый codebase
- Существующие README.md, CONTRIBUTING__20260213171958.md, docs/
- Возможно, уже есть .cursorrules или другие AI-правила

**Стратегия:**
- Автозаполнение на основе существующей документации
- НЕ перезаписывать существующий README.md (если он не заглушка)
- Предложить пользователю: "У вас уже есть README.md. Хотите, чтобы я обновил его согласно стандарту или оставить как есть?"
- Мигрировать правила из .cursorrules в AGENTS.md

---

## ОБРАБОТКА ОШИБОК

### Проблема: Нет Git-репозитория

**Симптом:** Bootstrap-скрипт не может определить корень проекта

**Решение:**
```bash
cd /path/to/project
git init
python3 ai-bootstrap.py .
```

### Проблема: Уже есть AI/ директория

**Симптом:** Bootstrap-скрипт находит существующие файлы

**Решение:**
- Скрипт пропускает существующие файлы (SKIP)
- Обновляет только AGENTS.md (управляемый блок)

### Проблема: AI не обнаруживает заглушки

**Симптом:** AI не предлагает заполнить README.md

**Возможные причины:**
1. AI не прочитала файл с заглушкой
2. Метаданные placeholder повреждены
3. AI не обучена распознавать placeholders

**Решение:**
- Явно попросить AI: "Прочитай README.md и ARCHITECTURE__20260210103632-01.md. Это заглушки, заполни их."
- Обновить CLAUDE.md с инструкциями по распознаванию placeholders

### Проблема: Контекста недостаточно, но AI не задаёт вопросы

**Симптом:** AI молча ждёт

**Решение:**
- Явно указать: "Проект новый, задай вопросы для заполнения README"
- Добавить в CLAUDE.md trigger для proactive questioning

---

## ПРИМЕРЫ

### Пример 1: Новый Python FastAPI проект

**Начальное состояние:**
```
my-api/
├── src/
│   └── main.py
├── tests/
├── pyproject.toml
└── .gitignore
```

**После bootstrap:**
```
my-api/
├── AI/                     # 8 файлов rulepack
├── src/
│   └── main.py
├── tests/
├── pyproject.toml
├── AGENTS.md
├── README.md              # ЗАГЛУШКА
├── ARCHITECTURE__20260210103632-01.md        # ЗАГЛУШКА
└── CLAUDE.md              # ЗАГЛУШКА
```

**AI анализирует:**
- pyproject.toml → FastAPI, SQLAlchemy, Pydantic
- src/main.py → entry point

**AI заполняет автоматически:**
- README.md: "REST API на FastAPI для [назначение]. Технологии: Python 3.11, FastAPI, SQLAlchemy..."
- ARCHITECTURE__20260210103632-01.md: структура, entry points, компоненты

**Подтверждение:**
"Проект: my-api, FastAPI REST API. Заполнил README и ARCHITECTURE. Корректно?"

### Пример 2: Пустой новый проект

**Начальное состояние:**
```
empty-project/
└── .git/
```

**После bootstrap:**
```
empty-project/
├── AI/
├── AGENTS.md
├── README.md              # ЗАГЛУШКА
├── ARCHITECTURE__20260210103632-01.md        # ЗАГЛУШКА
└── CLAUDE.md              # ЗАГЛУШКА
```

**AI обнаруживает:**
- Нет файлов кроме заглушек
- Контекста недостаточно

**AI задаёт вопросы:**
```
1. Как называется проект? → "Task Manager"
2. Краткое описание? → "CLI инструмент для управления задачами"
3. Основные функции? → "Добавление, удаление, фильтрация задач"
4. Технологии? → "Python 3.11, Click, SQLite"
5. Архитектурный паттерн? → "CLI application"
```

**AI заполняет:**
- README.md на основе ответов
- ARCHITECTURE__20260210103632-01.md с базовой структурой

---

## LINKS (INTERNAL)

- [[placeholder-system__20260210103631-03|Placeholder-System-Standard]] — технические детали системы заглушек
- [[progressive-validation__20260210103631-06|Progressive-Validation-Standard]] — поддержка актуальности после инициализации
- [[readme-standard__20260210103631-01|README-Standard]] — требования к README.md
- [[architecture-standard__20260210103631-02|ARCHITECTURE-Standard]] — требования к ARCHITECTURE__20260210103632-01.md
- [[agents-format__20260209220613-05|AGENTS-Format]] — формат AGENTS.md

---

**Примечание:** Этот стандарт описывает процесс инициализации. Технические детали заглушек см. в [[placeholder-system__20260210103631-03|placeholder-system]].
