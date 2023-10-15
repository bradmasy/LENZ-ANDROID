
import 'package:photo_gallery/auth/domain/AppUser.dart';

import '../HttpApi/HttpApi.dart';

HttpApi httpApi = HttpApi();
AppUser loginUser = AppUser();
class Album {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;

  Album({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}

class Photo {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String photo;

  Photo({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.photo = '',
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      photo: json['photo'] as String,
    );
  }
}

class AlbumPhoto {
  final int id;
  final int photoAlbumId;
  final int photoId;

  AlbumPhoto({
    this.id = 0,
    this.photoAlbumId = 0,
    this.photoId = 0,
  });

  factory AlbumPhoto.fromJson(Map<String, dynamic> json) {
    return AlbumPhoto(
      id: json['id'] as int,
      photoAlbumId: json['photoAlbumId'] as int,
      photoId: json['photoId'] as int,
    );
  }
}