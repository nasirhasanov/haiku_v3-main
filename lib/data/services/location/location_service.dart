import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haiku/utilities/constants/app_keys.dart';
import 'package:hive/hive.dart';

class LocationService {
  Future<void> updateLocationInfo() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        var box = Hive.box(AppKeys.locationBox);
        await Future.wait([
          box.put(AppKeys.countryCode, place.isoCountryCode ?? ''),
          box.put(AppKeys.subLocality, place.subLocality ?? ''),
          box.put(AppKeys.administrativeArea, place.administrativeArea ?? ''),
          box.put(AppKeys.street, place.street ?? ''),
          box.put(AppKeys.name, place.name ?? ''),
          box.put(AppKeys.latitude, position.latitude),
          box.put(AppKeys.longitude, position.longitude),
        ]);
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  String? getLocationDetail(String key) {
    var box = Hive.box('locationBox');
    return box.get(key);
  }
}
