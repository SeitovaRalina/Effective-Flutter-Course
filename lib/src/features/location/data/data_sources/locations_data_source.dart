import 'package:dio/dio.dart';

import '../../models/dto/location_dto.dart';

abstract interface class ILocationsDataSource {
  Future<List<LocationDto>> fetchLocations();
}

final class NetworkLocationsDataSource implements ILocationsDataSource {
  final Dio _dio;

  const NetworkLocationsDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<LocationDto>> fetchLocations() async {
    final response = await _dio.get('/locations');

    final List<dynamic> locations = response.data['data'];

    return locations.map((location) => LocationDto.fromJson(location)).toList();
  }
}
