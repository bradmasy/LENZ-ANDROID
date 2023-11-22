import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/components/PhotoTile.dart';

import '../DataModel/GlobalDataModel.dart';

class AllPhotos extends StatefulWidget {

  const AllPhotos({Key? key}) : super(key: key);

  @override
  _AllPhotosState createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {

  late CameraDescription _cameraDescription;
  List<Photo> photos = [];
  int crossAxisCount = 2;

  bool deleteMode = false;
  bool loading = false;
  List<Photo> deletePhotos = [];
  @override
  void initState() {
    super.initState();
    getAllPhotos();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:
          deleteMode ? const Text('Delete Photos Mode') :
          const Text('All Photos'),
          actions: [
            IconButton(
                onPressed: () {
                  deleteMode = !deleteMode;
                  setState(() {
                  });
                },
                icon: const Icon(Icons.delete_forever_outlined)),
            IconButton(
                onPressed: () {
                  crossAxisCount = crossAxisCount > 3 ? 2 : crossAxisCount + 1;
                  setState(() {
                  });
                },
                icon: const Icon(Icons.table_rows_outlined)),
            IconButton(
                onPressed: () async {
                  getAllPhotos();
                  var result = await context.push('/add_photo', extra: _cameraDescription);
                  if (result != null) {
                    getAllPhotos();
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
                  colors: [Color(0xff084470), Color(0xff0c7b93)])),
          child:
          Stack(
            children: [
              loading ? const Center(
                child:  CircularProgressIndicator(
                  color: Colors.white,
                ),
              ) : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  // width / height: fixed for *all* items
                  childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 200,
                ),
                // return a custom ItemCard
                itemBuilder: (context, index) =>
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        PhotoTile(photo: photos[index], onTapAllowed: true, refreshNotification: () { getAllPhotos(); },),
                        deleteMode ? Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (deletePhotos.contains(photos[index])) {
                                deletePhotos.remove(photos[index]);
                              } else {
                                deletePhotos.add(photos[index]);
                              }
                              setState(() {
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: deletePhotos.contains(photos[index]) ? Colors.red.withOpacity(0.7) : Colors.transparent,
                              ),
                              child: deletePhotos.contains(photos[index]) ? const Icon(Icons.check_circle, color: Colors.white,) : Container(),
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),
                itemCount: photos.length,
              ),
              deleteMode ? Positioned(
                bottom: 10 ,
                left: 20,
                right: 20,
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
                      showDialog(context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Photos'),
                            content: Text('Are you sure you want to delete ${deletePhotos.length} selected photos?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    deleteSelectedPhotos().then((value){
                                      value ? showToast('Photos deleted successfully') : showToast('Error deleting photos');
                                      deleteMode = false;
                                      setState(() {
                                      });
                                      Navigator.pop(context);
                                    });
                                  }, child: const Text('Delete')),
                            ],
                          )
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Text("Delete selected ${deletePhotos.length} photos",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff084470)),
                      ),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllPhotos() async {
    var result = await httpApi.getAllPhotos();
    List<Photo> photos = [];
    for (var item in result['results']) {
      photos.add(Photo.fromJson(item));
    }
    setState(() {
      this.photos = photos;
    });
  }

  Future<bool> deleteSelectedPhotos() async {
    try {
      loading = true;
      setState(() {
      });
      for (var item in deletePhotos) {
        await httpApi.deletePhoto(item.id);
      }
      deletePhotos.clear();
      await getAllPhotos();
      loading = false;
      setState(() {
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
