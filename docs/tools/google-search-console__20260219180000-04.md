---
id: 20260219180000-04
title: "Google Search Console API"
summary: >
  SEO-аналитика bankrotserv.ru и credoserv.ru через Search Console API.
  Без лимитов. Auth: OAuth2 (отдельный token_searchconsole.json).
type: spec
status: active
tags: [platform/google, eng/api, eng/seo, eng/integration, domain/marketing]
source: claude-opus-4-6
ai_weight: normal
created: 2026-02-19
updated: 2026-02-19
category: "API -> Google Cloud"
criticality: medium
platform: cross-platform
cost: "free"
---
# Google Search Console API

## Основная информация

- **Категория:** API - Google Cloud
- **Статус:** активно
- **Критичность:** средняя
- **Назначение:** SEO-аналитика bankrotserv.ru и credoserv.ru
- **Платформа:** cross-platform (REST API / Python SDK)
- **Бесплатный лимит:** без лимитов

## Подключение

- **Auth:** OAuth2 (отдельный токен)
- **Token:** `token_searchconsole.json`
- **Credentials:** `/Users/mac/Documents/documentoved/credentials.json`
- **Скрипт:** `scripts/google-search-console.py`

## Возможности

| Функция | Описание |
|---------|----------|
| Search Analytics | Запросы, клики, показы, CTR, позиции |
| URL Inspection | Проверка индексации конкретных URL |
| Sitemaps | Управление картами сайта |
| Index Coverage | Статус индексации страниц |

## Сайты

| Сайт | Назначение |
|------|-----------|
| bankrotserv.ru | Основной сайт банкротства |
| credoserv.ru | Кредитный сервис |

## Сценарии использования

| Сценарий | Описание |
|----------|----------|
| SEO-мониторинг | Трекинг позиций по ключевым запросам |
| Анализ трафика | Клики, показы, CTR по страницам |
| Обнаружение проблем | Ошибки индексации, проблемы с Mobile Usability |
| Конкурентный анализ | Позиции по запросам категории "банкротство" |
| Контент-стратегия | Запросы с высоким CTR, низкими позициями (quick wins) |

## Стоимость

| Функция | Лимит | Стоимость |
|---------|-------|-----------|
| Search Analytics | без лимитов | бесплатно |
| URL Inspection | 2 000 req/день | бесплатно |
| Sitemaps | без лимитов | бесплатно |

## Риски

- **risk_tier:** low
- **data_allowed:** SEO-данные (public по сути)
- **data_forbidden:** нет ограничений (данные о поиске публичны)
- **known_failure_modes:**
  1. OAuth token expired (требует refresh)
  2. Данные доступны с задержкой 2-3 дня
  3. API возвращает максимум 25 000 строк за запрос

## Связи

### Интеграции
- **scripts/google-search-console.py** - основной скрипт
- **Marketing Agent (Ольга)** - SEO-отчёты
- **Growth Analyst (Артём)** - аналитика роста органического трафика
- **VP ContentOps (Анна)** - контент-стратегия на основе поисковых запросов

### Зависимости
- Требует: Google Cloud аккаунт, OAuth2 credentials, верификация сайтов в Search Console
- Отдельный токен: token_searchconsole.json

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/google-workspace__20260212120000-07|Google Workspace]]
- [[ai_agents/docs/neurocompany/tools-registry__20260218133000-01|TOOLS_REGISTRY]]

## История

- 2026-02-19: Создана карточка (задача B24 #392)
