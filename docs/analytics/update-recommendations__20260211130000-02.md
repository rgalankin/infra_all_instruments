---
id: 20260211130000-02
title: "Рекомендации по обновлениям"
summary: >
  Текущее состояние обновлений: 28 устаревших Homebrew-пакетов,
  версии Ollama-моделей, рекомендации по обновлению инструментов.
type: spec
status: active
tags: [content/analytics, ai/analysis, eng/maintenance]
source: claude-sonnet-4-5
ai_weight: normal
created: 2026-02-11
updated: 2026-02-11
---
# Рекомендации по обновлениям

> Дата анализа: 2026-02-11
> Источник: `inventory-check.sh`, `brew outdated`, системное сканирование

## Сводка

| Категория | Статус | Действие |
|----------|:------:|---------|
| Homebrew | 28 устаревших | `brew upgrade` |
| Ollama | Актуален (v0.15.5) | Мониторинг новых моделей |
| macOS приложения | Не проверялось | Проверить App Store |
| Документация | 29 приложений без карточек | Создать карточки |

## 1. Homebrew — 28 устаревших пакетов

### Критичные (влияют на безопасность/производительность)

| Пакет | Категория | Приоритет | Команда |
|-------|----------|:---------:|---------|
| gnutls | Безопасность (TLS) | Высокий | `brew upgrade gnutls` |
| nss | Безопасность (сертификаты) | Высокий | `brew upgrade nss` |
| libgcrypt | Безопасность (крипто) | Высокий | `brew upgrade libgcrypt` |
| p11-kit | Безопасность (PKCS#11) | Высокий | `brew upgrade p11-kit` |

### Важные (инструменты ежедневного использования)

| Пакет | Категория | Влияние |
|-------|----------|---------|
| fzf | Терминал | Fuzzy-поиск в shell |
| btop | Мониторинг | Системный монитор |
| lazydocker | Docker | Docker TUI |
| tmux | Терминал | Мультиплексор |
| rclone | Синхронизация | Бэкапы, bisync |
| zoxide | Навигация | Умный cd |
| uv | Python | Менеджер пакетов |
| claude-code | AI | Claude Code CLI |

### Библиотеки (обновятся автоматически)

| Пакеты | Примечание |
|--------|-----------|
| abseil, freetype, gettext, libarchive, libpng, libtiff, libx11, libxext, ncurses, pango, poppler, protobuf, utf8proc, zstd | Зависимости, обновятся при `brew upgrade` основных пакетов |

### Рекомендуемая команда

```bash
# Безопасное обновление всего
brew upgrade

# Или поэтапно — сначала безопасность
brew upgrade gnutls nss libgcrypt p11-kit

# Затем инструменты
brew upgrade fzf btop lazydocker tmux rclone zoxide uv claude-code
```

### После обновления

```bash
# Очистка старых версий
brew cleanup

# Проверка
brew doctor
```

## 2. Ollama-модели

### Текущее состояние

| Модель | Размер | Статус | Примечание |
|--------|--------|:------:|-----------|
| qwen3:30b | 18 GB | Актуальна | Основная для русского |
| qwen3-coder:30b | 18 GB | Актуальна | Кодинг |
| deepseek-r1:8b | 5.2 GB | Актуальна | Рассуждения |
| llama3.1:8b | 4.9 GB | Проверить | Есть llama3.2/3.3 |
| nomic-embed-text | 274 MB | Актуальна | Embeddings |
| qwen2.5-coder:1.5b-base | 986 MB | Проверить | Есть qwen3-coder |

### Рекомендации по моделям

| Действие | Модель | Причина |
|---------|--------|--------|
| Рассмотреть обновление | llama3.1:8b → llama3.3:8b | Улучшенное качество |
| Рассмотреть удаление | qwen2.5-coder:1.5b-base | Дублирует qwen3-coder:30b (если autocomplete не нужен) |
| Мониторить | DeepSeek R1 70B | Когда хватит RAM |
| Мониторить | Qwen3 VL | Мультимодальная, когда появится в Ollama |

### Ограничения iMac Pro 2017

- RAM: 32GB DDR4 ECC → максимальный размер модели ~30B Q4
- GPU: Vega 56 8GB → Metal inference, но медленнее чем Apple Silicon
- Больше 1 модели одновременно → swap, деградация производительности

## 3. macOS-приложения

### Требуют ручной проверки

| Инструмент | Текущая версия | Как проверить |
|-----------|---------------|--------------|
| Cursor | - | About → Check for Updates |
| Obsidian | v1.8.10 | About → Check for Updates |
| Docker Desktop | v29.1.3 | About → Check for Updates |
| Raycast | v1.104.5 | About → Check for Updates |
| Bitwarden | v2025.12.0 | About → Check for Updates |

### Автоматизация проверки

```bash
# Casks обновляются через brew
brew upgrade --cask

# Проверить, что в casks
brew list --cask
```

## 4. Пробелы в документации

### Незадокументированные приложения (из inventory-check.sh)

| Приложение | Приоритет карточки |
|-----------|:-----------------:|
| Codex (OpenAI) | Средний — AI CLI |
| WireGuard | Высокий — VPN инфраструктура |
| GitHub Desktop | Средний — Git GUI |
| Google Docs/Sheets/Slides | Низкий — веб-приложения |
| Obsidian Web Clipper | Низкий — расширение Obsidian |
| Saby/SBIS | Низкий — бухгалтерия |
| Mango Office | Низкий — колл-центр |
| Hedy | Низкий — образование |

## Расписание обновлений

| Частота | Действие | Команда |
|---------|---------|---------|
| Еженедельно | Проверка brew outdated | `brew outdated` |
| Ежемесячно | Обновление brew | `brew upgrade && brew cleanup` |
| Ежемесячно | Проверка новых моделей Ollama | `ollama list` + поиск обновлений |
| Ежеквартально | Аудит macOS-приложений | Ручная проверка версий |
| При выходе | Обновление безопасности | Немедленно |

---

## Links (internal)

- [[infra_all_instruments/docs/analytics/_index__20260210220000-09|Аналитика]]
- [[infra_all_instruments/docs/tools/homebrew__20260210220600-14|Homebrew]]
- [[infra_all_instruments/docs/tools/ollama__20260210220600-03|Ollama]]
- [[infra_all_instruments/docs/neural-networks/_index__20260210220000-05|Нейросети]]

## История

- 2026-02-11: Первичный аудит обновлений
