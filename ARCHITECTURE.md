---
id: 20260210103631-01
title: ARCHITECTURE — Project Name
summary: >
  Architecture and structure of the project.
  [AI: fill with brief description based on analysis]
type: spec
status: draft
tags: [docops/architecture, project/uncategorized]
source: ai-bootstrap
ai_weight: high
created: 2026-02-10
updated: 2026-02-10
placeholder: true
placeholder_version: 2026-02-10-v1
placeholder_instructions: >
  AI должна заполнить этот ARCHITECTURE.md на основе анализа проекта.

  АЛГОРИТМ:
  1. SCAN project tree (exclude bootstrap files from AGENTS.md)
  2. EXTRACT:
     - Directory structure (tree scan with descriptions)
     - Entry points (main files, key modules)
     - Technologies (from package manager files)
     - Key components (from src/ structure)
  3. ЗАПОЛНИТЬ секции:
     - Overview: краткое описание проекта и технологий
     - Directory Structure: структура из tree с назначением папок
     - Entry Points: main файлы с описанием
     - Technologies: детальный список технологий
     - Key Components: описание основных компонентов
  4. ФИНАЛИЗИРОВАТЬ: удалить placeholder: true, обновить status: draft → active
---
# ARCHITECTURE

## OVERVIEW

[AI: Fill with project description, main technologies, and architectural pattern]

**Main Technologies:**
- Technology 1
- Technology 2
- Technology 3

**Architectural Pattern:** [AI: Identify pattern - MVC, microservices, monolith, etc.]

**Target Audience:** Developers working on [AI: describe target audience]

## DIRECTORY STRUCTURE

```
/
├── src/                    # Source code
│   └── [AI: analyze and describe subdirectories]
├── docs/                   # Documentation
│   ├── ai/                # AI rules (rulepack from template)
│   └── [AI: other docs]
├── tests/                  # Tests
├── AGENTS.md               # AI agent configuration
├── CLAUDE.md               # Claude Code instructions
├── README.md               # Project description
└── ARCHITECTURE.md         # This document
```

### DIRECTORY PURPOSES

**src/** — application source code
- [AI: Describe subdirectories and their purposes]

**docs/** — documentation
- `ai/` — AI tool rules (copied from AgentOps template during bootstrap)
- [AI: Describe other documentation directories]

**tests/** — testing
- [AI: Describe test organization]

## ENTRY POINTS

**For developers:**
- [AI: Identify main entry points from code scan]

**For AI tools:**
- `AGENTS.md` — rule switchboard (tri-state modes)
- `CLAUDE.md` — Claude Code instructions
- `README.md` — general project context
- `ARCHITECTURE.md` — this document (structure and architecture)

**For testing:**
- [AI: Identify test entry points]

## HIGH-LEVEL ARCHITECTURE

[AI: Optionally add architecture diagram based on analysis]

## KEY COMPONENTS

[AI: Identify and describe 3-5 main components based on src/ structure]

### COMPONENT 1: [Name]
- **Purpose:** [Description]
- **Technologies:** [List]
- **Location:** `src/[path]/`

## DESIGN DECISIONS

[AI: Initially empty - will be filled during development when architectural decisions are made]

## CODE CONVENTIONS

[AI: Optionally extract from existing code style]

## DOCOPS/AGENTOPS INTEGRATION

This project follows the DocOps/AgentOps standard:

**Required files:**
- `AGENTS.md` — tri-state rule switchboard
- `CLAUDE.md` — Claude Code instructions
- `AI/` — rulepack (DocOps-Core, DocOps-Standard, DocOps-Schema, Source-Allowlist, Adapters)

**Documentation:**
- All `.md` files in `docs/` MUST contain YAML frontmatter (10 fields)
- File naming format: `name-slug__YYYYMMDDhhmmss-XX.md`
- Links: ONLY Obsidian format `[[file__ID|label]]`

## LINKS (INTERNAL)

- [[readme-standard|README-Standard]] — README.md standard
- [[architecture-standard|ARCHITECTURE-Standard]] — ARCHITECTURE.md standard (this document follows it)
- [[docops-standard|DocOps-Standard]] — full DocOps specification
- [[agents-format|AGENTS-Format]] — AGENTS.md format and tri-state modes

---

**Note:** This ARCHITECTURE.md was created using the [ARCHITECTURE-Standard](AI/architecture-standard.md). When changing project structure, ALWAYS update the Directory Structure and Entry Points sections, as well as the `updated` field in the YAML frontmatter.
