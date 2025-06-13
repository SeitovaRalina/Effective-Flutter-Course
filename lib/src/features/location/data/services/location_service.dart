import 'package:geolocator/geolocator.dart';

import '../../models/location.dart';

abstract interface class ILocationService {
  Future<Location> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();
  Future<bool> isServiceEnabled();
}

class LocationService implements ILocationService {
  final defLocation = const OmskLocation();

  @override
  Future<Location> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return Location(lat: value.latitude, lng: value.longitude);
    }).catchError(
      (_) => defLocation,
    );
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<bool> isServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }
}
