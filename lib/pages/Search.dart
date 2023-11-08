import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../DataModel/GlobalDataModel.dart';
import '../components/PhotoTile.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Photo> photos = [];
  bool hideFilter = false;
  bool clearFilter = true;
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  int crossAxisCount = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Search Photos'),
            actions: [
              IconButton(
                  onPressed: () {
                    crossAxisCount = crossAxisCount > 3 ? 2 : crossAxisCount + 1;
                    setState(() {
                    });
                  },
                  icon: const Icon(Icons.table_rows_outlined)),
              IconButton(
                  onPressed: () async {
                    hideFilter = !hideFilter;
                    hideFilter ? showToast("Filter hidden") : showToast("Filter shown");
                    setState(() {});
                  },
                  icon: hideFilter
                      ? const Icon(Icons.filter_alt_off_sharp)
                      : const Icon(Icons.filter_alt_sharp)),
            ]),
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !hideFilter?
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0), topRight: Radius.circular(0)),),
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Photo Title',
                    ),
                  ),
                   const SizedBox(
                     height: 10,
                   ),
                   TextField(
                     controller: descriptionController,
                     decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: 'Photo Description',
                     ),
                   ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                         'From: ',
                         style: TextStyle(fontSize: 16),
                       ),
                      TextButton(
                        onPressed: () => _selectFromDate(context),
                          style: TextButton.styleFrom(
                              minimumSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(color: Colors.black38)
                              )
                          ),
                        child: Text(
                            clearFilter ? "Select Date" :
                            selectedDate.toLocal().toString().split(' ')[0])
                      ),
                      const Text(
                        'To: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => _selectToDate(context),
                          style: TextButton.styleFrom(
                              minimumSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: const BorderSide(color: Colors.black38)
                              )
                          ),
                        child: Text(
                            clearFilter ? "Select Date" :
                            selectedToDate.toLocal().toString().split(' ')[0])
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextButton(
                            onPressed: () {
                               titleController.text = "";
                               descriptionController.text = "";
                               clearFilter = true;
                               selectedDate = DateTime(2000, 1);
                               selectedToDate = DateTime.now();
                               setState(() {});
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: Colors.black38)
                                )
                            ),
                            child: const Text("Clear filter")
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        child: TextButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              searchPhotos();
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: Colors.black38)
                                )
                            ),
                            child: const Text("Search")
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ):
            Container(),
            Text(photos.isEmpty ? "No photos found" : "Photos found: ${photos.length}"),
            Container(
              width: MediaQuery.of(context).size.width,
              height: hideFilter ? MediaQuery.of(context).size.height - 170 : MediaQuery.of(context).size.height - 470,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              ),
              child:
              isLoading ? const Center(child: CircularProgressIndicator(),) :
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  // width / height: fixed for *all* items
                  childAspectRatio: MediaQuery.of(context).size.width / crossAxisCount / 200,
                ),
                // return a custom ItemCard
                itemBuilder: (context, index) =>
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        PhotoTile(photo: photos[index], onTapAllowed: true, refreshNotification: () {},),
                      ],
                    ),
                itemCount: photos.length,
              ),
            ),
          ],
        ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(2023, 1),
        lastDate: selectedToDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        clearFilter = false;
        selectedDate = picked;
      });
    }
  }
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 2)).subtract(const Duration(seconds: 1)),
        firstDate: selectedDate,
        lastDate: DateTime.now().add(const Duration(days: 2)).subtract(const Duration(seconds: 1)));
    if (picked != null && picked != selectedToDate && picked.isAfter(selectedDate)) {
      setState(() {
        clearFilter = false;
        selectedToDate = picked;
      });
    }
  }

  Future<void> searchPhotos() async {
    setState(() {
      isLoading = true;
    });
    String selectedDateStr = selectedDate.toIso8601String();
    String selectedToDateStr = selectedToDate.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)).toIso8601String();
    clearFilter ? selectedDateStr = "" : selectedDateStr = selectedDateStr;
    clearFilter ? selectedToDateStr = "" : selectedToDateStr = selectedToDateStr;
    debugPrint(
        "title: ${titleController.text}, description: ${descriptionController.text}, fromDate: $selectedDateStr, toDate: $selectedToDateStr");
    if (titleController.text.isEmpty && descriptionController.text.isEmpty && selectedDateStr.isEmpty && selectedToDateStr.isEmpty) {
      showToast("Please enter at least one filter");
      setState(() {
        isLoading = false;
      });
      return;
    }
    var result = await httpApi.searchPhotos(
        title: titleController.text,
        description: descriptionController.text,
        fromDate: selectedDateStr,
        toDate: selectedToDateStr
    );
    List<Photo> photos = [];
    print(result);
    if (result["message"] == "Error") {
      showToast("Error searching photos");
      return;
    }
    if (result['results'].length == 0) {
      showToast("No photos found");
      setState(() {
        this.photos.clear();
        isLoading = false;
      });
    } else {
      for (var item in result['results']) {
        photos.add(Photo.fromJson(item));
      }
      setState(() {
        this.photos = photos;
        isLoading = false;
      });
    }
  }
}
