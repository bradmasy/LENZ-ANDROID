import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';
import 'package:photo_gallery/globals.dart';
import 'package:provider/provider.dart';

import 'auth/auth_routes.dart';
import 'dash_page.dart';
import 'homepage.dart';

enum Routes {
  home(path: '/'),
  dash(path: '/dash');

  final String path;

  const Routes({required this.path});
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: Routes.home.path,
  routes: <RouteBase>[
    GoRoute(
        path: Routes.home.path,
        builder: (context, state) => const MyHomePage()),
    authRoutes,
    GoRoute(
        path: Routes.dash.path,
        builder: (context, state) => const DashPage(),
        redirect: _guard),
  ],
);

FutureOr<String?> _guard(BuildContext context, GoRouterState state) {
  AppUser? appUser = Provider.of<AppState>(context, listen: false).appUser;
  if (appUser != null && appUser.token != null) {
    print('authenticated ${state.path!}');
    return null;
  }
  print('not authenticated');
  return AuthRoutes.login.path;
}
