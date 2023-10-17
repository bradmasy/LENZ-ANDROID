import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          title: const Text('Albums'),
          actions: [
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
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              // width / height: fixed for *all* items
              childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 150,
            ),
            // return a custom ItemCard
            itemBuilder: (context, index) =>AlbumTile1(album: albums[index]),
            itemCount: albums.length,
          ),
        ),
      ),
    );
  }

  Future<void> getPhotos() async {
     var result = await httpApi.getAllPhotos();
     print(httpApi);
     print(result);
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
}
