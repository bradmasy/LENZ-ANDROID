import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';
import '../components/AlbumTile1.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List<Album> albums = [];
  int crossAxisCount = 2;
  bool deleteMode = false;
  List<Album> deleteAlbums = [];

  @override
  void initState() {
    super.initState();
    getAlbums();
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
          title:deleteMode ? const Text('Delete Albums Mode') :
          const Text('Albums'),
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
                  crossAxisCount = crossAxisCount > 2 ? 1 : crossAxisCount + 1;
                  setState(() {
                  });
                },
                icon: const Icon(Icons.table_rows_outlined)),
            IconButton(
                onPressed: () async {
                  getAlbums();
                  final result = await context.push('/add_album');
                  if (result != null) {
                    getAlbums();
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
                  colors: [Color(0xffffffff), Color(0xffffffff)])),
          child:
          Stack(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  // width / height: fixed for *all* items
                  childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 150,
                ),
                // return a custom ItemCard
                itemBuilder: (context, index) =>
                    Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        AlbumTile1(album: albums[index]),
                        deleteMode ? Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (deleteAlbums.contains(albums[index])) {
                                deleteAlbums.remove(albums[index]);
                              } else {
                                deleteAlbums.add(albums[index]);
                              }
                              setState(() {
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2.5, left: 5, right: 5, top: 2.5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xff084470),
                                  width: 2,
                                ),
                                color: deleteAlbums.contains(albums[index]) ? Colors.red.withOpacity(0.7) : Colors.transparent,
                              ),
                              child: deleteAlbums.contains(albums[index]) ? const Icon(Icons.check_circle, color: Colors.white,) : Container(),
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),
                itemCount: albums.length,
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
                            title: const Text('Delete Albums'),
                            content: Text('Are you sure you want to delete ${deleteAlbums.length} selected albums?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    deleteSelectedAlbums().then((value){
                                      showToast('Albums deleted successfully');
                                      deleteMode = false;
                                      getAlbums();
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
                      child: Text("Delete selected ${deleteAlbums.length} albums",
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

  Future<void> getAlbums() async {
    var result = await httpApi.getAllPhotoAlbums();
    print(result);
    albums.clear();
    for (var item in result['results']) {
      albums.add(Album.fromJson(item));
    }
    setState(() {});
  }

  Future<void> deleteSelectedAlbums() async {
    for (var item in deleteAlbums) {
      // await httpApi.deletePhotoAlbum(albumId: item.id);
    }
    deleteAlbums.clear();
    setState(() {
    });
  }
}
