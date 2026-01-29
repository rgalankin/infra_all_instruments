---
title: Claude Desktop
category: AI → desktop client
version: unknown
status: active
criticality: medium/high
updated: 2026-01-27
---

# CLAUDE DESKTOP

## ОСНОВНАЯ ИНФОРМАЦИЯ

- **Категория:** AI → desktop client
- **Версия:** (требуется уточнение)
- **Статус:** активно
- **Критичность:** средняя/высокая
- **Назначение:** Desktop клиент для Claude AI с поддержкой MCP серверов, управление n8n через MCP

## НАСТРОЙКИ

### ОСНОВНЫЕ ПАРАМЕТРЫ
- Путь к конфигурации: `~/.config/claude/mcp.json` (предположительно, на macOS)
- Платформа: macOS
- Режим работы: production
- Тип: Desktop приложение для работы с Claude AI

### ВЕРСИЯ И ОКРУЖЕНИЕ
- Платформа: macOS
- Режим работы: production

## MCP (MODEL CONTEXT PROTOCOL) СЕРВЕРЫ

### УСТАНОВЛЕННЫЕ MCP СЕРВЕРЫ (3)

#### 1. MACUSE
- **Статус:** ✅ Установлен
- **Назначение:** Интеграция с Macuse/Cursor
- **Тип:** локальное приложение
- **Примечание:** Настраивается отдельно от основного конфига (не в mcp.json)

#### 2. MCP-N8N
- **Статус:** ✅ Running (активен)
- **Назначение:** Управление n8n через MCP tools
- **Команда:** `ssh`
- **Аргументы:**
  - `-i /Users/mac/.ssh/mcp_n8n_ed25519` (SSH ключ)
  - `roman@82.202.129.193` (пользователь и IP VPS)
  - `docker exec -i mcp-n8n /usr/local/bin/node /app/build/index.js` (команда в Docker контейнере)
- **Конфигурация:**
  - Подключение: SSH туннель к VPS Beget
  - Сервер: `82.202.129.193` (VPS Beget)
  - SSH пользователь: `roman`
  - SSH ключ: `/Users/mac/.ssh/mcp_n8n_ed25519`
  - Docker контейнер: `mcp-n8n`
  - Скрипт: `/app/build/index.js` (Node.js)
- **Тип:** remote MCP сервер через SSH туннель
- **Связи:** VPS Beget, n8n
- **Примечание:** В Claude Desktop работает (running), в отличие от Cursor, где показывал ошибку

#### 3. LINEAR
- **Статус:** ✅ Установлен
- **Назначение:** Интеграция с Linear (управление задачами и проектами)
- **Команда:** `npx`
- **Аргументы:**
  - `-y` (автоматическое подтверждение)
  - `mcp-remote@latest` (пакет)
  - `https://mcp.linear.app/sse` (endpoint)
- **Endpoint:** `https://mcp.linear.app/sse`
- **Переменные окружения:** нет (пустой объект `{}`)
- **Тип:** remote MCP сервер через npx (SSE)
- **Примечание:** Использует `mcp-remote@latest` вместо `mcp-remote` (как в Cursor)

## ИНТЕРФЕЙС УПРАВЛЕНИЯ MCP СЕРВЕРАМИ

### LOCAL MCP SERVERS

Claude Desktop предоставляет интерфейс для управления локальными MCP серверами:
- **Название:** "Local MCP servers"
- **Описание:** "Add and manage MCP servers that you're working on."
- **Функции:**
  - Просмотр списка серверов
  - Просмотр деталей каждого сервера
  - Редактирование конфигурации (кнопка "Edit Config")
  - Удаление серверов (иконка корзины)
  - Просмотр статуса (running/stopped/error)

### ДЕТАЛИ СЕРВЕРА

Для каждого сервера отображается:
- **Имя сервера**
- **Статус** (цветной индикатор: running/stopped/error)
- **Команда** (command)
- **Аргументы** (args) - полный список аргументов команды
- **Возможность удаления** (иконка корзины)

## СРАВНЕНИЕ С CURSOR

### ОБЩИЕ СЕРВЕРЫ

#### MCP-N8N
- **Cursor:** ⚠️ Ошибка подключения (красный индикатор)
- **Claude Desktop:** ✅ Running (синий индикатор)
- **Вывод:** В Claude Desktop сервер работает корректно, возможно проблема была специфична для Cursor или уже решена

#### LINEAR
- **Cursor:** ✅ Активен (25 tools)
- **Claude Desktop:** ✅ Установлен
- **Разница:** В Cursor используется `mcp-remote`, в Claude Desktop - `mcp-remote@latest`

### УНИКАЛЬНЫЕ СЕРВЕРЫ

- **Macuse:** присутствует в обоих, но настраивается по-разному
- **Cursor:** имеет больше серверов (10 vs 3 в Claude Desktop)
- **Claude Desktop:** фокус на управлении n8n и Linear

## СВЯЗИ С ДРУГИМИ КОМПОНЕНТАМИ

### ИНТЕГРАЦИИ

- **n8n**: управление workflows через MCP
  - Тип связи: MCP сервер через SSH
  - Протокол: MCP через SSH tunnel
  - Статус: ✅ работает в Claude Desktop

- **Linear**: управление задачами
  - Тип связи: MCP сервер
  - Протокол: MCP (SSE)
  - Endpoint: `https://mcp.linear.app/sse`

- **VPS Beget**: хостинг для mcp-n8n
  - Тип связи: SSH подключение
  - Сервер: `82.202.129.193`
  - Пользователь: `roman`
  - SSH ключ: `/Users/mac/.ssh/mcp_n8n_ed25519`

- **Macuse/Cursor**: интеграция через Macuse
  - Тип связи: локальное приложение
  - Назначение: связь между Claude Desktop и Cursor

### ЗАВИСИМОСТИ

- Требует: macOS, SSH доступ к VPS, Docker на VPS
- Используется для: управления n8n workflows через Claude AI

## ПРОБЛЕМЫ И ЗАМЕЧАНИЯ

- **Разница в статусе mcp-n8n:** В Cursor показывал ошибку, в Claude Desktop работает (running)
  - Возможные причины:
    - Разные конфигурации подключения
    - Проблема была решена между проверками
    - Различия в обработке SSH подключений между Cursor и Claude Desktop

- **Версия Claude Desktop:** не указана в документации (требуется уточнение)

- **Macuse настройка:** Macuse не включен в основной mcp.json, настраивается отдельно

## ПОТЕНЦИАЛ УЛУЧШЕНИЯ

- Добавить версию Claude Desktop в документацию
- Выяснить причину различий в статусе mcp-n8n между Cursor и Claude Desktop
- Документировать процесс настройки Macuse в Claude Desktop
- Описать использование MCP tools для управления n8n

## СКРИНШОТЫ

### LOCAL MCP SERVERS
- Скриншот интерфейса управления MCP серверами: показывает список серверов (Macuse, mcp-n8n, linear) и детали выбранного сервера mcp-n8n со статусом "running"

## ИСТОРИЯ ИЗМЕНЕНИЙ

- 2026-01-27: Создана детальная документация Claude Desktop с информацией о MCP серверах и сравнением с Cursor
