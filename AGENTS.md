# AGENTS

<!-- AGENTOPS:BEGIN -->
## RULE SWITCHBOARD (TRI-STATE)
# TEMPLATE-VERSION: 2026-02-10-V5
# FORMAT: - [[<rule-ref>]] : <MODE> — <DESCRIPTION> | NOTES: <OPTIONAL>

- [[docops-core__20260209220613-01]] : true — базовые принципы DocOps | notes: 
- [[docops-standard__20260209220613-02]] : true — стандарт документации (YAML, ID, ссылки, атомарность, статусы) | notes: 
- [[docops-schema__20260209220613-03]] : true — YAML-схема и allowlist type/status/ai_weight | notes: 
- [[source-allowlist__20260209220613-04]] : true — допустимые значения source | notes: 
- [[agents-format__20260209220613-05]] : true — формат AGENTS.md и tri-state модель | notes: 
- [[adapters__20260209220613-06]] : auto — адаптеры под инструменты (Cursor/VSCode/ChatGPT) | notes: 
- [[readme-standard__20260210103631-01]] : true — требования к файлу README.md (БЕЗ YAML frontmatter) | notes: 
- [[architecture-standard__20260210103631-02]] : true — требования к файлу ARCHITECTURE.md (С YAML frontmatter) | notes: 
- [[placeholder-system__20260210103631-03]] : true — система заглушек с AI-инструкциями для инициализации | notes: 
- [[project-initialization__20260210103631-04]] : true — процесс инициализации новых проектов через bootstrap | notes: 
- [[ai-project-development-rules__20260210103631-05]] : true — правила поведения AI при развитии проекта | notes: 
- [[progressive-validation__20260210103631-06]] : true — непрерывная валидация актуальности документации | notes: 
- [[agents-vs-adapters__20260210103631-07]] : true — принципы разделения AGENTS.md и адаптеров | notes: 
- [[project-quality-metrics__20260210103631-08]] : true — метрики качества проекта и чеклисты | notes: 
- [[changelog-standard__20260210161929-01]] : auto — стандарт файла CHANGELOG.md (БЕЗ YAML, Keep a Changelog) | notes: 
<!-- AGENTOPS:END -->


## BOOTSTRAP METADATA
version: 2026-02-10-v5
exclude_from_context_analysis:
  - AGENTS.md
  - AI/*
  - AI/adapters__20260209220613-06.md
  - AI/agents-format__20260209220613-05.md
  - AI/agents-vs-adapters__20260210103631-07.md
  - AI/ai-project-development-rules__20260210103631-05.md
  - AI/architecture-standard__20260210103631-02.md
  - AI/changelog-standard__20260210161929-01.md
  - AI/docops-core__20260209220613-01.md
  - AI/docops-schema__20260209220613-03.md
  - AI/docops-standard__20260209220613-02.md
  - AI/placeholder-system__20260210103631-03.md
  - AI/progressive-validation__20260210103631-06.md
  - AI/project-initialization__20260210103631-04.md
  - AI/project-quality-metrics__20260210103631-08.md
  - AI/readme-standard__20260210103631-01.md
  - AI/source-allowlist__20260209220613-04.md
  - ARCHITECTURE.md
  - CLAUDE.md
  - README.md

context_analysis_instructions: >
  При анализе контекста проекта для заполнения заглушек (README.md, ARCHITECTURE.md)
  ИСКЛЮЧИТЬ файлы из exclude_from_context_analysis. Эти файлы созданы bootstrap-скриптом
  и не содержат контекста проекта. Анализировать только пользовательские файлы:
  код (src/, lib/, app/), конфигурацию (package.json, pyproject.toml), существующую документацию.

## PROJECT NOTES
- (optional)
