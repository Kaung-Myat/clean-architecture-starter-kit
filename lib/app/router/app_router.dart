import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session_controller.dart';
import '../../features/auth/presentation/screens/auth_page.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/posts/presentation/routing/post_detail_extra.dart';
import '../../features/posts/presentation/screens/create_post_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/posts/presentation/screens/posts_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/main_wrapper_screen.dart';
import 'page_transition.dart';
import 'route_names.dart';

/// Root navigator key — also used for imperative navigation / full-screen routes.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionControllerProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.authPath,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onAuth = loc == RouteNames.authPath;
      final isLoading = session.isLoading;
      final isAuth = session.asData?.value ?? false;

      if (isLoading) return null;
      if (!isAuth && !onAuth) return RouteNames.authPath;
      if (isAuth && onAuth) return RouteNames.homePath;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.authPath,
        name: RouteNames.auth,
        pageBuilder: (context, state) =>
            PageTransition.fade(state: state, child: const AuthPage()),
      ),
      // Full-screen routes (above the shell).
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RouteNames.createPostPath,
        name: RouteNames.createPost,
        pageBuilder: (context, state) => PageTransition.fade(
          state: state,
          child: const CreatePostScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: RouteNames.postDetailPath,
        name: RouteNames.postDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final highlight =
              state.uri.queryParameters['highlight'] == 'true';
          final extra = state.extra is PostDetailExtra
              ? state.extra as PostDetailExtra
              : null;
          return PageTransition.fade(
            state: state,
            child: PostDetailScreen(
              id: id,
              highlight: highlight,
              extra: extra,
            ),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.homePath,
                name: RouteNames.home,
                pageBuilder: (context, state) => PageTransition.fade(
                  state: state,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.postsPath,
                name: RouteNames.posts,
                pageBuilder: (context, state) => PageTransition.fade(
                  state: state,
                  child: const PostsListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settingsPath,
                name: RouteNames.settings,
                pageBuilder: (context, state) => PageTransition.fade(
                  state: state,
                  child: const SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
