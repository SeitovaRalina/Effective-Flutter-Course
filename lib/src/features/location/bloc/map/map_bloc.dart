import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/locations_repository.dart';
import '../../models/location.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ILocationsRepository _locationsRepository;

  MapBloc({required ILocationsRepository locationsRepository})
      : _locationsRepository = locationsRepository,
        super(const IdleMapState()) {
    on<LoadLocationsEvent>(_loadLocations);
    on<ChangeLocationEvent>(_changeLocation);
  }

  Future<void> _loadLocations(
      LoadLocationsEvent event, Emitter<MapState> emit) async {
    emit(ProgressMapState(
        locations: state.locations, currentLocation: state.currentLocation));
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<Location> locations =
          await _locationsRepository.loadLocations();
      final selectedLocation = prefs.getString('selectedLocation');

      Location currentLocation = locations.firstWhere(
          (loc) => loc.address == selectedLocation,
          orElse: () => locations.first);

      await prefs.setString('selectedLocation', currentLocation.address);

      emit(SuccessfulMapState(
          locations: locations, currentLocation: currentLocation));
    } on Object {
      emit(ErrorMapState(
          locations: state.locations, currentLocation: state.currentLocation));
    } finally {
      emit(IdleMapState(
          locations: state.locations, currentLocation: state.currentLocation));
    }
  }

  Future<void> _changeLocation(
      ChangeLocationEvent event, Emitter<MapState> emit) async {
    emit(ProgressMapState(
      locations: state.locations,
      currentLocation: state.currentLocation,
    ));
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLocation', event.location.address);

      emit(SuccessfulMapState(
          locations: state.locations ?? [], currentLocation: event.location));
    } on Object {
      emit(ErrorMapState(
          locations: state.locations, currentLocation: state.currentLocation));
    } finally {
      emit(IdleMapState(
          locations: state.locations, currentLocation: state.currentLocation));
    }
  }
}
