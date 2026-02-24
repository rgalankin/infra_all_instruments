---
id: 20260224-tochka-bank
title: "Точка Банк API"
summary: >
  API банка Точка для генерации платёжных ссылок (интернет-эквайринг) и QR-кодов
  СБП. OAuth 2.0 авторизация. Скрипт tochka-payment.py написан.
  Ожидается регистрация OAuth-приложения от CEO.
type: spec
status: pending
tags: [eng/api, biz/payments, eng/integration, platform/tochka]
source: kb-manager
ai_weight: normal
created: 2026-02-24
updated: 2026-02-24
category: "API -> Payments & Banking"
criticality: high
platform: cross-platform
cost: "transaction-based"
---
# ТОЧКА БАНК API

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** API - Payments & Banking
- **Статус:** pending (ожидается OAuth app от CEO)
- **Критичность:** высокая (приём платежей от клиентов)
- **Назначение:** генерация платёжных ссылок (интернет-эквайринг) и QR-кодов СБП
- **Платформа:** cross-platform (REST API)
- **Сайт:** https://developers.tochka.com
- **API Base URL:** `https://enter.tochka.com/uapi`
- **Token URL:** `https://enter.tochka.com/connect/token`
- **Документация:** https://developers.tochka.com/docs/tochka-api/
- **B24-приложение:** [Точка Банк](https://www.bitrix24.ru/apps/app/itsolutionru.tochkabase/)

## ПОДКЛЮЧЕНИЕ

- **Auth:** OAuth 2.0 (client_credentials -> consents -> access_token)
- **Credentials:** `.secrets/api-keys/tochka-bank.json` (пока пуст)
- **Env variables:**
  - `TOCHKA_CLIENT_ID` - client_id OAuth-приложения
  - `TOCHKA_CLIENT_SECRET` - client_secret
  - `TOCHKA_ACCESS_TOKEN` - access token (если уже получен)
  - `TOCHKA_CUSTOMER_CODE` - код клиента
  - `TOCHKA_MERCHANT_ID` - ID торговой точки в СБП
  - `TOCHKA_ACCOUNT_ID` - номер счёта/БИК

**Для регистрации OAuth-приложения:**
1. Войти в интернет-банк Точка
2. Интеграции и API -> Подключить -> Зарегистрировать OAuth 2.0 приложение
3. Указать scopes: accounts, balances, customers, statements, sbp, payments, acquiring

## ENDPOINTS

### Платёжные ссылки (Acquiring)

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/acquiring/v1.0/payments` | Создать платёжную ссылку |
| GET | `/acquiring/v1.0/payments/{operationId}` | Статус платежа |
| GET | `/acquiring/v1.0/payments` | Список операций |
| POST | `/acquiring/v1.0/payments/{id}/capture` | Списание (двухэтапная) |
| POST | `/acquiring/v1.0/payments/{id}/refund` | Возврат |
| POST | `/acquiring/v1.0/payments-with-receipt` | С фискализацией |
| GET | `/acquiring/v1.0/registry` | Реестр платежей |
| GET | `/acquiring/v1.0/retailers` | Инфо о ритейлере |

### QR-коды СБП

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/sbp/v1.0/qr-code/merchant/{mid}/{aid}` | Создать QR-код |
| GET | `/sbp/v1.0/qr-codes/{qrcId}/payment-status` | Статус QR-платежа |

## СКРИПТ

**Путь:** `~/Documents/ai_agents/scripts/tochka-payment.py`

**Зависимости:** Python 3, requests

```bash
# Авторизация (инструкция по OAuth)
python3 scripts/tochka-payment.py --action auth

# Создать платёжную ссылку
python3 scripts/tochka-payment.py --action create-link --amount 5000 --description "Оплата консультации"

# Создать QR-код СБП
python3 scripts/tochka-payment.py --action create-qr --amount 5000 --description "Оплата по QR"

# Проверить статус платежа
python3 scripts/tochka-payment.py --action check-status --payment-id abc123

# Информация о ритейлере
python3 scripts/tochka-payment.py --action retailers
```

**Возможности скрипта:**
- 7 действий (auth, create-link, create-qr, check-status, check-qr-status, retailers, list-payments)
- Кеширование токена (автообновление)
- Поддержка способов оплаты: card, sbp, tinkoff, dolyame
- Настройка TTL ссылки/QR

## СТОИМОСТЬ

Комиссия за транзакцию (зависит от тарифа расчётного счёта в Точке). Типичная комиссия:
- Карточные платежи: 1.5-2.5%
- СБП: 0.4-0.7%

## СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### P0: Приём оплаты от клиентов
- Генерация платёжной ссылки из карточки сделки B24
- Отправка ссылки клиенту в WhatsApp/Telegram/email
- Автоматическое обновление статуса сделки при оплате

### P1: QR-коды для офиса
- Статический QR-код на ресепшен
- Динамические QR для конкретных сумм

## СВЯЗИ

### Альтернативы
- **ЮKassa** - универсальная платёжная система (ожидается регистрация)

### Интеграции
- **Bitrix24 CRM** - привязка платежей к сделкам
- **n8n** - автоматические webhook-уведомления о платежах
- **Sales Agent (Максим)** - генерация ссылок из воронки продаж

### Зависимости
- Требует: расчётный счёт в банке Точка, OAuth-приложение
- Ключ хранится: `.secrets/api-keys/tochka-bank.json`

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/tools/_index__20260210220000-04|Реестр инструментов]]
- [[ai_agents/docs/tochka-bank-integration__20260223|Tochka Integration Doc]]

## ИСТОРИЯ

- 2026-02-24: Создана карточка. Скрипт написан, ожидается OAuth-приложение.
