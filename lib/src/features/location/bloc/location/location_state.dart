part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  final Location? location;

  const LocationState({this.location});

  @override
  List<Object?> get props => [location];
}

final class IdleLocationState extends LocationState {
  const IdleLocationState({super.location});

  @override
  String toString() => 'IdleLocationState';
}

final class ProgressLocationState extends LocationState {
  const ProgressLocationState({super.location});

  @override
  String toString() => 'ProgressLocationState';
}

final class SuccessfulLocationState extends LocationState {
  const SuccessfulLocationState({required super.location});

  @override
  String toString() => 'SuccessfulLocationState';
}

final class ErrorLocationState extends LocationState {
  const ErrorLocationState({super.location});

  @override
  String toString() => 'ErrorLocationState';
}
