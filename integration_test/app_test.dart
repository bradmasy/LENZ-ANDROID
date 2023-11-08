import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:photo_gallery/main.dart';

// run this command to start the patrol test
// DO NOT USE "flutter test" command
// patrol test -t integration_test/app_test.dart
// optional: --verbose
void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    nativeAutomation: true,
        ($) async {
      await $.pumpWidgetAndSettle(
          const MyApp()
      );
      await Future.delayed(const Duration(seconds: 2));

      await $.tap(find.byType(OutlinedButton).first);

      await Future.delayed(const Duration(seconds: 2));

      // await $(find.byKey(const Key('email')))
      //     .which<TextField>((widget) => widget.controller!.text.isNotEmpty)
      //     .enterText('1@1.ca');
      // await $(find.byKey(const Key('password')))
      //     .which<TextField>((widget) => widget.controller!.text.isNotEmpty)
      //     .enterText('1');
      await $.native.enterTextByIndex('1@1.ca', index: 0);
      await Future.delayed(const Duration(seconds:5));
      await $.native.enterTextByIndex('1', index: 1);
      await Future.delayed(const Duration(seconds: 5));
      expect(find.byType(OutlinedButton), findsNWidgets(2));
      await Future.delayed(const Duration(seconds: 5));

      await $.tap(find.byKey(const Key("login")));

      await Future.delayed(const Duration(seconds: 20));

        },
  );
}