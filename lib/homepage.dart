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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(child: Container(color: Colors.blue)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThisIsATest(number: globalNumber),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 50,
                color: Colors.red,
                child: const Text('GestureDetector'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onLongPress: () {
                    appState.setNumber(_counter);
                    print(
                        'ElevatedButton onLongPress appData.setNumber $_counter');
                  },
                  onPressed: () {
                    print('ElevatedButton');
                  },
                  child: const Text('ElevatedButton'),
                ),
                TextButton(
                  onPressed: () {
                    getData();
                    print('TextButton');
                  },
                  child: const Text('TextButton getData'),
                ),
                OutlinedButton(
                  onPressed: () {
                    print('OutlinedButton');
                  },
                  child: const Text('OutlinedButton'),
                ),
                IconButton(
                  onPressed: () {
                    print('IconButton');
                  },
                  icon: const Icon(Icons.add),
                ),
                ElevatedButton(
                    onPressed: () => context.push(AuthRoutes.login.path),
                    child: const Text('login')),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
