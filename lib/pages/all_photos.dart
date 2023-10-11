import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/components/photo_tile.dart';

import '../DataModel/GlobalDataModel.dart';

class AllPhotos extends StatefulWidget {
  const AllPhotos({Key? key}) : super(key: key);

  @override
  _AllPhotosState createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {

  late CameraDescription _cameraDescription;
  List<Photo> photos = [];

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
                  getAllPhotos();
                  context.push('/add_photo', extra: _cameraDescription);
                },
                icon: const Icon(Icons.add))
          ]),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(left: 10, right: 10,),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff084470), Color(0xff0c7b93)])),
          child: GridView.count(
            childAspectRatio: 0.70,
            crossAxisCount: 2,
            physics: const BouncingScrollPhysics(),
            children: List.generate(photos.length,(index){
              return PhotoTile(photo: photos[index]);
            }),
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
