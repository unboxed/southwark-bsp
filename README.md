# Southwark Building Safety Platform (BSP)

## Getting started

### Building the services

```sh
docker compose build
```

### Setting up the database

```sh
docker compose run --rm web bundle exec rails db:setup
```

### Run the services

```sh
docker compose up
```

## Deploying

The project is hosted on Heroku.

The `main` branch is automatically deployed to the staging environments.

**production is deployed manually**.
