---
title: n8n
category: AI/автоматизации → workflow engine
version: unknown
status: active
criticality: very_high
updated: 2026-01-27
---

# n8n

## Основная информация

- **Категория:** AI/автоматизации → workflow engine
- **Версия:** (требуется уточнение, образ `n8nio/n8n:1.121.3` упоминался ранее)
- **Статус:** активно
- **Критичность:** очень высокая
- **Назначение:** автоматизация процессов, webhooks, интеграции, оркестрация workflows
- **Доступ:** `n8n.fingroup.ru` (через Traefik, TLS)

## Настройки

### Основные параметры
- Домен: `n8n.fingroup.ru`
- Healthcheck: `/healthz`
- Reverse proxy: Traefik (TLS termination)
- Образ Docker: `n8nio/n8n:1.121.3` (требуется актуализация)
- Статус: активно

### Версия и окружение
- Платформа: Docker контейнер на VPS Beget
- Режим работы: production
- Доступ: через HTTPS (Traefik)

## Workspaces

### Personal Workspace

**Назначение:** Workflows, credentials и data tables, принадлежащие пользователю

**Разделы:**
- **Workflows** - рабочие процессы
- **Credentials** - учетные данные для интеграций
- **Executions** - история выполнения workflows
- **Data tables** - таблицы данных

## Workflows

### Структура workflows

Workflows организованы в папки и отдельные файлы:

#### Папки

1. **Blink** (2 workflows)
   - `Chat (updated) (1).json` - чат workflow
   - `Webhook Message Minimal (1).json` - минимальный webhook workflow
   - Последнее обновление: 3-4 дня назад
   - Создано: 22-23 января

2. **Клиенты от Агентов** (3 workflows)
   - `ASR Submit (from n8n).json` - отправка в ASR
   - `Session Cleanup Cron.json` - очистка сессий по расписанию
   - `Telegram Lead Processor (2).json` - обработка лидов из Telegram
   - Последнее обновление: 1 неделя назад
   - Создано: 15 января
   - Теги: "транскрибация" (для ASR Submit)

#### Отдельные workflows

1. **Скорринг клиентов.json**
   - Последнее обновление: 6 дней назад
   - Создано: 16 января
   - Теги: "Битрикс24"
   - Статус: ✅ активен (зеленый индикатор)

2. **Bitrix24: Подсчет звонков по лидам.json**
   - Последнее обновление: 2 часа назад
   - Создано: 27 января
   - Статус: ✅ активен (зеленый индикатор)

3. **Telegram Webhook.json**
   - Последнее обновление: 1 неделя назад
   - Создано: 19 января
   - Статус: ✅ активен (зеленый индикатор)

### Статистика workflows

- **Всего workflows:** 8 (5 отдельных + 3 в папке "Клиенты от Агентов" + 2 в папке "Blink")
- **Активных:** минимум 3 (с зелеными индикаторами)
- **Неактивных:** минимум 1 ("Chat (updated)" с серым индикатором)
- **По категориям:**
  - Bitrix24: 2 workflows
  - Telegram: 2 workflows
  - Blink: 2 workflows
  - ASR/Транскрибация: 1 workflow
  - Cron/Очистка: 1 workflow

## Credentials

### Установленные credentials (8)

1. **Bitrix24 Credoserv Base URL**
   - Тип: Header Auth
   - Последнее обновление: 1 час назад
   - Создано: 27 января
   - Назначение: аутентификация в Bitrix24

2. **Header Auth account 3**
   - Тип: Header Auth
   - Последнее обновление: 5 дней назад
   - Создано: 22 января

3. **Header Auth account 2**
   - Тип: Header Auth
   - Последнее обновление: 1 неделя назад
   - Создано: 16 января

4. **Groq account**
   - Тип: Groq
   - Последнее обновление: 1 неделя назад
   - Создано: 15 января
   - Иконка: красный круг с "9"

5. **Postgres_telegram_leads**
   - Тип: Postgres
   - Последнее обновление: 1 неделя назад
   - Создано: 15 января
   - Иконка: синяя база данных
   - Назначение: база данных для Telegram лидов

6. **Header Auth account**
   - Тип: Header Auth
   - Последнее обновление: 1 неделя назад
   - Создано: 15 января

7. **OpenRouter account**
   - Тип: OpenRouter
   - Последнее обновление: 1 неделя назад
   - Создано: 14 января
   - Иконка: белая стрелка
   - Назначение: доступ к OpenRouter API

8. **Telegram account**
   - Тип: Telegram API
   - Последнее обновление: 1 неделя назад
   - Создано: 14 января
   - Иконка: синий самолетик
   - Назначение: интеграция с Telegram

### Типы credentials

- **Header Auth:** 4 credentials (Bitrix24 и другие сервисы)
- **Groq:** 1 credential (LLM API)
- **Postgres:** 1 credential (база данных)
- **OpenRouter:** 1 credential (LLM API)
- **Telegram API:** 1 credential (Telegram бот)

## Связи с другими компонентами

### Интеграции

- **Bitrix24**: обработка лидов, подсчет звонков
  - Тип связи: REST API через Header Auth
  - Credentials: Bitrix24 Credoserv Base URL, Header Auth accounts
  - Workflows: "Скорринг клиентов", "Bitrix24: Подсчет звонков по лидам"

- **Telegram**: получение и обработка лидов
  - Тип связи: Telegram API
  - Credentials: Telegram account
  - Workflows: "Telegram Webhook", "Telegram Lead Processor"

- **PostgreSQL**: хранение данных лидов
  - Тип связи: база данных
  - Credentials: Postgres_telegram_leads
  - Назначение: хранение данных о лидах из Telegram

- **ASR (faster-whisper)**: транскрибация аудио
  - Тип связи: API/webhook
  - Workflows: "ASR Submit (from n8n)"
  - Теги: "транскрибация"

- **Groq**: LLM API
  - Тип связи: API
  - Credentials: Groq account

- **OpenRouter**: LLM API
  - Тип связи: API
  - Credentials: OpenRouter account

- **blink.new**: интеграция с сайтом
  - Тип связи: webhook/авторизация
  - Workflows: "Chat (updated)", "Webhook Message Minimal"
  - Статус: в работе (нет финальной спецификации)

- **Dify**: LLM платформа (через VPS)
  - Тип связи: API
  - Назначение: использование LLM в workflows

### Зависимости

- Требует: VPS Beget, Docker, Traefik, PostgreSQL
- Используется в: все проекты автоматизации (Bitrix_Admin/, n8n_workflow/, vps/)

## Проблемы и замечания

- **Исторический инцидент:** был случай повреждения SQLite и восстановление
  - Решение: ежедневные бэкапы
  - Риск: потеря/повреждение данных workflows

- **blink.new интеграция:** нет финальной спецификации
  - Какие поля нужны
  - Тип авторизации
  - Что является секретом

- **Версия n8n:** требуется актуализация версии образа

## Потенциал улучшения

- Документировать структуру всех workflows
- Создать карту зависимостей между workflows
- Описать назначение каждого credential
- Документировать интеграции с внешними сервисами
- Настроить мониторинг выполнения workflows

## Скриншоты

### Personal Workspace
- Скриншот интерфейса Personal workspace: показывает вкладки Workflows, Credentials, Executions, Data tables

### Workflows
- Скриншот списка workflows: показывает папки (Blink, Клиенты от Агентов) и отдельные workflows с датами обновления и создания

### Credentials
- Скриншот списка credentials: показывает 8 credentials с типами, датами обновления и создания

## История изменений

- 2026-01-27: Создана детальная документация n8n с информацией о workflows, credentials и интеграциях
