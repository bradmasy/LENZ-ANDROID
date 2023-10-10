import 'package:get_it/get_it.dart';
import 'package:photo_gallery/auth/services/auth_service.dart';
import 'package:photo_gallery/auth/services/auth_service_api.dart';

import '../globals.dart';

void getItAuthSetup() {
  GetIt.I.registerSingleton<AuthService>(AuthServiceAPI());
}
