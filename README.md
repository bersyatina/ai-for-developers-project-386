### Hexlet tests and linter status:
[![Actions Status](https://github.com/bersyatina/ai-for-developers-project-386/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/bersyatina/ai-for-developers-project-386/actions)

# Календарь звонков

Учебный проект Hexlet (Design First) — упрощённый аналог Cal.com. Владелец календаря публикует типы событий, гость выбирает свободный 30-минутный слот (окно записи — 14 дней) и бронирует звонок. Авторизации нет: владелец — предустановленный профиль (админ-часть на `/admin`), гость бронирует без аккаунта.

## Стек

- **Backend:** Laravel 13 (PHP 8.3), JSON API, MySQL
- **Frontend:** Vue 3 + Vite + Tailwind 4 (отдельный SPA)
- **Контракт:** TypeSpec → `spec/openapi.yaml` (единый источник правды)
- **Деплой:** Docker (docker-compose: backend, frontend/nginx, mysql)

## Структура

```
spec/            TypeSpec API-контракт → spec/openapi.yaml
backend/         Laravel API
frontend/        Vue 3 SPA
docker/          Dockerfile'ы + nginx-конфиги
docker-compose.yml
Makefile         хаб команд
scripts/         dusk.ps1 / dusk.sh — запуск браузерных тестов
```

## Быстрый старт (Docker)

```bash
docker compose up --build
```

- Приложение (SPA): http://localhost:8080
- API (прямой доступ): http://localhost:8000/api/event-types
- Миграции применяются автоматически при старте backend (entrypoint ждёт готовности MySQL).

## Локальная разработка

Требуется PHP 8.3, Composer, Node 18+ и MySQL.

```bash
# Backend
cd backend
cp .env.example .env
# настроить DB_DATABASE=call_calendar (и создать БД)
composer install
php artisan key:generate
php artisan migrate
php artisan serve --port=8000   # API на :8000

# Frontend (в другом терминале)
cd frontend
npm install
npm run dev                     # SPA на :5173, проксирует /api на :8000
```

## Команды

```bash
make test      # PHPUnit (feature-тесты backend)
make dusk      # Dusk-тесты (браузерные; Windows: powershell -File scripts/dusk.ps1)
make build     # сборка frontend (dist/)
make migrate   # миграции backend
make tsp       # пересобрать spec/openapi.yaml из TypeSpec
```

## API

Публичные эндпоинты (без авторизации):

| Метод | Путь | Описание |
|---|---|---|
| GET | `/api/event-types` | Список типов событий (гость) |
| POST | `/api/event-types` | Создать тип события (владелец) |
| GET | `/api/event-types/{id}/slots?date=YYYY-MM-DD` | Свободные 30-минутные слоты дня |
| POST | `/api/bookings` | Записаться на слот (гость) |
| GET | `/api/bookings` | Предстоящие встречи (владелец) |

Правила: слоты по 30 минут 24/7, окно записи 14 дней, на одно время не может быть двух броней (даже для разных типов). Конфликт времени — `409`, вне окна/не кратно 30 — `422`.
