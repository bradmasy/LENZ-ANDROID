
import 'package:dio/dio.dart';
import 'dart:io' as io;
import 'dart:convert';
import '../DataModel/GlobalDataModel.dart';
import '../auth/domain/AuthConstants.dart';
import 'HttpApiService.dart';

class HttpApi implements HttpApiService {
  final _dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        contentType: 'application/json; charset=UTF-8',
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 5),
      ),
  );

  HttpApi() {
    _dio.options.baseUrl = AuthConstants.authService;
  }

  void setToken(String token) {
    print('setToken: $token');
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = 'Token $token';
          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> getAllPhotos() async {
    try {
      final Response res = await _dio.get('/photo');
      final dynamic data = res.data;
      return data;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> getPhotosByID(int id) async {
    try {
      final Response res = await _dio.get('/photo/$id');
      final dynamic data = res.data;
      final List<dynamic> photos = data['photos'] ?? [];
      final Map<String, dynamic> result = {'photos': photos};
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> getAllPhotoAlbumPhotos() async {
    try {
      final Response res = await _dio.get('/photo-album-photo');
      final dynamic data = res.data;
      final List<dynamic> photoAlbumPhotos = data['photoAlbumPhotos'] ?? [];
      final Map<String, dynamic> result = {'photoAlbumPhotos': photoAlbumPhotos};
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> getPhotoAlbumPhotosByID(int id) async {
    try {
      final Response res = await _dio.get('/photo-album-photo/$id');
      final dynamic data = res.data;
      final List<dynamic> photoAlbumPhotos = data['results'] ?? [];
      final Map<String, dynamic> result = {'results': photoAlbumPhotos};
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> postPhotoUpload() async {
    try {
      final Response res = await _dio.post('/photo');
      final dynamic data = res.data;
      final List<dynamic> photoUpload = data['photoUpload'] ?? [];
      final Map<String, dynamic> result = {'photoUpload': photoUpload};
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> postCreatePhotoAlbumPhotoLink({
    int photo_id = 0,
    int photo_album_id =  0,
  }) async {
    if (photo_album_id == 0 || photo_id == 0) {
      return {'message': 'Error'};
    }
    try {
      final Response res = await _dio.post('/photo-album-photo', data: {
        'photo_id': photo_id,
        'photo_album_id': photo_album_id,
      });
      final dynamic data = res.data;
      final Map<String, dynamic> createPhotoAlbumPhotoLink = data ?? [];
      final Map<String, dynamic> result = {'result': createPhotoAlbumPhotoLink};
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> getAllPhotoAlbums() async {
    try {
      final Response res = await _dio.get('/photo-album');
      final dynamic data = res.data;
      return data;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> postCreatePhotoAlbum({
    String title = '',
    String description = '',
}) async {
    try {
      final Response res = await _dio.post('/photo-album',
          data: {
        'title': title,
        'description': description,
            'user_id': loginUser.userid,
      });
      final dynamic data = res.data;
      return data;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }


  @override
  Future<Map<String, dynamic>> uploadPhotos({
    String title = '',
    String description = '',
    String photoPath =  '',
  }) async {
    MultipartFile photo = await MultipartFile.fromFile(photoPath);
    final bytes = io.File(photoPath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(img64);
    var formData = FormData.fromMap({
      'photo': photo,
      'title': title,
      'description': description,
      'user_id': loginUser.userid,
      'active': true,
    });
    var response = await _dio.post('/photo-upload', data: formData);
    print(response.data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> deletePhoto(int id) async {
    //{"message":"Photo Album Successfully Deleted","photo":{"id":null,"userId":40,"description":"123","title":"123","photo":null,"active":true,"createdAt":"2023-10-11T03:58:06.869010Z","updatedAt":"2023-10-11T03:58:06.869025Z"}}
    try {
      final Response res = await _dio.delete('/photo/$id');
      final dynamic data = res.data;
      final Map<String, dynamic> result = data;
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> deletePhotoAlbum(int id) async {
    try {
      final Response res = await _dio.delete('/photo-album/$id');
      final dynamic data = res.data;
      final Map<String, dynamic> result = data;
      return result;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> updatePhoto({
    int id = 0,
    String title = '',
    String description = '',
  }) async {
    try {
      var formData = FormData.fromMap({
        'title': title,
        'description': description,
      });
      final Response res = await _dio.patch('/photo/$id',
          data:  formData);
      final dynamic data = res.data;
      return data;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }

  @override
  Future<Map<String, dynamic>> updatePhotoAlbum({
    String title = '',
    String description = '',
    int id =  0,
  }) async {
    if(id == 0) return {'message': 'Error'};
    try {
      final Response res = await _dio.patch('/photo-album/$id',
          data: {
            'title': title,
            'description': description,
          });
      final dynamic data = res.data;
      return data;
    } catch (e) {
      print(e);
      return {'message': 'Error'};
    }
  }


}