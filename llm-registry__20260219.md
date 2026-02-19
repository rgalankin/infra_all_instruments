---
id: 20260219120000
title: "Реестр LLM и AI-моделей, доступных по API"
summary: >
  Полный реестр нейросетей, доступных по API обычным пользователям.
  Включает топовые, средние, бюджетные модели, embedding-модели.
  Цены, контексты, способы подключения, статус интеграции в инфраструктуре.
type: registry
status: active
tags: [ai/llm, ai/embedding, content/registry, process/index]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-19
updated: 2026-02-19
---
# РЕЕСТР LLM И AI-МОДЕЛЕЙ, ДОСТУПНЫХ ПО API

**Автор:** Кира Архипова (KB Manager)
**Задача:** B24 #298 (проект LLM Ops, группа #4)
**Дата:** 2026-02-19
**Актуальность цен:** февраль 2026

Реестр охватывает все основные LLM и embedding-модели, доступные по публичному API. Для каждой модели указан статус подключения в нашей инфраструктуре.

---

## УСЛОВНЫЕ ОБОЗНАЧЕНИЯ

**Tier (качество):**
- **S** - лучшие в классе, frontier-модели
- **A** - сильные модели, отличное соотношение цена/качество
- **B** - рабочие лошадки, бюджетные варианты
- **C** - дешевые/бесплатные, для простых задач

**Подключена:**
- **Да** - активно используем в инфраструктуре
- **Частично** - есть доступ, но не основная
- **Нет** - не подключена, но доступна

---

## 1. ГЕНЕРАТИВНЫЕ МОДЕЛИ (LLM)

### Tier S - Frontier-модели

| Модель | Провайдер | Тип | Input $/1M tok | Output $/1M tok | Контекст | Доступ | Подключена | Сервер | Free tier | Качество |
|--------|-----------|-----|:--------------:|:---------------:|:--------:|--------|:----------:|--------|:---------:|:--------:|
| Claude Opus 4.6 | Anthropic | multimodal | $15.00 | $75.00 | 200K | Прямой API | Да | Облако Anthropic | Нет | S |
| Claude Sonnet 4.5 | Anthropic | multimodal | $3.00 | $15.00 | 200K | Прямой API | Да | Облако Anthropic | Нет | S |
| GPT-4o | OpenAI | multimodal | $2.50 | $10.00 | 128K | Прямой API | Нет | Облако OpenAI | $5 стартовые кредиты | S |
| Gemini 2.5 Pro | Google | multimodal | $1.25 / $2.50 | $10.00 / $15.00 | 1M | Прямой API / AI Studio | Нет | Облако Google | Да, AI Studio (бесплатный tier) | S |
| DeepSeek R1 | DeepSeek | text (reasoning) | $0.55 (cache $0.14) | $2.19 | 128K | Прямой API / OpenRouter / IS Smart | Да | OpenRouter + IS Smart (149.33.4.37) | OpenRouter free tier | S |

### Tier A - Сильные модели

| Модель | Провайдер | Тип | Input $/1M tok | Output $/1M tok | Контекст | Доступ | Подключена | Сервер | Free tier | Качество |
|--------|-----------|-----|:--------------:|:---------------:|:--------:|--------|:----------:|--------|:---------:|:--------:|
| Claude Haiku 3.5 | Anthropic | multimodal | $0.80 | $4.00 | 200K | Прямой API | Частично | Облако Anthropic | Нет | A |
| GPT-4o mini | OpenAI | multimodal | $0.15 | $0.60 | 128K | Прямой API | Нет | Облако OpenAI | $5 стартовые кредиты | A |
| Gemini 2.5 Flash | Google | multimodal | $0.15 / $0.30 | $0.60 / $2.50 (thinking) | 1M | Прямой API / AI Studio | Нет | Облако Google | Да, AI Studio | A |
| DeepSeek V3 | DeepSeek | text | $0.27 (cache $0.07) | $1.10 | 128K | Прямой API / OpenRouter | Частично | OpenRouter | OpenRouter free tier | A |
| DeepSeek R1T2 Chimera | TNG (DeepSeek merge) | text (reasoning) | Free tier | Free tier | 164K | OpenRouter | Да | OpenRouter | Да (50 req/day) | A |
| Codex CLI (o3-mini backend) | OpenAI | code | $1.10 | $4.40 | 200K | Codex CLI | Да | iMac (CLI) | Нет | A |
| Qwen3 235B | Alibaba | text | $0.30 | $1.20 | 128K | Прямой API / DashScope / OpenRouter | Частично | IS Smart | Да (DashScope free tier) | A |

### Tier B - Бюджетные модели

| Модель | Провайдер | Тип | Input $/1M tok | Output $/1M tok | Контекст | Доступ | Подключена | Сервер | Free tier | Качество |
|--------|-----------|-----|:--------------:|:---------------:|:--------:|--------|:----------:|--------|:---------:|:--------:|
| Mistral Large 2 | Mistral AI | text | $2.00 | $6.00 | 128K | Прямой API / OpenRouter | Нет | - | OpenRouter free tier | B |
| Llama 3.3 70B | Meta | text | Бесплатно (self-hosted) | Бесплатно | 128K | OpenRouter / Groq / IS Smart / SiliconFlow | Да | IS Smart + OpenRouter | Да (Groq, OpenRouter) | B |
| Qwen3 72B | Alibaba | text | $0.12 | $0.48 | 128K | DashScope / OpenRouter / SiliconFlow | Частично | IS Smart (как Qwen 3) | Да (DashScope, SiliconFlow) | B |
| Gemma 3 27B | Google | multimodal | Бесплатно (self-hosted) | Бесплатно | 128K | OpenRouter / IS Smart / Ollama | Да | IS Smart | Да (OpenRouter) | B |
| Phi 4 Reasoning | Microsoft | text (reasoning) | Бесплатно (self-hosted) | Бесплатно | 128K | IS Smart / Azure | Да | IS Smart (149.33.4.37) | Нет (IS Smart = $2.99/мес) | B |

### Tier C - Дешевые/бесплатные модели

| Модель | Провайдер | Тип | Input $/1M tok | Output $/1M tok | Контекст | Доступ | Подключена | Сервер | Free tier | Качество |
|--------|-----------|-----|:--------------:|:---------------:|:--------:|--------|:----------:|--------|:---------:|:--------:|
| Llama 3.1 8B | Meta | text | Бесплатно | Бесплатно | 128K | Ollama (локально) / Groq | Да | iMac (Ollama) | Да (локально) | C |
| DeepSeek R1 8B (distill) | DeepSeek | text (reasoning) | Бесплатно | Бесплатно | 128K | Ollama (локально) | Да | iMac (Ollama) | Да (локально) | C |
| Qwen3 30B | Alibaba | text | Бесплатно | Бесплатно | 32K | Ollama (локально) | Да | iMac (Ollama) | Да (локально) | C+ |
| Qwen3 Coder 30B | Alibaba | code | Бесплатно | Бесплатно | 32K | Ollama (локально) | Да | iMac (Ollama) | Да (локально) | C+ |
| Qwen 2.5 Coder 1.5B | Alibaba | code | Бесплатно | Бесплатно | 32K | Ollama (локально) | Да | iMac (Ollama) | Да (локально) | C |
| Qwen3 8B | Alibaba | text | Бесплатно | Бесплатно | 32K | Ollama / SiliconFlow / DeepInfra | Нет | - | Да (SiliconFlow бесплатно) | C |
| Gemma 3 9B | Google | multimodal | Бесплатно | Бесплатно | 128K | Ollama / Groq / DeepInfra | Нет | - | Да (Groq бесплатно) | C |

---

## 2. EMBEDDING-МОДЕЛИ

| Модель | Провайдер | Размерность | Контекст | $/1M tok | Русский (100) | Подключена | Сервер | Free tier | Качество |
|--------|-----------|:-----------:|:--------:|:--------:|:-------------:|:----------:|--------|:---------:|:--------:|
| text-embedding-3-small | OpenAI | 1536 | 8191 | $0.02 | 60 | Нет | Облако OpenAI | Нет ($5 стартовые) | B |
| text-embedding-3-large | OpenAI | 3072 | 8191 | $0.13 | 65 | Нет | Облако OpenAI | Нет ($5 стартовые) | A |
| Qwen3-Embedding-8B | Alibaba | 4096 | 32K | Бесплатно (SiliconFlow) | 88 | Нет | - | Да (SiliconFlow) | S |
| jina-embeddings-v3 | Jina AI | 1024 | 8192 | ~$0.02 | 82 | Нет | Облако Jina | 1M токенов бесплатно | A |
| BGE-M3 | BAAI | 1024 | 8192 | Бесплатно | 85 | Нет | - | Да (SiliconFlow, локально) | A |
| embed-multilingual-v3.0 | Cohere | 1024 | 512 | $0.10 | 78 | Нет | Облако Cohere | Trial (1000 выз./мес) | A |
| embed-v4 | Cohere | 1536 | 512 | $0.12 | 80 | Нет | Облако Cohere | Trial (1000 выз./мес) | A |
| voyage-3.5 | Voyage AI | 1024 | 32K | $0.06 | 58 | Нет | Облако Voyage | 200M токенов | A |
| voyage-multilingual-2 | Voyage AI | 1024 | 32K | ~$0.12 | 72 | Нет | Облако Voyage | 50M токенов | B |
| gemini-embedding-001 | Google | 3072 | 2048 | $0.15 | 65 | Нет | Облако Google | Free tier (AI Studio) | B |
| nomic-embed-text | Nomic AI | 768 | 8192 | Бесплатно | 55 | Да | iMac (Ollama) | Да (локально) | C |

---

## 3. СПОСОБЫ ПОДКЛЮЧЕНИЯ ПО КАЖДОЙ МОДЕЛИ

### Подключенные модели (статус "Да")

| Модель | Способ подключения | Сервер / Рантайм | Credential (имя) | Используется в |
|--------|-------------------|------------------|-------------------|---------------|
| Claude Opus 4.6 | Anthropic API (прямой) | Облако Anthropic | ANTHROPIC_API_KEY | Claude Code (основная модель) |
| Claude Sonnet 4.5 | Anthropic API (прямой) | Облако Anthropic | ANTHROPIC_API_KEY | Claude Code (fast mode) |
| DeepSeek R1T2 Chimera | OpenRouter API | Облако OpenRouter | OPENROUTER_API_KEY | Continue IDE (chat, complex tasks) |
| DeepSeek R1 0528 | OpenRouter API | Облако OpenRouter | OPENROUTER_API_KEY | Continue IDE (альтернативный reasoning) |
| DeepSeek R1 (полная) | IS Smart API | VPS ISHosting USA (149.33.4.37) | IS Smart API key (ai.ishosting.com) | n8n workflow (Documentoved) |
| Qwen 3 (IS Smart) | IS Smart API | VPS ISHosting USA (149.33.4.37) | IS Smart API key | n8n workflow (основная для рус. языка) |
| Gemma 3 (IS Smart) | IS Smart API | VPS ISHosting USA (149.33.4.37) | IS Smart API key | n8n workflow (общего назначения) |
| Llama 3.3 (IS Smart) | IS Smart API | VPS ISHosting USA (149.33.4.37) | IS Smart API key | n8n workflow (общего назначения) |
| Phi 4 Reasoning (IS Smart) | IS Smart API | VPS ISHosting USA (149.33.4.37) | IS Smart API key | n8n workflow (reasoning) |
| Qwen3 30B | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue IDE, Dify (основная для русского) |
| Qwen3 Coder 30B | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue IDE (кодинг) |
| DeepSeek R1 8B | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue IDE (reasoning) |
| Llama 3.1 8B | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue IDE (быстрые задачи) |
| Qwen 2.5 Coder 1.5B | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue IDE (autocomplete) |
| nomic-embed-text | Ollama (локально) | iMac Pro (localhost:11434) | Без ключа (localhost) | Continue (@codebase, @docs), Dify (RAG) |
| Codex CLI | OpenAI API (через Codex CLI) | iMac Pro (CLI) | OPENAI_API_KEY (через Codex) | Терминальный кодинг |

### Частично подключенные модели

| Модель | Способ подключения | Статус | Комментарий |
|--------|-------------------|--------|-------------|
| Claude Haiku 3.5 | Anthropic API | Доступен через ANTHROPIC_API_KEY | Не используется активно, можно подключить |
| DeepSeek V3 | OpenRouter API | Доступен через OPENROUTER_API_KEY | Есть в каталоге OpenRouter, не настроен в Continue |
| Qwen3 235B | IS Smart / DashScope | Qwen 3 на IS Smart (версия не уточнена) | На IS Smart доступна Qwen 3, точная версия зависит от обновлений провайдера |
| Qwen3 72B | IS Smart / SiliconFlow | Qwen 3 на IS Smart | Аналогично, доступна через IS Smart как "Qwen 3" |

### Не подключенные, но доступные

| Модель | Как подключить | Стоимость подключения |
|--------|---------------|----------------------|
| GPT-4o | Получить OPENAI_API_KEY, настроить в n8n/Continue | Оплата по факту ($2.50/$10.00 за 1M tok) |
| GPT-4o mini | Получить OPENAI_API_KEY | Оплата по факту ($0.15/$0.60 за 1M tok) |
| Gemini 2.5 Pro | Google AI Studio (бесплатно) или Vertex AI (платно) | Бесплатно через AI Studio (с лимитами) |
| Gemini 2.5 Flash | Google AI Studio | Бесплатно через AI Studio |
| Mistral Large 2 | OpenRouter (уже есть ключ) или прямой API Mistral | $2.00/$6.00 за 1M tok |
| Qwen3-Embedding-8B | SiliconFlow API (бесплатно) | Бесплатно (регистрация на SiliconFlow) |
| BGE-M3 | SiliconFlow API или Ollama (ollama pull bge-m3) | Бесплатно |
| jina-embeddings-v3 | Jina API | 1M токенов бесплатно при регистрации |
| text-embedding-3-large | OpenAI API | $0.13/1M tok |

---

## 4. РАНТАЙМЫ И ПРОВАЙДЕРЫ (СВОДКА)

| Рантайм / Провайдер | Статус | Модели | Credential | Endpoint |
|---------------------|--------|--------|------------|----------|
| **Ollama (локально)** | Активен | 6 моделей (5 LLM + 1 embedding) | Без ключа | localhost:11434 |
| **Anthropic API** | Активен | Claude Opus 4.6, Sonnet 4.5, Haiku 3.5 | ANTHROPIC_API_KEY | api.anthropic.com |
| **OpenRouter** | Активен | DeepSeek R1T2 Chimera, R1 0528, + 100 моделей | OPENROUTER_API_KEY | openrouter.ai/api/v1 |
| **IS Smart (IS Hosting)** | Активен | Qwen 3, DeepSeek R1, Gemma 3, Llama 3.3, Phi 4 | IS Smart API key | ai.ishosting.com |
| **Groq** | Активен (n8n) | Llama, Mixtral и др. | GROQ_API_KEY | api.groq.com/openai/v1 |
| **OpenAI API** | Не активен | GPT-4o, GPT-4o mini, Codex, embeddings | OPENAI_API_KEY (нет) | api.openai.com |
| **Google AI Studio** | Не активен | Gemini 2.5 Pro/Flash, embeddings | Google API key (нет) | generativelanguage.googleapis.com |
| **DashScope (Alibaba)** | Не активен | Qwen3 полная линейка, Qwen3-Embedding | DASHSCOPE_API_KEY (нет) | dashscope.aliyuncs.com |
| **SiliconFlow** | Не активен | BGE-M3, Qwen3-Embedding, Qwen3 8B, DeepSeek | SILICONFLOW_API_KEY (нет) | api.siliconflow.cn |
| **DeepInfra** | Не активен | Llama, Qwen, Mistral, Gemma (бесплатные) | DEEPINFRA_API_KEY (нет) | api.deepinfra.com |
| **Mistral API** | Не активен | Mistral Large 2, Codestral, и др. | MISTRAL_API_KEY (нет) | api.mistral.ai |
| **Cohere** | Не активен | embed-v4, Command R+ | COHERE_API_KEY (нет) | api.cohere.com |
| **Jina AI** | Не активен | jina-embeddings-v3/v4, reranker | JINA_API_KEY (нет) | api.jina.ai |
| **Voyage AI** | Не активен | voyage-3.5, multilingual-2 | VOYAGE_API_KEY (нет) | api.voyageai.com |

---

## 5. РЕКОМЕНДАЦИИ ПО БЫСТРОМУ ВЫБОРУ

| Задача | Рекомендация | Рантайм | Стоимость |
|--------|-------------|---------|-----------|
| Сложная архитектура / документация | Claude Opus 4.6 | Anthropic API | $15/$75 |
| Ежедневная работа с кодом | Claude Sonnet 4.5 (fast mode) | Anthropic API | $3/$15 |
| Русский текст / документы (локально) | Qwen3 30B | Ollama (iMac) | Бесплатно |
| Кодинг (локально) | Qwen3 Coder 30B | Ollama (iMac) | Бесплатно |
| Reasoning / глубокий анализ | DeepSeek R1T2 Chimera | OpenRouter | Бесплатно (50 req/day) |
| Autocomplete в IDE | Qwen 2.5 Coder 1.5B | Ollama (iMac) | Бесплатно |
| Обработка файлов (Documentoved) | Qwen 3 | IS Smart | $2.99/мес |
| Атомизация документов | DeepSeek R1 | IS Smart | $2.99/мес |
| Семантический поиск (текущий) | nomic-embed-text | Ollama (iMac) | Бесплатно |
| Семантический поиск (русский, лучшее качество) | Qwen3-Embedding-8B или BGE-M3 | SiliconFlow / локально | Бесплатно |
| Быстрый inference (низкая задержка) | Llama 3.3 70B | Groq | Бесплатный tier |
| Транскрибация аудио | Faster-Whisper | VPS Beget (Docker) | Бесплатно (self-hosted) |

---

## 6. ЦЕНОВОЕ СРАВНЕНИЕ ($/1M токенов, input/output)

```
Claude Opus 4.6:       $15.00 / $75.00   [====================] Самая дорогая
GPT-4o:                 $2.50 / $10.00   [======]
Claude Sonnet 4.5:      $3.00 / $15.00   [=======]
Mistral Large 2:        $2.00 /  $6.00   [=====]
Gemini 2.5 Pro:         $1.25 / $10.00   [====]
Claude Haiku 3.5:       $0.80 /  $4.00   [===]
DeepSeek R1:            $0.55 /  $2.19   [==]
DeepSeek V3:            $0.27 /  $1.10   [=]
Qwen3 235B:             $0.30 /  $1.20   [=]
Gemini 2.5 Flash:       $0.15 /  $0.60   [.]
GPT-4o mini:            $0.15 /  $0.60   [.]
Ollama (локальные):     $0.00 /  $0.00   Бесплатно (нужно железо)
OpenRouter free tier:   $0.00 /  $0.00   Бесплатно (50 req/day)
IS Smart:               Flat $2.99/мес    Фиксированная подписка
```

---

## 7. СТАТИСТИКА РЕЕСТРА

| Метрика | Значение |
|---------|---------|
| Всего моделей (LLM) | 23 |
| Всего моделей (embedding) | 11 |
| Подключено (активно) | 16 |
| Частично подключено | 4 |
| Не подключено | 14 |
| Рантаймов активных | 5 (Ollama, Anthropic, OpenRouter, IS Smart, Groq) |
| Рантаймов доступных | 14 |
| Бесплатных моделей | 12 (Ollama + free tiers) |

---

## Links (internal)

- [[infra_all_instruments/docs/neural-networks/_index__20260210220000-05|Реестр нейросетей (детальный)]]
- [[infra_all_instruments/docs/neural-networks/by-type/llm__20260210220400-09|LLM модели (локальные)]]
- [[infra_all_instruments/docs/neural-networks/by-type/embedding__20260210220400-10|Embedding модели]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/openrouter__20260210220400-20|Рантайм: OpenRouter]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/ollama-local__20260210220400-19|Рантайм: Ollama Local]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/groq__20260213150000-01|Рантайм: Groq]]
- [[infra_all_instruments/docs/tools/is-smart__20260214210000-01|IS Smart]]
- [[infra_all_instruments/docs/tools/claude-code__20260213150000-01|Claude Code]]
- [[infra_all_instruments/docs/tools/codex__20260212120000-05|Codex CLI]]
- [[infra_all_instruments/docs/integrations/api-map__20260210220500-04|Карта API endpoints]]

## История

- **2026-02-19:** Создан полный реестр LLM (задача B24 #298, автор: Кира Архипова)
