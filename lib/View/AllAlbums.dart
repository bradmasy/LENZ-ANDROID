import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';
import '../Presenter/AllAlbumPresenter.dart';
import '../components/AlbumTile.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> implements AlbumsView {
  late AlbumsPresenter _presenter;

  List<Album> albums = [];
  int crossAxisCount = 2;
  bool deleteMode = false;
  List<Album> deleteAlbums = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _presenter = AlbumsPresenterImpl(this);
    _presenter.fetchAlbums();
    getAlbums();
  }

  @override
  void onAlbumsFetched(List<Album> albums) {
    setState(() {
      this.albums = albums;
    });
  }

  @override
  void onAlbumsDeleted(bool success) {
    if (success) {
      showToast('Albums deleted successfully');
      _presenter.fetchAlbums(); // Refresh the album list
    } else {
      showToast('Error deleting albums');
    }
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
                key: const Key('delete_albums'),
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
                key: const Key('add_album'),
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
                  childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 150,
                ),
                // return a custom ItemCard
                itemBuilder: (context, index) =>
                    Stack(
                      key: Key(index.toString()),
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        AlbumTile1(album: albums[index], refreshNotification: () { getAlbums(); },),
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
                    key: const Key('delete_selected_albums'),

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
                                  key: const Key('delete_selected_albums_confirm'),
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
    albums.clear();
    for (var item in result['results']) {
      albums.add(Album.fromJson(item));
    }
    setState(() {});
  }

  Future<bool> deleteSelectedAlbums() async {
    try {
      loading = true;
      for (var item in deleteAlbums) {
        await httpApi.deletePhotoAlbum(item.id);
      }
      deleteAlbums.clear();
      await getAlbums();
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
