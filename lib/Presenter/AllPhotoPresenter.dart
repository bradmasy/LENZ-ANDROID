import 'package:photo_gallery/DataModel/GlobalDataModel.dart';
class AllPhotosPresenterImpl implements AllPhotosPresenter {
  final AllPhotosView _view;

  AllPhotosPresenterImpl(this._view);

  @override
  void fetchPhotos() async {
    try {
      var result = await httpApi.getAllPhotos();
      List<Photo> photos = [];
      for (var photo in result['results']) {
        photos.add(Photo.fromJson(photo));
      }
      _view.onPhotosFetched(photos);
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  void deleteSelectedPhotos(List<Photo> selectedPhotos) async {
    try {
      for (var photo in selectedPhotos) {
        await httpApi.deletePhoto(photo.id); // Assuming each photo has an 'id' attribute
      }
      _view.onPhotosDeleted(true);
    } catch (e) {
      print(e);
      _view.onPhotosDeleted(false);
    }
  }
}

abstract class AllPhotosView {
  void onPhotosFetched(List<Photo> photos);
  void onPhotosDeleted(bool success);
// Other UI update methods can be added here.
}

abstract class AllPhotosPresenter {
  void fetchPhotos();
  void deleteSelectedPhotos(List<Photo> selectedPhotos);
}