import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/components/PhotoTile.dart';

import '../DataModel/GlobalDataModel.dart';

class Photos extends StatefulWidget {
  Album album;
  Photos({Key? key, required this.album}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  List<AlbumPhoto> albumPhotos = [];
  int crossAxisCount = 2;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getAlbumPhotos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent, title: const Text('Photos'),
            actions: [
              IconButton(
                  onPressed: () {
                    crossAxisCount = crossAxisCount > 3 ? 2 : crossAxisCount + 1;
                    setState(() {
                    });
                  },
                  icon: const Icon(Icons.table_rows_outlined)),
              IconButton(
                  onPressed: () async {
                    var result = await context.push('/add_album_photo', extra: widget.album);
                    if (result != null) {
                      await getAlbumPhotos();
                    }
                  },
                  icon: const Icon(Icons.add))
            ]),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0), topRight: Radius.circular(0)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff084470), Color(0x440c7b93)])),
            child:
            albumPhotos.isEmpty && !isLoaded ? const Center(child: CircularProgressIndicator(color: Colors.white,)) :
            albumPhotos.isEmpty && isLoaded ? const Center(child: Text('No Photos Found', style: TextStyle(color: Colors.white),)) :
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                // width / height: fixed for *all* items
                childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 200,
              ),
              // return a custom ItemCard
              itemBuilder: (context, index) =>PhotoTile(photo: albumPhotos[index].photo, onTapAllowed: true,),
              itemCount: albumPhotos.length,
            ),
          ),
        ),
    );
  }

  Future<void> getAlbumPhotos() async {
    var response = await httpApi.getPhotoAlbumPhotosByID(widget.album.id);
    print(response.toString() + ' response' + widget.album.id.toString());
    if (response['results'] == null) {
      showToast('No Photos Found', duration: const Duration(seconds: 2), onDismiss: () {
      });
      return;
    }
    albumPhotos.clear();
    isLoaded = true;
    for (var item in response['results']) {
      albumPhotos.add(AlbumPhoto.fromJson(item));
    }
    setState(() {

    });
  }
}
