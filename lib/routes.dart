import 'package:go_router/go_router.dart';

import 'auth/auth_routes.dart';
import 'homepage.dart';

enum Routes {
  home(path: '/');

  final String path;

  const Routes({required this.path});
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
        path: Routes.home.path,
        builder: (context, state) =>
            const MyHomePage(title: 'Flutter Demo Home Page')),
    authRoutes
  ],
);
