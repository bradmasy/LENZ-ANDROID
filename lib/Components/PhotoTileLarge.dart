import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';

class PhotoTileLarge extends StatefulWidget {
  Photo photo;
  bool onTapAllowed;
  final VoidCallback refreshNotification;

  PhotoTileLarge({Key? key, required this.photo, required this.onTapAllowed, required this.refreshNotification}) : super(key: key);

  @override
  _PhotoTileLargeState createState() => _PhotoTileLargeState();
}

class _PhotoTileLargeState extends State<PhotoTileLarge> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildPhoto(),
        SizedBox(height: 10,),
      ],
    );
  }
  Widget buildPhoto() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),),
        height: 500,
        child:
          Stack (
            children: [
              widget.photo.photo.isNotEmpty? Image.memory(
                height: 500,
                width: MediaQuery.of(context).size.width,
                base64Decode(widget.photo.photo),
                fit: BoxFit.cover,
              ) : Image(
                height: 500,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://source.unsplash.com/random/200x200?sig=1${Random().nextInt(100)}'
                ), ),
              Positioned(
                bottom: 100,
                left:10,
                  child: Text(
                    "${widget.photo.title}",
                    style: const TextStyle(
                        height: 2,
                        fontSize: 50,
                        overflow: TextOverflow.fade,
                        shadows: [
                          Shadow(
                            blurRadius: 50.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Color(0xffffffff)),
                  )
              ),
              Positioned(
                  bottom: 50,
                  left:10,
                  child: Text(
                    "${widget.photo.description}",
                    style: const TextStyle(
                        height: 1,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xffffffff)),
                  )
              )
            ],
          )
    );
  }
}