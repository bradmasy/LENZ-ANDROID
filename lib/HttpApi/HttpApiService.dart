abstract class HttpApiService {
  Future<Map<String, dynamic>> getAllPhotos();

  Future<void> getPhotosByID(int id);

  Future<Map<String, dynamic>> getAllPhotoAlbumPhotos();

  Future<Map<String, dynamic>> getPhotoAlbumPhotosByID(int id);

  Future<void> postPhotoUpload();

  Future<Map<String, dynamic>> postCreatePhotoAlbumPhotoLink();

  Future<Map<String, dynamic>> getAllPhotoAlbums();

  Future<void> postCreatePhotoAlbum();
}