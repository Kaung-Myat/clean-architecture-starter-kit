# Clean Architecture Starter Kit

Production-ready Flutter template (**v2.3.0**, Dart SDK `>=3.8.0 <4.0.0`) built with **Clean Architecture** and **Riverpod**. Scaffold a named, ready-to-run app with the [`clean_frame`](https://pub.dev/packages/clean_frame) CLI — do not copy this repository by hand.

The shipped sample is a small app you can run immediately: email/Google auth, a bottom-nav shell (Home, Posts, Settings), a paginated posts flow (list, detail deep link, create form), dev/uat/prod flavors, EN + MY localization, and offline/error screens. Business rules stay in pure Dart. Flutter, Dio, and JSON stay outside `domain/`.

Layering rules and the "add a feature" checklist live in **[ABOUT-ARCHI.md](./ABOUT-ARCHI.md)**. Wiring real push notifications is **[docs/ENABLE_FCM.md](./docs/ENABLE_FCM.md)**.

---

## Getting started

Install the CLI, then create a project. The CLI replaces the placeholder package name `clean_frame_starter` with the name you pass to `-n`.

```bash
dart pub global activate clean_frame
clean_frame -n my_app
```

Pin a template version, or list the tags the CLI can fetch:

```bash
clean_frame -n my_app -v v2.3.0
clean_frame -l
```

### Run this repository

Use this only when you are changing the template itself. A new app should come from the CLI so the package name is rewritten.

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` sets `DEMO_MODE` to `true`, so auth and posts use in-memory demo datasources and the app runs with no API. UAT and prod files point `DEMO_MODE` at `false` and set placeholder `API_URL`s (`https://api-uat.example.com`, `https://api.example.com`) — replace those before expecting a real backend.

Cursor / VS Code launch configs **dev**, **uat**, and **prod** pass the same env files (`.vscode/launch.json`).

---

## What you get

| Area | In the template |
|---|---|
| Auth | Email + Google sign-in sample. Access token in secure storage drives routing. |
| Session | Signed out → `/auth`. Signed in on `/auth` → `/home`. |
| 401 | Refresh once, retry the request, otherwise sign out and open auth. Login skips this (`kSkip401Redirect`). |
| Shell | `StatefulShellRoute`: Home, Posts, Settings. Create-post and post detail sit above the shell. |
| Posts | Paginated list, `/posts/:id?highlight=true` with typed `PostDetailExtra`, create form with `FormFieldErrors.fromApi`. |
| Flavors | `env/{dev,uat,prod}.json` → `AppFlavor`, `Env`, `FlavorController`. |
| Async UI | `async.whenApp`: `NetworkException` → `OfflineScreen`, other errors → `ErrorScreen`. Reconnect triggers a refresh. |
| i18n | Slang, English + Myanmar. JSON in `lib/app/config/localization/i18n/`, generated `translations.g.dart`. |
| Push | Boilerplate only (`NoOpFcmService`). No `firebase_*` packages. |
| CI | GitHub Actions: `flutter analyze --fatal-infos` and `flutter test`. |

Routes (`lib/app/router/route_names.dart`): `/auth`, `/home`, `/posts`, `/posts/create`, `/posts/:id`, `/settings`.

---

## Project structure

```
lib/
├── main.dart                    # ProviderScope + TranslationProvider
├── app/                         # shell only — no business logic
│   ├── app.dart
│   ├── config/                  # theme, colors, Slang i18n, LocaleController
│   └── router/                  # auth redirect, shell, deep links
├── core/                        # cross-cutting — never imports features/
│   ├── auth/                    # SessionController
│   ├── domain/                  # PaginationMeta
│   ├── env/                     # AppFlavor, Env, FlavorController
│   ├── network/                 # Dio, ApiService, interceptors, token refresh
│   ├── services/                # connectivity, navigation, FCM boilerplate
│   ├── storage/                 # SharedPreferences, secure storage
│   ├── errors/                  # Failure (optional, unused by default)
│   ├── widgets/
│   └── utils/                   # whenApp, validators, infinite scroll, form errors
├── features/<feature>/
│   ├── di/                      # datasource → repository → usecase
│   ├── domain/                  # entity, I*Repository, usecase
│   ├── data/                    # Freezed model, datasource, repository impl
│   └── presentation/            # Riverpod controller, screens
└── shared/                      # MainWrapperScreen + shared widgets

env/{dev,uat,prod}.json
.vscode/launch.json
.github/workflows/ci.yml
```

Each feature follows the same cut. `posts` is the reference for lists, deep links, and form errors. `auth` is the reference for session and demo vs remote datasources.

Dependencies point inward only: `presentation → domain ← data`. Domain is pure Dart + Equatable — no Flutter, Freezed, JSON, or Dio. Datasources talk to `ApiService` only. Models map with `toEntity()` and never leave the data layer. Use cases and repositories let typed exceptions reach the notifier as `AsyncError` (no `Either` / `Failure` wrapper).

---

## Architecture highlights

| Rule | Detail |
|---|---|
| Dependencies | `presentation → domain ← data` |
| Domain | Equatable entities. No Freezed, JSON, or Flutter |
| Data | Freezed + `json_serializable` models, `ApiService`, `toEntity()` |
| DI | Feature-scoped `features/<f>/di/`. Repository providers are typed to `I*Repository` |
| Demo data | `Env.demoMode` selects `Demo*RemoteDataSource` (default **on** if unset) |
| Flavors | `FLAVOR`, `API_URL`, `APP_NAME`, `DEMO_MODE` via `--dart-define-from-file` |
| Session | Token present → GoRouter redirect. 401 → refresh → retry once → auth |
| Async UI | `async.whenApp` → `OfflineScreen` / `ErrorScreen` |
| Forms | `Validators` + `FormFieldErrors.fromApi` |
| Lists | `InfiniteScrollMixin` + `PaginationMeta` (posts sample) |
| Deep links | `/posts/:id?highlight=true` + `PostDetailExtra` |
| i18n | Slang (`context.t…`), `en` + `my` |
| FCM | Boilerplate only (`NoOpFcmService`) |
| CI | `flutter analyze --fatal-infos` + `flutter test` |

### Flavors

```bash
flutter run --dart-define-from-file=env/dev.json
flutter run --dart-define-from-file=env/uat.json
flutter run --dart-define-from-file=env/prod.json
```

| Define | Role |
|---|---|
| `FLAVOR` | `dev` / `uat` / `prod` → `AppFlavor` |
| `API_URL` | Dio `baseUrl`. Files ship with example hosts, not a live API |
| `APP_NAME` | `MaterialApp` title |
| `DEMO_MODE` | `true` → demo datasources. `false` → `*RemoteDataSourceImpl` + `ApiService` |
| `ENV` | Present on the env files; flavor selection uses `FLAVOR` |

`FlavorController` can switch flavor at runtime. That switch is disabled when the compile-time flavor is prod. Dio is rebuilt when the active flavor changes.

---

## Packages

Runtime:

| Area | Packages |
|---|---|
| State | `flutter_riverpod`, `riverpod_annotation` |
| Data | `dio`, `freezed_annotation`, `json_annotation`, `equatable` |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Nav / UX | `go_router`, `cupertino_back_gesture` |
| i18n | `slang`, `slang_flutter` |
| Network awareness | `connectivity_plus` |
| Logging | `logger` |

Codegen (dev): `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`, `slang_build_runner`. Tests use `mocktail`.

Firebase packages are not dependencies. Add them only when you follow `docs/ENABLE_FCM.md`.

---

## Code generation

Riverpod, Freezed, JSON, and Slang:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Slang alone (reads `slang.yaml`, writes `lib/app/config/localization/generated/`):

```bash
dart run slang
```

Generated `*.g.dart` and `*.freezed.dart` files belong to models and providers. Domain entities are handwritten.

Check the template the way CI does:

```bash
flutter analyze --fatal-infos
flutter test
```

---

## Adding a feature

Copy the shape in `features/auth` or `features/posts`. Short version:

1. `domain/` — entity, `I*Repository`, usecase.
2. `data/` — Freezed model (`fromJson` + `toEntity`), datasource via `ApiService`, repository impl.
3. Path constants in `core/network/api_routes.dart`.
4. `di/` — datasource → repository (interface) → usecase. Branch on `Env.demoMode` when you want an offline sample.
5. `presentation/` — `@riverpod` controller that calls the usecase, `ConsumerWidget` + `whenApp`.
6. Register the route in `lib/app/router/`.
7. `dart run build_runner build --delete-conflicting-outputs`, then analyze.

Full rules and the auth slice are in [ABOUT-ARCHI.md](./ABOUT-ARCHI.md).

---

## Template versions

| Tag | What's included |
|---|---|
| `v1.0.0` | Clean Architecture + Riverpod + Dio + GoRouter |
| `v2.0.0` | Pure domain, feature DI, ApiService auth, `DEMO_MODE` |
| `v2.1.0` | Slang i18n, connectivity, FCM boilerplate, iOS back gesture |
| `v2.2.0` | Flavors, session, shell nav, offline/error UI |
| `v2.3.0` | Token refresh, posts sample, form errors, deep links, CI, launch configs |

---

## License

MIT
