---
id: 20260224-url-shortener
title: "URL Shortener"
summary: >
  Собственный сервис сокращения ссылок с аналитикой переходов. FastAPI + PostgreSQL.
  Создание коротких ссылок с привязкой к каналу и контексту размещения.
  Скрипт написан, готов к деплою на VPS.
type: spec
status: in_progress
tags: [eng/api, analytics/traffic, eng/integration, platform/custom]
source: kb-manager
ai_weight: normal
created: 2026-02-24
updated: 2026-02-24
category: "API -> Custom Services"
criticality: low
platform: Linux
cost: "free (self-hosted)"
---
# URL SHORTENER

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** Custom Service - Link Shortener & Analytics
- **Статус:** in_progress (скрипт написан, готов к деплою)
- **Критичность:** низкая (вспомогательный инструмент для маркетинга)
- **Назначение:** сокращение ссылок с аналитикой переходов: канал, подтип, контекст размещения
- **Платформа:** Linux (self-hosted, FastAPI + PostgreSQL)

## ТЕХНИЧЕСКИЙ СТЕК

- **Framework:** FastAPI (Python)
- **Database:** PostgreSQL (asyncpg)
- **Deployment:** Docker / uvicorn

## ENDPOINTS

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/api/links` | Создать короткую ссылку |
| GET | `/s/{code}` | Редирект (302) + запись клика |
| GET | `/api/links/{code}/stats` | Статистика по ссылке |
| GET | `/api/links` | Список всех ссылок с фильтрами |
| GET | `/api/stats/summary` | Сводная статистика |
| GET | `/health` | Healthcheck |

## АТРИБУТЫ ССЫЛКИ

При создании ссылки указывается:
- **channel_type** - тип канала (мессенджер/сайт/соцсеть/email/оффлайн)
- **channel_name** - название канала (Telegram, WhatsApp, VK, fingroup.ru)
- **subtype** - подтип (чат/канал/ЛС/страница/пост)
- **context** - контекст размещения
- **contact** - контакт (если адресное размещение)

## АНАЛИТИКА ПЕРЕХОДОВ

Каждый переход записывает:
- Timestamp
- IP-адрес
- User-Agent
- Referer
- UTM-параметры (если есть)

## СКРИПТ

**Путь:** `~/Documents/ai_agents/scripts/url-shortener.py`

**Зависимости:** Python 3, fastapi, asyncpg, pydantic, uvicorn

```bash
# Запуск сервиса
DATABASE_URL=postgresql://user:pass@host/db uvicorn url-shortener:app --host 0.0.0.0 --port 8070
```

## ДЕПЛОЙ

Ожидается деплой на VPS (Beget или ISHosting). Требуется:
1. PostgreSQL база данных
2. Docker-контейнер или systemd-сервис
3. Traefik reverse proxy для HTTPS
4. Короткий домен (настроить DNS)

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P2: Отслеживание маркетинговых каналов
- Уникальные короткие ссылки для каждого канала размещения
- Анализ конверсии по каналам: какой мессенджер приводит больше клиентов

### P3: Реферальная программа
- Персональные ссылки для партнёров
- Отслеживание переходов по каждому рефералу

## СВЯЗИ

### Интеграции
- **Marketing Agent (Ольга)** - маркетинговая аналитика каналов
- **Growth Analyst (Артём)** - воронка конверсии
- **n8n** - автоматическая генерация ссылок для рассылок
- **DevOps (Михаил)** - деплой на VPS

### Зависимости
- Требует: PostgreSQL, Python 3, VPS для хостинга
- Рекомендуется: короткий домен (fingroup.link или аналог)

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. Скрипт написан, ожидается деплой.
