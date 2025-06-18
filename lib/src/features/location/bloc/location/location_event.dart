part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class InitLocationEvent extends LocationEvent {
  const InitLocationEvent();

  @override
  String toString() => 'InitLocationEvent';
}
