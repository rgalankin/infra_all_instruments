---
id: 20260219163000
title: "Аудит LLM-инфраструктуры"
summary: >
  Полная инвентаризация LLM-инфраструктуры: US-сервер (LLM Router, Squid egress),
  Beget VPS (без LLM Router, egress через US), iMac (Ollama, Open WebUI),
  облачные API (OpenAI, Anthropic, Gemini, DeepSeek, OpenRouter, Groq, GigaChat, YandexGPT).
type: report
status: active
tags: [ai/llm, eng/infrastructure, eng/audit]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-19
updated: 2026-02-19
---
# Аудит LLM-инфраструктуры

**Дата:** 2026-02-19
**Исполнитель:** Дмитрий Соколов (SysAdmin Agent, B24 ID: 14)
**Задача:** B24 #300, проект LLM Ops (группа #4)

---

## US-сервер (149.33.4.37) - ISHosting USA

### LLM Router

- **Тип:** Кастомный FastAPI-прокси (НЕ LiteLLM, НЕ vLLM)
- **Версия:** 2.0.0
- **Статус:** работает (healthy)
- **Контейнер:** `llm-router`
- **Порт:** 8080
- **Исходники на сервере:** `/home/roman/infra_vps_usa/llm-router/`
- **Compose:** `/home/roman/infra_vps_usa/docker-compose.yml`
- **Env-файл:** `/home/roman/infra_vps_usa/.env`
- **Стек:** Python 3.11 / FastAPI / uvicorn / httpx
- **Локальный репозиторий:** `~/Documents/infra_vps_usa/`

### Архитектура LLM Router

Двухсервисный Docker-стек в сети `american-egress-net`:

1. **egress-proxy** (Squid) - порт 3128, HTTP/HTTPS прокси с американским IP
2. **llm-router** (FastAPI) - порт 8080, маршрутизация запросов через egress-proxy

LLM Router определяет провайдера по префиксу модели:
- `gpt-*`, `o1`, `o3`, `o4`, `chatgpt-*` - OpenAI
- `claude-*` - Anthropic
- `gemini-*` - Gemini
- `deepseek*` - DeepSeek
- `openrouter/*` - OpenRouter
- Неизвестные модели - OpenRouter (fallback)

Поддерживает streaming и non-streaming, retry с exponential backoff (до 2 попыток).

### Подключённые провайдеры (5 активных)

| Провайдер | Base URL | Статус |
|-----------|----------|--------|
| OpenAI | https://api.openai.com | OK |
| Anthropic | https://api.anthropic.com | OK |
| Gemini (Google) | https://generativelanguage.googleapis.com | OK |
| DeepSeek | https://api.deepseek.com | OK |
| OpenRouter | https://openrouter.ai/api | OK |

### Доступные модели (через /v1/models)

| Провайдер | Модели |
|-----------|--------|
| OpenAI | gpt-4o, gpt-4o-mini, gpt-4-turbo, o1, o3-mini |
| Anthropic | claude-sonnet-4-5-20250929, claude-haiku-4-5-20251001, claude-opus-4-6 |
| Google | gemini-2.0-flash, gemini-2.5-pro |
| DeepSeek | deepseek-chat, deepseek-reasoner |
| OpenRouter | openrouter/* (400+ моделей через прокси) |

### API endpoints LLM Router

| Endpoint | Метод | Назначение |
|----------|-------|-----------|
| `/v1/chat/completions` | POST | Генерация текста (основной) |
| `/v1/models` | GET | Список моделей |
| `/v1/providers` | GET | Список провайдеров |
| `/` | GET | Healthcheck |

**Ограничение:** Router поддерживает ТОЛЬКО текстовую генерацию. Image generation (`/v1/images/generations`) НЕ проксируется.

### API-ключи на US-сервере

| Переменная | Провайдер | Наличие |
|------------|-----------|---------|
| `OPENAI_API_KEY` | OpenAI | Есть (sk-svcacct-*, service account) |
| `ANTHROPIC_API_KEY` | Anthropic | Есть (sk-ant-api03-*) |
| `GEMINI_API_KEY` | Google | Есть (AIzaSy*) |
| `DEEPSEEK_API_KEY` | DeepSeek | Есть (sk-*) |
| `OPENROUTER_API_KEY` | OpenRouter | Есть (sk-or-v1-*) |

Дополнительно на US-сервере `/opt/claude-code/.env`:
- `CF_API_EMAIL`, `CF_API_KEY`, `CF_ZONE_ID` (Cloudflare, домен fingroup.ru)
- `ANTHROPIC_API_KEY` (дублирован)

---

## Beget VPS (82.202.129.193)

### LLM Router / прокси

**LLM Router на Beget: ОТСУТСТВУЕТ.**

Beget не имеет собственного LLM-роутера. Для LLM-запросов используются:
- Прямые API-вызовы через egress-прокси к US-серверу
- n8n credentials с API-ключами напрямую к провайдерам
- Dify использует egress proxy (`HTTP_PROXY -> host.docker.internal:10808`)

### LLM-связанные сервисы на Beget

| Сервис | Назначение | Статус |
|--------|-----------|--------|
| **Dify** (dify.fingroup.ru) | LLM-платформа (RAG, приложения) | Работает |
| **n8n** (n8n.fingroup.ru) | Workflow-автоматизация с LLM-нодами | Работает |
| **ASR** (faster-whisper) | Распознавание речи | Работает |
| **LLM Council** | Совещание LLM-моделей через OpenRouter | Dev mode (без Docker) |
| **CreditWise Chat** | Чат-бот с GigaChat/YandexGPT | Работает |

### LLM Council

- **Статус:** development (не dockerized)
- **Путь:** `/home/roman/llm-council`
- **Backend:** FastAPI, порт 8001
- **Frontend:** Vite + React, порт 5173
- **Доступ:** localhost:5173 или SSH-туннель
- **API:** OpenRouter (OPENROUTER_API_KEY в `secrets/.env`)
- **Целевой домен:** llm.fingroup.ru (пока не развёрнут)

### AI CLI инструменты на Beget

| Инструмент | Контейнер | Порт | Модель/API |
|------------|-----------|------|-----------|
| OpenCode | opencode | 4096 | openrouter/anthropic/claude-3.5-sonnet |
| Claude Code | claude-code | 4097 | Claude Max/Pro subscription |
| Codex CLI | codex | 4098 | ChatGPT Plus/Pro subscription |

### API-ключи на Beget (`/opt/infra/secrets/.env`)

| Переменная | Провайдер | Наличие |
|------------|-----------|---------|
| `OPENAI_API_KEY` | OpenAI | Есть (тот же ключ, что на US) |
| `ANTHROPIC_API_KEY` | Anthropic | Есть (тот же ключ, что на US) |
| `OPENROUTER_API_KEY` | OpenRouter | Есть (тот же ключ, что на US) |
| `GROQ_API_KEY` | Groq | Есть (в n8n credentials) |
| `GIGACHAT_CLIENT_ID` | Сбер GigaChat | Есть (в secrets/.env) |
| `GIGACHAT_CLIENT_SECRET` | Сбер GigaChat | Есть (в secrets/.env) |
| `YANDEXGPT_API_KEY` | Яндекс YandexGPT | Есть (в secrets/.env) |
| `YANDEXGPT_FOLDER_ID` | Яндекс YandexGPT | Есть (в secrets/.env) |

### DNS Workaround на Beget

Для обхода гео-ограничений API используется DNS через Comss.one:
- DNS: `83.220.169.155#dns.comss.one` (DNS-over-TLS)
- Домены: `api.openai.com`, `api.anthropic.com`, `api.x.ai`, `generativelanguage.googleapis.com`
- Скрипты: `/usr/local/bin/enable-comss-dns`, `/usr/local/bin/disable-comss-dns`

---

## iMac Pro 2017 (локальная машина)

### Ollama

- **Установлен:** Да (`/usr/local/bin/ollama`)
- **Launchd сервис:** `com.ollama.ollama` (PID 1399, автозапуск)
- **Порт:** 11434 (TCP, слушает на 127.0.0.1)
- **Конфигурация:** `~/.ollama/`
- **API:** http://localhost:11434

### Фактически установленные модели (ollama list, актуально)

| Модель | Размер | Тип | Статус |
|--------|--------|-----|--------|
| nomic-embed-text:latest | 274 MB | Embedding | Установлена |

**Важно:** По документации (KB `infra_all_instruments`) должны быть установлены 6 моделей, фактически сейчас только 1. Вероятно, остальные были удалены для экономии места. Документированные, но отсутствующие модели:

| Модель | Размер | Тип |
|--------|--------|-----|
| qwen3:30b | 18 GB | LLM |
| qwen3-coder:30b | 18 GB | LLM |
| deepseek-r1:8b | 5.2 GB | LLM |
| llama3.1:8b | 4.9 GB | LLM |
| qwen2.5-coder:1.5b | 986 MB | LLM |

### LiteLLM / vLLM

- **LiteLLM:** НЕ установлен (нет бинарника, нет pip-пакета)
- **vLLM:** НЕ установлен

### Docker на iMac

Compose-проект `imac` (running), 3 контейнера:

| Контейнер | Образ | Порт | Статус |
|-----------|-------|------|--------|
| open-webui | ghcr.io/open-webui/open-webui:latest | 3000 -> 8080 | Up (healthy) |
| paddleocr-api | blazordevlab/paddleocrapi:latest | 8080 -> 8000 | Up |
| portainer-agent | portainer/agent | 9001 | Up |

- **Open WebUI** подключён к Ollama через `http://host.docker.internal:11434`
- **PaddleOCR** - OCR-сервис для распознавания текста с изображений

### Порты на iMac

| Порт | Сервис | Статус |
|------|--------|--------|
| 11434 | Ollama API | Слушает (127.0.0.1) |
| 8080 | PaddleOCR API | Слушает (*) |
| 3000 | Open WebUI | Слушает (*) |
| 4000 | LiteLLM | НЕ слушает |
| 8000 | vLLM | НЕ слушает |

### Continue IDE (конфигурация)

Файл: `~/.continue/config.yaml`

**Локальные модели:**
- Qwen3 30B (chat/edit/apply) - через Ollama, НО модель сейчас не установлена
- Llama 3.1 8B (chat) - через Ollama, НО модель сейчас не установлена
- Qwen Coder 1.5b (autocomplete) - через Ollama, НО модель сейчас не установлена
- Nomic Embed (embed) - через Ollama, установлена

**OpenRouter модели (через API):**
- Qwen3 Coder 480B (chat/edit/apply) - free tier
- Qwen3 Next 80B (chat/edit/apply) - free tier
- DeepSeek R1T2 Chimera (chat) - free tier
- DeepSeek R1 0528 (chat) - free tier

**Rerank провайдеры:**
- Voyage AI rerank-2 / rerank-2-lite (ключ `VOYAGE_API_KEY` есть)
- Cohere rerank-multilingual-v3.0 / rerank-english-v3.0 (ключ `COHERE_API_KEY` есть)

### Python-пакеты (pip3)

| Пакет | Версия | Назначение |
|-------|--------|-----------|
| anthropic | 0.79.0 | Anthropic Claude API SDK |
| openai | 2.21.0 | OpenAI API SDK |

---

## Облачные API - сводная таблица

| Провайдер | Переменная | Наличие ключа | Где используется |
|-----------|-----------|:------------:|-----------------|
| **OpenAI** | `OPENAI_API_KEY` | Есть | US LLM Router, Beget secrets, n8n |
| **Anthropic** | `ANTHROPIC_API_KEY` | Есть | US LLM Router, Beget secrets, Claude Code |
| **Google Gemini** | `GEMINI_API_KEY` | Есть | US LLM Router |
| **DeepSeek** | `DEEPSEEK_API_KEY` | Есть | US LLM Router |
| **OpenRouter** | `OPENROUTER_API_KEY` | Есть | US LLM Router, Beget secrets, Continue IDE, LLM Council, OpenCode |
| **Groq** | `GROQ_API_KEY` | Есть | n8n credentials (Telegram Lead Processor) |
| **GigaChat (Сбер)** | `GIGACHAT_CLIENT_ID/SECRET` | Есть | CreditWise Chat (credoserv-chat) |
| **YandexGPT** | `YANDEXGPT_API_KEY`, `FOLDER_ID` | Есть | CreditWise Chat (credoserv-chat) |
| **Voyage AI** | `VOYAGE_API_KEY` | Есть | Continue IDE (rerank) |
| **Cohere** | `COHERE_API_KEY` | Есть | Continue IDE (rerank) |
| **Alibaba Cloud** | `ALIBABA_ACCESS_KEY_ID/SECRET` | Есть | ai_agents .env |
| **DeepInfra** | - | Нет | Не используется |
| **SiliconFlow** | - | Нет | Не используется |
| **Fireworks** | - | Нет | Не используется |
| **Scaleway** | - | Нет | Не используется |
| **DashScope** | - | Нет | Не используется |
| **Replicate** | - | Нет | Не используется |

### Особенности использования ключей

- **Один ключ на нескольких серверах:** OPENAI_API_KEY, ANTHROPIC_API_KEY, OPENROUTER_API_KEY - одни и те же на US и Beget
- **Два разных OPENROUTER ключа:** один для LLM Router (US), другой для Continue IDE (Mac)
- **GigaChat / YandexGPT** - используются только в CreditWise Chat на Beget, российские API без гео-ограничений
- **Groq** - используется только в n8n credentials, OpenAI-compatible API

---

## Схема маршрутизации LLM-запросов

```
iMac (Mac)
  |
  +-- Ollama (localhost:11434) -- локальные модели (nomic-embed-text)
  |
  +-- Continue IDE -- Ollama / OpenRouter API (напрямую)
  |
  +-- Claude Code / Claude Desktop -- Anthropic API (напрямую через подписку)

Beget VPS (82.202.129.193)
  |
  +-- n8n -- Groq API (напрямую)
  |       +-- OpenRouter API (через credentials)
  |       +-- OpenAI API (через credentials)
  |
  +-- Dify -- egress proxy -> US -> LLM провайдеры
  |
  +-- CreditWise Chat -- GigaChat API (Сбер, напрямую)
  |                   +-- YandexGPT API (Яндекс, напрямую)
  |
  +-- LLM Council (dev) -- OpenRouter API (напрямую)
  |
  +-- AI CLI (OpenCode/Claude Code/Codex) -- через подписки/API

US VPS (149.33.4.37)
  |
  +-- LLM Router (:8080) -- Squid egress (:3128) -- OpenAI / Anthropic / Gemini / DeepSeek / OpenRouter
```

---

## Проблемы и рекомендации

### Критические

1. **Модели Ollama не установлены.** Из 6 задокументированных моделей фактически присутствует только nomic-embed-text (274 MB). Continue IDE настроен на 4 локальные модели, которых нет. Рекомендация: восстановить хотя бы qwen3:30b как основную или обновить документацию.

### Средние

2. **Одинаковые ключи на двух серверах.** OpenAI, Anthropic, OpenRouter - одни и те же ключи на US и Beget. При компрометации одного сервера - компрометируются все. Рекомендация: использовать раздельные ключи или API key rotation.

3. **LLM Router не проксирует image generation.** Для генерации изображений нужно вызывать OpenAI API напрямую. Рекомендация: добавить endpoint `/v1/images/generations` в LLM Router или документировать workaround.

4. **LLM Council не dockerized.** Работает в dev-режиме без Docker, домен llm.fingroup.ru не развёрнут. Рекомендация: либо dockerize, либо пометить как deprecated.

### Информационные

5. **API-ключи в plaintext.** На US-сервере `.env` доступен пользователю roman. На Beget - `/opt/infra/secrets/.env` (chmod 600). Рекомендация: рассмотреть HashiCorp Vault или Docker Secrets.

6. **Два разных OpenRouter ключа.** На LLM Router (US) и в Continue IDE (Mac) разные ключи. Не проблема, но нужно отслеживать оба при ротации.

---

## Links (internal)

- [[infra_vps_usa/ARCHITECTURE|Архитектура US-сервера]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/ollama-local__20260210220400-19|Рантайм: Ollama Local]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/openrouter__20260210220400-20|Рантайм: OpenRouter]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/groq__20260213150000-01|Рантайм: Groq]]
- [[infra_all_instruments/docs/integrations/api-map__20260210220500-04|Карта API endpoints]]
- [[infra_all_instruments/docs/integrations/data-flows__20260210220500-03|Потоки данных]]
- [[vps/docs/infrastructure__20260204223352|Инфраструктура VPS Beget]]
- [[vps/docs/vars__20260204221352|Переменные инфраструктуры]]
