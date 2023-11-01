import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

bool locationServiceEnabled = false;
LocationPermission locationServicePermission =
    LocationPermission.unableToDetermine;

@injectable
class LocationUtil {
  Future<bool> getPermission() async {
    // Test if location services are enabled.
    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    locationServicePermission = await Geolocator.checkPermission();
    if (locationServicePermission == LocationPermission.denied) {
      locationServicePermission = await Geolocator.requestPermission();
      if (locationServicePermission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (locationServicePermission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<Position> getLocation() async {
    if (!locationServiceEnabled ||
        locationServicePermission == LocationPermission.unableToDetermine) {
      await getPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  Stream<Position> getLocationStream() {
    LocationSettings locationSetting = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: const Duration(seconds: 2),
    );
    return Geolocator.getPositionStream(locationSettings: locationSetting);
  }
}
