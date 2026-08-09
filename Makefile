.PHONY: test dusk build dev migrate tsp install

## Backend (PHPUnit, feature-тесты)
test:
	cd backend && php artisan test

## Миграции backend
migrate:
	cd backend && php artisan migrate

## Frontend (сборка в dist/)
build:
	cd frontend && npm run build

## Frontend dev-сервер (проксирует /api на backend, порт 8000)
dev:
	cd frontend && npm run dev

## TypeSpec → spec/openapi.yaml
tsp:
	cd spec && npx tsp compile .

## Dusk: браузерные тесты (backend + Vite поднимаются автоматически)
dusk:
	bash scripts/dusk.sh
