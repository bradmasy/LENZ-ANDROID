import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'globals.dart';

class DashPage extends StatelessWidget {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
      if (child != null) {
        return child;
      }
      return Text('${appState.appUser}');
    });
  }
}
