PHONY: install dev build build-no-cache down stop workspace

CONTAINER_NAME=nextauth-api-sf

## Docker commands
install:
	sudo sysctl -w vm.max_map_count=262144
	cp .env .env.local
	@docker compose up -d --remove-orphans
	rm -rf var/log/*
	@docker exec -it ${CONTAINER_NAME} composer install
	@docker exec -it ${CONTAINER_NAME} php bin/console c:c

dev:
	sudo sysctl -w vm.max_map_count=262144
	@docker compose up -d --remove-orphans
	rm -rf var/log/*
	@docker exec -it ${CONTAINER_NAME} php bin/console c:c
# @docker exec -it ${CONTAINER_NAME} php bin/console d:m:m
# @docker exec -it ${CONTAINER_NAME} php bin/console d:f:l

build:
	docker rm -f ${CONTAINER_NAME} || true
	@docker compose build

build-no-cache:
	@docker compose build --no-cache

restart:
	@docker compose stop
	@docker compose build --no-cache
	@docker compose up -d

# clear cache
clear:
	symfony console c:c

charge-database:
	@docker exec -it ${CONTAINER_NAME} php bin/console d:m:m
	@docker exec -it ${CONTAINER_NAME} php bin/console d:f:l

migration:
	@docker exec -it ${CONTAINER_NAME} php bin/console make:migration

migrate-run:
	@docker exec -it ${CONTAINER_NAME} php bin/console d:m:m

stop:
	@docker compose stop

down:
	@docker compose down

workspace:
	@docker exec -it ${CONTAINER_NAME} bash

caddyfile:
	@docker exec -it ${CONTAINER_NAME} cat /etc/caddy/Caddyfile

############ Logs ########################################
logs:
	@docker compose logs -f webapp
