# Rabt Mobile (Flutter)

A cross‑platform mobile app for activist job adverts. Guests can browse, volunteers can apply, organizations can post/manage adverts. Uses Riverpod, GoRouter, and a centralized API layer with switchable mock/API data sources.

## Tech stack
- Flutter 3.x, Dart null safety
- Riverpod (state), GoRouter (navigation)
- http, flutter_secure_storage, shared_preferences, flutter_dotenv
- json_serializable (models), google_fonts

## Run
```bash
flutter pub get
# Local mock data (default in .env.local)
flutter run

# Switch to real backend (set ENV and API_BASE_URL)
# assets/env/.env or .env.local
# ENV=production
# API_BASE_URL=https://your-backend
```

## Environments
- Env files: `assets/env/.env` (prod), `assets/env/.env.local` (local)
- Loaded in `lib/main.dart` (prefers `.env.local`)
- Toggle between Mock/API via `ENV`:
  - `ENV=local` → in-memory mock data sources
  - anything else → real API (`/api/v1/...`) with bearer token

## Project structure (high level)
```
lib/
  main.dart                 # App bootstrap: env, ProviderScope, themes, router
  router/                   # GoRouter config and route guards
  theme/                    # Light/Dark themes, tokens, ThemeMode provider
  services/                 # ApiService (HTTP, auth headers, form/json helpers)
  models/                   # json_serializable data models (aligned with BE)
  state/
    auth/                   # session, login/signup, auth repository
    jobs/                   # adverts repository (+mock/api), providers, pagination
    applications/           # applications repository (+mock/api)
    volunteer/              # volunteer repository (+mock/api)
    prefs/                  # user prefs (city, distance)
  screens/
    auth/                   # login, signup
    jobs/                   # list, filters bar, details
    organization/           # create job, my jobs
    volunteer/              # profile setup
    common/                 # settings (theme, prefs)
  widgets/                  # reusable UI: buttons, text fields, cards, chips, states
```

## Routing
Defined in `lib/router/app_router.dart` with role‑based shells and guards.
- Guest: `/login`, `/signup`, `/jobs`, `/jobs/:id`
- Volunteer shell: `/v/jobs`, `/v/profile`, `/v/settings`
- Organizer shell: `/o/my-jobs`, `/o/create-job`, `/o/settings`

## State management (Riverpod)
Key providers/controllers:
- `authControllerProvider` → session restore, login (BE), pending advert tracking
- `advertsRepositoryProvider` → list/fetch/create/close adverts (mock/api)
- `applicationsRepositoryProvider` → create/update applications (mock/api)
- `volunteerRepositoryProvider` → profile fetch/update (mock/api)
- `jobsFilterProvider`, `searchQueryProvider`, `pageProvider` → filters/search/pagination
- `userPrefsProvider` → city & distance preferences
- `themeControllerProvider` → light/dark mode (persisted)

## API layer
Centralized in `lib/services/ApiService`:
- Helpers: `get`, `post`, `put`, `postForm`, `authHeaders(token)`
- All API endpoints are prefixed with `/api/v1` (see backend `app/main.py`).

Repositories (mock/api switch via `ENV`):
- `AdvertsRepository` → `listAll({query})`, `getById`, `create`, `close`
  - API: `/api/v1/adverts` (query params), `/api/v1/adverts/:id`, `/api/v1/adverts/:id/close`
  - Mock: seeded adverts, supports filtering, search, pagination (pageSize=10)
- `ApplicationsRepository` → `create`, `updateStatus`
  - API: `/api/v1/applications`
- `VolunteerRepository` → `me`, `update` (PUT `/api/v1/volunteers/profile`)

## Models (aligned with backend schemas)
Located in `lib/models/` and generated with json_serializable.
- `advert.dart` → `AdvertResponse`, `OneOffAdvertDetails`, `RecurringAdvertDetails`, `RecurringDays`
- `application.dart` → `ApplicationResponse`
- `organizer.dart`, `volunteer.dart`, `skill.dart`, `user.dart`
- `enums.dart` → mirrors BE `enums.py` values (e.g., FrequencyType.oneOff/recurring)

## Theming & UI kit
- `theme/app_theme.dart` → Light/Dark tokens, Google Fonts, component themes
- Reusable widgets:
  - `AppButton` (primary/outline + sizes)
  - `AppTextField` (themed inputs)
  - `AppCard` (rounded, padded Card)
  - `IconTile` (accent icon container)
  - `BadgeChip` (pills for category/frequency/location/skills)
  - `State views` (`EmptyView`, `ErrorView`)
  - `JobCard` (summary row used in list)

## Screens (key flows)
- Auth
  - Login: email/password via `/api/v1/auth/login` (form fields: `username`, `password`)
  - Signup: (WIP) to call `/api/v1/volunteers/register` or `/api/v1/organizers/register`
- Jobs
  - List: filters (frequency, category, skills, time_commitment, time_of_day), search `q`, pagination
  - Detail: badges, one‑off/recurring sections, Apply button
- Organization
  - Create Job (MVP fields), My Jobs (list + Close)
- Volunteer
  - Profile setup (MVP), onboard gate before accessing `/v/*`
- Settings
  - Theme toggle, City + Distance preferences (used in listing queries)

## Filters, search, pagination
Query params built in `state/jobs/jobs_providers.dart`:
- `frequency`, `category`, `skills` (comma names), `time_commitment`, `time_of_day`
- `q` (search), `page`
- `city`, `distance` (from settings)

## Auth/session
- Session stored securely (`flutter_secure_storage`)
- Token applied to every request via `Authorization: Bearer <token>`
- Pending advert id saved to return guests back to intended job after signup

## Mock vs API
- `ENV=local` → in‑memory mock data (seeded adverts) for instant dev
- Otherwise, real backend endpoints; ensure `API_BASE_URL` points to server root hosting `/api/v1` routes

## Codegen
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next steps / TODO
- Backend signup (volunteer/organizer) wiring
- Organizer: edit advert, applicants list + status updates
- Volunteer: full profile fields + complete‑onboarding endpoint
- Error handling & empty/skeleton states everywhere
- In‑app environment selector
