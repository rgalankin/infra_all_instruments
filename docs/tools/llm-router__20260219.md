---
id: 20260219000000
title: "LLM Router"
summary: >
  Кастомный FastAPI-прокси для маршрутизации LLM-запросов.
  6 провайдеров, 13 моделей, OpenAI-совместимый endpoint.
  Middleware: logging (SQLite), fallback chains, tier routing T1-T4, budget alerts.
type: spec
status: active
tags: [ai/llm, eng/infrastructure, platform/docker]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-19
updated: 2026-02-19
category: "AI - LLM - Роутер"
version: "v2.0.0"
criticality: high
cost: "бесплатно (self-hosted)"
---
# LLM ROUTER

## ОСНОВНАЯ ИНФОРМАЦИЯ

| Параметр | Значение |
|----------|----------|
| Версия | v2.0.0 + middleware (logging, fallback, tier, budget) |
| Тип | FastAPI-прокси, OpenAI-совместимый |
| Исходники | `~/Documents/ai_agents/services/llm-router/` |
| Конфиг | `config/config.yml` (pricing, tiers, fallback chains, agent mapping) |
| US-сервер | 149.33.4.37:8080 (production) |
| iMac | localhost:8000 (development) |
| Beget VPS | 82.202.129.193 (подготовлен к деплою) |
| Docker | python:3.11-slim, ~50-100 MB RAM |
| Endpoint | `/v1/chat/completions` (OpenAI-compatible) |
| Список моделей | `/v1/models` (13 моделей) |

## ПРОВАЙДЕРЫ (6)

| Провайдер | Модели | Endpoint | Статус |
|-----------|--------|----------|--------|
| OpenAI | gpt-4o, gpt-4o-mini, gpt-4-turbo, o1, o3-mini | api.openai.com | Активен |
| Anthropic | claude-opus-4-6, claude-sonnet-4-5, claude-haiku-4-5 | api.anthropic.com | Активен |
| Google Gemini | gemini-2.0-flash, gemini-2.5-pro | generativelanguage.googleapis.com | Активен |
| DeepSeek | deepseek-chat, deepseek-reasoner | api.deepseek.com | Активен |
| OpenRouter | 400+ моделей (openrouter/provider/model) | openrouter.ai/api | Активен |
| Groq | (ожидает API-ключ) | api.groq.com | Ожидает ключ |

## MIDDLEWARE

### 1. Logging (SQLite + JSONL fallback)
- Бэкенд: SQLite (`/data/llm_logs.db`)
- Fallback: JSONL (`/data/llm_logs_fallback.jsonl`) при недоступности БД
- Retention: 90 дней
- Логируются: модель, агент, токены (input/output), стоимость, latency, статус

### 2. Fallback Chains
- Автоматический переход на резервную модель при ошибке провайдера
- Триггеры: HTTP 500, 502, 503, 504, 529
- Макс. ретраев: 2
- Таймаут на запрос: 120 сек
- Пример цепочки: claude-opus-4-6 -> claude-sonnet-4-5 -> gpt-4o

### 3. Tier Routing (T1-T4)
- T1 (Strategic): AI Director, Chief of Staff - полный доступ, $50/день
- T2 (Operational): руководители отделов - premium-модели, $15/день
- T3 (Execution): специалисты - эффективные модели, $5/день
- T4 (Automation): n8n workflows, cron - высокий объём, $10/день
- Автоматический downgrade моделей по тиру (например T3 запрашивает Opus -> получает Haiku)

### 4. Budget Alerts
- Warning при 90% бюджета (лог)
- Block при 100% (HTTP 429)
- Ежедневный reset в 00:00 UTC
- Кэш расчётов: 60 сек TTL

## PRICING (за 1M токенов, USD)

| Модель | Input | Output |
|--------|-------|--------|
| claude-opus-4-6 | $15.00 | $75.00 |
| claude-sonnet-4-5 | $3.00 | $15.00 |
| claude-haiku-4-5 | $0.80 | $4.00 |
| gpt-4o | $2.50 | $10.00 |
| gpt-4o-mini | $0.15 | $0.60 |
| gpt-4-turbo | $10.00 | $30.00 |
| o1 | $15.00 | $60.00 |
| o3-mini | $1.10 | $4.40 |
| gemini-2.5-pro | $1.25 | $10.00 |
| gemini-2.0-flash | $0.10 | $0.40 |
| deepseek-chat | $0.27 | $1.10 |
| deepseek-reasoner | $0.55 | $2.19 |

## AGENT-TIER MAPPING

| Агент | Тир |
|-------|-----|
| ai_director | T1 |
| chief_of_staff | T1 |
| personal_assistant | T2 |
| sysadmin_agent | T2 |
| devops_agent | T2 |
| ops_automation_lead | T2 |
| vp_contentops | T2 |
| sales_agent | T2 |
| marketing_agent | T2 |
| hr_agent | T2 |
| growth_analyst | T2 |
| data_compliance | T2 |
| qa_risk_officer | T2 |
| agent_creator | T2 |
| skill_creator | T2 |
| elevenlabs_specialist | T3 |
| docops_agent | T3 |
| bitrix24_admin | T3 |
| kb_manager | T3 |
| n8n_engineer | T4 |
| (по умолчанию) | T3 |

## TASK ROUTING

| Тип задачи | Предпочтительная модель | Fallback |
|-------------|------------------------|----------|
| Стратегия | claude-opus-4-6 | gpt-4o |
| Анализ | claude-sonnet-4-5 | gpt-4o |
| Контент | claude-sonnet-4-5 | gpt-4o |
| Код | claude-sonnet-4-5 | deepseek-chat |
| Скиллы | claude-haiku-4-5 | gpt-4o-mini |
| Запросы | deepseek-chat | gpt-4o-mini |
| Перевод | gpt-4o-mini | deepseek-chat |

## РАЗВЁРТЫВАНИЕ

```bash
# Production (US-сервер)
ssh roman@149.33.4.37
cd /opt/llm-router
docker compose up -d

# Development (iMac)
cd ~/Documents/ai_agents/services/llm-router
uvicorn app.main:app --host 0.0.0.0 --port 8000

# Проверка
curl http://149.33.4.37:8080/v1/models
curl http://localhost:8000/v1/models
```

## СВЯЗИ

### Зависимости
- Docker (python:3.11-slim)
- API-ключи провайдеров (env variables)
- SQLite (встроенная)
- VPS ISHosting USA (production-хост)

### Используется в
- AI-агенты Кредо-Сервис (20 агентов)
- n8n workflows (через T4)
- Планируется интеграция с Dify

## LINKS (INTERNAL)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]
- [[infra_all_instruments/docs/infrastructure/vps-ishosting-usa__20260212220200-01|VPS ISHosting USA]] - production-хост
- [[infra_all_instruments/docs/infrastructure/vps-beget__20260210220200-01|VPS Beget]] - подготовлен к деплою
- [[infra_all_instruments/docs/neural-networks/_index__20260210220000-05|Реестр нейросетей]] - модели, доступные через Router

## ИСТОРИЯ

- 2026-02-19: Создана карточка. LLM Router v2.0.0 с полным набором middleware (logging, fallback, tier routing, budget alerts). 6 провайдеров, 13 моделей. Деплой на US-сервере (149.33.4.37:8080).
