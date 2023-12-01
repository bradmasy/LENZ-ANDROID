import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oktoast/oktoast.dart';
import 'package:patrol/patrol.dart';
import 'package:photo_gallery/components/PhotoTile.dart';
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
      await tester.tap(find.byType(NavigationDestination).at(4));
      await pumpForSeconds(tester, 3);
      await tester.tap(find.byKey(const Key('add_photo')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('take_photo')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await tester.enterText(find.byKey(const Key('title')), 'test$timestamp');
      await pumpForSeconds(tester, 2);
      await tester.enterText(find.byKey(const Key('description')), 'test$timestamp');
      await pumpForSeconds(tester, 2);
      await tester.tap(find.byKey(const Key('addPhoto')));
      await pumpForSeconds(tester, 10);
      expect(find.byType(PhotoTile), findsOneWidget);
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