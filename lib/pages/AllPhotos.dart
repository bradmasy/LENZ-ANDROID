import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          title: const Text('All Photos'),
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
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              // width / height: fixed for *all* items
              childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 200,
            ),
            // return a custom ItemCard
            itemBuilder: (context, index) =>PhotoTile(photo: photos[index], onTapAllowed: true,),
            itemCount: photos.length,
          ),
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
}
