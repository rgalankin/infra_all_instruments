---
id: "20260315-01"
title: "Интеграция: Git-sync двусторонняя синхронизация"
summary: >
  Трёхсторонняя синхронизация git-репозиториев между VPS USA, Beget и iMac
  через GitHub. Автокоммит, push/pull, merge conflict resolution, индексация
  .md файлов в Qdrant.
type: spec
status: active
tags: [eng/integration, ops/sync, ops/git]
source: sofia
ai_weight: high
created: 2026-03-15
updated: 2026-03-15
from: "VPS USA / Beget / iMac"
to: "GitHub"
protocol: "SSH/Git"
criticality: high
---
# Интеграция: Git-sync двусторонняя синхронизация

## Описание

Автоматическая двусторонняя синхронизация всех git-репозиториев между тремя нодами (VPS USA, Beget, iMac) через GitHub как hub. Скрипт рекурсивно ищет git-репозитории в заданной директории, выполняет автокоммит изменений, push и pull с автоматическим разрешением merge-конфликтов. Дополнительно запускает kb-indexer.py для индексации .md файлов в Qdrant.

## Архитектура

```
VPS USA (149.33.4.37)
  /srv/repos/ ──git push/pull──► GitHub ◄──git push/pull── /home/roman/repos/
                                   ▲                        Beget (82.202.129.193)
                                   │
                              git push/pull
                                   │
                              /Users/mac/repos/
                              iMac (reverse SSH tunnel)
```

## Конфигурация

### VPS USA (149.33.4.37)

- **Скрипт:** `/opt/hub/git-sync/git-sync-bidirectional.sh`
- **Repos:** `/srv/repos/`
- **Cron:** `*/5 * * * *`
- **User:** roman

### Beget (82.202.129.193)

- **Скрипт:** `/home/roman/hub/git-sync/git-sync-bidirectional.sh`
- **Repos:** `/home/roman/repos/`
- **Cron:** `*/5 * * * *`
- **User:** roman
- **Переменные:** `REPOS_DIR`, `LOG_FILE`

### iMac

- **Скрипт:** `/Users/mac/hub/git-sync/git-sync-bidirectional.sh`
- **Repos:** `/Users/mac/repos/`
- **Cron:** `*/5 * * * *`
- **User:** mac (не roman!)
- **Доступ:** reverse SSH tunnel через VPS USA: `ssh -i ~/.ssh/id_ed25519 -p 2222 mac@127.0.0.1`

### Общее

- **Протокол:** Git over SSH
- **Аутентификация:** SSH-ключи (ed25519)
- **Скрипт:** git-sync-bidirectional.sh v2 (рекурсивный поиск git-репо)
- **Функции:** автокоммит + push + pull + merge conflict resolution
- **Доп. задача:** запуск kb-indexer.py для .md файлов → Qdrant

## Компоненты

| Компонент | Роль | Карточка |
|----------|------|---------|
| VPS USA | Нода синхронизации | [[infra_all_instruments/docs/infrastructure/vps-usa__20260210220000-03|VPS USA]] |
| Beget | Нода синхронизации | [[infra_all_instruments/docs/infrastructure/vps-beget__20260210220000-03|VPS Beget]] |
| iMac | Нода синхронизации | [[infra_all_instruments/docs/hardware/imac__20260210220000-02|iMac]] |
| GitHub | Hub (центральный remote) | — |
| Qdrant | Векторная БД для .md | [[infra_all_instruments/docs/tools/qdrant__20260201200225|Qdrant]] |

## Статус

- **Работает:** да
- **Последняя проверка:** 2026-03-15
- **Известные проблемы:** нет

## Мониторинг

- **Как проверить:** `crontab -l | grep git-sync` на каждой ноде; проверить логи
- **Алерты:** нет

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/integrations/_index__20260210220000-07|Карта интеграций]]

## История

- 2026-03-15: Создана карточка
