---
title: Реестр нейросетей
category: AI → Models Registry
status: active
criticality: high
updated: 2026-02-01
---

# РЕЕСТР НЕЙРОСЕТЕЙ

> **Конфигурация Continue:** `~/.continue/config.yaml`  
> **Связанные документы:**
> - [Основная инфраструктура](../../ВСЯ%20МОЯ%20ИНФРАСТРУКТУРА%20(для%20LLM).md) — общий реестр инструментов
> - [n8n](./n8n.md) — интеграции с LLM через workflows
> - [Cursor](./cursor.md) — настройки Continue и MCP серверов
> - [Claude Desktop](./claude-desktop.md) — MCP серверы для Claude
> - [PaddleOCR](./paddleocr.md) — OCR для русского языка
> - [Tesseract OCR](./tesseract-ocr.md) — базовый OCR
> - [Warp](./warp.md) — терминал с AI-агентами

---

## Основная информация

- **Категория:** AI → Models Registry
- **Статус:** активно
- **Критичность:** высокая
- **Назначение:** единый реестр всех доступных нейросетей с характеристиками для быстрого выбора

### Оценочная шкала

| Оценка | Значение |
|--------|----------|
| 9-10 | Отлично |
| 7-8 | Хорошо |
| 5-6 | Удовлетворительно |
| 3-4 | Слабо |
| 1-2 | Плохо |
| 0 | Отсутствует |

**Легенда статусов:** ✅ Установлена | ⬇️ Рекомендуется установить | Доступна

---

## 0) ВЫБРАННЫЕ МОДЕЛИ ДЛЯ РАБОТЫ (Continue)

Текущая конфигурация в `~/.continue/config.yaml`. Переключение между моделями — через селектор в Continue.

### OpenRouter (требуется `OPENROUTER_API_KEY`)

| Модель | Роль | Задача |
|--------|------|--------|
| **Qwen3 Coder 480B** | chat, edit, apply | Код, 480B MoE, 262K context |
| **Qwen3 Next 80B** | chat, edit, apply | Документация, общий чат, 80B |
| **DeepSeek R1T2 Chimera** | chat | Reasoning, 671B MoE |
| **DeepSeek R1 0528** | chat | Reasoning, 671B |

### Локальные (Ollama)

| Модель | Роль | Задача |
|--------|------|--------|
| **qwen3:30b** | chat, edit, apply | Основная, русский, 30B |
| **deepseek-r1:8b** | chat | Reasoning локально (установить) |
| **llama3.1:8b** | chat | Быстрая модель |
| **qwen2.5-coder:1.5b** | autocomplete | Дополнение кода |
| **nomic-embed-text** | embed | @codebase, @docs |

---

## 0.1) УСТАНОВЛЕННЫЕ ЛОКАЛЬНО (Ollama)

**Текущий список** (`ollama list`):

| Модель | Размер | Используется | Комментарий |
|--------|--------|:------------:|-------------|
| **qwen3:30b** | 18 GB | ✅ | Основная модель Continue |
| **llama3.1:8b** | 4.9 GB | ✅ | Быстрая модель Continue |
| **qwen2.5-coder:1.5b** | 986 MB | ✅ | Autocomplete Continue |
| **nomic-embed-text** | 274 MB | ✅ | Embeddings Continue |
| **qwen3-coder:30b** | ~18GB | ✅ | Качественное редактирование кода локально |
| **deepseek-r1:8b** | ~5GB | ✅ | Reasoning, Chain-of-Thought |

---

## 1) ТЕКСТОВЫЕ МОДЕЛИ (LLM)

### 1.1 Локальные (Self-hosted через Ollama)

**Runtime:** Ollama (localhost:11434)  
**Конфигурация:** `~/.ollama/`

#### Основные модели

| Модель | Размер | Русский | Скорость | Требования | OCR | Транскр. | Статус |
|--------|--------|:-------:|:--------:|------------|:---:|:--------:|--------|
| **qwen3:30b** | 30B, ~18GB | 8 | 5 | 32GB RAM, GPU 24GB+ | 0 | 0 | ✅ Установлена |
| **qwen3:8b** | 8B, ~5GB | 7 | 7 | 16GB RAM | 0 | 0 | Доступна |
| **qwen3:4b** | 4B, ~2.5GB | 6 | 9 | 8GB RAM | 0 | 0 | Доступна |
| **qwen2.5:3b** | 3B, ~2GB | 6 | 9 | 8GB RAM | 0 | 0 | ✅ Установлена |
| **llama3.1:8b** | 8B, ~5GB | 5 | 7 | 16GB RAM | 0 | 0 | ✅ Установлена |
| **llama3.2** | 3.2B, ~2GB | 4 | 9 | 8GB RAM | 0 | 0 | ✅ Установлена |
| **deepseek-r1:8b** | 8B, ~5GB | 7 | 6 | 16GB RAM | 0 | 0 | ✅ Установлена |
| **gemma3:27b** | 27B, ~16GB | 7 | 5 | 32GB RAM, GPU 16GB+ | 0 | 0 | Доступна |
| **gemma3:12b** | 12B, ~8GB | 7 | 7 | 16GB RAM | 0 | 0 | Доступна |
| **gemma3:4b** | 4B, ~2.5GB | 6 | 9 | 8GB RAM | 0 | 0 | Доступна |
| **gemma3:1b** | 1B, ~700MB | 4 | 10 | 4GB RAM | 0 | 0 | Доступна |
| **gpt-oss:20b** | 20B, ~14GB | 7 | 6 | 24GB RAM | 0 | 0 | ✅ Установлена |
| **gpt-oss:120b** | 117B, ~70GB | 8 | 3 | 128GB RAM, GPU 80GB+ | 0 | 0 | Доступна |

#### Модели для кода

| Модель | Размер | Русский | Скорость | Требования | Статус |
|--------|--------|:-------:|:--------:|------------|--------|
| **qwen2.5-coder:1.5b** | 1.5B, ~1GB | 5 | 10 | 4GB RAM | ✅ Установлена |
| **qwen3-coder:30b** | 30B, ~18GB | 7 | 5 | 32GB RAM | ✅ Установлена |

#### Embeddings

| Модель | Размер | Языки | Скорость | Статус |
|--------|--------|-------|:--------:|--------|
| **nomic-embed-text** | 137M, ~274MB | Multi | 10 | ✅ Установлена |

---

### 1.2 Облачные через Ollama Cloud

**Тип:** API (облако Ollama)

| Модель | Параметры | Русский | Скорость | Особенности | Статус |
|--------|-----------|:-------:|:--------:|-------------|--------|
| **deepseek-v3.1:671b-cloud** | 671B MoE | 8 | 7 | Reasoning | Доступна |
| **qwen3-coder:480b-cloud** | 480B MoE | 8 | 6 | Code, tools | Доступна |
| **minimax-m2:cloud** | MoE | 6 | 8 | General | Доступна |
| **glm-4.6:cloud** | MoE | 7 | 8 | 26 языков | Доступна |
| **gpt-oss:120b-cloud** | 117B MoE | 8 | 7 | Tool use | Доступна |
| **gpt-oss:20b-cloud** | 21B MoE | 7 | 9 | Low latency | Доступна |

---

### 1.3 Бесплатные через OpenRouter

**Endpoint:** `https://openrouter.ai/api/v1`  
**Доступ:** требуется API key (бесплатный tier: 50 req/day)

| Модель | Параметры | Контекст | Русский | Скорость | Особенности |
|--------|-----------|----------|:-------:|:--------:|-------------|
| **DeepSeek R1 0528** | 671B | 164K | 8 | 6 | Reasoning, open-source |
| **TNG: DeepSeek R1T2 Chimera** | 671B MoE | 164K | 8 | 7 | 20% быстрее R1 |
| **TNG: DeepSeek R1T Chimera** | 671B MoE | 164K | 8 | 7 | R1+V3 merge |
| **TNG: R1T Chimera** | 671B MoE | 164K | 8 | 7 | Creative, EQ-Bench 1305 |
| **Arcee: Trinity Large Preview** | 400B MoE | 131K | 6 | 7 | Creative, agentic |
| **Arcee: Trinity Mini** | 26B MoE | 131K | 5 | 9 | Быстрая, agents |
| **Z.AI: GLM 4.5 Air** | MoE | 131K | 7 | 8 | Thinking mode |
| **NVIDIA: Nemotron 3 Nano** | 30B MoE | 256K | 5 | 8 | Agentic |
| **Meta: Llama 3.3 70B** | 70B | 131K | 5 | 7 | DE, FR, IT, PT, HI, ES, TH |
| **Qwen: Qwen3 Coder 480B** | 480B MoE | 262K | 8 | 6 | Code, tools, agents |
| **Qwen: Qwen3 Next 80B** | 80B MoE | 262K | 8 | 7 | RAG, tools, long context |
| **Google: Gemma 3 27B** | 27B | 131K | 7 | 7 | 140+ языков, vision |
| **Upstage: Solar Pro 3** | 102B MoE | 128K | 4 | 7 | Korean-focused |
| **OpenAI: gpt-oss-120b** | 117B MoE | 131K | 8 | 6 | Tool use, reasoning |
| **OpenAI: gpt-oss-20b** | 21B MoE | 131K | 7 | 8 | Low latency |

---

## 2) VISION-LANGUAGE МОДЕЛИ (VLM)

### 2.1 Локальные (Self-hosted через Ollama)

| Модель | Размер | Русский | Скорость | OCR | Требования | Статус |
|--------|--------|:-------:|:--------:|:---:|------------|--------|
| **qwen3-vl:30b** | 30B, ~18GB | 8 | 4 | 8 | 32GB RAM, GPU 24GB+ | Доступна |
| **qwen3-vl:8b** | 8B, ~5GB | 7 | 7 | 7 | 16GB RAM | Доступна |
| **qwen3-vl:4b** | 4B, ~2.5GB | 6 | 8 | 6 | 8GB RAM | Доступна |
| **gemma3:27b** (vision) | 27B, ~16GB | 7 | 5 | 4 | 32GB RAM | Доступна |

### 2.2 Облачные через Ollama Cloud

| Модель | Параметры | Русский | Скорость | OCR | Статус |
|--------|-----------|:-------:|:--------:|:---:|--------|
| **qwen3-vl:235b-cloud** | 235B MoE | 9 | 6 | 9 | Доступна |

---

## 3) СПЕЦИАЛИЗИРОВАННЫЕ МОДЕЛИ

### 3.1 OCR (Optical Character Recognition)

> См. также: [PaddleOCR](./paddleocr.md), [Tesseract OCR](./tesseract-ocr.md)

| Модель/Сервис | Русский | Скорость | Тип | Интеграция | Статус |
|---------------|:-------:|:--------:|-----|------------|--------|
| **PaddleOCR** | 9 | 8 | Self-hosted (Docker) | Python, API | ✅ Активна |
| **Tesseract OCR** | 7 | 9 | Self-hosted | CLI, Python | ✅ Активна |
| **qwen3-vl:30b** | 8 | 4 | Self-hosted | Ollama | Доступна |
| **qwen3-vl:235b-cloud** | 9 | 6 | Cloud | Ollama Cloud | Доступна |

**Рекомендуемый пайплайн для русского OCR:**
1. PaddleOCR → первичное распознавание
2. Tesseract OCR → альтернативный результат
3. qwen3:30b → объединение и улучшение результатов

### 3.2 Speech-to-Text (ASR / Транскрибация)

| Модель/Сервис | Русский | Скорость | Тип | Интеграция | Статус |
|---------------|:-------:|:--------:|-----|------------|--------|
| **Faster-Whisper** | 7 | 8 | Self-hosted (VPS) | n8n webhook | ✅ Активна |

### 3.3 Image Generation

| Модель | Качество | Скорость | Тип | Стоимость | Статус |
|--------|:--------:|:--------:|-----|-----------|--------|
| **ByteDance: Seedream 4.5** | 9 | 7 | OpenRouter | $0.04/image | Доступна |

---

## 4) РЕКОМЕНДАЦИИ ПО ВЫБОРУ

### Для русского текста (приоритет качества):

| Приоритет | Модель | Где | Комментарий |
|:---------:|--------|-----|-------------|
| 1 | **qwen3:30b** | Ollama | Лучшая локальная для русского |
| 2 | **DeepSeek R1** | OpenRouter | Отличный reasoning |
| 3 | **qwen3-vl:235b-cloud** | Ollama Cloud | Максимальное качество + OCR |
| 4 | **gemma3:27b** | Ollama | 140+ языков, хороший баланс |

### Для кода:

| Приоритет | Модель | Где | Комментарий |
|:---------:|--------|-----|-------------|
| 1 | **Qwen3 Coder 480B** | OpenRouter | Максимальное качество |
| 2 | **qwen3-coder:30b** | Ollama | Баланс скорости и качества |
| 3 | **qwen2.5-coder:1.5b** | Ollama | Autocomplete, быстро |

### Для OCR документов:

| Приоритет | Пайплайн | Комментарий |
|:---------:|----------|-------------|
| 1 | PaddleOCR + qwen3:30b | Пайплайн улучшения |
| 2 | qwen3-vl:30b | Встроенный OCR |
| 3 | qwen3-vl:235b-cloud | Максимальное качество |

### Для быстрых задач (низкие ресурсы):

| Приоритет | Модель | Где | RAM |
|:---------:|--------|-----|-----|
| 1 | **qwen3:4b** | Ollama | 8GB |
| 2 | **gemma3:4b** | Ollama | 8GB |
| 3 | **gpt-oss-20b** | OpenRouter | — |
| 4 | **llama3.2** | Ollama | 8GB |

---

## 5) ИНТЕГРАЦИИ

### С Continue (IDE)

> См. также: [Cursor](./cursor.md), `~/.continue/config.yaml`

| Роль | Модель (выбор в селекторе) | Провайдер |
|------|---------------------------|-----------|
| **Код / Edit / Apply** | Qwen3 Coder 480B (лучший) | OpenRouter |
| **Код / Edit / Apply** | Qwen3 Next 80B | OpenRouter |
| **Код / Edit / Apply** | qwen3:30b | Ollama (основная локально) |
| **Reasoning** | DeepSeek R1T2 Chimera, R1 0528 | OpenRouter |
| **Reasoning** | deepseek-r1:8b | Ollama |
| **Быстрая** | llama3.1:8b | Ollama |
| **Autocomplete** | qwen2.5-coder:1.5b | Ollama |
| **Embeddings** | nomic-embed-text | Ollama |

### С n8n

> См. также: [n8n](./n8n.md)

| Сервис | Назначение | Credentials |
|--------|------------|-------------|
| Groq | Быстрые LLM вызовы | Groq account |
| OpenRouter | Доступ к разным моделям | OpenRouter account |
| ASR | Транскрибация → LLM | — |

### С Dify

- RAG через локальные embeddings (nomic-embed-text)
- Chat через OpenRouter или локальные модели
- Домен: `dify.fingroup.ru`

---

## 6) КОМАНДЫ OLLAMA

```bash
# Список установленных моделей
ollama list

# Установить рекомендуемые модели
ollama pull qwen3-coder:30b
ollama pull deepseek-r1:8b

# Скачать модель
ollama pull qwen3:8b

# Запустить модель
ollama run <название модели>

# Удалить модель (освобождение места)
ollama rm <название модели>

# API endpoint
curl http://localhost:11434/api/generate -d '{
  "model": "qwen3:8b",
  "prompt": "Привет!"
}'
```

---

## 7) ИСТОРИЯ ОБНОВЛЕНИЙ

- **2026-02-01:** Обновлён реестр под текущую конфигурацию
  - Добавлен раздел «Выбранные модели для работы» (Continue)
  - Добавлен раздел «Установленные локально» с актуальным списком
  - Добавлена рекомендация установить qwen3-coder:30b и deepseek-r1:8b
  - Добавлены рекомендации по удалению (gpt-oss:20b, qwen2.5:3b, llama3.2) — ~17 GB
  - Обновлены интеграции с Continue
- **2026-02-01:** Создан реестр нейросетей
  - Добавлены все доступные модели Ollama (локальные и cloud)
  - Добавлены бесплатные модели OpenRouter
  - Добавлены оценки для русского языка, скорости, OCR
  - Добавлены интеграции с Continue, n8n, Dify
