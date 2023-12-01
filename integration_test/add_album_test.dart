import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oktoast/oktoast.dart';
import 'package:patrol/patrol.dart';
import 'package:photo_gallery/main.dart';
import 'package:photo_gallery/pages/Dashboard.dart';

// run this command to start the patrol test
// DO NOT USE "flutter test" command
// flutter test integration_test/app_test.dart
// optional: --verbose
void main() {
  group('Start Testing This App', () {
    testWidgets('init test', (tester) async {
      disableOverflowErrors();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('email')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('email')), '1@1.ca');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('password')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('password')), '1');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('login')));
      debugPrint('login complete......');
      await pumpForSeconds(tester, 10);
      debugPrint('login load complete......');
      // ----------All Albums test-------------
      showToast('Click NavigationDestination at position 3');
      debugPrint('Click NavigationDestination at position 3');
      await tester.tap(find.byType(NavigationDestination).at(3));
      await pumpForSeconds(tester, 2);
      debugPrint('End Click NavigationDestination at position 3');
      // int count = 0;
      // while (find.byType(GridView).evaluate().single.widget is GridView) {
      //   count++;
      // }
      await pumpForSeconds(tester, 1);
      await tester.tap(find.byKey(const Key('add_album')));
      await pumpForSeconds(tester, 1);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await tester.enterText(find.byKey(const Key('title')), 'UITESTname$timestamp');
      await tester.enterText(find.byKey(const Key('description')), 'UITESTdescription');
      await pumpForSeconds(tester, 1);
      await tester.tap(find.byKey(const Key('addAlbum')));
      await pumpForSeconds(tester, 4);
      // int newCount = 0;
      // while (find.byType(GridView).evaluate().single.widget is GridView) {
      //   newCount++;
      // }
      // showToast('Check if new album is added');
      // showToast('newCount: $newCount, count: $count');
      // expect(newCount, count + 1);
      // ----------End Albums test-------------

    });


  });
}

Future<void> pumpForSeconds(WidgetTester tester, int seconds) async {
  bool timerDone = false;
  Timer(Duration(seconds: seconds), () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
  }
}

void disableOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final isOverflowError = exception is FlutterError &&
        !exception.diagnostics.any(
                (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));

    if (isOverflowError) {
      print(details);
    } else {
      FlutterError.presentError(details);
    }
  };
}