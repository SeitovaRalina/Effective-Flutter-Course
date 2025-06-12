import 'dart:io';

import 'package:dio/dio.dart';

import '../models/dto/location_dto.dart';
import '../models/location.dart';
import '../utils/location_mapper.dart';
import 'data_sources/locations_data_source.dart';
import 'data_sources/savable_locations_data_source.dart';

abstract interface class ILocationsRepository {
  Future<List<Location>> loadLocations();
}

final class LocationsRepository implements ILocationsRepository {
  final ILocationsDataSource _networkLocationsDataSource;
  final ISavableLocationsDataSource _dbLocationsDataSource;

  const LocationsRepository({
    required ILocationsDataSource networkLocationsDataSource,
    required ISavableLocationsDataSource dbLocationsDataSource,
  })  : _networkLocationsDataSource = networkLocationsDataSource,
        _dbLocationsDataSource = dbLocationsDataSource;

  @override
  Future<List<Location>> loadLocations() async {
    var dtos = <LocationDto>[];
    try {
      dtos = await _networkLocationsDataSource.fetchLocations();
      _dbLocationsDataSource.saveLocations(locations: dtos);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        dtos = await _dbLocationsDataSource.fetchLocations();
      } else {
        throw Exception('Failed to fetch locations: $e');
      }
    }
    return dtos.map((e) => e.toModel()).toList();
  }
}
