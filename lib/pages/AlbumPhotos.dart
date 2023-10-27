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

  bool showInfo = false;

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
            backgroundColor: Colors.transparent,
            title: Text('Album Photos'),
            actions: [
              IconButton(
                  onPressed: () {
                    showInfo = !showInfo;
                    setState(() {
                    });
                  },
                  icon: const Icon(Icons.info_outline_rounded)),
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
            ],
        ),
        body: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  showInfo ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Text("Title: ${widget.album.title}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 25.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Text("Description: ${widget.album.description}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 25.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Text("Created at: ${DateTime.parse(widget.album.createdAt).toLocal().toString().substring(0, 19)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 25.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xff084470), width: 4),
                          ),
                          onPressed: () async {
                            showDialog(context: context, builder:
                                (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Update Album\nInformation"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: TextEditingController(text: widget.album.title),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Title',
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextField(
                                      controller: TextEditingController(text:  widget.album.description),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Description',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String updatedTitle = TextEditingController().text;
                                      String updatedDescription = TextEditingController().text;
                                      updateAlbumInformation(updatedTitle, updatedDescription).then((value)  {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text("Update"),
                                  ),
                                ],
                              );
                            }
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            child: const Text("Update album information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff084470)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: showInfo ? MediaQuery.of(context).size.height - 170 : MediaQuery.of(context).size.height - 100,
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
                      itemBuilder: (context, index) =>PhotoTile(photo: albumPhotos[index].photo, onTapAllowed: true, refreshNotification: () {  },),
                      itemCount: albumPhotos.length,
                    ),
                  ),
                ],
              ),
            ],
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

  Future<void> updateAlbumInformation(String updatedTitle, String updatedDescription) async {
    // var response = await httpApi.patchPhotoAlbumByID(widget.album.id, title: updatedTitle, description: updatedDescription);
    // if (response['id'] != null) {
    //   showToast('Album Updated', duration: const Duration(seconds: 2), onDismiss: () {
    //   });
    // }
  }
}
