import 'package:flutter/material.dart';

class MyUserProfile extends StatefulWidget {
  const MyUserProfile({super.key});

  @override
  State<MyUserProfile> createState() => _MyUserProfileState();
}

class _MyUserProfileState extends State<MyUserProfile> {
  final double coverHeight = 200;
  final double profileHeight = 120;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.indigo,
          body: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                buildTop(),
                buildDisplay(),
              ]
          )
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
        Positioned(
          top: top * 2,
          child: Row(
            children: <Widget>[
              buildEditButton("Cover Image"),
              const SizedBox(
                width: 10,
              ),
              buildEditButton("Profile Image"),
            ],
          ),
        )
      ],
    );
  }

  Widget buildCoverImage() => Image.network(
    "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3AtMjAwLWV5ZS0wMzQyNzAyLmpwZw.jpg",
    width: double.infinity,
    height: coverHeight,
    fit:BoxFit.cover,
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey,
    backgroundImage: const NetworkImage("https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png"),
  );

  Widget buildEditButton(text) => FilledButton(
      child: Text("Edit $text"),
      onPressed: () {
        print("Edit $text");
      }
  );

  Widget buildDisplay() => const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            children: [
              Text("firstname: "),
              Text("lastname: "),
              Text("username: "),
              Text("email: "),
              Text("password: "),
            ]
        ),
        Column(
            children: [
              Text("Thanksgiving"),
              Text("Holiday"),
              Text("T_Holiday"),
              Text("t@holiday.com"),
              Text("**********"),
            ]
        )
      ]
  );
}
