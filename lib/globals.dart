import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:photo_gallery/auth/domain/app_user.dart';

class AppState extends ChangeNotifier {
  AppUser? appUser;

  void setAppUser(AppUser? appUser) {
    this.appUser = appUser;
    notifyListeners();
  }
}
