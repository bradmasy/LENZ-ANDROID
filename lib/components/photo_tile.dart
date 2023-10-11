import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../DataModel/GlobalDataModel.dart';

class PhotoTile extends StatefulWidget {
  Photo photo;
  PhotoTile({Key? key, required this.photo}) : super(key: key);

  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
              context: context,
                  barrierColor: Colors.transparent,
                  useSafeArea: false,
              builder: (_) => ImageDialog(photo: widget.photo,)
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xff084470),
                        blurRadius: 20,
                        offset: Offset(0, 10))
                  ]),
              height: 200,
              width: 200,
              child: widget.photo.photo.isNotEmpty? Image.memory(
                base64Decode(widget.photo.photo),
                fit: BoxFit.cover,
              ) : Image(
                width: 200,
                height: 200,
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://source.unsplash.com/random/200x200?sig=1${Random().nextInt(100)}'
              ), )
            ),
          ),
          Text(
          "Title: " + widget.photo.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          ),
          Text(
            "Description: " +widget.photo.description,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          )
        ],
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  Photo photo;
  ImageDialog ({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 500,
          height: 500,
          color: Colors.transparent,
          child: photo.photo.isNotEmpty? Image.memory(
            base64Decode(photo.photo),
            fit: BoxFit.cover,
          ) : Image(image: NetworkImage(
              'https://source.unsplash.com/random/500x500?sig=1${Random().nextInt(100)}'
          ), ),
        ),
      ),
    );
  }
}