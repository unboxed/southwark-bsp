DOCKER-RUN = docker compose run --rm

.DEFAULT_GOAL := up

build:
	docker compose build

up:
	docker compose up || true

down:
	docker compose down

prompt:
	$(DOCKER-RUN) web bash

console:
	$(DOCKER-RUN) web rails console

migrate:
	$(DOCKER-RUN) web rails db:migrate

rollback:
	$(DOCKER-RUN) web rails db:rollback

db-prompt:
	$(DOCKER-RUN) web psql postgres://postgres:Ee56KRC39xzcVUiA@db

bundle-audit:
	$(DOCKER-RUN) web bundle-audit check --update

brakeman:
	$(DOCKER-RUN) web brakeman --no-pager

lint:
	$(DOCKER-RUN) web rubocop

rspec:
	$(DOCKER-RUN) web rspec

cucumber:
	$(DOCKER-RUN) web cucumber

rake:
	$(DOCKER-RUN) -e RAILS_ENV=test web rake
