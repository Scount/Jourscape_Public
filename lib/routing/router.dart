import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jourscape/features/user/presentation/pages/login_page.dart';
import 'package:jourscape/routing/app.dart';
import 'package:jourscape/features/wip_search/search_screen.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'app',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const AppScreens(),
              fullscreenDialog: true,
              key: state.pageKey,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        GoRoute(
          path: 'search',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const SearchScreen(),
              fullscreenDialog: true,
              key: state.pageKey,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
      ],
    ),
  ],
);
