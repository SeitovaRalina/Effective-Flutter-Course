part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  final List<Location>? locations;
  final Location? currentLocation;

  const MapState({this.locations, this.currentLocation});

  @override
  List<Object?> get props => [locations, currentLocation];
}

final class ProgressMapState extends MapState {
  const ProgressMapState({super.locations, super.currentLocation});

  @override
  String toString() => 'ProgressMapState';
}

final class SuccessfulMapState extends MapState {
  const SuccessfulMapState(
      {required super.locations, required super.currentLocation});

  @override
  String toString() => 'SuccessfulMapState';
}

final class ErrorMapState extends MapState {
  const ErrorMapState({super.locations, super.currentLocation});

  @override
  String toString() => 'ErrorMapState';
}

final class IdleMapState extends MapState {
  const IdleMapState({super.locations, super.currentLocation});

  @override
  String toString() => 'IdleMapState';
}
