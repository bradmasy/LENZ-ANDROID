import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';

class AddAlbum extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
   AddAlbum({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
      appBar: AppBar(
        title: const Text('Add Album'),
      ),
      //add a return button
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10) ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Album Title',
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Album Description',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      descriptionController.text += ' #Family';
                      showToast('Family Tagged', duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xff084470), width: 2), ),
                      child: const Center(
                        child: Text(
                          'Family',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff084470)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      descriptionController.text += ' #Life';
                      showToast('Life Tagged', duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff084470), width: 2), ),
                      child: const Center(
                        child: Text(
                          'Life',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff084470)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      descriptionController.text += ' #Large';
                      showToast('Large Tagged', duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff084470), width: 2), ),
                      child: const Center(
                        child: Text(
                          'Large',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff084470)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      descriptionController.text += ' #Small';
                      showToast('Small Tagged', duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff084470), width: 2), ),
                      child: const Center(
                        child: Text(
                          'Small',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff084470)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      descriptionController.text += ' #Friends';
                      showToast('Friends Tagged', duration: const Duration(seconds: 1));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff084470), width: 2), ),
                      child: const Center(
                        child: Text(
                          'Friends',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff084470)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: (){
                  descriptionController.text = '';
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xff084470), width: 2), ),
                  child: const Center(
                    child: Text(
                      'Clear Description',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff084470)),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container(),),
              GestureDetector(
                onTap: (){
                  addAlbum(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff084470), Color(0xff0c7b93)])),
                  child: const Center(
                    child: Text(
                      'Add Album',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );

  }

  Future<void> addAlbum(context) async {
    String title = titleController.text;
    String description = descriptionController.text;
    print(title + description);
    var result = await httpApi.postCreatePhotoAlbum(title: title, description: description);
    print(result);
    if (result['id'] != null) {
      showToast('Album Added', duration: const Duration(seconds: 2), onDismiss: () {
        Navigator.pop(context);
      });
    }
  }
}
