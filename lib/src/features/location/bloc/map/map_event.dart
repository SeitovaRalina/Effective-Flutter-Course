part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class LoadLocationsEvent extends MapEvent {
  const LoadLocationsEvent();

  @override
  String toString() => 'LoadLocationsEvent';
}

final class ChangeLocationEvent extends MapEvent {
  final Location location;

  const ChangeLocationEvent({required this.location});

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'ChangeLocationEvent: {id: ${location.address} }';
}
