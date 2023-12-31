@TestOn('vm')
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';
import 'package:photo_gallery/auth/services/AuthServiceApi.dart';
import 'package:photo_gallery/globals.dart';
import 'package:test/test.dart';

import 'AuthServiceApi_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<Response>()])
void main() {
  const String testEmail = 'test@test.com';
  const String testPw = 'test';

  late Dio mockDio;
  late AuthServiceAPI authServiceAPI;
  late Response mockResponse;
  late AppState appState;

  setUp(() {
    mockDio = MockDio();
    authServiceAPI = AuthServiceAPI.withDio(mockDio);
    mockResponse = MockResponse();
    appState = AppState();
    GetIt.I.reset();
  });

  /*
    curl -v -sw "\n" -X POST "https://lenz-5f9c8ee2c363.herokuapp.com/signup" \
      -H 'Content-Type: application/json' \
      -d '{"username": "test321", "email": "test321@test.ca", "password": "test", "first_name": "test", "last_name": "test"}' | json_pp
  */
  group('signup', () {
    const String path = '/signup';

    test('params passed', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.data).thenReturn({});
      await authServiceAPI.signUp(testEmail, testPw);
      dynamic reqDTO = verify(mockDio.post(path, data: captureAnyNamed('data')))
          .captured
          .single;

      expect(reqDTO['email'], testEmail);
      expect(reqDTO['password'], testPw);
    });

    test('result when success', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.statusCode).thenReturn(HttpStatus.created);
      when(mockResponse.data).thenReturn(
        {
          'message': 'User created successfully',
          'user': {
            'id': 0,
            'email': testEmail,
            'username': 'testUsername',
            'firstName': 'testFirstName',
            'lastName': 'testLastName'
          },
        },
      );

      Map<String, dynamic> result =
          await authServiceAPI.signUp(testEmail, testPw);
      expect(result['message'], 'User created successfully');
      expect(result['appUser'], isNotNull);
      expect(result['appUser'], isA<AppUser>());

      AppUser appUser = result['appUser'];
      expect(appUser.userid, 0);
      expect(appUser.username, 'testUsername');
      expect(appUser.email, testEmail);
    });

    test('message when failure', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.statusCode).thenReturn(HttpStatus.badRequest);
      when(mockResponse.data).thenReturn(
        {
          'error': 'Error creating user.',
          'message':
              'duplicate key value violates unique constraint \"user_user_email_key\"\nDETAIL:  Key (email)=(test321@test.ca) already exists.\n'
        },
      );

      Map<String, dynamic> result =
          await authServiceAPI.signUp(testEmail, testPw);
      expect(result['message'], mockResponse.data['message']);

      AppUser appUser = result['appUser'];
      expect(appUser.userid, isNull);
      expect(appUser.username, isNull);
      expect(appUser.email, isNull);
    });
  });

  group('signIn', () {
    const String path = '/login';

    test('params passed', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.data).thenReturn({});
      await authServiceAPI.signIn(testEmail, testPw);
      dynamic reqDTO = verify(mockDio.post(path, data: captureAnyNamed('data')))
          .captured
          .single;

      expect(reqDTO['email'], testEmail);
      expect(reqDTO['password'], testPw);
    });

    test('result when success', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.statusCode).thenReturn(HttpStatus.ok);
      when(mockResponse.data).thenReturn(
        {'Token': 'abc123', 'UserId': '1'},
      );
      GetIt.I.registerSingleton<AppState>(appState);

      Map<String, dynamic> result =
          await authServiceAPI.signIn(testEmail, testPw);
      expect(result['appUser'], isA<AppUser>());

      AppUser appUser = result['appUser'];
      expect(appUser.token, 'abc123');
      expect(appUser.userid, 1);
      expect(appUser.email, testEmail);
      expect(appUser.username, isNull);
    });

    test('message when failure', () async {
      when(mockDio.post(path, data: anything))
          .thenAnswer((_) async => mockResponse);
      when(mockResponse.statusCode).thenReturn(HttpStatus.badRequest);
      when(mockResponse.data).thenReturn(
        {
          'email': ['This field is required.'],
          'password': ['This field is required.']
        },
      );

      Map<String, dynamic> result =
          await authServiceAPI.signUp(testEmail, testPw);
      expect(result['message'], 'Error');
    });
  });
}
