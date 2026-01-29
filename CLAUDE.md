# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Southwark Building Safety Platform (BSP) — a Rails 8.0 application for managing building safety survey collection and administration. Public users complete multi-step building surveys; admins manage building records, review/approve surveys, and send notifications via GOV.UK Notify. Uses the GOV.UK Design System (govuk-frontend) for the UI.

**Stack:** Ruby 3.3.9, Rails 8.0.4, PostgreSQL 16, Node 22, esbuild, Dart Sass, Stimulus. Dockerized development environment.

## Common Commands

All development runs inside Docker. The Makefile wraps `docker compose run --rm web`:

```sh
make build          # Build Docker image
make up             # Start all services (web, db, workers, asset watchers)
make rspec          # Run all RSpec tests
make cucumber       # Run all Cucumber acceptance tests
make lint           # Run RuboCop
make brakeman       # Static security analysis
make bundle-audit   # Check gems for CVEs
make console        # Rails console
make migrate        # Run db:migrate
make prompt         # Bash shell in container
```

### Running individual tests

```sh
docker compose run --rm web rspec spec/models/building_spec.rb        # Single file
docker compose run --rm web rspec spec/models/building_spec.rb:15     # Single test by line
docker compose run --rm web cucumber features/admin/buildings.feature # Single feature
docker compose run --rm web cucumber features/admin/buildings.feature:25  # By line
docker compose run --rm web rubocop app/models/building.rb            # Lint single file
docker compose run --rm web rubocop -a                                # Auto-correct
```

### Database setup from scratch

```sh
docker compose run --rm web bundle exec rails db:setup
```

## Architecture

### Survey Form System (core domain)

**Key flow:** `SurveysController` → `Survey::Sections::<Stage>Form` → `Survey::Record`

- **Form classes** in `app/models/survey/sections/` extend `BaseForm` (ActiveModel, not ActiveRecord). Each handles its own validation and determines the next stage via `next_stage`.
- **`Survey::Record`** (`app/models/survey/record.rb`) persists all survey data in a single JSONB `data` column using `store_accessor`. One row per survey session.
- **`Survey::Stages`** (`app/models/survey/stages.rb`) defines the stage graph with allowed transitions and guards (e.g., must have a building before advancing past UPRN, must be completed before reaching check_your_answers).
- **`Survey::Staging`** manages stage/progress state. `Survey::Persistence` handles save logic. `Survey::Naming` maps stage names to form classes.
- **Materials** are managed inline during the survey via `Survey::Material`, `Survey::MaterialList`, and `Survey::NestedAttributes`.

### Building State Machine

Uses the **Statesman** gem. States: `not_contacted → contacted → received → accepted/rejected`. Tracked in `building_survey_transitions` table. Access via `building.survey_state`.

When a survey is completed (`Survey::Record#completed_at=`), it auto-transitions the building to `received`. Admins then accept or reject.

### Custom Type System

`lib/types/` contains custom ActiveRecord attribute types: `EnumType`, `CollectionType`, `ListType`, `ModelType`. These handle serialization of structured data within the JSONB survey data column.

### Notification System

Uses **GOV.UK Notify** (not standard Rails mailer) via `mail-notify` gem. `DeliverNotificationJob` handles async delivery. Webhook callbacks at `/callbacks/notification_statuses` update delivery status.

### Admin Interface

Namespaced under `Admin::` (`app/controllers/admin/`). Features: building CRUD (keyed by UPRN), survey review/accept/reject, CSV bulk import, CSV export (full and delta), letter sending, full-text search (Textacular).

### Key Model Relationships

- `Building` has_many `:surveys` (Survey::Record), has_one `:survey` (latest completed)
- `Building` has_many `:survey_transitions`, uses Statesman for state queries (`in_state`, `transition_to!`)
- `Building` identified by `uprn` (used as URL param via `to_param`)
- `Browseable` concern provides faceted filtering by survey state

### Routes

Public survey: `/survey/:section` (GET/POST). Admin: `/admin/*` with Devise auth. Buildings keyed by UPRN param.

## Testing

- **RSpec** (`spec/`): models, requests, system tests, exporters. Uses FactoryBot, Capybara with headless Chrome, Shoulda-matchers, Timecop, WebMock.
- **Cucumber** (`features/`): acceptance tests organized by survey section and admin features.
- Test helpers in `spec/support/` — notably `sign_in_helpers.rb` for admin auth in tests.

## CI

GitHub Actions (`.github/workflows/build.yml`) runs five parallel jobs on push/PR to main: bundle-audit, brakeman, rubocop, rspec, cucumber. All use PostgreSQL 16 service containers for test jobs.
