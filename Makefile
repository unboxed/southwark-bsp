DOCKER-RUN = docker-compose run --rm
BUNDLE-EXEC = bundle exec

.DEFAULT_GOAL := up

build:
	docker-compose build

up:
	docker-compose up

prompt:
	$(DOCKER-RUN) web bash

guard:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) guard

db-prompt:
	$(DOCKER-RUN) db psql postgres://postgres:postgres@db

lint:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) rubocop
