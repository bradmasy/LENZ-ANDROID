import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/DataModel/GlobalDataModel.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';
import 'package:photo_gallery/globals.dart';
import 'package:photo_gallery/homepage.dart';

import '../auth/services/AuthService.dart';
import '../components/PhotoTile.dart';
import '../components/PhotoTileLarge.dart';
import '../routes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Photo> photos = [];
  bool loading = false;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getAllPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Welcome ${GetIt.I.get<AppState>().appUser?.email}'),
            actions: [
              IconButton(
                  onPressed: () async {
                    showDialog(context: context,
                        builder:  (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    httpApi.setToken("");
                                    Navigator.of(context).pop();
                                    await GetIt.I.get<AuthService>().signOut();
                                    showToast('Logged out' );
                                    router.go("/");
                                  },
                                  child: Text('Logout')),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.logout_outlined))
            ]),
        body: ListView(
          controller: scrollController,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                  'Feature',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
            ),
            if (photos.isNotEmpty)
              PhotoTileLarge(photo: photos.first, onTapAllowed: true, refreshNotification: () { },),
            if (photos.isEmpty)
              Container(
                  height: 510,
                  child: const Center(child: CircularProgressIndicator())),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
            ),
            if (photos.isEmpty)
              Container(
                  height: 200,
                  child: const Center(child: CircularProgressIndicator())),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    for (var photo in photos.sublist(0, photos.length > 4 ? 4 : photos.length))
                      PhotoTile(photo: photo, onTapAllowed: true, refreshNotification: () { },),
                  ],
                ),
              ),
          ],
        ),
    );
  }

  Future<void> getAllPhotos() async {
    var result = await httpApi.getAllPhotos();
    print(result);
    List<Photo> photos = [];
    for (var item in result['results']) {
      photos.add(Photo.fromJson(item));
      if (photos.length == 5) {
        break;
      }
    }
    debugPrint('photos: $photos');
    photos.shuffle();
    setState(() {
      this.photos = photos;
    });
  }
}
