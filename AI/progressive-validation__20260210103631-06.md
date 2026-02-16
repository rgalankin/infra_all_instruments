---
id: 20260210103631-06
title: Progressive-Validation-Standard — непрерывная валидация документации
summary: >
  Стандарт системы непрерывной проверки актуальности документации проекта. Триггеры обновления, метрики качества, автоматические проверки, действия AI.
type: process
status: active
tags: [docops/agentops, process/validation, ai/automation]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-10
updated: 2026-02-10
---
# PROGRESSIVE-VALIDATION-STANDARD — НЕПРЕРЫВНАЯ ВАЛИДАЦИЯ

## НАЗНАЧЕНИЕ

Стандарт определяет систему **непрерывной валидации** документации проекта. После инициализации проекта (заполнения заглушек) AI продолжает следить за актуальностью документов и проактивно предлагает обновления при изменениях в коде.

**Цель:** Поддерживать документацию синхронизированной с реальным состоянием проекта без явных команд пользователя.

---

## КЛЮЧЕВЫЕ КОНЦЕПЦИИ

### 1. Инициализация vs Валидация

**Инициализация** (одноразовая):
- Проект новый или пустой
- Заглушки заполняются первый раз
- Нет предыдущей документации (или она в placeholder-режиме)
- Процесс: [[project-initialization__20260210103631-04|Project-Initialization-Standard]]

**Валидация** (непрерывная):
- Проект уже инициализирован (нет `placeholder: true`)
- Документация существует и была актуальной
- Код изменяется → документация может устареть
- Процесс: этот стандарт

### 2. Проактивность AI

AI **НЕ ждёт** явной команды "обнови README", а:
- Отслеживает изменения в коде
- Сравнивает с документацией
- Обнаруживает расхождения
- Предлагает обновления

**Важно:** AI предлагает, но НЕ обновляет автоматически (требуется согласие пользователя).

### 3. Триггеры валидации

**Триггер** — событие, которое может сделать документацию устаревшей.

**Типы триггеров:**
1. **Code-based** — изменения в коде (новая функция, рефакторинг)
2. **Time-based** — устаревание по времени (README не обновлялся >30 дней)
3. **Structural** — изменения структуры проекта (новая директория)
4. **Dependency-based** — изменения зависимостей (package.json, requirements.txt)

---

## ТРИГГЕРЫ ОБНОВЛЕНИЯ

### Триггер 1: Добавление public функции/API

**Событие:**
- Создана новая функция с docstring
- Добавлен public API endpoint
- Экспортирован новый класс/модуль

**Проверка:**
```python
IF функция публичная (не начинается с _):
  IF функция не упомянута в README.md:
    → TRIGGER: "Добавить описание {function_name} в README.md?"
```

**Пример:**
```python
# Пользователь добавил в src/api/users.py:
def get_user_by_id(user_id: int) -> User:
    """Получить пользователя по ID."""
    ...

# AI обнаруживает:
"Добавлена новая функция get_user_by_id в api/users.py.
Это публичный API — добавить описание в README.md → API Endpoints?"
```

### Триггер 2: Создание новой директории

**Событие:**
- Создана новая папка в проекте (src/новая_папка/)

**Проверка:**
```python
IF директория не в exclude_patterns (.git/, .venv/, node_modules/):
  IF директория не упомянута в ARCHITECTURE__20260210103632-01.md → Directory Structure:
    → TRIGGER: "Добавить {dir_name}/ в ARCHITECTURE__20260210103632-01.md?"
```

**Пример:**
```
# Пользователь создал src/migrations/
# AI обнаруживает:
"Создана новая директория src/migrations/.
Добавить описание в ARCHITECTURE__20260210103632-01.md → Directory Structure?
  src/migrations/    # Миграции базы данных"
```

### Триггер 3: Изменение зависимостей

**Событие:**
- Обновлён package.json, pyproject.toml, requirements.txt, Cargo.toml

**Проверка:**
```python
IF изменены dependencies/devDependencies:
  IF новые зависимости не упомянуты в README.md → Technologies:
    → TRIGGER: "Обновить список технологий в README.md?"
  IF новые зависимости не упомянуты в ARCHITECTURE__20260210103632-01.md → Technologies:
    → TRIGGER: "Обновить Technologies в ARCHITECTURE__20260210103632-01.md?"
```

**Пример:**
```toml
# Пользователь добавил в pyproject.toml:
[tool.poetry.dependencies]
redis = "^5.0.0"  # НОВАЯ ЗАВИСИМОСТЬ

# AI обнаруживает:
"Добавлена зависимость redis в pyproject.toml.
Обновить README.md и ARCHITECTURE__20260210103632-01.md:
  - README.md → Technologies: добавить Redis
  - ARCHITECTURE__20260210103632-01.md → Technologies: добавить Redis 5.0"
```

### Триггер 4: Рефакторинг структуры

**Событие:**
- Переименована директория
- Перемещён entry point (main.py → app.py)
- Изменена иерархия модулей

**Проверка:**
```python
IF ARCHITECTURE__20260210103632-01.md → Directory Structure не соответствует tree:
  → TRIGGER: "ARCHITECTURE__20260210103632-01.md устарел. Обновить структуру директорий?"

IF ARCHITECTURE__20260210103632-01.md → Entry Points не существуют:
  → TRIGGER: "Entry point изменился ({old} → {new}). Обновить ARCHITECTURE__20260210103632-01.md?"
```

**Пример:**
```
# Пользователь переименовал src/main.py → src/app.py
# AI обнаруживает:
"Entry point изменился: src/main.py → src/app.py.
Обновить ARCHITECTURE__20260210103632-01.md → Entry Points:
  - src/app.py — основная точка входа (было: src/main.py)"
```

### Триггер 5: Архитектурное решение

**Событие:**
- Выбор между подходами (монолит vs микросервисы)
- Смена технологии (MySQL → PostgreSQL)
- Добавление архитектурного паттерна (Event Sourcing)

**Проверка:**
```python
IF пользователь обсуждал варианты с AI:
  IF решение принято:
    → TRIGGER: "Зафиксировать архитектурное решение в ARCHITECTURE__20260210103632-01.md → Design Decisions?"
```

**Пример:**
```
# Диалог:
User: "Какую БД использовать: MySQL или PostgreSQL?"
AI: "Рекомендую PostgreSQL, потому что..."
User: "Согласен, используем PostgreSQL."

# AI предлагает:
"Зафиксировать это решение в ARCHITECTURE__20260210103632-01.md → Design Decisions:

### Решение: Выбор СУБД
Контекст: Необходимо было выбрать между MySQL и PostgreSQL.
Решение: PostgreSQL 15
Обоснование: JSON support, лучший JSONB, расширяемость
Trade-offs: Чуть сложнее в настройке, чем MySQL"
```

### Триггер 6: Устаревание по времени

**Событие:**
- README.md не обновлялся >30 дней
- За это время были значительные изменения в коде

**Проверка:**
```python
IF (current_date - README.updated) > 30 дней:
  IF значительные изменения (>10 коммитов, новые файлы):
    → TRIGGER: "README.md устарел ({date}). Проверить актуальность?"
```

**Пример:**
```
# AI при касании проекта:
"README.md последний раз обновлялся 2025-12-15 (56 дней назад).
С тех пор добавлены:
  - src/api/ (новая директория)
  - Redis зависимость
  - 23 коммита
Хотите, чтобы я проверил актуальность и обновил?"
```

---

## МЕТРИКИ КАЧЕСТВА ДОКУМЕНТАЦИИ

AI оценивает качество документации по метрикам и предлагает улучшения.

### Метрика 1: Актуальность README.md

**Критерии:**
- ✅ `updated` в последние 30 дней ИЛИ нет значительных изменений
- ✅ Список технологий соответствует package.json/pyproject.toml
- ✅ Инструкции по установке работают (команды актуальны)
- ✅ Структура проекта соответствует tree

**Оценка:**
```python
score = 0
IF updated в последние 30 дней: score += 25
IF technologies актуальны: score += 25
IF install commands работают: score += 25
IF structure актуальна: score += 25

IF score < 75: WARN "README.md качество низкое"
```

### Метрика 2: Актуальность ARCHITECTURE__20260210103632-01.md

**Критерии:**
- ✅ Directory Structure соответствует `tree` (проверка через сканирование)
- ✅ Entry Points существуют (файлы не удалены/переименованы)
- ✅ Key Components актуальны (компоненты не удалены)
- ✅ Design Decisions актуальны (решения не отменены)

**Проверка:**
```python
# Пример проверки Directory Structure
architecture_dirs = extract_dirs_from_architecture_md()
actual_dirs = scan_project_tree()

missing_dirs = actual_dirs - architecture_dirs  # Новые директории
obsolete_dirs = architecture_dirs - actual_dirs  # Удалённые

IF missing_dirs:
  → TRIGGER: "Обнаружены новые директории: {missing_dirs}. Добавить в ARCHITECTURE__20260210103632-01.md?"
IF obsolete_dirs:
  → TRIGGER: "Директории удалены: {obsolete_dirs}. Обновить ARCHITECTURE__20260210103632-01.md?"
```

### Метрика 3: Покрытие тестами

**Критерии:**
- ✅ Public API покрыт тестами (есть тесты для функций)
- ✅ Критичная бизнес-логика покрыта
- ✅ Coverage > X% (определяется проектом)

**Проверка:**
```python
IF добавлена публичная функция БЕЗ тестов:
  → TRIGGER: "Функция {name} не покрыта тестами. Добавить тест?"
```

### Метрика 4: Синхронизация AGENTS.md

**Критерии:**
- ✅ Все правила активированы корректно (нет дубликатов)
- ✅ bootstrap_metadata актуален (exclude_from_context_analysis покрывает все rulepack)
- ✅ Нет конфликтов между AGENTS.md и адаптерами

**Проверка:**
```python
IF AGENTS.md содержит правила, дублирующие адаптеры:
  → TRIGGER: "AGENTS.md содержит Claude-специфичные правила. Переместить в CLAUDE.md?"
```

---

## АЛГОРИТМ ПРОАКТИВНОЙ ВАЛИДАЦИИ

### Когда запускать валидацию

**Триггеры запуска:**
1. **При касании проекта** (первое действие AI в сессии):
   - Прочитать любой файл → проверить актуальность
2. **После завершения задачи** (добавление функции, рефакторинг):
   - Проверить, нужно ли обновить документацию
3. **Перед коммитом** (если пользователь просит создать коммит):
   - Проверить, включены ли обновления документации

### Алгоритм

```
FUNCTION validate_documentation_on_touch():
  1. READ README.md → extract `updated` date
     IF (current_date - updated) > 30 days:
       → CHECK: есть ли значительные изменения с тех пор?
       → IF yes: WARN "README.md устарел"

  2. READ ARCHITECTURE__20260210103632-01.md → extract Directory Structure
     SCAN project tree
     COMPARE architecture_dirs vs actual_dirs
     IF mismatch:
       → TRIGGER: "ARCHITECTURE__20260210103632-01.md не синхронизирован"

  3. READ package.json / pyproject.toml → extract dependencies
     READ README.md → extract Technologies section
     COMPARE dependencies vs technologies
     IF new dependencies not mentioned:
       → TRIGGER: "Обновить Technologies"

  4. REPORT findings to user:
     "Проект выглядит актуальным" ИЛИ
     "Обнаружены устаревшие документы: {list}. Обновить?"

FUNCTION validate_after_task(task_description):
  IF task == "добавление функции":
    → CHECK: функция публичная?
    → IF yes: TRIGGER "Добавить в README.md?"

  IF task == "рефакторинг":
    → CHECK: изменилась структура?
    → IF yes: TRIGGER "Обновить ARCHITECTURE__20260210103632-01.md?"

  IF task == "добавление зависимости":
    → CHECK: зависимость в README.md?
    → IF no: TRIGGER "Обновить Technologies"

FUNCTION validate_before_commit():
  IF README.md изменён:
    → CHECK: обновлён ли `updated` в YAML? (для файлов с YAML)
    → IF no: WARN "Обновить updated в YAML"

  IF добавлены новые файлы (src/новый_модуль.py):
    → CHECK: упомянуты ли в ARCHITECTURE__20260210103632-01.md?
    → IF no: TRIGGER "Добавить в Key Components?"
```

---

## ДЕЙСТВИЯ AI ПРИ ОБНАРУЖЕНИИ УСТАРЕВШЕЙ ДОКУМЕНТАЦИИ

### Сценарий 1: README.md устарел

**Обнаружено:**
- `updated: 2025-12-01` (40 дней назад)
- С тех пор добавлены: новая зависимость (Redis), новая директория (src/cache/)

**Действия AI:**
```
1. Проанализировать изменения:
   - git log --since="2025-12-01" --oneline (обзор коммитов)
   - Сканировать новые файлы/директории

2. Сообщить пользователю:
   "README.md последний раз обновлялся 2025-12-01 (40 дней назад).
   С тех пор:
     - Добавлена зависимость Redis (для кэширования)
     - Создана директория src/cache/
     - 15 коммитов

   Хотите, чтобы я обновил README.md?"

3. IF пользователь согласен:
   → Обновить разделы:
     - Technologies: добавить Redis
     - Project Structure: добавить src/cache/
     - Features: упомянуть кэширование (если это новая функция)
   → Обновить `updated` в YAML (если YAML есть)
```

### Сценарий 2: ARCHITECTURE__20260210103632-01.md не синхронизирован

**Обнаружено:**
- ARCHITECTURE__20260210103632-01.md → Directory Structure упоминает `src/utils/`
- Реальная структура: `src/utils/` не существует, но есть `src/helpers/`

**Действия AI:**
```
1. Сообщить:
   "ARCHITECTURE__20260210103632-01.md → Directory Structure не соответствует реальной структуре:
     - src/utils/ — упомянута, но не существует
     - src/helpers/ — существует, но не упомянута

   Похоже, src/utils/ была переименована. Обновить ARCHITECTURE__20260210103632-01.md?"

2. IF пользователь согласен:
   → Заменить src/utils/ на src/helpers/ в Directory Structure
   → Обновить описание (если назначение изменилось)
   → Обновить `updated` в YAML
```

### Сценарий 3: Добавлена новая публичная функция

**Обнаружено:**
- Пользователь добавил `async def send_email(to: str, subject: str, body: str)` в src/notifications.py
- README.md не упоминает email-уведомления

**Действия AI:**
```
1. Сообщить:
   "Добавлена публичная функция send_email в src/notifications.py.
   Это новая функция для отправки email-уведомлений.
   Добавить в README.md → Features?"

2. IF пользователь согласен:
   → Добавить в Features:
     "- **Email-уведомления**: Отправка email через send_email()"
   → ИЛИ в API Documentation (если есть такой раздел)
```

### Сценарий 4: Изменены зависимости

**Обнаружено:**
- package.json добавлена зависимость `axios: ^1.6.0`
- README.md → Technologies не упоминает Axios

**Действия AI:**
```
1. Сообщить:
   "Добавлена зависимость axios в package.json.
   Обновить Technologies в README.md?"

2. IF пользователь согласен:
   → Добавить в Technologies:
     "- Axios 1.6 — HTTP-клиент"
   → Также проверить ARCHITECTURE__20260210103632-01.md (обновить там, если есть раздел Technologies)
```

---

## АВТОМАТИЧЕСКИЕ ПРОВЕРКИ (ЧЕКЛИСТЫ)

AI использует чек-листы для проверки качества документации.

### Чеклист при касании проекта

```
[ ] README.md актуален
    - updated в последние 30 дней ИЛИ нет значительных изменений
    - Technologies соответствуют package.json/pyproject.toml
    - Install instructions работают
    - Structure актуальна

[ ] ARCHITECTURE__20260210103632-01.md актуален
    - Directory Structure соответствует tree
    - Entry Points существуют и не переименованы
    - Key Components актуальны

[ ] AGENTS.md синхронизирован
    - bootstrap_metadata актуален
    - exclude_from_context_analysis покрывает все rulepack
    - Нет дубликатов с адаптерами

[ ] Тесты покрывают критичные части
    - Public API покрыт тестами
    - Критичная бизнес-логика покрыта
```

### Чеклист после добавления функции

```
[ ] Функция задокументирована
    - Есть docstring (Python) / JSDoc (JS) / doc comment (Rust)

[ ] README.md обновлён (если публичная функция)
    - Функция упомянута в Features ИЛИ API Documentation

[ ] Тесты добавлены
    - Есть unit-тест для функции
    - Покрыты edge cases
```

### Чеклист после рефакторинга

```
[ ] ARCHITECTURE__20260210103632-01.md обновлён (если изменилась структура)
    - Directory Structure актуальна
    - Entry Points актуальны
    - Design Decisions зафиксированы (если архитектурное решение)

[ ] Тесты пройдены
    - Все тесты зелёные (ничего не сломалось)
```

### Чеклист перед коммитом

```
[ ] Документация синхронизирована с кодом
    - README.md актуален
    - ARCHITECTURE__20260210103632-01.md актуален (если были структурные изменения)

[ ] Метаданные обновлены
    - updated в YAML обновлён (для файлов с YAML)

[ ] Тесты пройдены
    - Все тесты зелёные
```

---

## ИНТЕГРАЦИЯ С ДРУГИМИ СТАНДАРТАМИ

### Связь с Placeholder System

**Placeholder System** → **Progressive Validation**

1. **Инициализация** (Placeholder System):
   - Проект новый → заглушки заполняются
   - `placeholder: true` → `placeholder: false`
   - Документация создана первый раз

2. **Валидация** (Progressive Validation):
   - Проект инициализирован → документация поддерживается
   - Код изменяется → документация обновляется
   - Непрерывный процесс

**Критерий перехода:**
```python
IF все файлы БЕЗ placeholder: true:
  → Проект инициализирован
  → Переход к режиму Progressive Validation
```

### Связь с AI Project Development Rules

**AI-Project-Development-Rules** определяет **поведение** AI.
**Progressive-Validation-Standard** определяет **процесс** валидации.

**Пример:**
- AI-Project-Development-Rules: "AI ОБЯЗАНА поддерживать документацию актуальной"
- Progressive-Validation-Standard: "Как именно проверять актуальность (алгоритмы, триггеры)"

### Связь с AGENTS.md

**AGENTS.md** активирует правило `progressive_validation: true`.

**Когда правило активно:**
- AI автоматически запускает валидацию при касании проекта
- AI проверяет триггеры после каждой задачи
- AI предлагает обновления перед коммитом

**Когда правило выключено (`false`):**
- AI НЕ проверяет актуальность автоматически
- Пользователь должен явно просить "проверь README"

**Режим auto:**
- AI проверяет только при явных изменениях (добавление функции, рефакторинг)
- Не проверяет time-based триггеры (устаревание по времени)

---

## ПРИМЕРЫ

### Пример 1: Проект после инициализации

**Начальное состояние:**
- README.md заполнен (placeholder: false, updated: 2026-01-15)
- ARCHITECTURE__20260210103632-01.md заполнен (placeholder: false, updated: 2026-01-15)
- Проект работает, нет изменений

**AI касается проекта (2026-02-10):**
```
1. READ README.md → updated: 2026-01-15 (26 дней назад)
2. CHECK: есть ли значительные изменения?
   → git log --since="2026-01-15" → 3 коммита (мелкие багфиксы)
3. DECISION: "Проект актуален, изменений мало"
4. REPORT: "README.md актуален (обновлён 26 дней назад, значительных изменений нет)"
```

### Пример 2: Добавлена новая функция

**Событие:**
```python
# Пользователь добавил в src/api/payments.py:
async def process_payment(payment_id: int) -> PaymentResult:
    """Обработать платёж."""
    ...
```

**AI обнаруживает:**
```
1. DETECT: новая публичная функция process_payment
2. CHECK README.md → "payments" упоминается? → НЕТ
3. TRIGGER: "Добавлена функция process_payment для обработки платежей.
            Добавить в README.md → Features?"
4. IF пользователь согласен:
   → UPDATE README.md:
     Features:
     - **Обработка платежей**: process_payment() для работы с платёжными системами
```

### Пример 3: Рефакторинг структуры

**Событие:**
- Пользователь переименовал `src/utils/` → `src/helpers/`

**AI обнаруживает:**
```
1. READ ARCHITECTURE__20260210103632-01.md → Directory Structure:
   src/utils/    # Вспомогательные функции

2. SCAN project tree → src/utils/ НЕ СУЩЕСТВУЕТ, есть src/helpers/

3. TRIGGER: "Директория src/utils/ переименована в src/helpers/.
            Обновить ARCHITECTURE__20260210103632-01.md?"

4. IF пользователь согласен:
   → UPDATE ARCHITECTURE__20260210103632-01.md:
     src/helpers/    # Вспомогательные функции (было: src/utils/)
   → UPDATE `updated: 2026-02-10`
```

### Пример 4: Устаревание по времени

**Событие:**
- README.md не обновлялся 45 дней
- За это время: добавлена Redis зависимость, создана src/cache/, 20 коммитов

**AI касается проекта:**
```
1. READ README.md → updated: 2025-12-26 (45 дней назад)
2. CHECK: значительные изменения?
   → git log --since="2025-12-26" --oneline → 20 коммитов
   → git diff 2025-12-26..HEAD --name-status → src/cache/ (новая)
   → package.json diff → redis added
3. TRIGGER: "README.md устарел (45 дней).
            С тех пор:
              - Добавлена зависимость Redis
              - Создана директория src/cache/
              - 20 коммитов
            Обновить README.md?"
4. IF пользователь согласен:
   → UPDATE Technologies: добавить Redis
   → UPDATE Structure: добавить src/cache/
   → UPDATE `updated: 2026-02-10`
```

---

## НАСТРОЙКИ И КОНФИГУРАЦИЯ

### В AGENTS.md

```yaml
## RULES (TRI-STATE)
- progressive_validation: true  # Включить автоматическую валидацию
```

**Режимы:**
- `true` — полная валидация (все триггеры, включая time-based)
- `false` — валидация отключена (только по явному запросу)
- `auto` — валидация при явных событиях (code-based, structural), без time-based

### В bootstrap_metadata (опционально)

```yaml
bootstrap_metadata:
  version: 2026-02-10-v1
  validation_settings:
    time_threshold_days: 30        # Порог устаревания README (дней)
    min_commits_for_stale: 10      # Минимум коммитов для "значительных изменений"
    exclude_from_validation: []    # Файлы, которые не валидировать
```

---

## ОБРАБОТКА ОШИБОК

### Проблема: Ложные срабатывания

**Симптом:** AI предлагает обновить README, хотя всё актуально

**Причина:** Алгоритм слишком чувствителен (порог 30 дней, но проект стабилен)

**Решение:**
- Увеличить `time_threshold_days` до 60-90 дней
- Повысить `min_commits_for_stale` до 15-20
- ИЛИ переключить режим на `auto` (отключить time-based триггеры)

### Проблема: AI не обнаруживает устаревшую документацию

**Симптом:** README очевидно устарел, но AI молчит

**Причина:** Правило `progressive_validation: false` ИЛИ AI не запустила проверку

**Решение:**
- Проверить AGENTS.md → progressive_validation должно быть `true`
- Явно попросить: "Проверь актуальность README.md"

### Проблема: AI спрашивает об обновлении на каждую мелочь

**Симптом:** Добавлена internal функция → AI предлагает обновить README

**Причина:** AI не различает public/private функции

**Решение:**
- Уточнить в CLAUDE.md: "Предлагать обновление README только для публичных API"

---

## LINKS (INTERNAL)

- [[placeholder-system__20260210103631-03|Placeholder-System-Standard]] — инициализация через заглушки
- [[project-initialization__20260210103631-04|Project-Initialization-Standard]] — процесс первичного заполнения
- [[ai-project-development-rules__20260210103631-05|AI-Project-Development-Rules]] — правила поведения AI
- [[readme-standard__20260210103631-01|README-Standard]] — требования к README.md
- [[architecture-standard__20260210103631-02|ARCHITECTURE-Standard]] — требования к ARCHITECTURE__20260210103632-01.md
- [[agents-format__20260209220613-05|AGENTS-Format]] — формат AGENTS.md и tri-state режимы

---

**Примечание:** Этот стандарт описывает процесс непрерывной валидации после инициализации проекта. Инициализация описана в [[project-initialization__20260210103631-04|project-initialization]].
