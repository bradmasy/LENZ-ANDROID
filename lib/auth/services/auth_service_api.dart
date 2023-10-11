import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';
import 'package:photo_gallery/auth/domain/constants.dart';
import 'package:photo_gallery/auth/domain/dtos/login_dto.dart';
import 'package:photo_gallery/auth/domain/dtos/signup_dto.dart';
import 'package:photo_gallery/auth/services/auth_service.dart';
import 'package:photo_gallery/globals.dart';

import '../../DataModel/GlobalDataModel.dart';

class AuthServiceAPI implements AuthService {
  final _dio = Dio();

  AuthServiceAPI() {
    _dio.options.baseUrl = AuthConstants.authService;
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    SignupDTO signupDTO = SignupDTO(_getRandomString(10), email, password,
        _getRandomString(5), _getRandomString(7));
    Map<String, dynamic> signupDTOJson = signupDTO.toJson();
    try {
      final Response res = await _dio.post('/signup', data: signupDTOJson);
      final dynamic data = res.data;
      final String message = data['message'] ?? 'Error';
      final appUserData = data['user'] ?? {};
      AppUser appUser = AppUser();
      appUser.userid = appUserData['id'];
      appUser.username = appUserData['username'];
      appUser.email = appUserData['email'];
      final Map<String, dynamic> result = {
        'message': message,
        'appUser': appUser
      };
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    Map<String, dynamic> loginDTOJson = LoginDTO(email, password).toJson();
    try {
      final Response res = await _dio.post('/login', data: loginDTOJson);
      //print res data
      print(res.data);
      AppUser appUser = AppUser();
      appUser.token = res.data['Token'];
      appUser.userid = int.parse(res.data['UserId'] ?? 0);
      GetIt.I.get<AppState>().setAppUser(appUser);
      final Map<String, dynamic> result = {'appUser': appUser};
      print(appUser.token);
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<void> signOut() async {
    GetIt.I.get<AppState>().setAppUser(null);
  }

  String _getRandomString(int len) {
    Random random = Random.secure();
    List<int> values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values).substring(0, len);
  }
}
