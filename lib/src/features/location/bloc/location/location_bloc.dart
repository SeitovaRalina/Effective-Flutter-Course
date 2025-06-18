import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(const IdleLocationState()) {
    on<InitLocationEvent>(_onInitLocation);
  }

  Future<void> _onInitLocation(
      InitLocationEvent event, Emitter<LocationState> emit) async {
    emit(ProgressLocationState(location: state.location));

    bool hasPermission = await _checkPermission();
    if (!hasPermission) {
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        emit(const ErrorLocationState());
        return;
      }
    }

    try {
      final Position position = await Geolocator.getCurrentPosition();
      final location =
          Location(lat: position.latitude, lng: position.longitude);
      emit(SuccessfulLocationState(location: location));
    } on Object {
      emit(ErrorLocationState(location: state.location));
    } finally {
      emit(IdleLocationState(location: state.location));
    }
  }

  Future<bool> _checkPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }
}
