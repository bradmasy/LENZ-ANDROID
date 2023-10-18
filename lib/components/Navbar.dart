import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../globals.dart';

class NavBar extends StatefulWidget {
  final GoRouter router;
  const NavBar({required this.router, Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<NavBar> {
  int index = 0;
  AppState appState = AppState();

  void onDestinationSelected(int newIndex) {
    setState(() => index = newIndex);
    String route;

    switch (index) {
      case 0:
        route = '/home';
        break;
      case 1:
        route = '/search';
        break;
      case 2:
        route = '/map';
        break;
      case 3:
        route = '/albums';
        break;
      case 4:
        route = '/userprofile';
        break;
      default:
        route = '/home'; // Default route if index is not matched
        break;
    }
    widget.router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(),
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
                  selectedIcon: Icon(Icons.person),
                  label: "Profile")
            ]));
  }
}
