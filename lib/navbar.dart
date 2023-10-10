import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'auth/auth_routes.dart';
import 'globals.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<NavBar> {
  int index = 0;
  AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
            height: 60,
            selectedIndex: index,
            // onDestinationSelected: (index) => setState(() => this.index = index),
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
              label: "Albums")
        ]));
  }
}
