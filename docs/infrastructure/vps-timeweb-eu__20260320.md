---
id: "20260320-vps-timeweb-eu"
title: "VPS Timeweb EU"
summary: >
  Новый европейский VPS (замена заблокированного Hetzner). Ubuntu, Docker-ready.
  Назначение: определяется.
type: spec
status: active
tags: [eng/infrastructure, platform/linux, hosting/timeweb]
source: roman
ai_weight: normal
created: 2026-03-20
updated: 2026-03-20
category: "Инфраструктура → сервер"
criticality: medium
---
# VPS TIMEWEB EU

## ОСНОВНАЯ ИНФОРМАЦИЯ

| Параметр | Значение |
|----------|----------|
| IPv4 | 72.56.24.15 |
| IPv6 | 2a03:6f02::1:69cf |
| Хостинг | [Timeweb Cloud](https://timeweb.cloud) |
| ОС | Ubuntu (уточнить версию) |
| Диск | 50 GB SSD (занято 3.8 GB, свободно 46.2 GB) |
| SSH | `ssh root@72.56.24.15` |
| Назначение | Определяется (замена Hetzner) |

## СЕКРЕТЫ

Пароли и ключи: `~/.openclaw/secrets/timeweb-eu.env`

## ЗАКРЫТЫЕ ПОРТЫ

465, 3389, 53413, 25, 587, 2525, 389

> ⚠️ Порты 25, 465, 587, 2525 закрыты — исходящая почта (SMTP) заблокирована провайдером.

## ПЕРВИЧНАЯ НАСТРОЙКА (TODO)

- [ ] Добавить SSH-ключ roman (вместо пароля)
- [ ] Создать пользователя roman (не работать под root)
- [ ] Обновить систему (apt update && apt upgrade)
- [ ] Установить Docker + Docker Compose
- [ ] Настроить firewall (ufw)
- [ ] Настроить fail2ban
- [ ] Определить назначение сервера

## ИСТОРИЯ

- 2026-03-20: Hetzner заблокировал аккаунт (санкционный compliance, гражданство РФ). Перешли на Timeweb Cloud.

## ЗАМЕТКА: HETZNER

Аккаунт Hetzner **заблокирован навсегда** (deactivated). Причина: проверка документов выявила гражданство РФ. Запрошен возврат средств. Hetzner больше не является опцией для Кредо-Сервис.
