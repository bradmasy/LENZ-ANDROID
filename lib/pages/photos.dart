import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../DataModel/GlobalDataModel.dart';

class Photos extends StatefulWidget {
  Album album;
  Photos({Key? key, required this.album}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent, title: const Text('Photos'),
            actions: [
              IconButton(
                  onPressed: () {
                    context.push('/add_photo');
                  },
                  icon: const Icon(Icons.add))
            ]),
        body: Center(
            child: Text(
              widget.album.title,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xff084470),
              ),
            )
        )
    );
  }

  Future<void> getAllPhotos() async {


  }

}
