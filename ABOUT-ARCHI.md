# ABOUT-ARCHI — Clean Architecture + Riverpod DI Framework

A reusable Flutter architecture reference. Use this as the blueprint when
scaffolding a new feature or a new project with Claude Code. It documents the
**layering rules**, the **Riverpod-as-DI** wiring, the **network layer**, and
the **common infrastructure** (theme, localization, services, shared widgets).

> Stack: Flutter · Riverpod (`flutter_riverpod` + `riverpod_annotation`) ·
> Dio · GoRouter · Slang (i18n) · Freezed + json_serializable · Hive /
> SharedPreferences / flutter_secure_storage · Material 3.

---

## 1. Layering model

Clean Architecture, **feature-first**. Each feature is a vertical slice with
three layers; dependencies point **inward only** (`presentation → domain ←
data`). The domain layer knows nothing about Flutter, Dio, or JSON.

```
lib/
├── app/                         # App shell + global config (no business logic)
│   ├── app.dart                 # MaterialApp.router, watches theme/locale/router
│   ├── main.dart  (lib/main.dart)
│   ├── config/
│   │   ├── colors.dart, dimensions.dart, assets.dart
│   │   ├── app_typography_constants.dart, text_styles.dart
│   │   ├── theme/               # light/dark ThemeData + ThemeExtension + controller
│   │   └── localization/        # Slang i18n (source JSON + generated + provider)
│   └── router/                  # GoRouter: app_router, route_names, page_transition
│
├── core/                        # Cross-cutting, feature-agnostic infrastructure
│   ├── di/                      # Riverpod provider wiring per feature (see §3)
│   ├── network/                 # Dio client, ApiService, routes, interceptors, exceptions
│   ├── storage/                 # SharedPrefs / Hive / secure storage / cache
│   ├── services/                # Device-level services (connectivity, location, fcm, …)
│   ├── errors/                  # Failure/exception base types (optional)
│   ├── usecases/                # Base UseCase contract (optional)
│   ├── utils/                   # extensions, formatters, validators, helpers, logger, mixins
│   ├── widgets/                 # core-level widgets (app_scaffold, error/empty)
│   ├── auth/                    # session/user cache
│   ├── database/                # local db bootstrap
│   └── env/                     # Env (reads .env via flutter_dotenv)
│
├── features/<feature>/          # One folder per feature
│   ├── data/
│   │   ├── datasources/         # Talk to ApiService; parse responses → entities
│   │   ├── models/              # DTOs (Freezed/json) + `toEntity()` mappers
│   │   └── repositories/        # *RepositoryImpl: implements domain interface
│   ├── domain/
│   │   ├── entities/            # Pure Dart, no annotations, no JSON
│   │   ├── repositories/        # `abstract interface class I*Repository`
│   │   └── usecases/            # One class per action, callable via `call(...)`
│   └── presentation/
│       ├── providers/           # Riverpod notifiers + UI state classes
│       ├── screens/             # ConsumerWidget / ConsumerStatefulWidget
│       └── widgets/             # Feature-local widgets
│
└── shared/                      # App-wide reusable UI (not feature-specific)
    ├── main_wrapper_screen.dart # bottom-nav shell
    └── widgets/                 # buttons, text fields, dialogs, toast, skeletons, …
```

### Dependency rules (enforce these)

- `domain/` imports **nothing** from `data/` or `presentation/`, and nothing
  Flutter/Dio/JSON. Only pure Dart + other domain types.
- `data/` implements `domain` interfaces and may import `core/network`,
  `core/storage`. It maps DTOs → entities; **never leak a model/DTO upward**.
- `presentation/` depends on `domain` (entities + usecases) and on
  `core/di` providers. It never touches `data/` directly.
- `core/` and `shared/` never import from `features/`.
- **Imports inside `lib/` are relative** (`../../core/...`), not
  `package:app/...` — `prefer_relative_imports` is on.

---

## 2. The vertical slice (canonical example)

A feature wires four artifacts. Below is the real Notification slice — copy its
shape for any new feature.

**Domain — entity** (pure Dart):
```dart
class NotificationEntity {
  const NotificationEntity({ required this.id, this.tag, /* … */ });
  final String id;
  final String? tag;
  // Derived/business getters live here, e.g. displayTitle.
}
```

**Domain — repository interface** (the contract `data` must satisfy):
```dart
abstract interface class INotificationRepository {
  Future<({List<NotificationEntity> records, PaginationMeta meta})>
      getNotifications({int page, int limit});
}
```

**Domain — usecase** (one action; invoked as a function via `call`):
```dart
class GetNotificationsUseCase {
  const GetNotificationsUseCase({required INotificationRepository repository})
      : _repository = repository;
  final INotificationRepository _repository;

  Future<({List<NotificationEntity> records, PaginationMeta meta})> call({
    int page = 1,
    int limit = 20,
  }) => _repository.getNotifications(page: page, limit: limit);
}
```

**Data — model/DTO** (Freezed + json; owns `fromJson` and `toEntity`):
```dart
@freezed
abstract class NotificationData with _$NotificationData {
  const NotificationData._();
  const factory NotificationData({ required String id, String? tag /* … */ }) = _NotificationData;
  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  NotificationEntity toEntity() => NotificationEntity(id: id, tag: tag /* … */);
}
```

**Data — datasource** (the only place that calls `ApiService`):
```dart
class NotificationDataSource {
  NotificationDataSource({required ApiService apiService}) : _apiService = apiService;
  final ApiService _apiService;

  Future<({List<NotificationEntity> records, PaginationMeta meta})> list({int page = 1, int limit = 20}) async {
    final res = await _apiService.get(url: ApiRoutes.notifications, queryParameters: {'page': page, 'limit': limit});
    final parsed = NotificationResponse.fromJson(res.data as Map<String, dynamic>);
    return (records: parsed.data.map((d) => d.toEntity()).toList(), meta: parsed.paginationMeta);
  }
}
```

**Data — repository impl** (thin; delegates to datasource):
```dart
class NotificationRepositoryImpl implements INotificationRepository {
  const NotificationRepositoryImpl({required NotificationDataSource dataSource}) : _dataSource = dataSource;
  final NotificationDataSource _dataSource;
  @override
  Future<...> getNotifications({int page = 1, int limit = 20}) => _dataSource.list(page: page, limit: limit);
}
```

> **Error handling convention:** usecases/repositories do **not** wrap results
> in `Either`/`Failure`. Datasources let `ApiService` throw typed exceptions
> (`ApiException`, `NetworkException`) and those propagate up to the notifier,
> where Riverpod captures them as `AsyncError`. (The `core/errors` base types
> exist as optional scaffolding but are unused in the default flow.)

---

## 3. Dependency Injection — Riverpod is the service locator

**There is no `get_it`/`injectable`.** Each feature has a DI file in
`core/di/<feature>_di.dart` that declares plain `Provider`s wiring
datasource → repository → usecase. Presentation reads the usecase provider.

```dart
// core/di/notification_di.dart
final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  return NotificationDataSource(apiService: ref.watch(apiServiceProvider));
});

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepositoryImpl(dataSource: ref.watch(notificationDataSourceProvider));
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(repository: ref.watch(notificationRepositoryProvider));
});
```

Rules:
- The repository provider is typed to the **interface** (`I*Repository`), so
  the impl is swappable (fakes in tests).
- DI files are aggregated/exported via `core/di/di.dart` for convenient import.
- Composition root–style overrides happen in `main.dart`'s `ProviderScope`
  (see §4) — that is where concrete singletons (SharedPreferences, CookieJar)
  are injected into provider placeholders.

---

## 4. App bootstrap (`main.dart`) & shell (`app.dart`)

`main()` does async init, then injects runtime singletons via `overrides`:

```dart
runApp(
  ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences), // resolved instance
      cookieJarProvider.overrideWithValue(cookieJar),                 // PersistCookieJar
    ],
    child: TranslationProvider(child: const MyApp()),                 // Slang root
  ),
);
```

Order in `main()`: `WidgetsFlutterBinding.ensureInitialized()` → load `.env`
→ Firebase init + background FCM handler → `LocaleSettings.useDeviceLocale()`
→ resolve `SharedPreferences` / cookie jar → `runApp`.

`MyApp` (a `ConsumerWidget`) is `MaterialApp.router` and **watches** the
global providers so the whole app rebuilds on change:
```dart
final themeMode = ref.watch(themeControllerProvider);
ref.watch(localeControllerProvider);
ref.watch(connectivityServiceProvider);   // starts global online/offline listener
ref.watch(pushNotificationProvider);       // FCM permission + foreground display
final goRouter = ref.watch(appRouterProvider);
```

It also: forces `textScaler = 1.0`, dismisses the keyboard on background tap,
and applies platform-aware `SafeArea`.

---

## 5. Network layer (`core/network/`)

```
dio_client.dart            # dioClientProvider — single Dio with interceptors
api_service.dart           # apiServiceProvider — typed get/post/put/patch/delete/uploadFile
api_routes.dart            # ApiRoutes — all endpoint path constants + storageUrl()
api_method.dart            # ApiMethod enum
interceptors/              # auth_interceptor, logger_interceptor, retry_interceptor
exceptions/                # api_exception, network_exception, unauthorized_exception
models/pagination_meta.dart
```

- **`dioClientProvider`** builds one `Dio` with tight timeouts (connect 6s,
  receive 8s) and the interceptor chain. Interceptor **order matters**:
  `CookieManager → LoggerInterceptor → AuthInterceptor`.
  > No pre-flight connectivity gate and no retry interceptor by design — both
  > caused bad UX (false "offline" flashes / 30–45s hangs). Offline state is
  > driven by the **actual** request failing, mapped to `NetworkException`.
- **`ApiService`** is the single seam the data layer talks to. It builds
  headers (`Content-Type`, optional device info), supports per-request opt-outs
  via `Options.extra`, and converts every `DioException` through
  `_mapDioError`:
  - response present → `ApiException` (`fromJson` / `fromHtmlResponse`), with
    `isServerError` (5xx) / `isClientError` (4xx) helpers, and validation
    detail extraction.
  - no response (timeout / `connectionError` / `SocketException`) →
    `NetworkException.fromDio`.
- **`AuthInterceptor`** supports cookie auth (via `CookieManager`) **and**
  bearer-token auth in parallel. Per-request flags:
  - `kSkipAuthExtra` → don't attach `Authorization` (e.g. `/login`).
  - `kSkip401Redirect` → a 401 means "wrong credentials", not "session
    expired"; don't fire `onSessionExpired`.
  On any other 401 → `onSessionExpired()` clears tokens/cookies and routes to
  login.
- **Pagination**: `PaginationMeta { currentPage, totalPages, totalRows }` with
  `hasNextPage`. Datasources return records `({records, meta})` records.

---

## 6. State management — Riverpod notifiers

Presentation state lives in `presentation/providers/`. Two shapes:

**(a) Simple async read** — derive state straight from a usecase in `build()`:
```dart
class PendingRequestsNotifier extends AsyncNotifier<List<RequestSummaryEntity>> {
  @override
  Future<List<RequestSummaryEntity>> build() =>
      ref.watch(getRequestsUseCaseProvider).call(status: 'PENDING', limit: 100);

  Future<void> refresh() async { ref.invalidateSelf(); await future; }
}
```

**(b) Paginated list with "load more"** — a custom state class + `AsyncNotifier`.
First page errors surface as `AsyncError`; **load-more errors are kept on the
data state** (`loadMoreError`) so a failed next-page fetch never wipes the list:
```dart
class NotificationListState {
  const NotificationListState({required this.records, required this.meta,
      this.isLoadingMore = false, this.loadMoreError});
  // … copyWith(clearLoadMoreError: …)
}

class NotificationNotifier extends AsyncNotifier<NotificationListState> {
  @override
  Future<NotificationListState> build() async {
    final r = await ref.read(getNotificationsUseCaseProvider).call(page: 1, limit: 20);
    return NotificationListState(records: r.records, meta: r.meta);
  }
  Future<void> loadMore() async { /* guard hasNextPage/isLoadingMore; append; catch → loadMoreError */ }
  Future<void> refresh() async { ref.invalidateSelf(); await future; }
}
```

Conventions:
- Screens are `ConsumerWidget` / `ConsumerStatefulWidget`; read with
  `ref.watch` in `build`, side-effect reads with `ref.read`.
- Render with `asyncState.when(loading/error/data)` and
  `skipLoadingOnRefresh: true, skipLoadingOnReload: true` so refreshes don't
  flash skeletons.
- In `error`, branch on exception type: `NetworkException → OfflineScreen`,
  `ApiException && isServerError → ErrorScreen`, else a generic retry view.
- **Refresh-on-reconnect**: listen to `connectivityStreamProvider` and call
  `notifier.refresh()` only on a real `false → true` transition.
- Annotation-style (`@riverpod` + `*.g.dart`) is used for controllers like
  `ThemeController` / `LocaleController`; plain providers elsewhere. Either is
  fine — keep a feature internally consistent.

---

## 7. Common infrastructure

### 7.1 Theme (`app/config/theme/`)
- `light_theme.dart` / `dark_theme.dart` export `lightThemeData` /
  `darkThemeData` (Material 3). `theme.dart` barrel-exports them.
- **Design tokens beyond `ColorScheme`** go in an `AppColorsExtension`
  (`ThemeExtension`) with `light` / `dark` variants and `lerp` — e.g.
  `customBackground`, `cardShadow`.
- `ThemeController` (`@riverpod`) holds `ThemeMode`, persists via
  `SharedPrefService`, exposes `setThemeMode` / `toggleTheme`.
- **Access in widgets via `context` extension** (`core/utils/extensions/context_extension.dart`):
  ```dart
  context.colorScheme   // Theme.of(context).colorScheme
  context.textTheme     // Theme.of(context).textTheme
  context.colors        // AppColorsExtension custom tokens
  ```
  Raw colors/typography constants live in `app/config/colors.dart` and
  `app_typography_constants.dart` — reference these, don't hardcode hex.

### 7.2 Localization — Slang (`app/config/localization/`)
- Source JSON: `i18n/strings_en.i18n.json`, `strings_my.i18n.json`.
- Generated: `generated/translations.g.dart` (config in `slang.yaml`).
- App wrapped in `TranslationProvider`; access strings via
  `context.t.<path>` (e.g. `context.t.features.request.requests`).
- `LocaleController` (`@riverpod`) persists the chosen locale and calls
  `LocaleSettings.setLocale`. Default = device locale.
- **After editing any i18n JSON, run `dart run build_runner build -d`.**

### 7.3 Storage (`core/storage/`)
- `shared_pref_service.dart` — `sharedPreferencesProvider` (overridden in
  `main`) + `SharedPrefService` wrapper (typed keys for theme/locale, etc.).
- `secure_storage.dart` — `SecureStorage` for access/refresh tokens
  (`saveTokens`, `getAccessToken`, `clearTokens`).
- `hive_service.dart`, `cache_manager.dart` — structured/object caching.

### 7.4 Services (`core/services/`)
Device-/platform-level capabilities, each exposed as a `Provider`:

| Service | Provider | Purpose |
|---|---|---|
| `ConnectivityService` | `connectivityServiceProvider` + `connectivityStreamProvider` | Online/offline stream, global restore/offline toasts |
| `LocationService` | `locationServiceProvider` | `getCurrentLocation()` (gated by permissions) |
| `PermissionService` | `permissionServiceProvider` | Location/camera/photos/notification permission requests |
| `NotificationService` | `notificationServiceProvider` | Local notifications (init, channels, show, cancel) |
| `PushNotificationService` | `pushNotificationProvider` | FCM init, foreground display, background handler |
| `FcmService` | `fcmServiceProvider` | FCM token |
| `DeviceInfoService` | `deviceInfoServiceProvider` | Device id / platform headers |
| `NetworkInfoService` | `networkInfoServiceProvider` | Wi-Fi IP for `IP-Address` header |
| `NavigationService` | — | imperative nav via `rootNavigatorKey` |
| `SocketService` | — | realtime socket (optional) |

> Services that hold a subscription (e.g. connectivity) must implement
> `dispose()` and register `ref.onDispose(...)` in their provider.

### 7.5 Routing (`app/router/`)
- `appRouterProvider` builds a `GoRouter` with a `rootNavigatorKey` plus
  per-tab `shellNavigatorKey`s (StatefulShellRoute for bottom nav).
- All paths/names are constants in `route_names.dart`; navigate with
  `context.goNamed(RouteNames.x)` / `context.pushNamed(...)`.
- Custom transitions in `page_transition.dart`; full-screen routes attach to
  `rootNavigatorKey` via `parentNavigatorKey`.

### 7.6 Utils (`core/utils/`)
- `extensions/` — `context_extension` (theme), `async_value_extension`
  (`ref.listenServerErrorToast(provider, context)` fires a toast once per new
  5xx error), `datetime_extension`, `string_extension`, `app_bar_extension`
  (`.primayAppBar(context)`).
- `formatters/` — currency, date. `validators/` — email/password/phone.
- `helpers/` — debounce, dialog, launcher, snackbar, pdf builder.
- `infinite_scroll_mixin.dart` — `InfiniteScrollMixin` drives `loadMore()` +
  `ensureViewportFilled()` for paginated lists.
- `logger/app_logger.dart` — **use `AppLogger.d/i/w/e` instead of
  `debugPrint`.**

### 7.7 Common widgets
`shared/widgets/` (app-wide):
- `AppElevatedButton`, `app_loader.dart` (`AppLoader`), `CustomTextField`,
  `CustomBottomNavBar`.
- `AppDialogs` (static helpers), `AppToast` (`AppToast.show(...)`,
  `AppToast.serverError(context)`).
- `OfflineScreen` / `OfflineBanner`, `ErrorScreen` — standard error/offline UIs
  (always pass an `onRetry`).
- `SkeletonBox` / `SkeletonCircle` / `ShimmerWrapper` — loading skeletons.
- `HorizontalDatePicker`, `EditableProfileImage`, `FullScreenImageViewer`.

`core/widgets/` (lower-level): `AppScaffold`, `AppNetworkImage`, `EmptyWidget`,
generic error widget.

---

## 8. Build & codegen rules

- **Code generation is mandatory** — a fresh checkout won't compile until:
  ```
  dart run build_runner build -d
  ```
  Run it after pulling, or after editing any file with `@riverpod`,
  `@freezed`, `@JsonSerializable`, or any Slang i18n JSON. Generated outputs:
  `*.g.dart`, `*.freezed.dart`, `translations.g.dart`.
- `flutter pub get` for deps · `flutter analyze` must be clean
  (`flutter_lints` + `prefer_relative_imports: true`) · `flutter test`.
- Env via `--dart-define-from-file=.env` / `flutter_dotenv`; `.env` is
  gitignored. Keys: `API_URL`, `APP_NAME`, `FIREBASE_KEY`, `ENV`. Read through
  `core/env/env.dart` (`Env.baseUrl`, `Env.isConfigured`).

---

## 9. Checklist — adding a new feature

1. `features/<f>/domain/`: entity (pure), `I<F>Repository`, usecase(s) with `call()`.
2. `features/<f>/data/`: model(s) (`fromJson` + `toEntity`), datasource (uses
   `ApiService` + `ApiRoutes`), `<F>RepositoryImpl`.
3. Add the endpoint constant to `core/network/api_routes.dart`.
4. `core/di/<f>_di.dart`: `datasource → repository (as interface) → usecase`
   providers; export from `core/di/di.dart`.
5. `features/<f>/presentation/providers/`: `AsyncNotifier` (+ state class if
   paginated) reading the usecase provider; expose `refresh()` / `loadMore()`.
6. `presentation/screens/`: `ConsumerWidget`; `async.when` with
   skip-loading-on-refresh; type-branch errors → `OfflineScreen` /
   `ErrorScreen` / generic; reconnect-refresh via `connectivityStreamProvider`.
7. Register route in `app/router/` (path/name constants + GoRoute).
8. Add i18n keys to the Slang JSON.
9. `dart run build_runner build -d` → `flutter analyze` → done.
