import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';
import 'package:photo_gallery/globals.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/pages/add_photo.dart';
import 'package:photo_gallery/pages/albums.dart';
import 'package:photo_gallery/pages/add_album.dart';
import 'package:photo_gallery/pages/all_photos.dart';
import 'package:photo_gallery/pages/dashboard.dart';
import 'package:photo_gallery/pages/photos.dart';

import 'DataModel/GlobalDataModel.dart';
import 'auth/auth_routes.dart';
import 'pages/dash_page.dart';
import 'homepage.dart';

enum Routes {
  home(path: '/'),
  dash(path: '/dash'),

  albums(path: '/albums'),

  photos(path: '/photos'),

  addPhoto(path: '/add_photo'),

  allPhotos(path: '/all_photos'),

  addAlbum(path: '/add_album');

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
        // path: Routes.dash.path,
        // builder: (context, state) => const DashPage(),
        // redirect: _guard),
        path: Routes.dash.path, builder: (context, state) => const Dashboard()),
    GoRoute(
        path: Routes.albums.path, builder: (context, state) => const Albums()),
    GoRoute(
        path: Routes.photos.path, builder: (context, state) {
      Album album = state.extra as Album;
      return Photos(album: album);
    },),
    GoRoute(
        path: Routes.addAlbum.path, builder: (context, state) => AddAlbum()),
    GoRoute(
        path: Routes.addPhoto.path, builder: (context, state) {
      CameraDescription camera = state.extra as CameraDescription;
      return AddPhoto(camera: camera);
    }),
    GoRoute(
        path: Routes.allPhotos.path, builder: (context, state) => const AllPhotos()),
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
