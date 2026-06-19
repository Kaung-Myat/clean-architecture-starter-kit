import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/theme/theme.dart';
import 'router/app_router.dart';

/// Root widget. `MaterialApp.router` that watches the global providers so the
/// whole app rebuilds on theme/router change (see ABOUT-ARCHI §4).
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Clean Architecture Starter',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,
      routerConfig: goRouter,
      builder: (context, child) {
        // Force textScaler = 1.0 and dismiss the keyboard on background tap.
        return MediaQuery.withNoTextScaling(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
