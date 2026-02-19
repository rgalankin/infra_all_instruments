---
id: 20260219200000
title: "Infrastructure Matrix: единый реестр инфраструктуры по точкам"
summary: >
  Матрица инфраструктуры компании по 5 точкам: US, DE, RU (Beget), Local Mac.
  Разделы: MCP-серверы, скрипты, API, LLM, Docker-сервисы, железо.
type: spec
status: active
tags: [eng/infrastructure, infra/inventory, content/registry, process/governance]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-19
updated: 2026-02-19
owner: Roman Galankin
---
# INFRASTRUCTURE MATRIX

Единый реестр инфраструктуры компании по точкам развертывания.

**Точки инфраструктуры:**

| Код | Расположение | IP | Назначение |
|-----|-------------|-----|-----------|
| US | ISHosting, New York | 149.33.4.37 | LLM Router, Egress Proxy, Hub (DB+RAG+CLI), VPN |
| DE | ISHosting, Germany | 38.244.128.203 | VPN dual-mode (Reality + XHTTP) |
| RU | Beget, Russia | 82.202.129.193 | Production: n8n, Dify, Traefik, PostgreSQL, MCP |
| Local | iMac Pro 2017, macOS | localhost | Разработка, AI-агенты, Claude Code, Ollama |

> Обозначения: **V** = есть, **-** = нет, **?** = неизвестно, **P** = подготовлен/планируется

---

## 1. MCP-серверы

MCP-серверы, доступные через Claude Code, Cursor, Warp, Claude Desktop.

### 1.1 MCP в Claude Code (ai_agents)

| MCP Server | US | DE | RU | Local | Описание |
|------------|:--:|:--:|:--:|:-----:|----------|
| b24-portal | - | - | - | V | Bitrix24 REST API (задачи, пользователи, CRM) |
| b24-dev (bitrix24-docs) | - | - | - | V | Документация Bitrix24 REST API |
| github | - | - | - | V | GitHub API (issues, PRs, repos) |
| brave-search | - | - | - | V | Brave Search API (веб-поиск) |
| google-workspace | - | - | - | V | 11 сервисов Google Workspace (complete tier) |
| kb-server | V | - | - | V | Семантический поиск KB (Qdrant + PostgreSQL) |
| calculator | V | V | V | V | Математические вычисления (бесплатно) |

### 1.2 MCP в Cursor

| MCP Server | US | DE | RU | Local | Описание |
|------------|:--:|:--:|:--:|:-----:|----------|
| macuse | - | - | - | V | macOS automation (Calendar, Mail, Reminders, 56 tools) |
| github | - | - | - | V | GitHub API (26 tools) |
| linear | - | - | - | V | Linear project management (25 tools) |
| filesystem | - | - | - | V | Файловая система KB (14 tools) |
| bitrix24-docs | - | - | - | V | Документация B24 (4 tools) |
| brave-search | - | - | - | V | Brave Search (2 tools) |
| context7 | - | - | - | V | Документация библиотек (2 tools) |
| ssh (Beget) | - | - | V | V | SSH к VPS Beget (2 tools) |
| warp | - | - | - | V | Warp терминал (3 tools) |
| n8n | - | - | V | V | n8n workflow management (ошибка подключения) |
| n8n-dev | - | - | V | V | n8n dev instance |
| n8n-prod | - | - | V | V | n8n prod instance |
| playwright | - | - | - | V | Browser automation (22 tools) |
| mcp-postgres | - | - | V | V | PostgreSQL через MCP |
| mcp-ssh | - | - | V | V | SSH через MCP |

### 1.3 MCP в Warp

| MCP Server | US | DE | RU | Local | Описание |
|------------|:--:|:--:|:--:|:-----:|----------|
| GitHub | - | - | - | V | GitHub (40 tools) |
| Linear | - | - | - | V | Linear (25 tools) |
| Playwright | - | - | - | V | Browser automation (22 tools) |
| Notion | - | - | - | V | Notion docs (12 tools) |
| Context7 | - | - | - | V | Library docs (2 tools) |

### 1.4 MCP в Claude Desktop

| MCP Server | US | DE | RU | Local | Описание |
|------------|:--:|:--:|:--:|:-----:|----------|
| mcp-n8n | - | - | V | V | n8n через SSH-туннель к VPS |
| linear | - | - | - | V | Linear (управление задачами) |
| Macuse | - | - | - | V | macOS интеграция |

### 1.5 MCP на серверах (Docker)

| MCP Server | US | DE | RU | Local | Порт | Описание |
|------------|:--:|:--:|:--:|:-----:|------|----------|
| mcp-n8n (prod) | - | - | V | - | 3900 | MCP для n8n production |
| mcp-n8n (dev) | - | - | V | - | 3904 | MCP для n8n development |
| mcp-postgres | V | - | V | - | 3902/3903 | MCP для PostgreSQL |
| mcp-ssh | - | - | V | - | ? | MCP для SSH |
| mcp-warp-http | - | - | V | - | 3901 | MCP для Warp HTTP API |

---

## 2. Python-скрипты

Скрипты из `/Users/mac/Documents/ai_agents/scripts/`.

### 2.1 B24 (Bitrix24)

| Скрипт | US | DE | RU | Local | Описание |
|--------|:--:|:--:|:--:|:-----:|----------|
| b24-agent-context.sh | - | - | - | V | Загрузка контекста агента из B24 |
| b24-create-task.sh | - | - | - | V | Создание задачи в B24 |
| b24-update-task.sh | - | - | - | V | Обновление статуса задачи |
| b24-add-task-comment.sh | - | - | - | V | Добавление комментария к задаче |
| b24-send-message.sh | - | - | - | V | Отправка сообщения в B24 чат |
| b24-register-chatbots.sh | - | - | - | V | Регистрация чат-ботов в B24 |
| b24-register-chatbots-batch2.sh | - | - | - | V | Регистрация чат-ботов (batch 2) |

### 2.2 Email

| Скрипт | US | DE | RU | Local | Описание |
|--------|:--:|:--:|:--:|:-----:|----------|
| check-corporate-email.sh | - | - | - | V | Проверка корп. почты (IMAP) |
| send-corporate-email.sh | - | - | - | V | Отправка корп. письма (SMTP) |
| email-poller.py | V | - | - | V | Polling почтовых ящиков (daemon) |
| email-poller.sh | - | - | - | V | Wrapper для email-poller |
| email-poll-and-notify.sh | - | - | - | V | Polling + уведомления |
| deploy-email-poller.sh | V | - | - | V | Деплой email poller на сервер |
| test-email-poller.sh | - | - | - | V | Тест email poller |
| create_mailboxes.py | - | - | - | V | Создание почтовых ящиков |

### 2.3 Google API

| Скрипт | US | DE | RU | Local | Описание |
|--------|:--:|:--:|:--:|:-----:|----------|
| google-sheets-edit.py | - | - | - | V | CRUD Google Sheets API v4 |
| google-calendar.py | - | - | - | V | CRUD Google Calendar |
| google-tasks.py | - | - | - | V | CRUD Google Tasks |
| google-docs.py | - | - | - | V | CRUD Google Docs |
| google-contacts.py | - | - | - | V | Google Contacts API |
| google-maps.py | - | - | - | V | Google Maps API |
| google-search-console.py | - | - | - | V | Google Search Console API |
| google-translate.py | - | - | - | V | Google Translation API |
| google-vision-ocr.py | - | - | - | V | Google Vision OCR API |

### 2.4 KB (База знаний)

| Скрипт | US | DE | RU | Local | Описание |
|--------|:--:|:--:|:--:|:-----:|----------|
| kb-indexer.py | V | - | - | V | Индексация KB в Qdrant + PostgreSQL |
| mcp-kb-server.py | V | - | - | V | MCP-сервер для семантического поиска |
| kb-enhance.py | - | - | - | V | Улучшение карточек KB |
| kb-enhance-calls.py | - | - | - | V | Улучшение транскрипций звонков |
| kb-fix-calls.py | - | - | - | V | Исправление ошибок в транскрипциях |
| kb-add-crossrefs.py | - | - | - | V | Добавление перекрестных ссылок |
| kb-process.py | - | - | - | V | Обработка KB-документов |

### 2.5 Прочие

| Скрипт | US | DE | RU | Local | Описание |
|--------|:--:|:--:|:--:|:-----:|----------|
| claude-stats-collector.py | - | - | - | V | Сбор статистики Claude Code |
| llm-sheet-updater.py | - | - | - | V | Обновление LLM-реестра в Google Sheets |
| transcribe-calls.py | - | - | - | V | Транскрипция звонков |
| elevenlabs-kb-refresh.sh | - | - | - | V | Обновление KB для ElevenLabs |
| git-sync-pull.sh | V | - | - | - | Git sync: pull на VPS (cron */5) |
| deploy-memory.sh | V | - | - | V | Деплой memory system |
| validate-agents-structure.sh | - | - | - | V | Валидация структуры агентов |

---

## 3. API-интеграции

| API | US | DE | RU | Local | Auth | Бесплатно | Описание |
|-----|:--:|:--:|:--:|:-----:|------|:---------:|----------|
| Google Workspace (11 сервисов) | - | - | - | V | OAuth2 | V | Gmail, Drive, Calendar, Docs, Sheets, Slides, Forms, Chat, Tasks, Contacts, Apps Script |
| Google Cloud Vision OCR | - | - | - | V | OAuth2 | Лимит | Распознавание текста на изображениях |
| Google Cloud Translation | - | - | - | V | OAuth2 | Лимит | Перевод текста |
| Google Maps | - | - | - | V | API Key | Лимит | Геокодирование, маршруты |
| Google Search Console | - | - | - | V | OAuth2 | V | SEO-аналитика |
| Bitrix24 REST API | - | - | - | V | Webhook | V | CRM, задачи, пользователи, чаты |
| OpenAI API | V | - | - | V | API Key | - | GPT-4o, GPT-4-turbo, o1, o3-mini |
| Anthropic API | V | - | - | V | API Key | - | Claude Opus, Sonnet, Haiku |
| Google Gemini API | V | - | - | V | API Key | Лимит | Gemini 2.0 Flash, 2.5 Pro |
| DeepSeek API | V | - | - | V | API Key | - | DeepSeek Chat, Reasoner |
| OpenRouter API | V | - | - | V | API Key | - | 400+ моделей (агрегатор) |
| Groq API | P | - | - | ? | API Key | Лимит | Быстрый инференс (ключ ожидается) |
| SiliconFlow API | V | - | - | V | API Key | Лимит | Embeddings (Qwen3-Embedding-8B) |
| Brave Search API | - | - | - | V | API Key | - | Веб-поиск |
| GitHub API | - | - | - | V | Token | V | Repos, issues, PRs |
| Linear API | - | - | - | V | API Key | V | Project management |
| Telegram API | - | - | V | V | Token | V | MTProto, Bot API |
| GigaChat API (Sber) | - | - | V | - | OAuth2 | Лимит | LLM для CreditWise чата |
| ElevenLabs API | - | - | - | V | API Key | Лимит | Text-to-Speech |
| DaData API | V | V | V | V | API Key | 10K/день | Стандартизация адресов, ИНН, ФИО, реквизиты компаний |
| ФССП API | V | V* | V | V | - | ~500/день | Проверка задолженностей по исполнительным производствам |
| Банк России API | V | V | V | V | - | V | Курсы валют, реестры кредитных организаций, справочники |
| Росфинмониторинг API | V | V | V | V | - | V | Проверка по перечню лиц (террористы, экстремисты) |
| api-parser.ru | V | V* | V | V | API Key | - (990 р/мес) | Парсинг сайтов, мониторинг, сбор данных |
| SpectrumData | V | V* | V | V | API Key | - (~10 р/запрос) | Проверка физ/юрлиц: паспорта, ИНН, авто, суды |
| IDX | V | V* | V | V | API Key | - (от 5 р/запрос) | Верификация документов, идентификация личности |

> **V*** = доступность с US-сервера не подтверждена. Российские API (ФССП, api-parser, SpectrumData, IDX) могут требовать прокси через RU (Beget) для доступа с зарубежных серверов.

---

## 4. LLM-реестр

### 4.1 Через LLM Router (v2.0.0)

LLM Router: единый OpenAI-совместимый `/v1/chat/completions` endpoint.

| LLM | Напрямую | Через Router | US | DE | RU | Local | Провайдер |
|-----|:--------:|:------------:|:--:|:--:|:--:|:-----:|-----------|
| claude-opus-4-6 | V | V | V | - | - | V | Anthropic |
| claude-sonnet-4-5 | V | V | V | - | - | V | Anthropic |
| claude-haiku-4-5 | V | V | V | - | - | V | Anthropic |
| gpt-4o | V | V | V | - | - | V | OpenAI |
| gpt-4o-mini | V | V | V | - | - | V | OpenAI |
| gpt-4-turbo | V | V | V | - | - | V | OpenAI |
| o1 | V | V | V | - | - | V | OpenAI |
| o3-mini | V | V | V | - | - | V | OpenAI |
| gemini-2.5-pro | V | V | V | - | - | V | Google |
| gemini-2.0-flash | V | V | V | - | - | V | Google |
| deepseek-chat | V | V | V | - | - | V | DeepSeek |
| deepseek-reasoner | V | V | V | - | - | V | DeepSeek |
| 400+ через OpenRouter | V | V | V | - | - | V | OpenRouter |

**Router endpoints:**
- US: `http://149.33.4.37:8080/v1/chat/completions` (production)
- Local: `http://localhost:8000/v1/chat/completions` (development)
- RU (Beget): подготовлен, не задеплоен

**Middleware:** Logging (SQLite), Fallback chains, Tier routing (T1-T4), Budget alerts

### 4.2 Локальные модели (Ollama, только Local Mac)

| Модель | Параметры | Размер | Назначение | Рус. |
|--------|----------|--------|-----------|:----:|
| qwen3:30b | 30B | 18 GB | Основная, русский язык | 8/10 |
| qwen3-coder:30b | 30B | 18 GB | Кодинг | 7/10 |
| deepseek-r1:8b | 8B | 5.2 GB | Reasoning | 7/10 |
| llama3.1:8b | 8B | 4.9 GB | Баланс скорости/качества | 6/10 |
| llama3.2:latest | 3.2B | 2 GB | Легковесные задачи | 5/10 |
| gpt-oss:20b | 20.9B | 14 GB | Альтернатива для сложных задач | ? |
| qwen2.5-coder:1.5b | 1.5B | 986 MB | Autocomplete в IDE | 5/10 |
| nomic-embed-text | 137M | 274 MB | Embeddings для @codebase | - |

**Ollama endpoint:** `http://localhost:11434`

### 4.3 Облачные (OpenRouter, прямой доступ)

| Модель | Параметры | Контекст | Рус. | Назначение |
|--------|----------|---------|:----:|-----------|
| DeepSeek R1T2 Chimera | 671B MoE | 164K | 8/10 | Сложные задачи, reasoning |
| DeepSeek R1 0528 | 671B | 164K | 8/10 | Альтернативный reasoning |

### 4.4 Pricing (LLM Router, за 1M токенов, USD)

| Модель | Input | Output |
|--------|------:|-------:|
| claude-opus-4-6 | $15.00 | $75.00 |
| claude-sonnet-4-5 | $3.00 | $15.00 |
| claude-haiku-4-5 | $0.80 | $4.00 |
| gpt-4o | $2.50 | $10.00 |
| gpt-4o-mini | $0.15 | $0.60 |
| gemini-2.5-pro | $1.25 | $10.00 |
| gemini-2.0-flash | $0.10 | $0.40 |
| deepseek-chat | $0.27 | $1.10 |
| deepseek-reasoner | $0.55 | $2.19 |

---

## 5. Docker-контейнеры / Сервисы

### 5.1 RU (Beget, 82.202.129.193)

20+ контейнеров, два Docker-стека: `net_proxy` (public) и `net_internal` (private).

| Сервис | Порт | Домен | Критичность | Описание |
|--------|------|-------|:-----------:|----------|
| Traefik v3.1 | 80, 443 | *.fingroup.ru | Высокая | Reverse proxy, HTTPS, Let's Encrypt |
| n8n (production) | 5678 | n8n.fingroup.ru | Очень высокая | Workflow engine |
| n8n (development) | 5678 | n8n-dev.fingroup.ru | Средняя | Dev-инстанс |
| PostgreSQL | 5432 | - | Высокая | Основная СУБД (n8n, credoserv, telegram) |
| Qdrant | 6333 | - | Высокая | Векторная БД для RAG |
| Dify | - | dify.fingroup.ru | Высокая | AI-платформа (API, worker, nginx, redis, pg) |
| Portainer | - | portainer.fingroup.ru | Средняя | Docker UI |
| pgAdmin | - | pgadmin.fingroup.ru | Средняя | PostgreSQL UI |
| MCP-n8n (prod) | 3900 | - | Высокая | MCP для n8n (WireGuard/SSH) |
| MCP-n8n (dev) | 3904 | - | Средняя | MCP для n8n dev |
| MCP-Warp HTTP | 3901 | - | Средняя | MCP для Warp HTTP |
| MCP-Postgres | 3903 | - | Средняя | MCP для PostgreSQL |
| MCP-SSH | ? | - | Средняя | MCP для SSH |
| Telegram Forwarder | - | - | Средняя | MTProto -> n8n webhook |
| Telegram Story Publisher | 8000 | - | Средняя | Публикация stories |
| WhatsApp API | - | wa.fingroup.ru | Средняя | WhatsApp интеграция |
| ASR | - | - | Средняя | Speech-to-text (faster-whisper) |
| CreditWise Chat | - | credoserv.ru, api.credoserv.ru | Средняя | Frontend (nginx) + Backend (Node.js) |
| Warp-Runner | 3000 | - | Средняя | Telegram -> Warp Agent |
| XRay relay | 6 портов | - | Средняя | Dokodemo-door -> US/DE |
| Egress-tunnel | 10808, 1080 | - | Высокая | VLESS -> US (HTTP/SOCKS5 proxy) |

### 5.2 US (ISHosting, 149.33.4.37)

Hub-сервер: egress + LLM + DB + RAG + CLI.

| Сервис | Порт | Критичность | Описание |
|--------|------|:-----------:|----------|
| Egress Proxy (Squid) | 3128 | Высокая | HTTP/HTTPS прокси (US IP для LLM API) |
| LLM Router (FastAPI) | 8080 | Высокая | Маршрутизация LLM-запросов (6 провайдеров) |
| Hub Traefik v3.6.8 | 8444 | Высокая | L7 reverse proxy за nginx |
| Hub n8n v2.7.5 | 5678 | Высокая | Workflow engine (n8n-usa.fingroup.ru) |
| Hub MCP-Postgres | 3902 | Средняя | MCP PostgreSQL (HTTP/SSE) |
| Hub MCP-n8n | 3900 | Средняя | MCP n8n workflow management |
| Hub PostgreSQL 16 | 5432 | Высокая | PostgreSQL (localhost only) |
| Hub Qdrant | 6333, 6334 | Высокая | Векторная БД (localhost only) |
| 3X-UI | 2053, 2096 | Средняя | VPN (VLESS Reality) |
| Sub-merge | ? | Низкая | Объединение VPN-подписок US+DE |
| VPN-мониторинг | ? | Низкая | TCP-connect мониторинг VPN |
| Vaultwarden | ? | Средняя | Менеджер паролей |

**CLI tools на US:**
- claude 2.1.42
- codex 0.101.0
- gemini 0.28.2

### 5.3 DE (ISHosting VPN, 38.244.128.203)

| Сервис | Порт | Критичность | Описание |
|--------|------|:-----------:|----------|
| 3X-UI (XRay v26.2.6) | 443, 47819 | Средняя | VPN dual-mode: Reality + XHTTP CDN |
| Dokodemo-door relay | 50443, 50382 | Средняя | Multi-hop relay -> US |
| nginx | 443 | Средняя | geo-routing для Reality SNI |

### 5.4 Local Mac (iMac Pro 2017)

| Сервис | Порт | Описание |
|--------|------|----------|
| Ollama | 11434 | LLM runtime (7 моделей) |
| Docker Desktop | - | Контейнеризация |
| LLM Router (dev) | 8000 | Development-инстанс LLM Router |
| PaddleOCR | 8080 | OCR (русский язык, Docker) |
| Open WebUI | ? | UI для локальных LLM |

---

## 6. Железо

| Параметр | US (ISHosting) | DE (ISHosting VPN) | RU (Beget) | Local (iMac Pro 2017) |
|----------|:--------------:|:------------------:|:----------:|:--------------------:|
| CPU | Xeon 4x2.20 GHz | 1 Core | ? | 8-Core Xeon W |
| RAM | 8 GB | 960 MiB | ? | 32 GB |
| Disk | 50 GB SSD | 9.8 GB SSD | ? | SSD (объем ?) |
| OS | Ubuntu 24.04.4 LTS | Debian 12 | Ubuntu 24.04 LTS | macOS (iMac Pro 2017) |
| IP | 149.33.x.x | 38.244.x.x | 82.202.x.x | localhost |
| Хостинг | ISHosting | ISHosting | Beget | - |
| Стоимость | $39.99/мес | $6.99/мес | ? | - |
| Панель | HestiaCP | - | - | - |
| Docker | v29.2.1 | ? | V | Docker Desktop |
| Firewall | UFW | ? | UFW | macOS Firewall |

> Примечание: точные характеристики Beget не указаны в имеющейся документации. RAM и CPU требуют уточнения.

---

## 7. Сводная статистика

| Метрика | Значение |
|---------|----------|
| Точек инфраструктуры | 4 (US, DE, RU, Local) |
| MCP-серверов (уникальных) | 22 |
| Python-скриптов | 37 |
| API-интеграций | 26 |
| LLM-моделей (через Router) | 13+ (+ 400 через OpenRouter) |
| Локальных моделей (Ollama) | 8 |
| Docker-контейнеров (RU) | 20+ |
| Docker-контейнеров (US) | 12+ |
| Docker-контейнеров (DE) | 3 |
| Docker-контейнеров (Local) | 3-4 |

---

## 8. Git Sync (Mac -> US)

| Параметр | Значение |
|----------|----------|
| Принцип | Mac = master (push), VPS = read-only replica (pull) |
| Скрипт | `/opt/hub/git-sync/git-sync-pull.sh` |
| Cron | `*/5 * * * *` (каждые 5 мин) |
| Репозиториев | 16 |
| При изменении .md | автозапуск kb-indexer.py для Qdrant |
| Embedding | SiliconFlow (Qwen3-Embedding-8B, 4096 dims) |

---

## Links (Internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/infrastructure/_index__20260210220000-03|Реестр инфраструктуры]]
- [[infra_all_instruments/docs/tools/llm-router__20260219|LLM Router]]
- [[ai_agents/docs/neurocompany/tools-registry__20260218133000-01|TOOLS_REGISTRY]]
- [[infra_all_instruments/docs/neural-networks/_index__20260210220000-05|Реестр нейросетей]]
- [[infra_all_instruments/docs/mcp/_index__20260210220000-06|Реестр MCP-серверов]]
