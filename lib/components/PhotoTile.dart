import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';

class PhotoTile extends StatefulWidget {
  Photo photo;
  bool onTapAllowed;
  final VoidCallback refreshNotification;

  PhotoTile({Key? key, required this.photo, required this.onTapAllowed, required this.refreshNotification}) : super(key: key);

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
                showDialog(
                  context: context,
                      barrierColor: Colors.transparent,
                      useSafeArea: false,
                  builder: (_) => ImageDialog(photo: widget.photo,)
                ).then((value) => widget.refreshNotification()  );
              },
            child: buildPhoto(),
          ) :
          GestureDetector(
            onLongPress: () async {
               showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  useSafeArea: false,
                  builder: (_) => ImageDialog(photo: widget.photo,)
              ).then((value) => widget.refreshNotification()  );
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

class ImageDialog extends StatefulWidget {
  Photo photo;
  ImageDialog ({Key? key, required this.photo}) : super(key: key);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.photo.title;
    descriptionController.text = widget.photo.description;
  }

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
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: widget.photo.photo.isNotEmpty? InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 3,
                  child: Image.memory(
                    base64Decode(widget.photo.photo),
                    fit: BoxFit.contain,
                  ),
                ) : Image(image: NetworkImage(
                    'https://source.unsplash.com/random/500x500?sig=1${Random().nextInt(100)}'
                ), ),
              ),
              Positioned(
                bottom: 100 ,
                left: 20,
                right: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text("Title: ${widget.photo.title}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 25.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text("Description: ${widget.photo.description}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 25.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text("Created at: ${DateTime.parse(widget.photo.createdAt).toLocal().toString().substring(0, 19)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 25.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 40 ,
                left: 20,
                right: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff084470), width: 4),
                    ),
                    onPressed: () async {
                      showDialog(context: context, builder:
                          (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Update Photo Information"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,

                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Title',
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Description',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                updatePhotoInformation().then((value)  {
                                  value ? showToast('Photo information updated successfully') : showToast('Error updating photo information');
                                  Navigator.pop(context, widget.photo);
                                });
                              },
                              child: const Text("Update"),
                            ),
                          ],
                        );
                      }
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Text("Update photo information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff084470)),
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

  Future<bool> updatePhotoInformation() async {
    String updatedTitle = titleController.text;
    String updatedDescription = descriptionController.text;
    try {
      print(widget.photo.id.toString() + updatedTitle + updatedDescription);
      dynamic result = await httpApi.updatePhoto(id: widget.photo.id, title: updatedTitle, description: updatedDescription);
      print(result);
      widget.photo = Photo(
          id: widget.photo.id,
          title: updatedTitle,
          description: updatedDescription,
          photo: widget.photo.photo,
          createdAt: widget.photo.createdAt,
          updatedAt: widget.photo.updatedAt
      );
      setState(() {
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}