---
id: "20260320-vps-timeweb-eu"
title: "VPS Timeweb EU"
summary: >
  Европейский VPS (Нидерланды, Rotterdam). Замена заблокированного Hetzner.
  Ubuntu 24.04, Docker-ready, базовая безопасность настроена.
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
| ОС | Ubuntu 24.04.4 LTS (Noble Numbat) |
| Ядро | 6.8.0-90-generic |
| CPU | 2 vCPU (QEMU Virtual CPU v8.2.0, 2.0 GHz) |
| RAM | 3.8 GB |
| Диск | 50 GB SSD (занято ~4.1 GB, свободно ~44 GB) |
| Расположение | Rotterdam, South Holland, NL (AS210976 Timeweb, LLP) |
| Часовой пояс | Europe/Amsterdam |
| SSH | `ssh roman@72.56.24.15` (ключ ed25519) |
| Назначение | Определяется (замена Hetzner) |

## ДОСТУП

- **Пользователь:** `roman` (sudo, вход только по SSH-ключу)
- **Root-логин по паролю:** отключён (`PermitRootLogin prohibit-password`)
- **SSH-ключ:** `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIUWcCOOFmZFeGQtQrRDPIEvn/l23I44h6GM7wcYJoJ roman@us-server`
- Пароли и ключи: `~/.openclaw/secrets/timeweb-eu.env`

## ЗАКРЫТЫЕ ПОРТЫ (ПРОВАЙДЕР)

| Порт | Протокол |
|------|----------|
| 25, 465, 587, 2525 | SMTP (исходящая почта заблокирована) |
| 389 | LDAP |
| 3389 | RDP |
| 53413 | — |

> ⚠️ Порты 25, 465, 587, 2525 закрыты — SMTP недоступен. Использовать внешние relay (SendGrid, Mailgun и т.п.).

## UFW (FIREWALL)

| Порт | Действие |
|------|----------|
| 22/tcp | ALLOW (SSH) |
| 80/tcp | ALLOW (HTTP) |
| 443/tcp | ALLOW (HTTPS) |
| всё остальное | DENY |

## УСТАНОВЛЕННОЕ ПО

| Компонент | Версия / Статус |
|-----------|----------------|
| Docker | Установлен (get.docker.com), сервис включён |
| Docker Compose | v5.1.1 (плагин) |
| fail2ban | 1.0.2, активен |
| ufw | Активен |

## ПЕРВИЧНАЯ НАСТРОЙКА (ВЫПОЛНЕНО 2026-03-20)

- [x] Добавить SSH-ключ roman (вместо пароля)
- [x] Создать пользователя roman с sudo-правами
- [x] Обновить систему (`apt update && apt upgrade`)
- [x] Установить Docker + Docker Compose
- [x] Настроить firewall (ufw: 22, 80, 443)
- [x] Установить fail2ban
- [x] Отключить root-вход по паролю (`PasswordAuthentication no`, `PermitRootLogin prohibit-password`)

## ИСТОРИЯ

- 2026-03-20: Первичная настройка VPS. Базовая безопасность, Docker, UFW, fail2ban.
- 2026-03-20: Hetzner заблокировал аккаунт (санкционный compliance, гражданство РФ). Перешли на Timeweb Cloud.

## ЗАМЕТКА: HETZNER

Аккаунт Hetzner **заблокирован навсегда** (deactivated). Причина: проверка документов выявила гражданство РФ. Запрошен возврат средств. Hetzner больше не является опцией для Кредо-Сервис.
