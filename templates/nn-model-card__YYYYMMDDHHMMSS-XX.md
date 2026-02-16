---
id: YYYYMMDDHHMMSS-XX
title: "[Название модели]"
summary: >
  [Краткое описание модели]
type: spec
status: active
tags: [ai/llm]
source: roman
ai_weight: normal
created: YYYY-MM-DD
updated: YYYY-MM-DD
model_family: "[Семейство]"
model_params: "[Параметры, e.g. 30B]"
quantization: "[Q4_K_M / F16 / etc.]"
size_gb: 0
russian_score: 0
speed_score: 0
provider: "[Компания]"
runtime: "[ollama-local / openrouter / groq / cloud]"
installed: false
used_in: []
---
# [Название модели]

## Основная информация

- **Семейство:** [Qwen3 / LLaMA / DeepSeek / etc.]
- **Параметры:** [30B / 8B / 1.5B]
- **Квантизация:** [Q4_K_M / F16 / etc.]
- **Размер:** [GB]
- **Провайдер:** [Alibaba/Qwen / Meta / DeepSeek / etc.]

## Оценки

| Критерий | Оценка (1-10) | Комментарий |
|---------|--------------|------------|
| Русский язык | [1-10] | [комментарий] |
| Скорость | [1-10] | [на iMac Pro / на VPS] |
| Качество кода | [1-10] | [если применимо] |
| Reasoning | [1-10] | [если применимо] |

## Где используется

| Инструмент | Роль | Настройки |
|-----------|------|----------|
| [Continue] | [chat/edit/apply] | [температура, токены] |
| [n8n] | [workflow] | [endpoint] |

## Рантайм

- **Где запускается:** [Ollama localhost:11434 / OpenRouter API / Groq API]
- **Установлена:** да/нет
- **Команда запуска:** `ollama run [model]` (если Ollama)
- **API endpoint:** [URL]

## Тип модели

- [[infra_all_instruments/docs/neural-networks/by-type/llm__20260210220000-01|LLM]] / VLM / Embedding / ASR / OCR / Image-gen

## Альтернативы

| Модель | Сравнение | Когда выбрать |
|--------|----------|--------------|
| [альтернатива] | [+/- по сравнению] | [сценарий] |

## Проблемы и замечания

- [Описание]

## Links (internal)

- [[infra_all_instruments/registry__20260210220000-01|Registry]]
- [[infra_all_instruments/docs/neural-networks/_index__20260210220000-05|Реестр нейросетей]]
- [[infra_all_instruments/docs/neural-networks/by-provider/PROVIDER__TS|Провайдер]]
- [[infra_all_instruments/docs/neural-networks/by-runtime/RUNTIME__TS|Рантайм]]

## История

- YYYY-MM-DD: Создана карточка
