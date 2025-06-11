import '../../../common/database/database.dart';
import '../models/dto/location_dto.dart';

extension LocationDatabaseMapper on LocationDto {
  LocationsCompanion toDatabase() {
    return LocationsCompanion.insert(
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
