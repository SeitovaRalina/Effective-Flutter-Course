import '../models/dto/location_dto.dart';
import '../models/location.dart';

extension LocationMapper on LocationDto {
  Location toModel() {
    return Location(
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
