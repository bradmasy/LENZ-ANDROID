import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_gallery/auth/view/Login.dart';

void main() {
  testWidgets('login page', (tester) async {
    const login = Login();
    await tester.pumpWidget(const MaterialApp(home: login));

    expect(find.byWidget(login), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    Finder appBarWidget = find.byType(AppBar).at(0);

    Widget title = (appBarWidget.evaluate().first.widget as AppBar).title!;

    expect((title as Text).data, 'Login');
  });
}
