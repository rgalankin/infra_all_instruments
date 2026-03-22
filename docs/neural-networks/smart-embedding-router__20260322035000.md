---
id: smart-embedding-router__20260322035000
title: "Smart Embedding Router v2 — архитектура и маршруты"
summary: "Полная архитектура интеллектуального роутера embedding-запросов: failover между провайдерами, стэкинг ~69M бесплатных токенов, маршрутизация по задачам, анализ рисков. Обновлено с учётом Voyage AI (+200M), Novita AI, Cloudflare Workers AI, DashScope."
type: reference
status: active
tags: [ai/embedding, infra/architecture, process/optimization, ai/rag, infra/failover]
source: ai-research
ai_weight: high
created: 2026-03-22
updated: 2026-03-22
---
# Smart Embedding Router v2 — архитектура и маршруты

## Концепция

Smart Embedding Router — архитектурный паттерн для максимизации бесплатного использования embedding API путём:

1. **Стэкинга free tier** — регистрация на всех провайдерах с бесплатными квотами
2. **Failover-маршрутизации** — автоматическое переключение при исчерпании квот или ошибках
3. **Подсчёта токенов** — трекинг использования по каждому провайдеру
4. **Задачно-ориентированной маршрутизации** — выбор провайдера не только по цене, но и по типу задачи

---

## Полная карта провайдеров (2026-03-22)

### Qwen3-Embedding-8B провайдеры

| Провайдер | Бесплатных токенов | Тип квоты | Цена после | Маршрут из РФ | Риск санкций |
|-----------|:-----------------:|:---------:|:----------:|:-------------:|:------------:|
| Scaleway (EU) | 1M | Навсегда | €0.10/1M | Прямой | Средний |
| DashScope Singapore | 1M | 90 дней | $0.07/1M | Прямой | Низкий |
| DashScope Beijing | 1M | 90 дней | ~$0.007/1M | Прямой | Низкий |
| DeepInfra | ~36M ($1.80) | Разовый | $0.05/1M | US VPS | Высокий |
| SiliconFlow | ~20M ($1.00) | Разовый | $0.02–0.05/1M | Прямой | Низкий |
| Fireworks AI | ~10M ($1.00) | Разовый | $0.10/1M | US VPS | Высокий |
| OpenRouter | — | Платный | $0.01/1M | US VPS | Высокий |
| Ollama (локально) | ∞ | Постоянный | $0 | Локально | Нет |

**Итого Qwen3 free tier стэкинг: ~69M токенов + 1M навсегда (Scaleway) + ∞ локально**

### Дополнительные провайдеры (другие модели)

| Провайдер | Модель | Бесплатно | Тип | Маршрут | Качество RU |
|-----------|--------|:---------:|:---:|:-------:|:-----------:|
| Voyage AI | voyage-3, voyage-3.5 | 200M токенов | Разовый | VPN | 72/100 |
| Novita AI | BGE-M3 | Навсегда | Постоянный | VPN | 85/100 |
| SiliconFlow | BGE-M3 | Навсегда | Постоянный | Прямой | 85/100 |
| Google AI Studio | text-embedding-004 | 100 RPM | Постоянный | Прямой | 60/100 |
| Google AI Studio | gemini-embedding-001 | Free tier | Постоянный | Прямой | 65/100 |
| Cloudflare Workers AI | qwen3-embedding-0.6B | 10K Neurons/д | Постоянный | Прямой | ~70/100 |
| Jina AI | jina-embeddings-v3 | 1–10M токенов | Разовый | Прямой | 82/100 |

---

## Архитектура роутера

```
[Embedding Request]
        │
        ▼
  [Token Counter]  ──── подсчёт токенов, определение задачи
        │
        ▼
  [Task Classifier]
   ├─ "russian_text"  ──▶ приоритет Qwen3-8B
   ├─ "bulk_indexing" ──▶ DeepInfra / SiliconFlow (большие квоты)
   ├─ "sensitive_data"──▶ Ollama local only
   ├─ "edge_request" ──▶ Cloudflare Workers AI
   └─ "multilingual" ──▶ voyage-multilingual-2 или Qwen3-8B
        │
        ▼
  [Provider Selector] ──── выбор по приоритету и квотам
        │
   ┌────┴────┬──────┬──────┬──────┬──────┐
   ▼         ▼      ▼      ▼      ▼      ▼
[DashScope] [Scaleway] [DeepInfra] [SiliconFlow] [Fireworks] [Voyage AI]
(истекают   (1M        (~36M       (~20M          (~10M       (200M
 первыми)   навсегда)  кредит)     кредит)        кредит)     кредит)
   │         │          │           │              │            │
   └────┬────┴──────────┴───────────┴──────────────┘            │
        │                                                        │
        ▼                                                        ▼
   [OpenRouter]                                            [Novita/SiliconFlow]
   ($0.01/1M)                                              BGE-M3 (бесплатно)
        │                                                        │
        └──────────────────────┬─────────────────────────────────┘
                               │
                               ▼
                         [Ollama Local]
                         (последний резерв, всегда доступен)
```

---

## Маршруты по типам задач

| Задача | Первый выбор | Резерв | Причина |
|--------|-------------|--------|---------|
| **RAG для русских документов** | DashScope SG → DeepInfra | SiliconFlow → Scaleway | Qwen3-8B = лучший RU |
| **Пакетная индексация (>1M токенов)** | DeepInfra | SiliconFlow | Большие квоты, нет жёстких rate limits |
| **Штучные запросы / тестирование** | Scaleway | Google AI Studio | 1M навсегда, без истечения |
| **Чувствительные данные** | Ollama (локально) | — | Данные не покидают сервер |
| **Edge / мобильные** | Cloudflare Workers AI | Google AI Studio | Бесплатно, глобальный CDN |
| **Мультиязычный поиск (не RU)** | Voyage AI | jina-embeddings-v3 | 200M бесплатных токенов |
| **Production без бюджета** | Novita AI (BGE-M3) | SiliconFlow (BGE-M3) | Бесплатно навсегда |
| **Production с минимальным бюджетом** | OpenRouter ($0.01/1M) | Scaleway | Самый дешёвый Qwen3 |
| **Аварийный режим (все квоты исчерпаны)** | Ollama → OpenRouter | — | Всегда есть fallback |

---

## Приоритеты расходования free tier

### Логика: истекающее — первым

```
ПРИОРИТЕТ 1 (истекают через 90 дней):
  → DashScope Beijing  (1M токенов)
  → DashScope Singapore (1M токенов)
  Итого: 2M

ПРИОРИТЕТ 2 (разовые, не истекают):
  → DeepInfra  (~36M токенов, $1.80 кредит)
  → SiliconFlow (~20M токенов, $1.00 кредит)
  → Fireworks AI (~10M токенов, $1.00 кредит)
  Итого: ~66M

ПРИОРИТЕТ 3 (постоянные, экономить):
  → Scaleway  (1M навсегда, rate limit 50 req/day)
  → Novita AI (BGE-M3 навсегда)
  → Google AI Studio (100 RPM навсегда)

ПОСТОЯННЫЙ РЕЗЕРВ:
  → Ollama (∞, нужна GPU)

ПЛАТНЫЙ FALLBACK:
  → OpenRouter ($0.01/1M через US VPS)
```

---

## Сводная таблица free tier (все провайдеры)

| # | Провайдер | Модель | Бесплатных токенов | Срок | Тип |
|:-:|-----------|--------|:-----------------:|:----:|:---:|
| 1 | DashScope Beijing | Qwen3-Embedding-8B | 1M | 90 дней | Разовый |
| 2 | DashScope Singapore | Qwen3-Embedding-8B | 1M | 90 дней | Разовый |
| 3 | DeepInfra | Qwen3-Embedding-8B | ~36M | Пока не кончатся | Разовый |
| 4 | SiliconFlow (Qwen3) | Qwen3-Embedding-8B | ~20M | Пока не кончатся | Разовый |
| 5 | Fireworks AI | Qwen3-Embedding-8B | ~10M | Пока не кончатся | Разовый |
| 6 | Voyage AI | voyage-3 / voyage-3.5 | 200M | Пока не кончатся | Разовый |
| 7 | Jina AI | jina-embeddings-v3 | 1–10M | Пока не кончатся | Разовый |
| 8 | Scaleway | Qwen3-Embedding-8B | 1M | Навсегда | Постоянный |
| 9 | SiliconFlow (BGE) | BGE-M3 | ∞ | Навсегда | Постоянный |
| 10 | Novita AI | BGE-M3 | ∞ | Навсегда | Постоянный |
| 11 | Google AI Studio | text-embedding-004 | ~∞ (100 RPM) | Навсегда | Постоянный |
| 12 | Cloudflare Workers | qwen3-embedding-0.6B | ~∞ (10K N/day) | Навсегда | Постоянный |
| 13 | Ollama (локально) | Любая open-source | ∞ | Навсегда | Постоянный |

**Итого разовые квоты: ~268M+ токенов**
**Постоянные бесплатные ресурсы: ∞ (Ollama) + постоянные API с лимитами**

---

## Расчёт ёмкости: на сколько хватит

### Базовые метрики

- 1 страница A4 (русский) ≈ 700 токенов
- 1 чанк RAG (512 токенов) ≈ 350 слов
- 1 поисковый запрос ≈ 20–50 токенов

### Сценарии

| Сценарий | Объём | Токенов | Хватит на |
|----------|-------|:-------:|-----------|
| **Базовый RAG** | 100 документов × 10 стр. | ~700K | ~99 полных проектов |
| **Расширенный RAG** | 1000 документов × 10 стр. | ~7M | ~10 проектов |
| **Интенсивный RAG** | 10 000 документов × 10 стр. | ~70M | ~1 проект |
| **Семантический поиск** | 10K запросов/мес. | ~500K/мес. | ~11 лет |
| **Индексация KB** | 500 статей × 5 стр. | ~1.75M | ~39 индексаций |
| **Реиндексация ежемесячная** | 500 статей/мес. | ~1.75M/мес. | ~39 месяцев |

**Вывод:** для малого бизнеса (сотни документов, умеренный поиск) ~69M разовых токенов хватит на 1–3 года без каких-либо расходов. С Voyage AI (+200M) — на 3–7 лет.

---

## Маршруты из России

### Доступные напрямую

| Провайдер | Регион сервера | Доступность |
|-----------|---------------|:-----------:|
| DashScope Beijing | Китай | Прямой |
| DashScope Singapore | Сингапур | Прямой |
| SiliconFlow | Китай | Прямой |
| Scaleway | Франция / EU | Прямой |
| Google AI Studio | Глобальный | Прямой (возможно нужен VPN) |
| Cloudflare Workers AI | Edge / глобальный | Прямой |
| Jina AI | Глобальный | Прямой |
| Ollama | Локальный | Локально |

### Требуют US VPS / VPN

| Провайдер | Причина | Решение |
|-----------|---------|---------|
| DeepInfra | Гео-ограничение для РФ | Через US VPS (ISHosting) |
| Fireworks AI | Гео-ограничение для РФ | Через US VPS (ISHosting) |
| OpenRouter | Гео-ограничение для РФ | Через US VPS (ISHosting) |
| Voyage AI | Гео-ограничение для РФ | Через VPN / US VPS |
| Novita AI | Гео-ограничение для РФ | Через VPN |

> **Рекомендация:** Для US-ограниченных провайдеров использовать ISHosting USA VPS как egress proxy. API-запросы маршрутизируются через VPS, ответы возвращаются напрямую.

---

## Матрица санкционных рисков

| Провайдер | Юрисдикция | Риск блокировки | Риск санкций | Рекомендация |
|-----------|-----------|:---------------:|:------------:|--------------|
| DashScope Beijing/SG | Китай | Низкий | Низкий | Приоритет для критичных задач |
| SiliconFlow | Китай | Низкий | Низкий | Надёжный вариант |
| Scaleway | Франция/EU | Средний | Средний | Текущий основной |
| Jina AI | Германия | Средний | Средний | Допустимо |
| Google AI Studio | США | Высокий | Высокий | Только для некритичного |
| Cloudflare | США | Высокий | Высокий | Только edge/некритичное |
| DeepInfra | США | Высокий | Высокий | Через US VPS, расходовать быстрее |
| Fireworks AI | США | Высокий | Высокий | Через US VPS, расходовать быстрее |
| OpenRouter | США | Высокий | Высокий | Только платный fallback |
| Voyage AI | США | Высокий | Высокий | Расходовать 200M быстрее |
| Novita AI | США | Высокий | Высокий | Через VPN, для BGE-M3 |
| Ollama | Локально | Нет | Нет | Всегда безопасен |

### Стратегия минимизации рисков

1. **Критичные данные** — только через Ollama или китайские провайдеры
2. **Диверсификация** — иметь 3+ резервных провайдера
3. **Быстро расходовать US-квоты** — DeepInfra, Fireworks, Voyage AI использовать первыми (пока не заблокированы)
4. **Долгосрочная опора** — DashScope, SiliconFlow, Scaleway, Ollama
5. **Китайские провайдеры** — наименее подвержены санкционным рискам

---

## Псевдокод роутера

```python
class SmartEmbeddingRouter:
    """Роутер embedding-запросов с failover и трекингом квот."""

    PROVIDERS = [
        # (name, base_url, model, free_tokens, priority, requires_vpn)
        ("dashscope_sg",  "dashscope-intl.aliyuncs.com", "text-embedding-v4", 1_000_000, 1, False),
        ("dashscope_bj",  "dashscope.aliyuncs.com",       "text-embedding-v4", 1_000_000, 2, False),
        ("deepinfra",     "api.deepinfra.com/v1",         "Qwen/Qwen3-Embedding-8B", 36_000_000, 3, True),
        ("siliconflow",   "api.siliconflow.com/v1",       "Qwen/Qwen3-Embedding-8B", 20_000_000, 4, False),
        ("fireworks",     "api.fireworks.ai/inference/v1","Qwen/Qwen3-Embedding-8B", 10_000_000, 5, True),
        ("scaleway",      "api.scaleway.ai/v1",           "Qwen/Qwen3-Embedding-8B", 1_000_000,  6, False),
        ("openrouter",    "openrouter.ai/api/v1",         "qwen/qwen3-embedding-8b", 0,           7, True),
        ("ollama",        "localhost:11434",               "qwen3-embedding",         float("inf"), 8, False),
    ]

    def embed(self, text: str, task: str = "general") -> list[float]:
        # 1. Подсчёт токенов
        token_count = self.count_tokens(text)

        # 2. Выбор по типу задачи
        if task == "sensitive":
            return self._embed_via("ollama", text)

        # 3. Failover по приоритету
        for provider in self._sorted_by_priority(task):
            if self._has_quota(provider, token_count):
                try:
                    result = self._call_provider(provider, text)
                    self._deduct_quota(provider, token_count)
                    return result
                except ProviderError:
                    self._record_error(provider)
                    continue

        raise NoProvidersAvailable("Все провайдеры исчерпаны")

    def _sorted_by_priority(self, task: str) -> list:
        """Для русских текстов — DashScope первым (истекающая квота)."""
        providers = sorted(self.PROVIDERS, key=lambda p: p[5])  # by priority
        if task == "bulk":
            # Для пакетной обработки — сначала провайдеры с большими квотами
            providers = sorted(providers, key=lambda p: -p[4])
        return providers
```

---

## Трекинг использования

Для каждого провайдера отслеживать в `.secrets/embedding_usage.json`:

```json
{
  "siliconflow": {
    "total_tokens_used": 1250000,
    "free_quota_remaining": 18750000,
    "quota_expires_at": null,
    "last_request_at": "2026-03-22T03:50:00Z",
    "error_count": 0,
    "status": "active"
  },
  "dashscope_sg": {
    "total_tokens_used": 340000,
    "free_quota_remaining": 660000,
    "quota_expires_at": "2026-05-20T00:00:00Z",
    "last_request_at": "2026-03-22T02:15:00Z",
    "error_count": 0,
    "status": "active"
  }
}
```

---

## Rate Limits

| Провайдер | RPM | TPM | Дополнительно |
|-----------|:---:|:---:|----------------|
| Scaleway (free) | ~20 | — | 50 req/day на free tier |
| DashScope | 100 | — | 1000 RPD |
| DeepInfra | 60 | — | — |
| SiliconFlow | 60 | — | — |
| Fireworks AI | 60 | — | — |
| Google AI Studio | 100 | 1M | 1500 RPD |
| Cloudflare Workers AI | — | — | 10K Neurons/день |
| Ollama | ∞ | ∞ | Ограничено только оборудованием |

---

## Changelog

- **2026-02-18:** Создан v1 (в `/docs/infrastructure/`) — базовая архитектура, стратегия ~69M токенов, анализ рисков
- **2026-03-22:** Создан v2 (в `/docs/neural-networks/`) — добавлены Voyage AI (+200M), Novita AI, Cloudflare Workers AI, DashScope Beijing/Singapore, Task Classifier, псевдокод роутера, полная матрица рисков

## Links (internal)

- [[infra_all_instruments/docs/neural-networks/cards/qwen3-embedding-8b__20260220190000|Карточка: Qwen3-Embedding-8B (обновлена 2026-03-22)]]
- [[infra_all_instruments/docs/neural-networks/cards/qwen3-embedding-8b__20260218210000-01|Карточка: Qwen3-Embedding-8B (детальная с примерами кода)]]
- [[infra_all_instruments/docs/neural-networks/by-type/embedding__20260210220400-10|Embedding модели (индекс)]]
- [[infra_all_instruments/docs/neural-networks/cards/bge-m3__20260218190000-04|Карточка: BGE-M3]]
- [[infra_all_instruments/docs/infrastructure/smart-embedding-router__20260218220000-01|Smart Embedding Router v1 (стратегия стэкинга)]]
- [[infra_all_instruments/docs/infrastructure/vps-ishosting-usa__20260212220200-01|VPS ISHosting USA (для US-провайдеров)]]
- [[infra_all_instruments/docs/infrastructure/_index__20260210220000-03|Реестр инфраструктуры]]
