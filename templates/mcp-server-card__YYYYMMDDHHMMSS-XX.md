---
id: YYYYMMDDHHMMSS-XX
title: "MCP: [Название сервера]"
summary: >
  [Краткое описание MCP-сервера]
type: spec
status: active
tags: [eng/mcp]
source: roman
ai_weight: normal
created: YYYY-MM-DD
updated: YYYY-MM-DD
mcp_tools_count: 0
mcp_type: npm|npx|docker|sse|binary
requires_env: []
configured_in: []
---
# MCP: [Название сервера]

## Основная информация

- **Тип:** [npm / npx / docker / SSE endpoint / binary]
- **Tools:** [количество]
- **Статус:** ✅ активен / ⚠️ ошибка / ❌ отключён
- **Назначение:** [что делает]

## Конфигурация

### Команда запуска
```json
{
  "command": "[команда]",
  "args": ["[аргументы]"],
  "env": {
    "[ENV_VAR]": "[описание, не значение!]"
  }
}
```

### Endpoint (для SSE)
- URL: [URL]
- Аутентификация: [тип]

## Инструменты (tools)

| Tool | Описание |
|------|---------|
| [имя] | [что делает] |

## Настроен в

| Инструмент | Статус | Примечания |
|-----------|--------|-----------|
| Cursor | ✅/⚠️/❌ | [примечания] |
| Warp | ✅/⚠️/❌ | [примечания] |
| Claude Desktop | ✅/⚠️/❌ | [примечания] |

## Требования

- **Переменные окружения:** `[ENV_VAR_1]`, `[ENV_VAR_2]`
- **Зависимости:** [npm пакеты, Docker образы, etc.]
- **Сеть:** [VPN требуется / публичный доступ]

## Проблемы и замечания

- [Описание]

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/mcp/_index__20260210220000-06|Реестр MCP]]

## История

- YYYY-MM-DD: Создана карточка
