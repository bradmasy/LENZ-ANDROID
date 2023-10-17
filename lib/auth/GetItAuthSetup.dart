import 'package:get_it/get_it.dart';
import 'package:photo_gallery/auth/services/AuthService.dart';
import 'package:photo_gallery/auth/services/AuthServiceApi.dart';

void getItAuthSetup() {
  GetIt.I.registerSingleton<AuthService>(AuthServiceAPI());
}
