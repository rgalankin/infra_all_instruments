---
id: YYYYMMDDHHMMSS-XX
title: "Интеграция: [A] → [B]"
summary: >
  [Краткое описание интеграции]
type: spec
status: active
tags: [eng/integration]
source: roman
ai_weight: normal
created: YYYY-MM-DD
updated: YYYY-MM-DD
from: "[Источник]"
to: "[Назначение]"
protocol: "[HTTP/MCP/SSH/WebDAV/etc.]"
criticality: high|medium|low
---
# Интеграция: [A] → [B]

## Описание

[Что делает эта интеграция, зачем нужна]

## Архитектура

```
[A] → [протокол] → [промежуточные звенья] → [B]
```

## Конфигурация

- **Протокол:** [HTTP REST / MCP / SSH tunnel / WebDAV / etc.]
- **Endpoint:** [URL]
- **Аутентификация:** [тип]
- **Переменные:** `[ENV_VAR]`

## Компоненты

| Компонент | Роль | Карточка |
|----------|------|---------|
| [A] | Источник | [[ссылка на карточку]] |
| [B] | Назначение | [[ссылка на карточку]] |

## Статус

- **Работает:** да/нет/частично
- **Последняя проверка:** YYYY-MM-DD
- **Известные проблемы:** [описание]

## Мониторинг

- **Как проверить:** [команда / URL / способ]
- **Алерты:** [настроены / нет]

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/integrations/_index__20260210220000-07|Карта интеграций]]

## История

- YYYY-MM-DD: Создана карточка
