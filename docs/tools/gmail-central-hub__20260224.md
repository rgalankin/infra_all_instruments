---
id: gmail-central-hub
title: Gmail как центральный почтовый хаб CEO
type: tool-doc
status: active
tags: [gmail, email, google-workspace, yandex, beget, hub]
source: manual
summary: Техническая документация по настройке Gmail (5427611@gmail.com) как центрального хаба для сбора и отправки почты с нескольких адресов
created: 2026-02-24
updated: 2026-02-24
---

# Gmail как центральный почтовый хаб CEO

## Обзор

Gmail-аккаунт `5427611@gmail.com` настроен как центральный почтовый хаб, который:
- **Собирает** входящую почту с Яндекс (galankin@yandex.ru) и fingroup (1@fingroup.ru) через POP3
- **Отправляет** от имени этих адресов через SMTP (Send As)
- **Управляется** через Google Workspace MCP и Gmail API (OAuth2)

## Архитектура

```
                    ┌─────────────────────────┐
                    │   Gmail (5427611@gmail)  │
                    │   ЦЕНТРАЛЬНЫЙ ХАБ       │
                    ├─────────────────────────┤
  POP3 сбор ──────►│  galankin@yandex.ru      │──── Send As (SMTP)
  POP3 сбор ──────►│  1@fingroup.ru           │──── Send As (SMTP)
                    │  5427611@gmail.com       │──── Основной
                    └─────────────────────────┘
                              │
                    OAuth2 API (MCP google-workspace)
                              │
                    ┌─────────────────────────┐
                    │  Claude Code / Софья    │
                    └─────────────────────────┘
```

## Подключённые аккаунты

### 1. galankin@yandex.ru (Яндекс)

**POP3 сбор (Gmail → Яндекс):**
| Параметр | Значение |
|----------|----------|
| Сервер | pop.yandex.ru |
| Порт | 995 |
| SSL | Да |
| Логин | galankin@yandex.ru |
| Пароль | App-пароль (Яндекс ID) |
| Метка в Gmail | galankin@yandex.ru |
| Копии на сервере | Оставлять |

**Send As (SMTP):**
| Параметр | Значение |
|----------|----------|
| Сервер | smtp.yandex.ru |
| Порт | 465 |
| SSL | Да |
| Логин | galankin@yandex.ru |
| Пароль | App-пароль |

**Примечания:**
- POP3 должен быть включён в настройках Яндекса: mail.360.yandex.ru → Почтовые программы
- Используется app-пароль (не основной пароль аккаунта)
- Дата настройки: 2026-02-24

### 2. 1@fingroup.ru (Beget)

**POP3 сбор (Gmail → fingroup):**
| Параметр | Значение |
|----------|----------|
| Сервер | pop.beget.com |
| Порт | 995 |
| SSL | Да |
| Логин | 1@fingroup.ru |

**SMTP (Send As):**
| Параметр | Значение |
|----------|----------|
| Сервер | smtp.beget.com |
| Порт | 465 |
| SSL | Да |
| Логин | 1@fingroup.ru |

**Примечания:**
- MX-записи переключены на Beget (2026-02-24)
- IMAP/POP3 работают через imap.beget.com / pop.beget.com
- Рекомендуется настроить catch-all (*@fingroup.ru → 1@fingroup.ru) в панели Beget

### 3. 1@credoserv.ru (Beget, рабочий)

Не подключён к Gmail-хабу. Используется напрямую через SMTP/IMAP.
| Параметр | Значение |
|----------|----------|
| SMTP | smtp.beget.com:465 (SSL) |
| IMAP | imap.beget.com:993 (SSL) |
| Логин | 1@credoserv.ru |

## API-доступ

### Google Workspace MCP

Все операции с Gmail доступны через MCP google-workspace:
- `search_gmail_messages` - поиск писем
- `get_gmail_message_content` - чтение письма
- `send_gmail_message` - отправка (с поддержкой Send As через `from_email`)
- `draft_gmail_message` - создание черновика
- `batch_modify_gmail_message_labels` - массовое управление метками
- `create_gmail_filter` / `delete_gmail_filter` - фильтры
- `list_gmail_labels` - список меток

### OAuth2

- Client: `/Users/mac/Documents/documentoved/credentials.json`
- Token: `/Users/mac/Documents/documentoved/secrets/token.json`
- Scopes: gmail.modify, gmail.send, gmail.labels и др.

## Метки Gmail (ключевые)

| Метка | ID | Назначение |
|-------|----|------------|
| AI/Tech | Label_21 | Технические рассылки |
| ЖКХ | (пользовательская) | Коммунальные платежи |
| galankin@yandex.ru | (автоматическая) | Почта с Яндекса |
| 1@fingroup.ru | (автоматическая) | Почта с fingroup |

## Результаты тестирования (2026-02-24)

| Маршрут | Статус |
|---------|--------|
| sofia@credoserv.ru → 5427611@gmail.com | Доставлено |
| 5427611@gmail.com → sofia@credoserv.ru | Доставлено |
| galankin@yandex.ru (Send As) → sofia@credoserv.ru | Доставлено |
| 5427611@gmail.com → galankin@yandex.ru | Доставлено |
| sofia@credoserv.ru → galankin@yandex.ru | Доставлено |

## Связанные документы

- Секреты: `.secrets/api-keys/ceo-email-credentials.json`
- Корпоративные почтовые ящики: `.secrets/mailbox_passwords.json`
- Скрипты: `scripts/check-corporate-email.sh`, `scripts/send-corporate-email.sh`
- Скилл Софьи: `docs/skills/check-corporate-email__20260218180000.md`
