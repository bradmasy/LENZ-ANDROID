import 'dart:async';

import 'package:flutter/material.dart';

class ThisIsATest extends StatefulWidget {
  int number;
  ThisIsATest({Key? key, required this.number}) : super(key: key);
  @override
  _ThisIsATestState createState() => _ThisIsATestState();
}

class _ThisIsATestState extends State<ThisIsATest> {
  @override
  void initState() {
    super.initState();
    _wait2Seconds().then((value) =>
      print('waited 2 seconds'),
    );

    print('globalNumber is ');
    print('initState');
  }

  @override
  void dipose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('This is a test'),
        ),
        body:
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              children: [
                for (int i = widget.number; i < 100; i++)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        print('tapped $i');
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.only(left: 50, right: 50, top: 10, bottom:10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$i',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          ),
        ),
      );
  }

  Future<void> _wait2Seconds() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void test() {
    setState(() {
      widget.number++;
    });
  }
}

class Bear {
  String price;
  String name;
  Rating rating;
  String image;
  int id;

  Bear({required this.price, required this.name, required this.rating, required this.image, required this.id});

  Bear.fromJson(Map<String, dynamic> json)
      : price = json['price'],
        name = json['name'],
        rating = Rating.fromJson(json['rating']),
        image = json['image'],
        id = json['id'];
}

class Rating {
  double average;
  int reviews;

  Rating({required this.average, required this.reviews});

  Rating.fromJson(Map<String, dynamic> json)
      : average = json['average'].toDouble(),
        reviews = json['reviews'];
}