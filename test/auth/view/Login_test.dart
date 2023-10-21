import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';
import 'package:photo_gallery/auth/services/AuthService.dart';
import 'package:photo_gallery/auth/view/Login.dart';
import 'package:photo_gallery/pages/Dashboard.dart';
import 'package:photo_gallery/routes.dart';
import 'package:provider/provider.dart';

import 'Login_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
void main() {
  const String testEmail = 'test@test.com';
  const String testPw = 'test';

  late Login login;
  late Widget app;
  late AuthService mockAuthService;
  late GoRouter mockRouter;

  setUp(() {
    login = const Login();
    mockRouter = GoRouter(initialLocation: '/', routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => login,
      ),
      GoRoute(
          path: Routes.dash.path,
          builder: (context, state) => const Dashboard())
    ]);
    app = OKToast(
      child: MaterialApp.router(
        routerConfig: mockRouter,
      ),
    );
    mockAuthService = MockAuthService();
    GetIt.I.reset();
  });

  testWidgets('appbar login title', (widgetTester) async {
    await widgetTester.pumpWidget(app);

    expect(find.byWidget(login), findsOneWidget);

    Finder appBar = find.byType(AppBar).first;
    expect(appBar, findsOneWidget);

    Widget? title = (appBar.evaluate().single.widget as AppBar).title;
    expect((title as Text).data, 'Login');
  });

  testWidgets('email text field', (widgetTester) async {
    await widgetTester.pumpWidget(app);

    Finder email = find.byType(TextField).at(0);
    expect(email, findsOneWidget);

    TextField textField = email.evaluate().single.widget as TextField;
    expect(textField.decoration?.labelText, 'Email');

    await widgetTester.enterText(email, testEmail);
    expect(textField.controller?.value.text, testEmail);
  });

  testWidgets('password text field', (widgetTester) async {
    await widgetTester.pumpWidget(app);

    Finder pw = find.byType(TextField).at(1);
    expect(pw, findsOneWidget);

    TextField textField = pw.evaluate().single.widget as TextField;
    expect(textField.decoration?.labelText, 'Password');
    expect(textField.obscureText, true);

    await widgetTester.enterText(pw, testPw);
    expect(textField.controller?.value.text, testPw);
  });

  testWidgets('login button', (widgetTester) async {
    await widgetTester.pumpWidget(app);

    Finder loginBtn = find.byType(OutlinedButton).first;
    expect(loginBtn, findsOneWidget);

    OutlinedButton btn = loginBtn.evaluate().single.widget as OutlinedButton;
    expect((btn.child as Text).data, 'login');
  });

  testWidgets('login button pressed', (WidgetTester widgetTester) async {
    GetIt.I.registerSingleton<AuthService>(mockAuthService);
    await widgetTester.pumpWidget(app);
    sleep(const Duration(milliseconds: 10));
    final BuildContext context = widgetTester.element(find.byType(Login));

    AppUser testUser = AppUser();
    testUser.token = 'abc';
    when(mockAuthService.signIn(testEmail, testPw)).thenAnswer(
      (_) => Future.value(
        {'appUser': testUser},
      ),
    );

    Finder email = find.byType(TextField).at(0);
    await widgetTester.enterText(email, testEmail);
    Finder pw = find.byType(TextField).at(1);
    await widgetTester.enterText(pw, testPw);
    Finder loginBtn = find.byType(OutlinedButton).first;
    await widgetTester.tap(loginBtn);
    // await widgetTester.pumpAndSettle();

    expect(mockRouter.routeInformationProvider.value.uri.path, Routes.dash.path);
  });
}
