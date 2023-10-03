import 'package:go_router/go_router.dart';
import 'package:photo_gallery/auth/view/login.dart';
import 'package:photo_gallery/auth/view/signup.dart';

enum AuthRoutes {
  auth(relativePath: '/', path: '/auth'),
  login(relativePath: 'login', path: '/auth/login'),
  signup(relativePath: 'signup', path: '/auth/signup');

  final String relativePath;
  final String path;

  const AuthRoutes({required this.relativePath, required this.path});
}

final GoRoute authRoutes = GoRoute(
  path: AuthRoutes.auth.path,
  redirect: (_, __) => null,
  routes: <RouteBase>[
    GoRoute(
        path: AuthRoutes.login.relativePath,
        builder: (context, state) => const Login()),
    GoRoute(
        path: AuthRoutes.signup.relativePath,
        builder: (context, state) => const Signup())
  ],
);
