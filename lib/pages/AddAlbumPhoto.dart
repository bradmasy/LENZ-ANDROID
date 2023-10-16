import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/DataModel/GlobalDataModel.dart';

import '../components/PhotoTile.dart';

class AddAlbumPhoto extends StatefulWidget {
  Album album;
  AddAlbumPhoto({Key? key, required this.album}) : super(key: key);

  @override
  _AddAlbumPhotoState createState() => _AddAlbumPhotoState();
}

class _AddAlbumPhotoState extends State<AddAlbumPhoto> {
  List<Photo> photos = [];
  List<int> selectedPhotos = [];
  int crossAxisCount = 2;
  @override
  void initState() {
    super.initState();
    getAllPhotos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                crossAxisCount = crossAxisCount > 3 ? 2 : crossAxisCount + 1;
                setState(() {
                });
              },
              icon: const Icon(Icons.table_rows_outlined)),

        ],
          backgroundColor: Colors.transparent,
          title: Text(selectedPhotos.isEmpty ? 'Add Photos to Album' : 'You selected ${selectedPhotos.length} photos'),),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0), topRight: Radius.circular(0)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff084470), Color(0xff0c7b93)])),
              child:
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  // width / height: fixed for *all* items
                  childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 200,
                ),
                // return a custom ItemCard
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: () {
                        print("tap this photo: ${photos[index].id}");
                        if (selectedPhotos.contains(photos[index].id)) {
                          selectedPhotos.remove(photos[index].id);
                        } else {
                          selectedPhotos.add(photos[index].id);
                        }
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: selectedPhotos.contains(photos[index].id) ? 0.5 : 1,
                            child:
                            PhotoTile(photo: photos[index], onTapAllowed: false,),
                          ),
                            Positioned(
                            top: 10,
                            right: 10,
                            child: selectedPhotos.contains(photos[index].id) ? const Icon(Icons.check_circle, color: Colors.white,) : Container(),),
                        ],
                      ), ),
                itemCount: photos.length,
              ),

            ),
            selectedPhotos.isEmpty ? Container() :

            Positioned(
              bottom: 10 ,
              child:
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff084470), width: 4),
                    ),
                    onPressed: () async {
                      addAllPhotosToAlbum().then((value){
                        showToast('Photos Added', duration: const Duration(seconds: 2), onDismiss: () {
                          Navigator.pop(context, true);
                        });
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Text("Add selected photos to\n ${widget.album.title}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff084470)),
                  ),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> getAllPhotos() async {
    var result = await httpApi.getAllPhotos();
    List<Photo> photos = [];
    print(result);
    for (var item in result['results']) {
      photos.add(Photo.fromJson(item));
    }
    setState(() {
      this.photos = photos;
    });
  }

  Future<void> addAllPhotosToAlbum() async {
    for (var photo_id in selectedPhotos) {
      var result = await httpApi.postCreatePhotoAlbumPhotoLink(photo_id: photo_id, photo_album_id: widget.album.id);
      debugPrint(result.toString());
    }
  }
}
