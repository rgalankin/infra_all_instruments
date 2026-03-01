---
id: 20260224-yandex-wordstat
title: "Yandex Wordstat API"
summary: >
  Статистика поисковых запросов Яндекса через API Яндекс.Директ v4 (JSON).
  Частотность ключевых слов, связанные запросы, региональная фильтрация.
  OAuth2-авторизация. Скрипт wordstat-api.py работает.
type: spec
status: active
tags: [eng/api, marketing/seo, eng/integration, platform/yandex]
source: kb-manager
ai_weight: normal
created: 2026-02-24
updated: 2026-02-24
category: "API -> SEO & Marketing"
criticality: medium
platform: cross-platform
cost: "free"
---
# YANDEX WORDSTAT API

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - SEO & Marketing
- **Статус:** активно (работает)
- **Критичность:** средняя (маркетинг, SEO, контент-планирование)
- **Назначение:** статистика частотности поисковых запросов в Яндексе
- **Платформа:** cross-platform (REST API)
- **Сайт:** https://wordstat.yandex.ru
- **API URL:** https://api.direct.yandex.ru/v4/json/
- **Документация:** https://yandex.ru/dev/direct/

## ПОДКЛЮЧЕНИЕ

- **Auth:** OAuth 2.0 (Яндекс.OAuth)
- **Credentials:** `.secrets/api-keys/yandex-wordstat.json`
- **Поля:** client_id, client_secret, oauth_token
- **Получение токена:**
  1. Открыть: `https://oauth.yandex.ru/authorize?response_type=token&client_id=<CLIENT_ID>`
  2. Авторизоваться в Яндекс
  3. Скопировать access_token из URL
  4. Сохранить: `python3 wordstat-api.py --save-token "ТОКЕН"`

## API МЕТОДЫ (Яндекс.Директ v4 JSON)

| Метод | Описание |
|-------|----------|
| `CreateNewWordstatReport` | Создать отчёт по частотности |
| `GetWordstatReportList` | Список отчётов (проверка готовности) |
| `GetWordstatReport` | Получить данные отчёта |
| `DeleteWordstatReport` | Удалить отчёт (освободить слот) |

**Особенности:**
- Асинхронная модель: создать отчёт -> ждать готовности -> получить данные -> удалить
- Лимит одновременных отчётов (ошибка 53 при превышении)
- Результаты: SearchedWith (фразы с ключевым словом) + SearchedAlso (связанные запросы)

## РЕГИОНЫ (GeoID)

| Регион | GeoID |
|--------|-------|
| Россия | 225 |
| Москва | 213 |
| Санкт-Петербург | 2 |
| Московская область | 1 |
| Екатеринбург | 54 |
| Новосибирск | 65 |
| Казань | 43 |
| Самара | 51 |
| Ростов | 39 |
| Краснодар | 35 |

## СКРИПТ

**Путь:** `~/Documents/ai_agents/scripts/wordstat-api.py`

**Зависимости:** Python 3, requests

```bash
# Частотность ключевого слова
python3 scripts/wordstat-api.py --query "банкротство физических лиц" --format table

# С региональным фильтром
python3 scripts/wordstat-api.py --query "кредитный брокер" --region moscow --format json

# Связанные запросы
python3 scripts/wordstat-api.py --query "банкротство" --action related --limit 30

# Тренды (текущая частотность)
python3 scripts/wordstat-api.py --query "списание долгов" --action trends

# Несколько регионов
python3 scripts/wordstat-api.py --query "банкротство" --region moscow,spb,ekb

# Проверка токена
python3 scripts/wordstat-api.py --check-token
```

## СТОИМОСТЬ

Бесплатно при наличии аккаунта Яндекс.Директ.

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P1: SEO-анализ для контент-стратегии
- Определение частотности целевых ключевых слов (банкротство, списание долгов)
- Анализ региональных различий в спросе

### P1: Конкурентный анализ
- Связанные запросы для расширения семантического ядра
- Мониторинг трендов по ключевым словам рынка

### P2: Планирование рекламных кампаний
- Оценка спроса перед запуском контекстной рекламы
- Подбор ключевых слов для Яндекс.Директ

## СВЯЗИ

### Интеграции
- **Marketing Agent (Ольга)** - SEO-анализ, планирование контента
- **VP ContentOps (Анна)** - исследование ключевых слов для статей
- **Growth Analyst (Артём)** - мониторинг трендов рынка
- **n8n** - автоматический сбор частотности в workflows

### Зависимости
- Требует: OAuth-приложение Яндекс + аккаунт с доступом к Директ
- Ключ хранится: `.secrets/api-keys/yandex-wordstat.json`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]
- [[ai_agents/docs/skills/yandex-wordstat-api__20260223|Wordstat Skill Doc]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. Скрипт работает, OAuth-токен получен.
