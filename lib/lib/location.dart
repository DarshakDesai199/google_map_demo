import 'package:geolocator/geolocator.dart';

class LocationData {
  late double latitude;
  late double longitude;

  Future<void> getCurrentLocation() async {
    try {
      print('called');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('ERROR ============$e');
    }
  }
}
