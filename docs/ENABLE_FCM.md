# Enable Firebase Cloud Messaging (FCM)

v2.1.0 ships **FCM as boilerplate only** so the template builds without
`google-services.json` / `GoogleService-Info.plist`.

Default providers:

- `fcmServiceProvider` → `NoOpFcmService` (`getToken()` returns `null`)
- `pushNotificationProvider` → no-op `init()`

## Steps to wire real FCM

1. Create a Firebase project and register Android / iOS apps.
2. Add packages to `pubspec.yaml`:

   ```yaml
   dependencies:
     firebase_core: ^4.10.0
     firebase_messaging: any
     flutter_local_notifications: any   # optional, for Android foreground
   ```

3. Run FlutterFire CLI:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. Replace `NoOpFcmService` with a real `FirebaseMessaging` wrapper
   (see `hr-mobile` `lib/core/services/fcm_service.dart` as a reference).
5. In `push_notification_service.dart`, request permission, set iOS
   foreground presentation options, and listen to
   `FirebaseMessaging.onMessage`.
6. In `main.dart`:

   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
   ```

7. Override the provider if needed:

   ```dart
   fcmServiceProvider.overrideWithValue(FirebaseFcmService()),
   ```

8. Pass `ref.watch(fcmServiceProvider).getToken()` into login / device
   registration usecases when your API expects an FCM token.

Until then, leave the no-op implementations — the rest of the kit stays runnable.
