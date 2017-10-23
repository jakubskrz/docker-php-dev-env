include .env

.PHONY: build up halt shell composer-install composer-update

all: up

build:
	docker-compose --project-name $(PROJECT_NAME) build --no-cache

up:
	docker-compose --project-name $(PROJECT_NAME) up -d nginx

halt:
	docker-compose --project-name $(PROJECT_NAME) down

shell:
	docker-compose --project-name $(PROJECT_NAME) exec php bash

composer-install:
	docker-compose --project-name $(PROJECT_NAME) run --rm composer install

composer-update:
	docker-compose --project-name $(PROJECT_NAME) run --rm composer update
