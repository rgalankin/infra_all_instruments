---
id: 20260219180000-02
title: "Google Cloud Translation API"
summary: >
  Перевод текстов через Cloud Translation API. Экономия токенов Claude
  при работе с иноязычным контентом. Бесплатно: 500 000 символов/мес.
type: spec
status: active
tags: [platform/google, eng/api, ai/nlp, eng/integration]
source: claude-opus-4-6
ai_weight: normal
created: 2026-02-19
updated: 2026-02-19
category: "API -> Google Cloud"
criticality: low
platform: cross-platform
cost: "freemium"
---
# Google Cloud Translation API

## Основная информация

- **Категория:** API - Google Cloud
- **Статус:** активно
- **Критичность:** низкая
- **Назначение:** перевод текстов (экономия токенов Claude при работе с иноязычным контентом)
- **Платформа:** cross-platform (REST API / Python SDK)
- **Бесплатный лимит:** 500 000 символов/месяц

## Подключение

- **Auth:** API key
- **Credentials:** `.secrets/google_api_key.json`
- **SDK:** `google-cloud-translate` (pip install google-cloud-translate)
- **Скрипт:** `scripts/google-translate.py`

## Возможности

| Функция | Описание |
|---------|----------|
| Перевод текста | 100+ языков, автоопределение исходного языка |
| Batch-перевод | Массовый перевод документов |
| Определение языка | Автоматическая детекция языка текста |

## Сценарии использования

| Сценарий | Описание |
|----------|----------|
| Перевод документации | Перевод технической документации вместо Claude |
| Подготовка контента | Перевод маркетинговых текстов |
| Pre-processing для Claude | Перевод входящего текста перед отправкой в LLM |

## Стоимость

| Функция | Бесплатно | Далее |
|---------|-----------|-------|
| Translation (Basic) | 500 000 символов/мес | $20 за 1M символов |
| Language Detection | 500 000 символов/мес | $20 за 1M символов |

## Риски

- **risk_tier:** low
- **data_allowed:** public, internal
- **data_forbidden:** конфиденциальные документы клиентов
- **known_failure_modes:**
  1. Превышение бесплатного лимита (500K символов/month)
  2. Неточный перевод юридических терминов
  3. API key revoked или expired

## Связи

### Интеграции
- **scripts/google-translate.py** - основной скрипт перевода
- **Claude Code** - pre/post-processing текстов

### Зависимости
- Требует: Google Cloud аккаунт, API key
- SDK: `pip install google-cloud-translate`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/google-workspace__20260212120000-07|Google Workspace]]
- [[ai_agents/docs/neurocompany/tools-registry__20260218133000-01|TOOLS_REGISTRY]]

## История

- 2026-02-19: Создана карточка (задача B24 #392)
