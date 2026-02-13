---
id: 20260210161929-01
title: CHANGELOG-Standard — требования к файлу CHANGELOG.md
summary: >
  Стандарт для файла CHANGELOG.md: фиксированное имя, формат Keep a Changelog v1.1.0, БЕЗ YAML frontmatter, ISO-даты вместо SemVer, placeholder через HTML-комментарии.
type: spec
status: active
tags: [docops/agentops, docops/standards, docops/changelog]
source: claude-opus-4-6
ai_weight: high
created: 2026-02-10
updated: 2026-02-10
---
# CHANGELOG-STANDARD

## 1) НАЗНАЧЕНИЕ

`CHANGELOG.md` — tool-entry файл с фиксированным именем, фиксирующий историю изменений проекта в структурированном виде. Формат основан на [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/).

**Ценность для AI-инструментов:**
- Показывает эволюцию проекта (какие проблемы решались и когда)
- Предотвращает регрессии (AI видит, что уже исправлялось)
- Компактнее git log (структурированная информация за меньше токенов)
- Показывает breaking changes и deprecated функции

---

## 2) ПРАВИЛА

### 2.1 Фиксированное имя
Файл ОБЯЗАН называться `CHANGELOG.md` (UPPERCASE).

### 2.2 YAML Frontmatter — ЗАПРЕЩЁН
`CHANGELOG.md` НЕ ДОЛЖЕН содержать YAML frontmatter (аналогично README.md).

### 2.3 Формат — Keep a Changelog v1.1.0
Категории: Added, Changed, Deprecated, Removed, Fixed, Security.
Для docs-проектов: упрощённый набор Added/Changed/Removed.

### 2.4 Версионирование
ISO-даты `[YYYY-MM-DD]` вместо SemVer. Секция `[Unreleased]` всегда вверху.

### 2.5 Placeholder
HTML-комментарии (как README.md). AI заполняет на основе `git log`.

---

## 3) AI-ИНСТРУКЦИИ ДЛЯ ЗАПОЛНЕНИЯ

1. READ `git log --oneline`
2. GROUP коммиты по категориям Keep a Changelog
3. DETERMINE логические версии (по тегам или датам)
4. FORMAT по стандарту Keep a Changelog
5. FINALIZE — удалить HTML-комментарии placeholder

---

## LINKS (INTERNAL)

- [[readme-standard__20260210103631-01|README-Standard]] — аналогичный стандарт для README.md
- [[architecture-standard__20260210103631-02|ARCHITECTURE-Standard]] — стандарт ARCHITECTURE.md
- [[placeholder-system__20260210103631-03|Placeholder-System-Standard]] — система placeholder
- [[adapters__20260209220613-06|Adapters]] — таблица tool-entry файлов
