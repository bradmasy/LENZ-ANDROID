import '../DataModel/GlobalDataModel.dart';

class AlbumsPresenterImpl implements AlbumsPresenter {
  final AlbumsView _view;

  AlbumsPresenterImpl(this._view);

  @override
  void fetchAlbums() async {
    try {
      var result = await httpApi.getAllPhotoAlbums();
      List<Album> albums = [];
      for (var album in result['results']) {
        albums.add(Album.fromJson(album));
      }
      _view.onAlbumsFetched(albums);
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  void deleteSelectedAlbums(List<Album> selectedAlbums) async {
    try {
      for (var album in selectedAlbums) {
        await httpApi.deletePhotoAlbum(album.id); // Assuming each album has an 'id' attribute
      }
      _view.onAlbumsDeleted(true);
    } catch (e) {
      print(e);
      _view.onAlbumsDeleted(false);
    }
  }
}

abstract class AlbumsView {
  void onAlbumsFetched(List<Album> albums);
  void onAlbumsDeleted(bool success);
// Other UI update methods can be added here.
}

abstract class AlbumsPresenter {
  void fetchAlbums();
  void deleteSelectedAlbums(List<Album> selectedAlbums);
// Other user action methods can be added here.
}