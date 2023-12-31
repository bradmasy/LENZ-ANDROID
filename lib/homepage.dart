import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';
import 'package:photo_gallery/routes.dart';
import 'package:provider/provider.dart';

import 'auth/AuthRoutes.dart';
import 'globals.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
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
              margin: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 50),
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
                  width: 180,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      backgroundColor: Color(0xddffffff),
                      side:
                          const BorderSide(color: Color(0xff084470), width: 4),
                    ),
                    onPressed: _loginThen,
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Color(0xff084470),
                        fontSize: 16,
                      ),
                    ),
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

  void _loginThen() async {
    AppUser? appUser = await context.push(AuthRoutes.login.path) as AppUser;
    if (context.mounted && appUser.token != null) {
      context.go(Routes.dash.path);
    }
    return;
  }
}
