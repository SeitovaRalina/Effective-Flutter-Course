import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Location _location = Location();

  LocationBloc() : super(LocationInitial()) {
    on<RequestLocationEvent>(_onRequestLocation);
  }

  Future<void> _onRequestLocation(
      RequestLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          emit(LocationServiceDisabled());
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          emit(LocationPermissionDenied());
          return;
        }
      }

      final locData = await _location.getLocation();

      emit(LocationSuccess(
        latitude: locData.latitude!,
        longitude: locData.longitude!,
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }
}
