import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_gallery/main.dart';
import '../lib/homepage.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  testWidgets("tap on next", (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle(const Duration(seconds: 3));
    final getStartedButton = find.byKey(const Key('getStartedButton'));
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pump();

  });
}
