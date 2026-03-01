---
id: 20260224-yandex-cloud
title: "Яндекс.Cloud"
summary: >
  Облачная платформа Яндекса. AI-сервисы: SpeechKit (STT/TTS), Vision (OCR),
  Translate, YandexGPT. Есть static key (только S3), ожидается authorized key
  для AI-сервисов.
type: spec
status: in_progress
tags: [eng/api, ai/cloud, eng/integration, platform/yandex-cloud]
source: kb-manager
ai_weight: normal
created: 2026-02-24
updated: 2026-02-24
category: "API -> Cloud & AI Services"
criticality: medium
platform: cross-platform
cost: "pay-as-you-go"
---
# ЯНДЕКС.CLOUD

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - Cloud & AI Services
- **Статус:** in_progress (есть static key для S3, ожидается authorized key для AI-сервисов)
- **Критичность:** средняя (AI-сервисы для обработки документов)
- **Назначение:** облачные AI-сервисы: распознавание речи, OCR, перевод, генерация
- **Платформа:** cross-platform (REST API, gRPC)
- **Сайт:** https://console.yandex.cloud
- **Документация:** https://cloud.yandex.ru/docs

## ПОДКЛЮЧЕНИЕ

- **Auth:** Service account key (JSON), IAM-токен
- **Credentials:** `.secrets/api-keys/yandex-cloud.json`
- **Текущий ключ:** static key (key_id: aje0i8fmh82aogcdquvn) - только для S3
- **Требуется:** authorized key для IAM-токена (AI-сервисы)

**Получение IAM-токена из authorized key:**
```bash
# Установить yc CLI
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

# Создать authorized key (в консоли Yandex.Cloud)
yc iam key create --service-account-name <SA_NAME> --output key.json

# Получить IAM-токен
yc iam create-token
```

## AI-СЕРВИСЫ

| Сервис | Описание | Применимость |
|--------|----------|-------------|
| **SpeechKit STT** | Распознавание речи | Высокая (обработка звонков) |
| **SpeechKit TTS** | Синтез речи | Средняя (голосовые уведомления) |
| **Vision OCR** | Распознавание текста на изображениях | Высокая (документы) |
| **Translate** | Машинный перевод | Низкая |
| **YandexGPT** | Генерация текста | Средняя (ассистент) |
| **Object Storage (S3)** | Объектное хранилище | Высокая (бэкапы) |

## СКРИПТЫ

Специализированные скрипты пока не созданы. Ожидается authorized key.

## СТОИМОСТЬ

Pay-as-you-go. Примерные тарифы:
- SpeechKit STT: от 1.2 руб/15 сек
- SpeechKit TTS: от 2 руб/1000 символов
- Vision OCR: от 1.6 руб/страница
- Object Storage: от 1.92 руб/ГБ/мес
- Грант для новых пользователей: 4000 руб на 60 дней

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P1: OCR документов клиентов
- Распознавание паспортов, справок, договоров через Vision
- Автоматическое извлечение данных в CRM

### P1: Транскрибация звонков
- SpeechKit STT для записей телефонных консультаций
- Анализ качества обслуживания

### P2: Голосовые уведомления
- SpeechKit TTS для автоматических звонков-напоминаний

### P3: Объектное хранилище
- Бэкап документов и данных в Yandex S3

## СВЯЗИ

### Альтернативы
- **Google Cloud Vision** - OCR (уже подключён)
- **Google Cloud Translation** - перевод (уже подключён)
- **Soniox** - STT (уже подключён)

### Интеграции
- **n8n** - HTTP Request для вызова API
- **Sysadmin (Дмитрий)** - инфраструктура, бэкапы
- **ElevenLabs Specialist (Наталья)** - синтез речи

### Зависимости
- Требует: аккаунт Yandex.Cloud, сервисный аккаунт с authorized key
- Ключ хранится: `.secrets/api-keys/yandex-cloud.json`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. Есть static key для S3, ожидается authorized key для AI.
