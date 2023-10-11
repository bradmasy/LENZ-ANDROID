import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/routes.dart';
import 'package:provider/provider.dart';

import 'auth/services/auth_service.dart';
import 'globals.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<AppState>(
          builder: (BuildContext context, AppState appState, Widget? child) {
            if (child != null) {
              return child;
            }
            return Text('${appState.appUser}');
          }),
      TextButton(
          onPressed: () => _logout(context), child: const Text('logout')),
    ]);
  }

  _logout (BuildContext context) async {
    GetIt.I.get<AuthService>().signOut()
        .then((value) => context.go(Routes.dash.path));
  }
}
