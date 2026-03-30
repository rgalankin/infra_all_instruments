---
id: client-servers-registry
title: "Реестр клиентских серверов"
summary: >
  Серверы, создаваемые для клиентов компании. НЕ наша инфраструктура —
  после настройки передаются клиентам в собственность.
  SoT: client-servers-registry.json
type: registry
status: active
tags: [eng/infrastructure, content/registry, clients]
source: sysadmin_agent
ai_weight: high
created: 2026-03-30
updated: 2026-03-30
---

# РЕЕСТР КЛИЕНТСКИХ СЕРВЕРОВ

> ⚠️ **Единый источник истины:** `client-servers-registry.json`
> Этот файл — human-readable вид. При расхождении — верить JSON.

---

## Никита Филин

| Поле | Значение |
|------|---------|
| Контакт | `openclaw_engineer` |

### Серверы

| Параметр | Значение |
|----------|---------|
| Имя | `nikita-filin-claude` |
| Провайдер | Timeweb Cloud |
| Локация | nl-1 (Netherlands) |
| IP | — (ещё не создан) |
| Конфигурация | 2CPU / 4GB RAM / Ubuntu 24.04 |
| Статус | ⏳ Ожидание предзаказа |
| Передан клиенту | Нет |
| Дата создания | 2026-03-30 |

**Установлено (готовится):**
- Claude Code v2.1.87
- Bun v1.3.11
- Telegram plugin (`anthropics/claude-plugins-official`)

**Примечания:**
- nl-1 и другие EU/Almaty локации распроданы на 2026-03-30
- Заявка на предзаказ USA-сервера Timeweb подана 2026-03-30
- Шаблон деплоя: `template-claude-telegram-plugin` (72.56.24.15, nl-1)

---

## Как добавить нового клиента

1. Обновить `client-servers-registry.json` — добавить объект в `clients[]`
2. Обновить этот файл — добавить раздел с таблицей
3. Зафиксировать в `memory/YYYY-MM-DD.md`
