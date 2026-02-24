---
id: 20260224-yandex-rasp
title: "Яндекс.Расписание API"
summary: >
  API расписаний транспорта (поезда, электрички, автобусы, самолёты).
  API key получен. Данные о маршрутах, расписаниях, ценах.
type: spec
status: active
tags: [eng/api, eng/integration, platform/yandex]
source: kb-manager
ai_weight: low
created: 2026-02-24
updated: 2026-02-24
category: "API -> Transport & Travel"
criticality: low
platform: cross-platform
cost: "free"
---
# ЯНДЕКС.РАСПИСАНИЕ API

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - Transport & Travel
- **Статус:** активно (API key получен)
- **Критичность:** низкая (вспомогательный инструмент)
- **Назначение:** расписания транспорта: поезда, электрички, автобусы, самолёты
- **Платформа:** cross-platform (REST API)
- **Сайт:** https://rasp.yandex.ru
- **API Base URL:** https://api.rasp.yandex.net
- **Документация:** https://yandex.ru/dev/rasp/doc/

## ПОДКЛЮЧЕНИЕ

- **Auth:** API key (query parameter `apikey`)
- **Credentials:** `.secrets/api-keys/yandex-schedule.json`
- **API key:** получен и сохранён

## ENDPOINTS

| Endpoint | Описание |
|----------|----------|
| `/v3.0/search/` | Расписание рейсов между станциями |
| `/v3.0/schedule/` | Расписание рейсов по станции |
| `/v3.0/thread/` | Список станций рейса |
| `/v3.0/nearest_stations/` | Ближайшие станции |
| `/v3.0/nearest_settlement/` | Ближайший город |
| `/v3.0/carrier/` | Информация о перевозчике |
| `/v3.0/stations_list/` | Список всех станций |
| `/v3.0/copyright/` | Копирайт Яндекс.Расписаний |

## ПРИМЕРЫ ЗАПРОСОВ

```bash
API_KEY="c2019739-caca-49d9-a72f-c804306b10fc"

# Расписание Москва -> Санкт-Петербург
curl "https://api.rasp.yandex.net/v3.0/search/?apikey=$API_KEY&from=c213&to=c2&date=2026-02-24"

# Расписание по станции
curl "https://api.rasp.yandex.net/v3.0/schedule/?apikey=$API_KEY&station=s2000006"

# Ближайшие станции
curl "https://api.rasp.yandex.net/v3.0/nearest_stations/?apikey=$API_KEY&lat=55.75&lng=37.62&distance=5"
```

## СКРИПТЫ

Специализированный скрипт не создан. API вызывается напрямую через HTTP.

## СТОИМОСТЬ

Бесплатно для некоммерческого использования. Лимиты:
- 500 запросов в сутки (стандартный ключ)

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P3: Логистика выездных консультаций
- Поиск оптимального маршрута для выездного юриста
- Расписание транспорта до города клиента

### P3: Информация для клиентов
- Подсказка клиенту, как добраться до офиса

## СВЯЗИ

### Зависимости
- Требует: API key (получается на https://developer.tech.yandex.ru/)
- Ключ хранится: `.secrets/api-keys/yandex-schedule.json`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. API key получен.
