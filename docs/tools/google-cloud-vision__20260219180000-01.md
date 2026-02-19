---
id: 20260219180000-01
title: "Google Cloud Vision API"
summary: >
  OCR документов и распознавание изображений через Cloud Vision API.
  Бесплатно: 1000 запросов/мес. SDK: google-cloud-vision. Auth: API key.
type: spec
status: active
tags: [platform/google, eng/api, ai/ocr, eng/integration]
source: claude-opus-4-6
ai_weight: normal
created: 2026-02-19
updated: 2026-02-19
category: "API -> Google Cloud"
criticality: medium
platform: cross-platform
cost: "freemium"
---
# Google Cloud Vision API

## Основная информация

- **Категория:** API - Google Cloud
- **Статус:** активно
- **Критичность:** средняя
- **Назначение:** OCR документов, распознавание изображений, детекция текста на фото
- **Платформа:** cross-platform (REST API / Python SDK)
- **Бесплатный лимит:** 1 000 запросов/месяц

## Подключение

- **Auth:** API key
- **Credentials:** `.secrets/google_api_key.json`
- **SDK:** `google-cloud-vision` (pip install google-cloud-vision)
- **Скрипт:** `scripts/google-vision-ocr.py`

## Возможности

| Функция | Описание |
|---------|----------|
| TEXT_DETECTION | OCR: извлечение текста из изображений |
| DOCUMENT_TEXT_DETECTION | OCR документов с сохранением структуры |
| LABEL_DETECTION | Распознавание объектов на изображении |
| FACE_DETECTION | Обнаружение лиц |
| LOGO_DETECTION | Распознавание логотипов |
| SAFE_SEARCH_DETECTION | Проверка контента на безопасность |

## Сценарии использования

| Сценарий | Описание |
|----------|----------|
| OCR судебных документов | Извлечение текста из сканов для KB |
| Распознавание паспортов/ИНН | Обработка документов клиентов |
| Проверка скриншотов | Автоматическое описание скриншотов |

## Стоимость

| Функция | Бесплатно | Далее |
|---------|-----------|-------|
| Все типы детекции | 1 000 запросов/мес | $1.50 за 1000 запросов |

## Риски

- **risk_tier:** low
- **data_allowed:** public, internal (документы без ПДн)
- **data_forbidden:** ПДн клиентов без согласия
- **known_failure_modes:**
  1. Превышение бесплатного лимита (1000 req/month)
  2. Низкое качество OCR при плохих сканах
  3. API key revoked или expired

## Связи

### Интеграции
- **scripts/google-vision-ocr.py** - основной скрипт для OCR
- **KB MCP Server** - результаты OCR могут индексироваться в KB

### Зависимости
- Требует: Google Cloud аккаунт, API key
- SDK: `pip install google-cloud-vision`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/google-workspace__20260212120000-07|Google Workspace]]
- [[infra_all_instruments/docs/tools/google-drive__20260210220600-08|Google Drive]]
- [[ai_agents/docs/neurocompany/tools-registry__20260218133000-01|TOOLS_REGISTRY]]

## История

- 2026-02-19: Создана карточка (задача B24 #392)
