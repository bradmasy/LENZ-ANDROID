import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Signup')),
        body: const Center(
            child: Column(
          children: [Text('Signup')],
        )));
  }
}
