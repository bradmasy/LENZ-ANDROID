import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/routes.dart';
import 'package:photo_gallery/this_is_a_test.dart';

import 'auth/auth_routes.dart';
import 'globals.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppState appState = AppState();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter = appState.number++;
    });
    print('$_counter');
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homepage_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 50),
              child: Row(
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/BCIT_logo.svg/1129px-BCIT_logo.svg.png',
                    height: 60,
                    fit: BoxFit.fitHeight,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              "LENZ",
              style: TextStyle(
                fontSize: 99,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 99.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const Text(
              '- your story through… the eyes of a lens',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xffffffff),
                fontStyle: FontStyle.italic,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 25.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0xff084470),
                            width: 4
                        ),
                      ),
                      onPressed: () => context.push(AuthRoutes.login.path),
                      child: const Text('login')),
                ),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        backgroundColor: Color(0xff084470),
                        side: const BorderSide(
                            color: Color(0xff084470),
                            width: 4
                        ),
                      ),
                      onPressed: () => context.push(AuthRoutes.signup.path),
                      child: const Text('Signup',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  //dio get request https://api.sampleapis.com/beers/ale
  Future<void> getData() async {
    final dio = Dio();
    final response = await dio.get('https://api.sampleapis.com/beers/ale');
    print(response.data);
    List<Bear> bears = [];
    // for (var element in response.data) {
    //   bears.add(Bear.fromJson(element));
    // }
    bears = (response.data as List).map((e) => Bear.fromJson(e)).toList();
    for (var element in bears) {
      print(element.name);
    }
  }
}
