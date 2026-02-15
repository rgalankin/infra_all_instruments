---
id: 20260214230000-02
title: "Задание SysAdmin: бэкапы VPS ISHosting VPN Germany"
summary: >
  ТЗ для сисадмина: автобэкап x-ui.db и certbot auto-renewal cron.
  Сервер: 38.244.128.203, Debian 12, 3X-UI/XRay VPN.
type: spec
status: active
tags: [eng/infrastructure, ops/backup, hosting/ishosting, eng/vpn]
source: roman
ai_weight: high
created: 2026-02-14
updated: 2026-02-14
---
# ЗАДАНИЕ SYSADMIN: БЭКАПЫ VPS ISHOSTING VPN GERMANY

## КОНТЕКСТ

- **Сервер:** VPS ISHosting VPN Germany, 38.244.128.203
- **ОС:** Debian 12 (bookworm)
- **SSH:** `ssh roman@38.244.128.203` (алиас: `ishosting-vpn`)
- **Критичность:** средняя (VPN-сервер)
- **Назначение:** VPN-сервер dual-mode (Reality Self-Steal + XHTTP CDN)
- **Ключевые компоненты:** 3X-UI v2.6.7, XRay-core v25.8.29, nginx, certbot
- **Домены:** mail.fingroup.ru (Reality SNI), vpn.fingroup.ru (CDN через Cloudflare)
- **Ресурсы:** 1 Core / 960 MiB RAM / 9.8 GB SSD (7.3 GB свободно)

> **Важно:** сервер имеет ограниченный диск (9.8 GB), поэтому бэкапы должны быть компактными с жёстким retention.

---

## ЗАДАЧА 1: АВТОМАТИЧЕСКИЙ БЭКАП X-UI.DB

### Цель

Настроить автоматический ежедневный бэкап базы данных 3X-UI. Файл `x-ui.db` содержит всю конфигурацию VPN: inbounds, клиенты, подписки, настройки. Потеря = полная перенастройка VPN с нуля.

### Текущее состояние

- **Исходный файл:** `/etc/x-ui/x-ui.db`
- **Существующий бэкап:** `/root/x-ui-backup-20260212.db` (ручной, от 2026-02-12)
- **Автоматический бэкап:** не настроен

### Что нужно сделать

1. **Создать скрипт** `/root/scripts/backup-xui.sh`:

   ```bash
   #!/bin/bash
   # Автобэкап x-ui.db

   BACKUP_DIR="/root/backups/x-ui"
   SOURCE="/etc/x-ui/x-ui.db"
   DATE=$(date +%Y%m%d-%H%M)

   mkdir -p "$BACKUP_DIR"

   # Копия с датой
   cp "$SOURCE" "$BACKUP_DIR/x-ui-$DATE.db"

   # Сжатие (экономия диска)
   gzip "$BACKUP_DIR/x-ui-$DATE.db"

   # Retention: 14 дней (экономия места на маленьком диске)
   find "$BACKUP_DIR" -name "x-ui-*.db.gz" -mtime +14 -delete

   echo "[$(date)] x-ui backup OK: x-ui-$DATE.db.gz" >> /var/log/backup-xui.log
   ```

2. **Сделать исполняемым:**
   ```bash
   mkdir -p /root/scripts /root/backups/x-ui
   chmod +x /root/scripts/backup-xui.sh
   ```

3. **Добавить в cron:**
   ```bash
   # Каждый день в 04:00
   echo "0 4 * * * /root/scripts/backup-xui.sh" | crontab -
   ```

   > Если уже есть записи в crontab, добавить строку через `crontab -e`, а не перезаписывать.

4. **Тестовый прогон:**
   ```bash
   /root/scripts/backup-xui.sh
   ls -la /root/backups/x-ui/
   cat /var/log/backup-xui.log
   ```

5. **Проверить размер:**
   ```bash
   # Исходный файл
   ls -la /etc/x-ui/x-ui.db

   # Сжатый бэкап
   ls -la /root/backups/x-ui/

   # Оценить: 14 дней * размер = сколько места на диске?
   ```

### Формат отчёта

```markdown
## Бэкап x-ui.db

- Исходный файл: /etc/x-ui/x-ui.db (размер: X KB)
- Скрипт: /root/scripts/backup-xui.sh
- Cron: ежедневно 04:00
- Хранение: /root/backups/x-ui/
- Retention: 14 дней
- Размер сжатого бэкапа: X KB
- Оценка места: ~X MB на 14 дней
- Тестовый прогон: OK / ошибка
```

---

## ЗАДАЧА 2: CERTBOT AUTO-RENEWAL CRON

### Цель

Настроить автоматическое продление SSL-сертификатов Let's Encrypt через certbot. Без этого сертификаты истекут через 90 дней и VPN перестанет работать.

### Текущее состояние

- **Certbot:** установлен (использовался при настройке)
- **Сертификаты:** для mail.fingroup.ru (используется nginx + Reality)
- **Auto-renewal:** не настроен (нет cron)
- **Cloudflare Origin Certificate:** используется для vpn.fingroup.ru (не требует renewal — срок 15 лет)

### Что нужно сделать

1. **Проверить текущие сертификаты:**
   ```bash
   certbot certificates
   ```
   Записать: какие домены, даты истечения, пути к файлам.

2. **Проверить, работает ли renewal:**
   ```bash
   certbot renew --dry-run
   ```
   Если есть ошибки — исправить (порт 80 может быть занят nginx).

3. **Настроить cron для auto-renewal:**
   ```bash
   # Добавить в crontab (вместе с бэкапом x-ui)
   # Дважды в день (рекомендация Let's Encrypt)
   0 0,12 * * * certbot renew --quiet --deploy-hook "systemctl reload nginx"
   ```

   > `--deploy-hook` — перезагрузить nginx после обновления сертификата, чтобы подхватил новый.

4. **Проверить совместимость с nginx:**
   - Certbot использует standalone или webroot?
   - Если standalone — нужно ли останавливать nginx на порту 80?
   - Если webroot — указать правильный путь

   ```bash
   # Проверить конфигурацию renewal
   cat /etc/letsencrypt/renewal/*.conf
   ```

5. **Проверить даты истечения:**
   ```bash
   # Когда истекают текущие сертификаты?
   openssl x509 -in /etc/letsencrypt/live/mail.fingroup.ru/cert.pem -noout -dates
   ```

### Формат отчёта

```markdown
## Certbot Auto-Renewal

- Домены с LE-сертификатами: ...
- Дата истечения: ...
- Метод renewal: standalone / webroot / dns
- Cron: 0 0,12 * * * certbot renew ...
- deploy-hook: systemctl reload nginx
- dry-run результат: OK / ошибка (описание)
- Cloudflare Origin Cert (vpn.fingroup.ru): не требует renewal
```

---

## ПРИОРИТЕТЫ

| # | Задача | Приоритет | Сложность | Время |
|---|--------|-----------|-----------|-------|
| 1 | Автобэкап x-ui.db | Высокий | Низкая | 15-20 мин |
| 2 | Certbot auto-renewal | Высокий | Низкая | 15-30 мин |

**Рекомендуемый порядок:** 2 → 1 (сначала certbot — чтобы сертификаты не протухли).

---

## ОГРАНИЧЕНИЯ И ПРЕДУПРЕЖДЕНИЯ

- **Диск ограничен:** 9.8 GB всего, ~7.3 GB свободно. Бэкапы с жёстким retention (14 дней).
- **Не перезапускать 3X-UI** без необходимости — обрыв VPN-соединений клиентов.
- **Не менять порты nginx** (8443) — на них завязан XHTTP CDN через Cloudflare.
- **certbot renew** — проверить `--dry-run` перед боевым запуском.

---

## ПОСЛЕ ВЫПОЛНЕНИЯ

1. Прислать отчёт по каждой задаче в формате выше
2. Приложить вывод `crontab -l`
3. Приложить вывод тестового прогона скрипта бэкапа
4. Приложить вывод `certbot renew --dry-run`
5. Указать дату истечения текущих сертификатов

## LINKS (INTERNAL)

- [[infra_all_instruments/docs/infrastructure/vps-ishosting-vpn__20260212220200-02|VPS ISHosting VPN Germany]]
- [[infra_all_instruments/docs/tools/cloudflare__20260214225000-02|Cloudflare]]
- [[infra_all_instruments/docs/infrastructure/domains-dns__20260210220200-07|Домены и DNS]]
- [[infra_all_instruments/registry__20260210220000-01|Registry]]
