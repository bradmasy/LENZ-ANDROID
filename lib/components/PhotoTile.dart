import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../DataModel/GlobalDataModel.dart';

class PhotoTile extends StatefulWidget {
  Photo photo;
  bool onTapAllowed;
  PhotoTile({Key? key, required this.photo, required this.onTapAllowed}) : super(key: key);

  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.onTapAllowed ?
          GestureDetector(
              onTap: () async {
                  await showDialog(
                  context: context,
                      barrierColor: Colors.transparent,
                      useSafeArea: false,
                  builder: (_) => ImageDialog(photo: widget.photo,)
                  );
              },
            child: buildPhoto(),
          ) :
          GestureDetector(
            onLongPress: () async {
              await showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  useSafeArea: false,
                  builder: (_) => ImageDialog(photo: widget.photo,)
              );
            },
            child: buildPhoto(),
          ),
          SizedBox(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                "${widget.photo.title}",
                    style: const TextStyle(
                        height: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff)),
                ),
                const SizedBox(width: 10,),
                Text(
                  "${widget.photo.description}",
                  style: const TextStyle(
                      height: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xffffffff)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildPhoto() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xff084470),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ]),
        height: 175,
        width: 200,
        child: widget.photo.photo.isNotEmpty? Image.memory(
          base64Decode(widget.photo.photo),
          fit: BoxFit.cover,
        ) : Image(
          width: 200,
          height: 175,
          fit: BoxFit.fill,
          image: NetworkImage(
              'https://source.unsplash.com/random/200x200?sig=1${Random().nextInt(100)}'
          ), )
    );
  }
}

class ImageDialog extends StatelessWidget {
  Photo photo;
  ImageDialog ({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.black54,
        shadowColor: Colors.black54,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: photo.photo.isNotEmpty? InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 3,
              child: Image.memory(
                base64Decode(photo.photo),
                fit: BoxFit.contain,
              ),
            ) : Image(image: NetworkImage(
                'https://source.unsplash.com/random/500x500?sig=1${Random().nextInt(100)}'
            ), ),
          ),
        ),
      ),
    );
  }
}