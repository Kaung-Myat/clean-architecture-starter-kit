# Clean Architecture Starter Kit

A production-ready Flutter template built with **Clean Architecture** and **Riverpod** dependency injection. Use this template via the [`clean_frame`](https://pub.dev/packages/clean_frame) CLI — it scaffolds a fully named, ready-to-run project in seconds.

---

## Getting started

Install the CLI globally:

```bash
dart pub global activate clean_frame
```

Create a new project:

```bash
clean_frame -n my_app
```

With a custom organisation prefix:

```bash
clean_frame -n my_app -o com.yourcompany
```

With a specific template version:

```bash
clean_frame -n my_app -v v2.0.0
```

List all available template versions:

```bash
clean_frame -l
```

> Do not clone this repository directly. The app name throughout the project is the internal placeholder `clean_frame_starter`. The CLI replaces it with your chosen name automatically.

---

## Project structure (v2)

```
lib/
├── app/                        # App shell (no business logic)
│   ├── app.dart
│   ├── config/                 # colours, typography, theme
│   └── router/                 # GoRouter
│
├── core/                       # Cross-cutting infrastructure
│   ├── domain/                 # Shared domain types (e.g. PaginationMeta)
│   ├── env/                    # --dart-define Env
│   ├── errors/                 # Optional Failure types (unused by default)
│   ├── network/                # Dio, ApiService, routes, interceptors
│   ├── storage/                # SharedPreferences, SecureStorage
│   ├── utils/                  # extensions, formatters, validators, logger
│   └── widgets/                # low-level scaffolds / empty / error
│
├── features/
│   └── auth/
│       ├── di/                 # Feature-scoped Riverpod wiring
│       ├── data/
│       │   ├── datasources/    # ApiService (prod) + DemoAuth (DEMO_MODE)
│       │   ├── models/         # Freezed DTOs + toEntity()
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/       # Pure Dart + Equatable (no Freezed/JSON)
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           └── screens/
│
├── shared/widgets/             # App-wide UI kit
└── main.dart
```

Read **[ABOUT-ARCHI.md](./ABOUT-ARCHI.md)** for layering rules and feature checklist.

---

## Architecture highlights (v2)

| Rule | Detail |
|---|---|
| Dependencies | `presentation → domain ← data` (inward only) |
| Domain | Pure Dart entities — **no** Freezed / JSON / Flutter |
| Data | Freezed models, `ApiService` seam, `toEntity()` mappers |
| DI | Feature-scoped (`features/<f>/di/`) — `core/` never imports `features/` |
| Errors | Typed exceptions → Riverpod `AsyncError` (no `Either` by default) |
| Demo | `DEMO_MODE=true` (default) uses `DemoAuthRemoteDataSource` |

### Run against a real API

```bash
flutter run \
  --dart-define=DEMO_MODE=false \
  --dart-define=API_URL=https://api.example.com \
  --dart-define=ENV=dev
```

---

## Pre-installed packages

### State management and DI
| Package | Purpose |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` | State + DI |
| `riverpod_generator` | Code-gen providers |

### Data and networking
| Package | Purpose |
|---|---|
| `dio` | HTTP client |
| `freezed` + `json_serializable` | Immutable DTOs (data layer only) |
| `equatable` | Value equality for domain entities |

### Storage and utilities
| Package | Purpose |
|---|---|
| `shared_preferences` / `flutter_secure_storage` | Local + secure storage |
| `go_router` | Navigation |
| `logger` | Structured logging |

---

## Code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Manual step after project creation

Rename the Android Kotlin source directory if the CLI leaves the template path:

```
android/app/src/main/kotlin/com/example/clean_frame_starter/
                                          ↓
android/app/src/main/kotlin/com.example/your_app_name/
```

---

## Template versions

| Branch / tag | What's included |
|---|---|
| `v1.0.0` | Initial Clean Architecture + Riverpod + Dio + GoRouter |
| `v2.0.0` | Pure domain entities, feature-scoped DI, ApiService auth sample, `PaginationMeta` in domain, DEMO_MODE |

Run `clean_frame -l` to see the full list.

---

## License

MIT
