import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/env/env.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/push_notification_service.dart';
import 'config/localization/generated/translations.g.dart';
import 'config/localization/locale_controller.dart';
import 'config/theme/theme.dart';
import 'router/app_router.dart';

/// Root widget. Watches theme / locale / router and starts global services.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    ref.watch(localeControllerProvider);

    // Global listeners (side effects on watch).
    ref.watch(connectivityServiceProvider);
    ref.watch(pushNotificationProvider);

    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: Env.appName,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: goRouter,
      builder: (context, child) {
        return BackGestureWidthTheme(
          // Slightly wider than stock iOS edge for easier discovery.
          backGestureWidth: BackGestureWidth.fixed(32),
          child: MediaQuery.withNoTextScaling(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
