---
id: 20260224-himera-search
title: "Himera Search"
summary: >
  OSINT-сервис поиска данных по физлицам и юрлицам. API v2 для поиска по ФИО,
  телефону, ИНН, email, авто, паспорту. Скрипт himera-search.py написан,
  API возвращает ошибку версии - ожидается проверка кабинета.
type: spec
status: in_progress
tags: [eng/api, biz/compliance, eng/integration, platform/himera]
source: kb-manager
ai_weight: normal
created: 2026-02-24
updated: 2026-02-24
category: "API -> OSINT & Data Search"
criticality: medium
platform: cross-platform
cost: "paid"
---
# HIMERA SEARCH

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - OSINT & Data Search
- **Статус:** in_progress (скрипт написан, API возвращает "Version api error")
- **Критичность:** средняя (вспомогательный инструмент для проверки клиентов)
- **Назначение:** поиск данных по физлицам/юрлицам (ФИО, телефон, ИНН, email, авто, паспорт)
- **Платформа:** cross-platform (REST API)
- **Сайт:** https://himera-search-bot.org
- **Документация:** https://himera-search-bot.org/cabinet/docs_api2 (требует авторизации)

## ПОДКЛЮЧЕНИЕ

- **Auth:** API key (передаётся в теле JSON-запроса)
- **Credentials:** `.secrets/api-keys/himera.json`
- **Env variable:** `HIMERA_API_KEY`
- **Base URL:** `https://himera-search-bot.org`
- **Endpoints:**
  - Search: `POST /api/search`
  - Balance: `POST /api/balance`

## ТИПЫ ЗАПРОСОВ

| Тип | Формат | Пример |
|-----|--------|--------|
| phone | +79991234567 | Поиск по телефону |
| fio | Иванов Иван Иванович | Поиск по ФИО |
| inn_fl | 123456789012 (12 цифр) | ИНН физлица |
| inn_ul | 1234567890 (10 цифр) | ИНН юрлица |
| email | user@example.com | Поиск по email |
| auto | А123БВ77 | Поиск по госномеру |
| passport_rf | 1234 567890 | Поиск по паспорту |
| snils | 123-456-789 01 | Поиск по СНИЛС |
| general | произвольный текст | Общий поиск |

## СКРИПТ

**Путь:** `~/Documents/ai_agents/scripts/himera-search.py`

**Зависимости:** Python 3, requests

```bash
# Универсальный поиск (тип определяется автоматически)
python3 scripts/himera-search.py --action search --query "Иванов Иван Иванович"

# Поиск по телефону с JSON-выводом
python3 scripts/himera-search.py --action search --query "+79991234567" --format json

# Проверка баланса
python3 scripts/himera-search.py --action balance
```

**Возможности скрипта:**
- Автоопределение типа запроса по формату строки
- Нормализация телефонов (+7)
- Дедупликация результатов
- Форматы вывода: text, json, table
- Debug-режим для отладки запросов

## ТЕКУЩАЯ ПРОБЛЕМА

API endpoint возвращает "Version api error" (HTTP 404). Возможные причины:
1. API key не активирован для API v2
2. Требуется другой формат endpoint
3. Необходимо проверить актуальную документацию в кабинете

**Действия:** CEO/Администратор должен войти в кабинет Himera и проверить:
- Активирован ли тариф API v2
- Актуальный формат запросов

## СТОИМОСТЬ

Платный сервис с балансовой системой. Каждый поисковый запрос списывает средства.

## СВЯЗИ

### Альтернативы
- **SpectrumData** - более легитимный B2B API для бизнес-проверок
- **api-parser.ru** - агрегатор госданных

### Интеграции
- **n8n** - HTTP Request для автоматических проверок
- **Bitrix24 CRM** - обогащение данных контакта

## РИСКИ

- **risk_tier:** high
- **data_allowed:** проверка по согласию субъекта данных
- **data_forbidden:** массовый сбор ПДн, использование без правового основания
- **compliance:** необходима оценка Елены Степановой (Data Compliance)

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]
- [[ai_agents/docs/himera-search-integration__20260223|Himera Integration Doc]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. Скрипт написан, API не отвечает корректно.
