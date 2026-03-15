---
id: "20260315063003-03"
title: "Интеграция: Telegram Channel @biznaneyronah"
summary: >
  Публикация контента в Telegram-канал @biznaneyronah через бота @rgalankin_bot.
  Тексты, фото, голос, опросы от имени канала.
type: spec
status: active
tags: [eng/integration, social/telegram]
source: claude-opus-4-6
ai_weight: high
created: 2026-03-15
updated: 2026-03-15
from: "OpenClaw"
to: "Telegram Channel @biznaneyronah"
protocol: "Telegram Bot API"
criticality: medium
---
# Интеграция: Telegram Channel @biznaneyronah

## Описание

Публикация контента в Telegram-канал «Бизнес на нейронах» (@biznaneyronah) через бота @rgalankin_bot, добавленного как админ канала. Посты публикуются от имени канала (подпись отключена).

## Архитектура

```
OpenClaw (message tool) → Telegram Bot API (@rgalankin_bot) → @biznaneyronah
```

## Конфигурация

- **Протокол:** Telegram Bot API (HTTPS)
- **Канал:** @biznaneyronah
- **Chat ID:** -1002256827249
- **Бот:** @rgalankin_bot (админ канала)
- **Подпись сообщений:** OFF (посты от имени канала)
- **Публикация:** OpenClaw message tool (`action=send`, `target=@biznaneyronah`)

### Доступные типы контента

- Текстовые сообщения
- Фото
- Голосовые сообщения
- Опросы
- Реакции

### Тематика канала

Бизнес на нейронах, AI в бизнесе

## Компоненты

| Компонент | Роль | Карточка |
|----------|------|---------|
| @rgalankin_bot | Бот-публикатор | — |
| OpenClaw | Источник контента | — |
| Telegram | Платформа | — |

## Статус

- **Работает:** да
- **Последняя проверка:** 2026-03-15
- **Известные проблемы:** нет

## Мониторинг

- **Как проверить:** отправить тестовое сообщение через OpenClaw message tool
- **Алерты:** нет

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/integrations/_index__20260210220000-07|Карта интеграций]]

## История

- 2026-03-15: Создана карточка
