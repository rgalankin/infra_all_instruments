---
id: 20260219180000-03
title: "Google Maps Platform"
summary: >
  Геокодирование, поиск организаций, маршруты через Google Maps API.
  Подсервисы: Geocoding, Places, Directions, Distance Matrix.
  Бесплатно: 10 000 запросов/мес.
type: spec
status: active
tags: [platform/google, eng/api, eng/geo, eng/integration]
source: claude-opus-4-6
ai_weight: normal
created: 2026-02-19
updated: 2026-02-19
category: "API -> Google Cloud"
criticality: medium
platform: cross-platform
cost: "freemium"
---
# Google Maps Platform

## Основная информация

- **Категория:** API - Google Cloud
- **Статус:** активно
- **Критичность:** средняя
- **Назначение:** геокодирование, поиск организаций, маршруты
- **Платформа:** cross-platform (REST API / Python SDK)
- **Бесплатный лимит:** 10 000 запросов/месяц

## Подключение

- **Auth:** API key
- **Credentials:** `.secrets/google_api_key.json`
- **SDK:** `googlemaps` (pip install googlemaps)
- **Скрипт:** `scripts/google-maps.py`

## Подсервисы

| Подсервис | Описание | Бесплатно |
|-----------|----------|-----------|
| Geocoding | Адрес -> координаты и обратно | 10 000 req/мес |
| Places | Поиск организаций, детали, отзывы | 10 000 req/мес |
| Directions | Построение маршрутов | 10 000 req/мес |
| Distance Matrix | Расстояние и время между точками | 10 000 req/мес |

## Сценарии использования

| Сценарий | Описание |
|----------|----------|
| Поиск МФЦ/судов по адресу | Геокодирование адресов клиентов |
| Поиск арбитражных управляющих | Places API для поиска по категориям |
| Расчёт расстояния до офиса | Distance Matrix для логистики |
| Маршруты для курьеров | Directions API |

## Стоимость

| Подсервис | Бесплатно | Далее |
|-----------|-----------|-------|
| Geocoding | 10 000 req/мес | $5 за 1000 req |
| Places | 10 000 req/мес | $17-32 за 1000 req |
| Directions | 10 000 req/мес | $5-10 за 1000 req |
| Distance Matrix | 10 000 req/мес | $5-10 за 1000 elements |

## Риски

- **risk_tier:** low
- **data_allowed:** public, business (адреса, координаты)
- **data_forbidden:** хранение персональных адресов клиентов без согласия
- **known_failure_modes:**
  1. Превышение бесплатного лимита
  2. Некорректное геокодирование российских адресов
  3. Ограничения Places API для России
  4. API key revoked или billing disabled

## Связи

### Интеграции
- **scripts/google-maps.py** - основной скрипт
- **Sales Agent** - поиск организаций по локации
- **Marketing Agent** - геоаналитика

### Зависимости
- Требует: Google Cloud аккаунт, API key, активированный billing
- SDK: `pip install googlemaps`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/google-workspace__20260212120000-07|Google Workspace]]
- [[ai_agents/docs/neurocompany/tools-registry__20260218133000-01|TOOLS_REGISTRY]]

## История

- 2026-02-19: Создана карточка (задача B24 #392)
