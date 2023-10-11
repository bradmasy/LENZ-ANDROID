import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/components/album_tile1.dart';

import '../DataModel/GlobalDataModel.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List<Album> albums = [];

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
                  getAlbums();
                  context.push('/add_album');
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
                  colors: [Color(0xff084470), Color(0x440c7b93)])),
          child: GridView.count(
            childAspectRatio: 0.80,
            crossAxisCount: 2,
            physics: const BouncingScrollPhysics(),
            children: List.generate(albums.length,(index){
              return AlbumTile1(album: albums[index]);
            }),
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
