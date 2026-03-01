---
id: 20260224-yandex-locator
title: "Яндекс.Локатор API"
summary: >
  API геолокации по Wi-Fi и сотовым вышкам. Определение местоположения устройства
  без GPS. API key получен.
type: spec
status: active
tags: [eng/api, eng/geo, eng/integration, platform/yandex]
source: kb-manager
ai_weight: low
created: 2026-02-24
updated: 2026-02-24
category: "API -> Geolocation"
criticality: low
platform: cross-platform
cost: "free"
---
# ЯНДЕКС.ЛОКАТОР API

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - Geolocation
- **Статус:** активно (API key получен)
- **Критичность:** низкая (вспомогательный инструмент)
- **Назначение:** определение местоположения устройства по Wi-Fi и сотовым вышкам (без GPS)
- **Платформа:** cross-platform (REST API)
- **Документация:** https://yandex.ru/dev/locator/

## ПОДКЛЮЧЕНИЕ

- **Auth:** API key (query parameter)
- **Credentials:** `.secrets/api-keys/yandex-locator.json`
- **API key:** получен и сохранён

## API

Яндекс.Локатор определяет координаты устройства на основе:
- Видимых Wi-Fi точек доступа (BSSID, уровень сигнала)
- Данных сотовых вышек (Cell ID, LAC, MCC, MNC)

Точность: от 30 до 500 метров (зависит от плотности Wi-Fi/вышек).

## СКРИПТЫ

Специализированный скрипт не создан. API вызывается напрямую через HTTP.

## СТОИМОСТЬ

Бесплатно. Лимиты по стандартному ключу.

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P3: Геолокация для логистики
- Определение примерного местоположения выездного сотрудника
- Backup-геолокация при недоступности GPS

## СВЯЗИ

### Альтернативы
- **Google Geolocation API** - аналогичный сервис от Google
- **2GIS Radar API** - геолокация по Wi-Fi/сотовым вышкам

### Зависимости
- Требует: API key (developer.tech.yandex.ru)
- Ключ хранится: `.secrets/api-keys/yandex-locator.json`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. API key получен.
