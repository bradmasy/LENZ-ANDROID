import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/pages/albums.dart';
import 'package:photo_gallery/pages/photos.dart';

import '../components/navbar.dart';
import '../routes.dart';
import 'all_photos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          height: 60,
          selectedIndex: index,
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: "Search"),
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: "Map"),
            NavigationDestination(
                icon: Icon(Icons.photo_album_outlined),
                selectedIcon: Icon(Icons.photo_album),
                label: "Albums"),
            NavigationDestination(
                icon: Icon(Icons.photo_album_outlined),
                selectedIcon: Icon(Icons.photo),
                label: "Photos")
          ]),
      body: IndexedStack(
        index: index,
        children: <Widget>[
          Container(),
          Container(),
          Container(),
          Albums(),
          AllPhotos(),
        ],
      ),
    );
  }

  void onDestinationSelected(int newIndex) {
    setState(() => index = newIndex);
    String route;
  }
}
