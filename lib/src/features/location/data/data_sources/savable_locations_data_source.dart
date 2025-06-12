import 'package:drift/drift.dart';

import '../../../../common/database/database.dart';
import '../../utils/location_database_mapper.dart';
import '../../models/dto/location_dto.dart';
import 'locations_data_source.dart';

abstract interface class ISavableLocationsDataSource
    implements ILocationsDataSource {
  Future<void> saveLocations({required List<LocationDto> locations});
}

final class DbLocationsDataSource implements ISavableLocationsDataSource {
  final MenuDb _menuDb;

  const DbLocationsDataSource({required MenuDb menuDb}) : _menuDb = menuDb;

  @override
  Future<List<LocationDto>> fetchLocations() async {
    final locations = await _menuDb.select(_menuDb.locations).get();
    return List<LocationDto>.of(
      locations.map((location) => LocationDto.fromDatabase(location)),
    );
  }

  @override
  Future<void> saveLocations({required List<LocationDto> locations}) async {
    await _menuDb.batch((batch) {
      for (final location in locations) {
        batch.insert(
          _menuDb.locations,
          location.toDatabase(),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
