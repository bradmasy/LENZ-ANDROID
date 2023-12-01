import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oktoast/oktoast.dart';
import 'package:patrol/patrol.dart';
import 'package:photo_gallery/main.dart';
import 'package:photo_gallery/View/Dashboard.dart';

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
      await tester.tap(find.byType(NavigationDestination).at(3));
      await pumpForSeconds(tester, 3);
      await tester.tap(find.byKey(const Key('delete_albums')));
      await pumpForSeconds(tester, 3);
      await tester.tap(find.byKey(const Key('0')));
      await pumpForSeconds(tester, 3);
      await tester.tap(find.byKey(const Key('delete_selected_albums')));
      await pumpForSeconds(tester, 3);
      await tester.tap(find.byKey(const Key('delete_selected_albums_confirm')));
      await pumpForSeconds(tester, 3);
      expect(find.byType(GridView), findsOneWidget);
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