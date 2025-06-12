part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationServiceDisabled extends LocationState {}

class LocationPermissionDenied extends LocationState {}

class LocationSuccess extends LocationState {
  final double latitude;
  final double longitude;

  const LocationSuccess({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class LocationError extends LocationState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}
