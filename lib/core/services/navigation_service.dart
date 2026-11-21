import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/router/route_names.dart';

/// Imperative navigation helpers (session expiry, deep links, etc.).
class NavigationService {
  const NavigationService._();

  static BuildContext? get _context => rootNavigatorKey.currentContext;

  static void goAuth() {
    final context = _context;
    if (context == null || !context.mounted) return;
    context.goNamed(RouteNames.auth);
  }

  static void goHome() {
    final context = _context;
    if (context == null || !context.mounted) return;
    context.goNamed(RouteNames.home);
  }
}
