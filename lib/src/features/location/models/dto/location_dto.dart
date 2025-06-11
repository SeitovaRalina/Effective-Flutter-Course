import 'package:json_annotation/json_annotation.dart';

import '../../../../common/database/database.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto {
  final String address;
  final double lat;
  final double lng;

  const LocationDto({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  static fromDatabase(Location location) {
    return LocationDto(
      address: location.address,
      lat: location.lat,
      lng: location.lng,
    );
  }
}
