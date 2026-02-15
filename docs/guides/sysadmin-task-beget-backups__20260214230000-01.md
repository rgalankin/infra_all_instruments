---
id: 20260214230000-01
title: "Задание SysAdmin: бэкапы и мониторинг VPS Beget"
summary: >
  ТЗ для сисадмина: карта бэкапов, мониторинг диска, автобэкап acme.json.
  Сервер: 82.202.129.193, Ubuntu 24.04, Docker-стек.
type: spec
status: active
tags: [eng/infrastructure, ops/backup, ops/monitoring]
source: roman
ai_weight: high
created: 2026-02-14
updated: 2026-02-14
---
# ЗАДАНИЕ SYSADMIN: БЭКАПЫ И МОНИТОРИНГ VPS BEGET

## КОНТЕКСТ

- **Сервер:** VPS Beget, 82.202.129.193
- **ОС:** Ubuntu 24.04 LTS
- **SSH:** `ssh roman@82.202.129.193` (алиас: `srv`)
- **Корень проекта:** `/opt/infra`
- **Критичность:** высокая (production-сервер)
- **Docker-стек:** n8n (prod + dev), Dify, Traefik, PostgreSQL, Qdrant, ASR, MCP-n8n, MCP-Warp, MCP-Postgres, CreditWise, Telegram-*, WhatsApp

---

## ЗАДАЧА 1: КАРТА БЭКАПОВ

### Цель

Составить полную карту: что бэкапится, куда сохраняется, как восстановить. Документ — основа для disaster recovery.

### Что нужно сделать

1. **Инвентаризация данных** — для каждого сервиса определить:

| Сервис | Что бэкапить | Путь на сервере | Критичность |
|--------|-------------|-----------------|-------------|
| PostgreSQL | Все базы (n8n, dify, creditwise и др.) | ? | Очень высокая |
| n8n | Workflows, credentials, execution history | ? (в БД или volume?) | Очень высокая |
| Dify | Данные приложений, knowledge base | ? | Высокая |
| Traefik | acme.json (SSL-сертификаты) | ? | Высокая |
| Qdrant | Векторные коллекции | ? | Средняя |
| Docker Compose | docker-compose.yml, .env файлы | `/opt/infra/` | Высокая |
| Конфигурации | nginx, systemd units, cron | /etc/ | Средняя |

2. **Проверить существующие бэкапы** — что уже настроено:
   ```bash
   # Проверить cron
   crontab -l
   sudo crontab -l

   # Проверить systemd timers
   systemctl list-timers --all

   # Проверить наличие бэкап-скриптов
   find /opt/infra -name "*backup*" -o -name "*dump*" 2>/dev/null
   ls -la /var/backups/
   ```

3. **Проверить бэкапы Beget** — предоставляет ли хостинг автоматические бэкапы:
   - Есть ли weekly snapshots?
   - Где хранятся?
   - Как запросить восстановление?

4. **Настроить автоматические бэкапы PostgreSQL:**
   ```bash
   # Определить все базы
   docker exec <postgres_container> psql -U <user> -l

   # Тестовый дамп
   docker exec <postgres_container> pg_dumpall -U <user> > /tmp/test_dump.sql
   ```

   Рекомендуемая схема:
   - **Ежедневно:** `pg_dumpall` → `/opt/infra/backups/postgres/daily/`
   - **Retention:** 7 ежедневных, 4 еженедельных
   - **Cron:** `0 3 * * * /opt/infra/scripts/backup-postgres.sh`

5. **Настроить бэкап Docker volumes:**
   ```bash
   # Список volumes
   docker volume ls

   # Определить, какие volumes критичны
   docker inspect <container> | grep -A5 Mounts
   ```

### Формат отчёта

```markdown
## Карта бэкапов VPS Beget (82.202.129.193)

### Существующие бэкапы
| Что | Метод | Расписание | Хранение | Retention |
|-----|-------|-----------|----------|-----------|
| ... | ... | ... | ... | ... |

### Настроенные бэкапы (новые)
| Что | Метод | Расписание | Хранение | Retention |
|-----|-------|-----------|----------|-----------|
| PostgreSQL | pg_dumpall | ежедневно 03:00 | /opt/infra/backups/ | 7 daily + 4 weekly |
| ... | ... | ... | ... | ... |

### НЕ бэкапится (требует решения)
| Что | Причина | Риск |
|-----|---------|------|
| ... | ... | ... |

### Процедура восстановления
| Сценарий | Шаги |
|----------|------|
| Восстановление PostgreSQL | 1. ... 2. ... |
| Восстановление n8n | 1. ... 2. ... |
| Полное восстановление сервера | 1. ... 2. ... |
```

---

## ЗАДАЧА 2: МОНИТОРИНГ ДИСКА

### Цель

Настроить автоматический alert при заполнении диска выше порога. Предотвратить ситуацию, когда диск переполняется и Docker/PostgreSQL падают.

### Что нужно сделать

1. **Проверить текущее состояние:**
   ```bash
   df -h
   du -sh /opt/infra/*
   du -sh /var/lib/docker/*
   docker system df
   ```

2. **Создать скрипт мониторинга** `/opt/infra/scripts/disk-monitor.sh`:

   Логика:
   - Проверить `df -h /` — процент использования
   - Если > 80% → предупреждение в Telegram
   - Если > 90% → критический alert в Telegram
   - Также проверить `docker system df` — неиспользуемые images/volumes

3. **Настроить cron:**
   ```
   # Каждые 6 часов
   0 */6 * * * /opt/infra/scripts/disk-monitor.sh
   ```

4. **Telegram alert** — использовать бота для отправки:
   - Бот и chat_id — спросить у владельца (Роман)
   - Или использовать существующий n8n webhook для алертов

### Формат отчёта

```markdown
## Мониторинг диска

- Скрипт: /opt/infra/scripts/disk-monitor.sh
- Cron: каждые N часов
- Порог предупреждения: 80%
- Порог критический: 90%
- Канал алертов: Telegram / n8n webhook
- Текущее использование: X% (Y GB из Z GB)
```

---

## ЗАДАЧА 3: АВТОБЭКАП ACME.JSON (TRAEFIK)

### Цель

Настроить автоматический бэкап файла `acme.json`, который содержит SSL-сертификаты Let's Encrypt. Потеря этого файла = перевыпуск всех сертификатов (с rate limits).

### Что нужно сделать

1. **Найти acme.json:**
   ```bash
   # Обычно в Docker volume или bind mount
   docker inspect traefik | grep -A10 Mounts
   find / -name "acme.json" 2>/dev/null
   ```

2. **Настроить ежедневный бэкап:**
   ```bash
   # Скрипт /opt/infra/scripts/backup-acme.sh
   #!/bin/bash
   ACME_PATH="<путь к acme.json>"
   BACKUP_DIR="/opt/infra/backups/traefik"
   mkdir -p "$BACKUP_DIR"
   cp "$ACME_PATH" "$BACKUP_DIR/acme-$(date +%Y%m%d).json"
   # Retention: 30 дней
   find "$BACKUP_DIR" -name "acme-*.json" -mtime +30 -delete
   ```

3. **Добавить в cron:**
   ```
   0 4 * * * /opt/infra/scripts/backup-acme.sh
   ```

4. **Проверить, сколько сертификатов:**
   ```bash
   # Подсчитать домены в acme.json
   cat <path>/acme.json | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('le',{}).get('Certificates',[])))"
   ```

### Формат отчёта

```markdown
## Бэкап acme.json

- Путь к acme.json: ...
- Количество сертификатов: N
- Домены: ...
- Скрипт бэкапа: /opt/infra/scripts/backup-acme.sh
- Cron: ежедневно 04:00
- Retention: 30 дней
- Хранение бэкапов: /opt/infra/backups/traefik/
```

---

## ПРИОРИТЕТЫ

| # | Задача | Приоритет | Сложность | Время |
|---|--------|-----------|-----------|-------|
| 1 | Карта бэкапов | Высокий | Средняя | 2-3 часа |
| 2 | Мониторинг диска | Средний | Низкая | 30-60 мин |
| 3 | Автобэкап acme.json | Высокий | Низкая | 15-30 мин |

**Рекомендуемый порядок:** 3 → 2 → 1 (от быстрого к долгому).

---

## ПОСЛЕ ВЫПОЛНЕНИЯ

1. Прислать отчёт по каждой задаче в формате выше
2. Указать пути к созданным скриптам
3. Подтвердить, что cron настроен (`crontab -l`)
4. Провести тестовый прогон каждого скрипта и приложить вывод

## LINKS (INTERNAL)

- [[infra_all_instruments/docs/infrastructure/vps-beget__20260210220200-01|VPS Beget]]
- [[infra_all_instruments/docs/infrastructure/traefik__20260210220200-05|Traefik]]
- [[infra_all_instruments/registry__20260210220000-01|Registry]]
