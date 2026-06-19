import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_page.dart';
import 'page_transition.dart';
import 'route_names.dart';

/// Root navigator key — also used for imperative navigation / full-screen routes.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Builds the app's [GoRouter]. Add per-tab `shellNavigatorKey`s +
/// `StatefulShellRoute` here when you introduce bottom navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.authPath,
    routes: [
      GoRoute(
        path: RouteNames.authPath,
        name: RouteNames.auth,
        pageBuilder: (context, state) =>
            PageTransition.fade(state: state, child: const AuthPage()),
      ),
    ],
  );
});
