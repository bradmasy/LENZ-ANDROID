
import 'package:geolocator/geolocator.dart';
import '../DataModel/GlobalDataModel.dart';


abstract class HttpApiService {
  Future<Map<String, dynamic>> getAllPhotos();

  Future<void> getPhotosByID(int id);

  Future<Map<String, dynamic>> getAllPhotoAlbumPhotos();

  Future<Map<String, dynamic>> getPhotoAlbumPhotosByID(int id);

  Future<void> postPhotoUpload();

  Future<Map<String, dynamic>> postCreatePhotoAlbumPhotoLink();

  Future<Map<String, dynamic>> getAllPhotoAlbums();

  Future<Map<String, dynamic>> postCreatePhotoAlbum({
    String title = '',
    String description = '',
  });

  Future<Map<String, dynamic>> uploadPhotos({
    String title = '',
    String description = '',
    String photoPath =  '',
    Position? position
  });

  Future<Map<String, dynamic>> deletePhoto(int id);

  Future<Map<String, dynamic>> deletePhotoAlbum(int id);

  Future<Map<String, dynamic>> updatePhoto({
    required Photo photo,
    String title = '',
    String description = '',
  });

  Future<Map<String, dynamic>> updatePhotoAlbum({
    String title = '',
    String description = '',
    int id =  0,
  });


  Future<Map<String, dynamic>> searchPhotos({
    String title = '',
    String description = '',
    String fromDate = '',
    String toDate = ''
  });
}