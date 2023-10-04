import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';
import 'package:photo_gallery/auth/domain/constants.dart';
import 'package:photo_gallery/auth/domain/dtos/login_dto.dart';
import 'package:photo_gallery/auth/domain/dtos/signup_dto.dart';
import 'package:photo_gallery/auth/services/auth_service.dart';

class AuthServiceAPI implements AuthService {
  final _dio = Dio();

  AuthServiceAPI() {
    _dio.options.baseUrl = AuthConstants.authService;
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    SignupDTO signupDTO = SignupDTO(_getRandomString(10), email, password,
        _getRandomString(5), _getRandomString(7));
    final Response res = await _dio.post('/signup', data: signupDTO);
    final dynamic data = res.data;
    AppUser appUser = AppUser();
    appUser.userid = data['id'];
    appUser.username = data['username'];
    appUser.email = data['email'];
    return appUser;
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    final Response res =
        await _dio.post('/login', data: LoginDTO(email, password));
    AppUser appUser = AppUser();
    appUser.token = res.data['token'];
    return appUser;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  String _getRandomString(int len) {
    Random random = Random.secure();
    List<int> values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values).substring(0, len);
  }
}
