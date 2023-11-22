import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_gallery/globals.dart';
import 'package:photo_gallery/injection.dart';
import 'package:photo_gallery/routes.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  initState() {
    if (GetIt.I.isRegistered<AppState>()) {
          return;
    }
    configureDependencies();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return ChangeNotifierProvider(
        create: (BuildContext context) => GetIt.I.get<AppState>(),
        lazy: false,
        child: OKToast(
          child: MaterialApp(
            title: 'LENZ',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),
            home: EasySplashScreen(
              logo: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/BCIT_logo.svg/1129px-BCIT_logo.svg.png',
                height: 200,
                fit: BoxFit.fitHeight,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('BCIT');
                },
              ),
              title: const Text(
                'LENZ',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff084470),
                ),
              ),
              backgroundColor: const Color(0xffffffff),
              showLoader: true,
              loaderColor: const Color(0xff084470),
              loadingText: const Text(
                'your story through… the eyes of a lens',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff084470),
                  fontStyle: FontStyle.italic,
                ),
              ),
              navigator: MaterialApp.router(
                title: 'LENZ',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                  useMaterial3: true,
                ),
                routerConfig: router,
              ),
              durationInSeconds: 1,
            ),
          ),
        ));
  }
}
