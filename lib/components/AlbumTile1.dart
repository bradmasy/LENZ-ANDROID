import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../DataModel/GlobalDataModel.dart';

class AlbumTile1 extends StatelessWidget {
  Album album;
  AlbumTile1({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/photos', extra: album);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.5, left: 5, right: 5, top: 2.5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xff084470),
            width: 2,
          ),
          color: Color(0xff084470).withOpacity(0.5) ,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 120,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),),
            //   child: const Icon(
            //     Icons.photo_camera_back_outlined,
            //     size: 120 ,
            //     color: Color(0xffffffff),
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  album.title == "" ? "No Title" : album.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff)),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Text(
              album.description == "" ? "No Description" : album.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  height: 1,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffffffff)),
            ),
          ],
        ),
      ),
    );
  }
}
