import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_gallery/auth/domain/AppUser.dart';

@singleton
class AppState extends ChangeNotifier {
  AppUser? appUser;

  void setAppUser(AppUser? appUser) {
    this.appUser = appUser;
    notifyListeners();
  }
}
