import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';
import 'package:photo_gallery/auth/services/AuthServiceApi.dart';
import 'package:test/test.dart';

import 'AuthServiceApi_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  /**
   * curl -v -sw "\n" -X POST "https://lenz-5f9c8ee2c363.herokuapp.com/signup" \
      -H 'Content-Type: application/json' \
      -d '{"username": "test321", "email": "test321@test.ca", "password": "test", "first_name": "test", "last_name": "test"}' | json_pp
   */
  test('Signup should work', () async {
    final Dio mockDio = MockDio();
    final AuthServiceAPI authServiceAPI = AuthServiceAPI.withDio(mockDio);

    when(mockDio.post('/signup', data: anything)).thenAnswer((_) async =>
        Response(data: {
          "message": "User created successfully",
          "user": {
            "id": 0,
            "email": "test@test.com",
            "username": "testUsername",
            "firstName": "testFirstName",
            "lastName": "testLastName"
          }
        }, statusCode: HttpStatus.created, requestOptions: RequestOptions()));

    Map<String, dynamic> result =
        await authServiceAPI.signUp('test@test.com', 'test');
    expect(result['message'], "User created successfully");
    expect(result['appUser'], isNotNull);
    expect(result['appUser'], isA<AppUser>());

    AppUser appUser = result['appUser'];
    expect(appUser.userid, 0);
    expect(appUser.username, 'testUsername');
    expect(appUser.email, 'test@test.com');
  });
}
