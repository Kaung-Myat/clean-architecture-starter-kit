# ABOUT-ARCHI — Clean Architecture + Riverpod (v2.3)

Blueprint for scaffolding features and new projects from this kit.

> Stack shipped in **v2.3.0**: Flutter · Riverpod · Dio · GoRouter ·
> Freezed + json_serializable (data only) · Equatable (domain) ·
> SharedPreferences / flutter_secure_storage · Slang (EN/MY) ·
> connectivity_plus · cupertino_back_gesture · FCM **boilerplate**
> (no Firebase deps) · Material 3 · flavors via
> `--dart-define-from-file=env/{dev,uat,prod}.json` · SessionController ·
> token refresh on 401 · `whenApp` offline/error UI · bottom-nav shell ·
> posts sample (pagination + deep links + form field errors) · CI ·
> VS Code launch configs.

Optional later: real Firebase/FCM (see `docs/ENABLE_FCM.md`), Hive,
permission/location services.

---

## 1. Layering model

Clean Architecture, **feature-first**. Dependencies point **inward only**
(`presentation → domain ← data`). Domain knows nothing about Flutter, Dio, or JSON.

```
lib/
├── app/                         # App shell + global config (no business logic)
│   ├── app.dart
│   ├── config/theme/
│   ├── config/localization/     # Slang source JSON + generated + LocaleController
│   └── router/
│
├── core/                        # Cross-cutting — NEVER imports features/
│   ├── auth/                    # SessionController (token presence)
│   ├── domain/                  # Shared domain types (PaginationMeta, …)
│   ├── env/                     # AppFlavor, Env, FlavorController
│   ├── services/                # connectivity, FCM boilerplate, navigation
│   ├── errors/                  # Optional Failure (unused by default)
│   ├── network/                 # Dio, ApiService, routes, interceptors, mappers
│   ├── storage/
│   ├── utils/                   # whenApp, reconnect refresh
│   └── widgets/
│
├── features/<feature>/
│   ├── di/                      # datasource → repository → usecase providers
│   ├── data/
│   │   ├── datasources/         # Talk to ApiService only (or Demo* for kit)
│   │   ├── models/              # Freezed DTOs + toEntity()
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/            # Pure Dart + Equatable
│   │   ├── repositories/        # abstract interface class I*Repository
│   │   └── usecases/
│   └── presentation/
│       ├── providers/
│       ├── screens/
│       └── widgets/
│
└── shared/widgets/
```

### Dependency rules (enforce these)

- `domain/` imports **nothing** from `data/` or `presentation/`, and nothing
  Flutter / Dio / JSON / Freezed. Only pure Dart + Equatable + other domain /
  `core/domain` types.
- `data/` implements `domain` interfaces; may import `core/network`,
  `core/storage`. Maps DTOs → entities; **never leak a model/DTO upward**.
- `presentation/` depends on `domain` (entities + usecases) and **feature**
  `di/` providers. It never touches `data/` directly.
- `core/` and `shared/` never import from `features/`.
- Feature DI lives in `features/<f>/di/` (not `core/di`) so the import rule holds.
- Prefer **relative imports** inside `lib/` (`prefer_relative_imports`).

---

## 2. Auth vertical slice (canonical)

Copy this shape for every new feature.

**Domain — entity** (Equatable, no Freezed):

```dart
class UserEntity extends Equatable {
  const UserEntity({required this.id, required this.email, /* … */});
  final String id;
  final String email;
  UserEntity copyWith({…}) => …;
  @override
  List<Object?> get props => [id, email, …];
}
```

**Domain — repository interface:**

```dart
abstract interface class IAuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
}
```

**Domain — usecase** (one action; `call(...)`):

```dart
class LoginWithEmailUseCase {
  const LoginWithEmailUseCase({required IAuthRepository repository})
      : _repository = repository;
  final IAuthRepository _repository;
  Future<UserEntity> call(String email, String password) =>
      _repository.signInWithEmail(email, password);
}
```

Skip pass-through usecases when they only forward a single repository call
and add no orchestration — keep them when they coordinate multiple steps.

**Data — model** (Freezed + json + `toEntity`):

```dart
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({required String id, /* … */}) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) => …;
  UserEntity toEntity() => UserEntity(id: id, /* … */);
}
```

**Data — datasource** (only place that calls `ApiService`):

```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiService apiService});
  // post(ApiRoutes.login, …) → UserModel.fromJson
}
```

**Demo swap:** when `Env.demoMode == true`, DI selects
`DemoAuthRemoteDataSource` (same interface, no network) so the kit runs offline.

**Data — repository impl** (thin; may persist tokens via `SecureStorage`):

```dart
class AuthRepositoryImpl implements IAuthRepository {
  // remote → persist tokens → toEntity()
}
```

**Error handling:** usecases/repositories do **not** wrap in `Either`/`Failure`.
Typed exceptions propagate to the notifier → `AsyncError`.

---

## 3. Dependency injection — feature-scoped

```dart
// features/auth/di/auth_providers.dart
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (Env.demoMode) return DemoAuthRemoteDataSource();
  return AuthRemoteDataSourceImpl(apiService: ref.watch(apiServiceProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});
```

Rules:

- Repository provider is typed to the **interface** (`I*Repository`).
- Composition-root overrides (e.g. `SharedPreferences`) happen in `main.dart`
  `ProviderScope.overrides`.

---

## 4. App bootstrap

```dart
runApp(
  ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp(),
  ),
);
```

`MyApp` watches theme + router providers.

---

## 5. Network layer (`core/network/`)

```
dio_client.dart
api_service.dart          # single seam for data sources
api_routes.dart
interceptors/             # logger, auth (bearer)
exceptions/               # ApiException, NetworkException, …
models/pagination_meta_mapper.dart   # JSON → core/domain/PaginationMeta
```

- Datasources call **`ApiService` only** — never a raw `Dio` instance.
- `PaginationMeta` (domain) lives in `core/domain/`; JSON parsing is in
  `PaginationMetaMapper` (network/data).
- Auth interceptor flags: `kSkipAuthExtra`, `kSkip401Redirect`.
- Timeouts default to connect 15s / receive 30s (adjust per market).

---

## 6. State management

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserEntity?> build() async => null;

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(loginWithEmailUseCaseProvider)(email, password),
    );
  }
}
```

Screens: `ConsumerWidget` + `async.whenApp` (see §7).

---

## 7. Flavors, session, offline / error UI

### Flavors / env files

```bash
flutter run --dart-define-from-file=env/dev.json
flutter run --dart-define-from-file=env/uat.json
flutter run --dart-define-from-file=env/prod.json
```

| Define | Meaning |
|---|---|
| `FLAVOR` | `dev` / `uat` / `prod` → `AppFlavor` |
| `API_URL` | Dio `baseUrl` |
| `APP_NAME` | MaterialApp title |
| `DEMO_MODE` | Demo auth + posts datasources |

`FlavorController` can override flavor at runtime (disabled when compile-time
flavor is prod). Dio rebuilds when flavor changes.

### Session

`SessionController` reads `SecureStorage` for an access token. GoRouter
`redirect` sends unauthenticated users to `/auth` and authenticated users
away from auth to `/home`.

Auth interceptor on **401**:
1. call `TokenRefreshService` (bare Dio → `ApiRoutes.refreshToken`)
2. on success → retry the request once (queued concurrent 401s wait)
3. on failure → `signOut()` + `goAuth()`

Use `kSkip401Redirect` on login so wrong credentials do not trigger refresh.

### Async UI / forms / lists

```dart
async.whenApp(
  onRetry: () => ref.read(myProvider.notifier).refresh(),
  data: (value) => …,
);
```

- `NetworkException` → `OfflineScreen`
- other / 5xx → `ErrorScreen`
- `ref.listenReconnectRefresh(refresh)` reloads when connectivity returns
- Forms: local `Validators` + `FormFieldErrors.fromApi(ApiException)`
- Lists: `InfiniteScrollMixin` + `PaginationMeta` (see `features/posts`)

Deep links: `/posts/:id?highlight=true` + typed `PostDetailExtra`.

Shell: `StatefulShellRoute` + `MainWrapperScreen` (Home / Posts / Settings).

---

## 8. Build & codegen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Generated: `*.g.dart`, `*.freezed.dart` (models/providers only — **not** entities).

---

## 9. Checklist — adding a new feature

1. `features/<f>/domain/`: pure entity, `I*Repository`, usecase(s).
2. `features/<f>/data/`: Freezed model (`fromJson` + `toEntity`), datasource
   via `ApiService` + `ApiRoutes`, `*RepositoryImpl`.
3. Add path constants to `core/network/api_routes.dart`.
4. `features/<f>/di/`: datasource → repository (interface) → usecase.
5. `presentation/providers/`: notifier reading usecase providers.
6. `presentation/screens/`: `ConsumerWidget` + typed error UI.
7. Register route in `app/router/`.
8. `dart run build_runner build -d` → `flutter analyze` → done.

---

## 10. What changed in v2.0.0

- Domain entities are Equatable (Freezed removed from domain).
- Feature-scoped DI; removed `core/di` importing features.
- Auth sample uses `ApiService` (prod) + `DemoAuthRemoteDataSource` (demo).
- `PaginationMeta` moved to `core/domain`; mapper stays in network.
- Docs match the real `app/` + `features/` layout.
- Broader SDK constraint; softer Dio timeouts; `DEMO_MODE` flag.

---

## 11. What changed in v2.1.0

- Slang i18n (EN/MY) + `LocaleController` + `TranslationProvider`.
- `ConnectivityService` with online/offline toasts (watch from `MyApp`).
- FCM **boilerplate only**: `NoOpFcmService` + no-op push init
  (no `firebase_*` packages — enable via `docs/ENABLE_FCM.md`).
- iOS edge back swipe via `cupertino_back_gesture` in `MyApp.builder`.

---

## 12. What changed in v2.2.0

- Flavors via `env/{dev,uat,prod}.json` + `AppFlavor` / `FlavorController`.
- `SessionController` + GoRouter auth redirect + 401 session expiry.
- Bottom-nav shell (`MainWrapperScreen`) with Home + Settings sample screens
  (Posts tab added in v2.3.0).
- `whenApp` / `OfflineScreen` / `ErrorScreen` + reconnect refresh helper.
- `NavigationService` for imperative auth/home navigation.

---

## 13. What changed in v2.3.0

- Token refresh on 401 (`TokenRefreshService` + queued retry).
- `features/posts` sample: paginated list, detail deep link, create form.
- `FormFieldErrors` convention for server validation maps.
- GitHub Actions CI (`analyze` + `test`).
- `.vscode/launch.json` for `env/{dev,uat,prod}.json`.
