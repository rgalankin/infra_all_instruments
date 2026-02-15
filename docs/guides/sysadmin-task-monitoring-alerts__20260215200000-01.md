---
id: 20260215200000-01
title: "Задание SysAdmin: мониторинг туннелей + Telegram-алерты"
summary: >
  ТЗ для сисадмина: мониторинг egress-tunnel Beget→US, VPN-эндпоинтов,
  Telegram-алерты через n8n webhook. Два сервера: Beget + ISHosting USA.
type: spec
status: active
tags: [eng/infrastructure, ops/monitoring]
source: roman
ai_weight: high
created: 2026-02-15
updated: 2026-02-15
---
# ЗАДАНИЕ SYSADMIN: МОНИТОРИНГ ТУННЕЛЕЙ + TELEGRAM-АЛЕРТЫ

## КОНТЕКСТ

### Серверы

| Сервер | IP | SSH | Роль |
|--------|-----|-----|------|
| VPS Beget | 82.202.129.193 | `ssh roman@82.202.129.193` (алиас: `srv`) | Production: n8n, Dify, Traefik, Docker-стек |
| VPS ISHosting USA | 149.33.4.37 | `ssh roman@149.33.4.37` (алиас: `ishosting-usa`) | LLM Router, egress-proxy, VPN, Vaultwarden |

### Критичный канал

```
Docker-сервисы (Beget) → Squid proxy (Beget) → VLESS-туннель → US VPS → LLM API
```

Egress-tunnel — **единая точка отказа** для 7+ Docker-сервисов, которые используют LLM API (OpenAI, Anthropic и др.). При падении туннеля все эти сервисы теряют доступ к API.

### Что уже есть

**На US VPS:**
- `/opt/monitoring/vpn-monitor.sh` — мониторинг RAM, диска, 3x-ui, nginx → n8n webhook
- `/opt/vpn-monitor/monitor.sh` — TCP-connect проверка 12 VPN-эндпоинтов (только лог, без алертов)
- Cron (root): `*/5 * * * * /opt/monitoring/vpn-monitor.sh`
- Webhook: `https://n8n.fingroup.ru/webhook/vpn-monitoring`
- n8n workflow (Beget): принимает webhook → отправляет Telegram

**Чего НЕ хватает:**
1. Мониторинг egress-tunnel на Beget (задача 1)
2. Telegram-алерты при падении VPN-эндпоинтов на US (задача 2)

---

## ЗАДАЧА 1: МОНИТОРИНГ EGRESS-TUNNEL (BEGET)

### Цель

Каждые 5 минут проверять, что egress-tunnel (VLESS Beget → US) работает. При сбое — Telegram-алерт.

### Логика проверки

```bash
# Запрос через egress-proxy (Squid на Beget, порт 10808 или 3128)
# → трафик идёт через VLESS-туннель → выходит через US VPS
# → внешний IP должен быть 149.33.4.37

EXPECTED_IP="149.33.4.37"
ACTUAL_IP=$(curl -s --proxy http://127.0.0.1:10808 --max-time 10 https://ifconfig.me)

if [ "$ACTUAL_IP" != "$EXPECTED_IP" ]; then
    # АЛЕРТ: туннель не работает
fi
```

### Скрипт: `/opt/monitoring/egress-monitor.sh`

```bash
#!/bin/bash
# egress-monitor.sh — мониторинг VLESS egress-tunnel Beget → US
# Проверяет: curl через proxy → IP = US VPS
# Алерт: n8n webhook → Telegram

WEBHOOK_URL="https://n8n.fingroup.ru/webhook/vpn-monitoring"
EXPECTED_IP="149.33.4.37"
PROXY="http://127.0.0.1:10808"
COOLDOWN_DIR="/opt/monitoring"
COOLDOWN_SEC=1800  # 30 минут между повторными алертами
LOG="/var/log/egress-monitor.log"
HOSTNAME_LABEL="beget-egress"
SERVER_IP="82.202.129.193"

# --- Cooldown ---
is_cooled_down() {
    local file="${COOLDOWN_DIR}/.cooldown_egress_${1}"
    if [ -f "$file" ]; then
        local age=$(( $(date +%s) - $(stat -c %Y "$file" 2>/dev/null || echo 0) ))
        [ "$age" -lt "$COOLDOWN_SEC" ] && return 0
    fi
    return 1
}

set_cooldown() {
    touch "${COOLDOWN_DIR}/.cooldown_egress_${1}"
}

clear_cooldown() {
    rm -f "${COOLDOWN_DIR}/.cooldown_egress_${1}" 2>/dev/null
}

send_alert() {
    local body
    body=$(python3 -c "
import json, sys
msg = sys.argv[1]
print(json.dumps({'message': msg}))
" "$1")
    curl -s -o /dev/null -w "%{http_code}" \
        -X POST -H "Content-Type: application/json" \
        -d "$body" "$WEBHOOK_URL"
}

# --- Main ---
NOW=$(date '+%Y-%m-%d %H:%M:%S %Z')

# Проверка 1: curl через proxy
ACTUAL_IP=$(curl -s --proxy "$PROXY" --max-time 10 https://ifconfig.me 2>/dev/null)
CURL_EXIT=$?

if [ $CURL_EXIT -ne 0 ] || [ -z "$ACTUAL_IP" ]; then
    # Proxy не отвечает
    if ! is_cooled_down "proxy_down"; then
        MSG=$(printf "🔴 <b>Egress Tunnel DOWN</b>\n🖥 %s (%s)\n🕐 %s\n\n⚠️ Proxy %s не отвечает (exit code: %d)\n7+ Docker-сервисов без доступа к LLM API!" \
            "$HOSTNAME_LABEL" "$SERVER_IP" "$NOW" "$PROXY" "$CURL_EXIT")
        CODE=$(send_alert "$MSG")
        set_cooldown "proxy_down"
        echo "[$NOW] ALERT: proxy down (HTTP $CODE)" >> "$LOG"
    else
        echo "[$NOW] ALERT: proxy down (cooldown)" >> "$LOG"
    fi
elif [ "$ACTUAL_IP" != "$EXPECTED_IP" ]; then
    # IP не совпадает — туннель маршрутизирует неправильно
    if ! is_cooled_down "wrong_ip"; then
        MSG=$(printf "⚠️ <b>Egress Tunnel WRONG IP</b>\n🖥 %s (%s)\n🕐 %s\n\nОжидали: %s\nПолучили: %s\nТуннель маршрутизирует трафик неправильно!" \
            "$HOSTNAME_LABEL" "$SERVER_IP" "$NOW" "$EXPECTED_IP" "$ACTUAL_IP")
        CODE=$(send_alert "$MSG")
        set_cooldown "wrong_ip"
        echo "[$NOW] ALERT: wrong IP $ACTUAL_IP (HTTP $CODE)" >> "$LOG"
    else
        echo "[$NOW] ALERT: wrong IP (cooldown)" >> "$LOG"
    fi
else
    # Всё ок
    clear_cooldown "proxy_down"
    clear_cooldown "wrong_ip"
    echo "[$NOW] OK: IP=$ACTUAL_IP" >> "$LOG"
fi

# Ротация лога
tail -500 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
```

### Установка

```bash
# 1. На VPS Beget (ssh roman@82.202.129.193)
sudo mkdir -p /opt/monitoring
sudo tee /opt/monitoring/egress-monitor.sh < скрипт_выше
sudo chmod +x /opt/monitoring/egress-monitor.sh

# 2. Тест
sudo bash /opt/monitoring/egress-monitor.sh
# Ожидание: "[дата] OK: IP=149.33.4.37"

# 3. Cron (root)
sudo crontab -e
# Добавить строку:
*/5 * * * * /opt/monitoring/egress-monitor.sh

# 4. Тест алерта (временно поменять EXPECTED_IP на 1.2.3.4, запустить, вернуть обратно)
```

### Верификация

- [ ] `sudo bash /opt/monitoring/egress-monitor.sh` → лог: `OK: IP=149.33.4.37`
- [ ] Тест с неправильным IP → Telegram-алерт приходит
- [ ] Cron работает: `sudo grep egress /var/log/syslog | tail -5`
- [ ] Cooldown работает: повторный сбой в течение 30 мин не дублирует алерт

---

## ЗАДАЧА 2: VPN-АЛЕРТЫ НА US СЕРВЕРЕ

### Цель

Существующий `/opt/vpn-monitor/monitor.sh` на US VPS проверяет 12 VPN-эндпоинтов TCP-connect, но результаты пишутся только в лог. Добавить отправку алертов через n8n webhook при сбоях.

### Текущее состояние

Файл: `/opt/vpn-monitor/monitor.sh`
Проверяемые эндпоинты (12 шт.):

| Имя | Адрес | Описание |
|-----|-------|----------|
| DE_Express | 38.244.128.203:443 | VPN Germany прямой |
| DE_Turbo | 38.244.128.203:47819 | VPN Germany Turbo |
| US_Express | 149.33.4.37:443 | VPN US прямой |
| US_Turbo | 149.33.4.37:47382 | VPN US Turbo |
| DE_Bridge | 82.202.129.193:41443 | VPN DE через Beget relay |
| DE_Bridge_Turbo | 82.202.129.193:41819 | VPN DE Turbo через Beget |
| US_Bridge | 82.202.129.193:40443 | VPN US через Beget relay |
| US_Bridge_Turbo | 82.202.129.193:40382 | VPN US Turbo через Beget |
| US_Max | 82.202.129.193:42443 | VPN US Max через Beget |
| US_Max_Turbo | 82.202.129.193:42382 | VPN US Max Turbo |
| DE_Relay_US | 38.244.128.203:50443 | VPN DE relay через US |
| DE_Relay_US_Turbo | 38.244.128.203:50382 | VPN DE relay Turbo |

Лог: `/opt/vpn-monitor/results.log`
Cron: **нет** (скрипт есть, но в cron — `/opt/monitoring/vpn-monitor.sh`, это другой скрипт)

### Что нужно сделать

**Вариант A (рекомендуется): дополнить существующий скрипт**

Добавить в `/opt/vpn-monitor/monitor.sh` блок отправки webhook при FAIL > 0:

```bash
# --- Добавить в конец monitor.sh (после цикла проверок) ---

WEBHOOK_URL="https://n8n.fingroup.ru/webhook/vpn-monitoring"
COOLDOWN_FILE="/opt/vpn-monitor/.cooldown_vpn_fail"
COOLDOWN_SEC=1800

if [ "$FAIL" -gt 0 ]; then
    # Cooldown check
    SEND=1
    if [ -f "$COOLDOWN_FILE" ]; then
        AGE=$(( $(date +%s) - $(stat -c %Y "$COOLDOWN_FILE" 2>/dev/null || echo 0) ))
        [ "$AGE" -lt "$COOLDOWN_SEC" ] && SEND=0
    fi

    if [ "$SEND" -eq 1 ]; then
        # Собираем список упавших
        FAIL_LIST=$(echo "$RESULTS" | grep "FAIL" | sed 's/^  /• /')

        MSG=$(printf "🔴 <b>VPN Endpoints DOWN</b>\n🖥 vpn-usa (%s)\n🕐 %s\n\n%s/%s OK, <b>%s FAIL</b>\n\n%s" \
            "$SERVER_IP" "$TS" "$OK" "$TOTAL" "$FAIL" "$FAIL_LIST")

        BODY=$(python3 -c "
import json, sys
print(json.dumps({'message': sys.argv[1]}))
" "$MSG")

        curl -s -o /dev/null -X POST \
            -H "Content-Type: application/json" \
            -d "$BODY" "$WEBHOOK_URL"

        touch "$COOLDOWN_FILE"
    fi
else
    rm -f "$COOLDOWN_FILE" 2>/dev/null
fi
```

**Переменные для добавления в начало скрипта:**
```bash
SERVER_IP="149.33.4.37"
```

### Cron

Добавить отдельный cron для `/opt/vpn-monitor/monitor.sh` (сейчас не запланирован):

```bash
sudo crontab -e
# Добавить:
*/5 * * * * /opt/vpn-monitor/monitor.sh >> /opt/vpn-monitor/cron.log 2>&1
```

### Верификация

- [ ] `/opt/vpn-monitor/monitor.sh` выполняется без ошибок
- [ ] При всех OK — Telegram НЕ получает сообщение
- [ ] При FAIL — Telegram получает сообщение со списком упавших эндпоинтов
- [ ] Cooldown: повторный сбой в течение 30 мин не дублирует алерт
- [ ] Cron настроен: `sudo crontab -l | grep vpn-monitor`

---

## ЗАДАЧА 3: N8N WORKFLOW (ПРОВЕРКА)

### Цель

Убедиться, что n8n workflow для Telegram-алертов работает корректно для всех новых источников.

### Текущее состояние

- Webhook: `https://n8n.fingroup.ru/webhook/vpn-monitoring` — уже используется `/opt/monitoring/vpn-monitor.sh` на US VPS
- Формат: POST JSON `{"message": "<html-текст>"}`
- Telegram-бот и chat_id — уже настроены в n8n workflow

### Что нужно проверить

1. Webhook принимает POST с полем `message`
2. Telegram-сообщение приходит с HTML-форматированием (`<b>`, `<code>`)
3. Алерты от разных источников различимы (по `HOSTNAME_LABEL`)

### Тест

```bash
# С любого сервера:
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"message":"🧪 <b>Test Alert</b>\n🖥 test-server\n\nЭто тестовый алерт. Можно игнорировать."}' \
  https://n8n.fingroup.ru/webhook/vpn-monitoring

# Ожидание: Telegram-сообщение с текстом
```

### Верификация

- [ ] Тестовый алерт приходит в Telegram
- [ ] HTML-форматирование отображается корректно
- [ ] Алерт от Beget-egress отличим от US-vpn (разные HOSTNAME_LABEL)

---

## СВОДКА

| Задача | Сервер | Скрипт | Cron | Webhook |
|--------|--------|--------|------|---------|
| 1. Egress-tunnel | Beget | `/opt/monitoring/egress-monitor.sh` (новый) | `*/5 * * * *` | `vpn-monitoring` |
| 2. VPN-эндпоинты | US | `/opt/vpn-monitor/monitor.sh` (дополнить) | `*/5 * * * *` | `vpn-monitoring` |
| 3. n8n workflow | Beget (n8n) | — | — | проверить |

### Приоритет

1. **Задача 1 (egress-tunnel)** — критично, единая точка отказа для 7+ сервисов
2. **Задача 2 (VPN-эндпоинты)** — важно, пользователи VPN без доступа при сбое
3. **Задача 3 (n8n workflow)** — проверка, что алерты доходят

### Связанные файлы

- [[infra_all_instruments/docs/infrastructure/vps-beget__20260210220200-01|VPS Beget]]
- [[infra_all_instruments/docs/infrastructure/vps-ishosting-usa__20260212220200-01|VPS ISHosting USA]]
- [[infra_all_instruments/docs/guides/sysadmin-task-beget-backups__20260214230000-01|ТЗ: бэкапы Beget]]
