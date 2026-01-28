# MCP (Model Context Protocol) серверы

Документация всех установленных MCP серверов в Cursor, Warp и Claude Desktop.

## Обзор

### Cursor

**Всего установлено:** 10 MCP серверов  
**Активных:** 9  
**С ошибками:** 1 (n8n)

**Конфигурация:** `~/.cursor/mcp.json`

### Warp

**Всего установлено:** 5 MCP серверов  
**Активных:** 5  
**С ошибками:** 0

**Конфигурация:** (через интерфейс Warp)

### Claude Desktop

**Всего установлено:** 3 MCP серверов  
**Активных:** 3 (все running)  
**С ошибками:** 0

**Конфигурация:** `~/.config/claude/mcp.json` (предположительно, на macOS)

## Список серверов

### 1. macuse

- **Статус:** ✅ Активен
- **Tools:** 56 tools enabled
- **Назначение:** Интеграция с Macuse/Cursor
- **Команда:** `/Applications/Macuse.app/Contents/MacOS/macuse mcp`
- **Переменные окружения:** нет
- **Тип:** локальное приложение

### 2. github

- **Статус:** ✅ Активен
- **Tools:** 26 tools enabled
- **Назначение:** Интеграция с GitHub (репозитории, issues, PR, код)
- **Команда:** `npx -y @modelcontextprotocol/server-github`
- **Переменные окружения:**
  - `GITHUB_PERSONAL_ACCESS_TOKEN`: (требуется настройка)
- **Тип:** npm пакет

### 3. linear

- **Статус:** ✅ Активен
- **Tools:** 25 tools enabled
- **Назначение:** Интеграция с Linear (управление задачами и проектами)
- **Команда:** `npx -y mcp-remote https://mcp.linear.app/sse`
- **Endpoint:** `https://mcp.linear.app/sse`
- **Переменные окружения:** нет
- **Тип:** remote MCP сервер (SSE)

### 4. filesystem

- **Статус:** ✅ Активен
- **Tools:** 14 tools enabled
- **Назначение:** Работа с файловой системой базы знаний
- **Команда:** `npx -y @modelcontextprotocol/server-filesystem [путь]`
- **Рабочая директория:** `/Users/mac/Library/CloudStorage/GoogleDrive-5427611@gmail.com/Мой диск/00_БАЗА ЗНАНИЙ/kb_dev`
- **Переменные окружения:** нет
- **Тип:** npm пакет
- **Возможности:** чтение/запись файлов, поиск, создание директорий

### 5. bitrix24-docs

- **Статус:** ✅ Активен
- **Tools:** 4 tools enabled
- **Назначение:** Доступ к документации Bitrix24 (методы API, события, статьи)
- **Команда:** `npx -y mcp-remote https://mcp-dev.bitrix24.com/mcp`
- **Endpoint:** `https://mcp-dev.bitrix24.com/mcp`
- **Переменные окружения:** нет
- **Тип:** remote MCP сервер

### 6. brave-search

- **Статус:** ✅ Активен
- **Tools:** 2 tools enabled
- **Назначение:** Поиск в интернете через Brave Search API
- **Команда:** `npx -y @modelcontextprotocol/server-brave-search`
- **Переменные окружения:**
  - `BRAVE_API_KEY`: (требуется настройка)
- **Тип:** npm пакет

### 7. context7

- **Статус:** ✅ Активен
- **Tools:** 2 tools enabled
- **Назначение:** Доступ к актуальной документации библиотек и фреймворков
- **Команда:** `npx -y mcp-remote https://mcp.context7.com/mcp`
- **Endpoint:** `https://mcp.context7.com/mcp`
- **Переменные окружения:**
  - `CONTEXT7_API_KEY`: (настроен)
- **Тип:** remote MCP сервер

### 8. ssh

- **Статус:** ✅ Активен
- **Tools:** 2 tools enabled
- **Назначение:** SSH доступ к удаленным серверам
- **Команда:** `node [путь к mcp-ssh/dist/index.js]`
- **Конфигурация:**
  - SSH Host: `82.202.129.193` (VPS Beget)
  - SSH Port: `22`
  - SSH User: `roman`
  - SSH Key: `/Users/mac/.ssh/mcp_n8n_ed25519`
- **Переменные окружения:**
  - `SSH_HOST`: `82.202.129.193`
  - `SSH_PORT`: `22`
  - `SSH_USER`: `roman`
  - `SSH_PRIVATE_KEY_PATH`: `/Users/mac/.ssh/mcp_n8n_ed25519`
- **Тип:** локальный Node.js скрипт
- **Связи:** VPS Beget

### 9. warp

- **Статус:** ✅ Активен
- **Tools:** 3 tools enabled
- **Назначение:** Интеграция с Warp терминалом (задачи, workflows, агенты)
- **Команда:** `node [путь к mcp-warp/dist/index.js]`
- **Путь к скрипту:** `/Users/mac/Library/CloudStorage/GoogleDrive-5427611@gmail.com/Мой диск/00_БАЗА ЗНАНИЙ/kb_dev/vps/compose/mcp-warp/dist/index.js`
- **Переменные окружения:**
  - `WARP_API_KEY`: (настроен)
- **Тип:** локальный Node.js скрипт
- **Связи:** Warp терминал

### 10. n8n

- **Статус:** ⚠️ Ошибка подключения
- **Tools:** (неизвестно из-за ошибки)
- **Назначение:** Управление n8n workflows через MCP
- **Команда:** `ssh -i [ключ] roman@82.202.129.193 docker exec -i mcp-n8n /usr/local/bin/node /app/build/index.js`
- **Конфигурация:**
  - Подключение: SSH туннель к VPS
  - Сервер: `82.202.129.193` (VPS Beget)
  - Docker контейнер: `mcp-n8n`
  - SSH ключ: `/Users/mac/.ssh/mcp_n8n_ed25519`
  - SSH опции: `StrictHostKeyChecking=no`, `UserKnownHostsFile=/dev/null`
- **Переменные окружения:** нет
- **Тип:** remote MCP сервер через SSH туннель
- **Проблемы:**
  - Ошибка подключения (красный индикатор в интерфейсе)
  - Требует диагностики
- **Связи:** VPS Beget, n8n

## MCP серверы в Warp

### 1. GitHub

- **Статус:** ✅ Установлен и включен
- **Tools:** 40 tools available
- **Назначение:** Управление issues, проектами и кодом
- **Описание:** "Manage issues, projects and code."
- **Тип:** preset/popular server
- **Примечание:** Больше tools, чем в Cursor (40 vs 26)

### 2. Linear

- **Статус:** ✅ Установлен и включен
- **Tools:** 25 tools available
- **Назначение:** Инструменты управления проектами
- **Описание:** "Project management tools."
- **Тип:** preset/popular server
- **Примечание:** Такое же количество tools, как в Cursor (25)

### 3. Playwright

- **Статус:** ✅ Установлен и включен
- **Tools:** 22 tools available
- **Назначение:** Автоматизация браузера и тестирование
- **Тип:** preset/popular server
- **Примечание:** Уникальный для Warp (нет в Cursor)

### 4. Notion

- **Статус:** ✅ Установлен и включен
- **Tools:** 12 tools available
- **Назначение:** Получение документации из Notion
- **Описание:** "Retrieve documentation on Notion."
- **Тип:** preset/popular server
- **Примечание:** Уникальный для Warp (нет в Cursor)

### 5. Context7

- **Статус:** ✅ Установлен и включен
- **Tools:** 2 tools available
- **Назначение:** Доступ к актуальной документации библиотек и фреймворков
- **Тип:** preset/popular server
- **Примечание:** Такое же количество tools, как в Cursor (2)

### Доступные для добавления

#### Figma

- **Статус:** Доступен для добавления (Shared from Warp)
- **Назначение:** Чтение дизайнов Figma
- **Описание:** "Read Figma designs."
- **Тип:** shared from Warp
- **Действие:** можно добавить через кнопку "+ Add"

## Статистика

### Cursor MCP серверы

#### По типу подключения

- **Локальные приложения:** 1 (macuse)
- **npm пакеты:** 3 (github, filesystem, brave-search)
- **Remote MCP серверы:** 4 (linear, bitrix24-docs, context7)
- **Локальные Node.js скрипты:** 2 (ssh, warp)

#### По количеству tools

- **Больше всего tools:** macuse (56), github (26), linear (25)
- **Среднее количество:** filesystem (14)
- **Мало tools:** bitrix24-docs (4), warp (3), brave-search (2), context7 (2), ssh (2)

#### По статусу

- **Активны:** 9 серверов
- **С ошибками:** 1 сервер (n8n)

### Warp MCP серверы

#### По количеству tools

- **Больше всего tools:** GitHub (40), Linear (25), Playwright (22)
- **Среднее количество:** Notion (12)
- **Мало tools:** Context7 (2)

#### По статусу

- **Активны:** 5 серверов
- **С ошибками:** 0 серверов

### Сравнение Cursor и Warp

#### Общие серверы

- **GitHub:** Cursor (26 tools) vs Warp (40 tools) - в Warp больше возможностей
- **Linear:** одинаково (25 tools в обоих)
- **Context7:** одинаково (2 tools в обоих)

#### Уникальные для Cursor

- macuse, filesystem, bitrix24-docs, brave-search, ssh, warp, n8n

#### Уникальные для Warp

- Playwright, Notion

#### Доступные для добавления

- **Figma:** доступен в Warp (shared from Warp)

## MCP серверы в Claude Desktop

### 1. mcp-n8n

- **Статус:** ✅ Running (активен)
- **Назначение:** Управление n8n через MCP tools
- **Команда:** `ssh`
- **Аргументы:**
  - `-i /Users/mac/.ssh/mcp_n8n_ed25519` (SSH ключ)
  - `roman@82.202.129.193` (пользователь и IP VPS)
  - `docker exec -i mcp-n8n /usr/local/bin/node /app/build/index.js` (команда в Docker)
- **Конфигурация:**
  - Подключение: SSH туннель к VPS Beget
  - Сервер: `82.202.129.193`
  - SSH пользователь: `roman`
  - SSH ключ: `/Users/mac/.ssh/mcp_n8n_ed25519`
  - Docker контейнер: `mcp-n8n`
  - Скрипт: `/app/build/index.js`
- **Тип:** remote MCP сервер через SSH туннель
- **Связи:** VPS Beget, n8n
- **Примечание:** В Claude Desktop работает (running), в отличие от Cursor, где показывал ошибку

### 2. linear

- **Статус:** ✅ Установлен
- **Назначение:** Интеграция с Linear (управление задачами и проектами)
- **Команда:** `npx`
- **Аргументы:**
  - `-y` (автоматическое подтверждение)
  - `mcp-remote@latest` (пакет)
  - `https://mcp.linear.app/sse` (endpoint)
- **Endpoint:** `https://mcp.linear.app/sse`
- **Переменные окружения:** нет
- **Тип:** remote MCP сервер через npx (SSE)
- **Примечание:** Использует `mcp-remote@latest` вместо `mcp-remote` (как в Cursor)

### 3. Macuse

- **Статус:** ✅ Установлен
- **Назначение:** Интеграция с Macuse/Cursor
- **Тип:** локальное приложение
- **Примечание:** Настраивается отдельно от основного конфига (не в mcp.json)

## Сравнение всех инструментов

### Общие серверы

#### mcp-n8n
- **Cursor:** ⚠️ Ошибка подключения
- **Claude Desktop:** ✅ Running
- **Вывод:** Работает в Claude Desktop, проблема была специфична для Cursor или решена

#### linear
- **Cursor:** ✅ Активен (25 tools, `mcp-remote`)
- **Warp:** ✅ Активен (25 tools)
- **Claude Desktop:** ✅ Установлен (`mcp-remote@latest`)
- **Разница:** В Claude Desktop используется `@latest` версия пакета

#### Macuse
- **Cursor:** ✅ Активен (56 tools)
- **Claude Desktop:** ✅ Установлен
- **Примечание:** Настраивается по-разному в каждом инструменте

### Уникальные серверы

#### Только в Cursor (10 серверов)
- macuse, filesystem, bitrix24-docs, brave-search, ssh, warp, github (26 tools), n8n (ошибка)

#### Только в Warp (5 серверов)
- GitHub (40 tools), Linear (25 tools), Playwright (22 tools), Notion (12 tools), Context7 (2 tools)

#### Только в Claude Desktop (3 сервера)
- mcp-n8n (running), linear, Macuse

### Статистика по инструментам

- **Cursor:** 10 серверов, 9 активных, 1 ошибка
- **Warp:** 5 серверов, все активны
- **Claude Desktop:** 3 сервера, все running

## Интеграции

### С внешними сервисами

- **GitHub** - управление кодом
- **Linear** - управление задачами
- **Bitrix24** - документация CRM
- **Brave Search** - поиск в интернете
- **Context7** - документация библиотек

### С локальной инфраструктурой

- **Filesystem** - база знаний `kb_dev`
- **SSH** - VPS Beget (82.202.129.193)
- **Warp** - терминал
- **n8n** - автоматизация (через VPS)

## Проблемы

### n8n MCP сервер

**Симптомы:**
- Красный индикатор статуса в интерфейсе Cursor
- Ошибка подключения

**Возможные причины:**
1. Проблемы с Docker контейнером `mcp-n8n` на VPS
2. Сетевые проблемы (SSH туннель)
3. Проблемы с SSH ключом
4. Контейнер не запущен или упал

**Диагностика:**
1. Проверить статус контейнера на VPS: `docker ps | grep mcp-n8n`
2. Проверить логи контейнера: `docker logs mcp-n8n`
3. Проверить SSH подключение: `ssh -i /Users/mac/.ssh/mcp_n8n_ed25519 roman@82.202.129.193`
4. Проверить доступность контейнера: `docker exec -i mcp-n8n /usr/local/bin/node /app/build/index.js`

## Рекомендации

1. **Диагностировать и исправить** ошибку подключения n8n MCP сервера
2. **Настроить API keys** для серверов, которые их требуют (github, brave-search)
3. **Документировать использование** каждого MCP сервера в соответствующих проектах
4. **Мониторить производительность** MCP серверов

## Связи с другими компонентами

### Cursor

- **Cursor** - основной IDE, где установлены MCP серверы
- **VPS Beget** - хостинг для n8n MCP сервера
- **Warp** - интегрирован через MCP сервер (3 tools)
- **GitHub** - интегрирован через MCP сервер (26 tools)
- **Linear** - интегрирован через MCP сервер (25 tools)
- **Bitrix24** - интегрирован через MCP сервер (4 tools)

### Warp

- **Warp** - терминал с AI-агентами, где установлены MCP серверы
- **GitHub** - интегрирован через MCP сервер (40 tools)
- **Linear** - интегрирован через MCP сервер (25 tools)
- **Notion** - интегрирован через MCP сервер (12 tools)
- **Playwright** - интегрирован через MCP сервер (22 tools)
- **Context7** - интегрирован через MCP сервер (2 tools)
- **Figma** - доступен для добавления (shared from Warp)

### Claude Desktop

- **Claude Desktop** - Desktop клиент для Claude AI с поддержкой MCP серверов
- **n8n** - интегрирован через MCP сервер mcp-n8n (через SSH туннель к VPS)
- **Linear** - интегрирован через MCP сервер (через `mcp-remote@latest`)
- **Macuse** - интегрирован через локальное приложение
- **VPS Beget** - хостинг для mcp-n8n сервера (SSH подключение)

## История изменений

- 2026-01-27: Создана документация всех MCP серверов в Cursor
- 2026-01-27: Добавлена документация MCP серверов в Warp
- 2026-01-27: Добавлена документация MCP серверов в Claude Desktop
