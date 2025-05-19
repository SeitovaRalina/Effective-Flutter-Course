part of 'menu_bloc.dart';

sealed class MenuState extends Equatable {
  final List<MenuCategory>? categories;
  final List<MenuItem>? items;

  const MenuState({this.categories, this.items});

  @override
  List<Object?> get props => [categories, items];
}

final class ProgressMenuState extends MenuState {
  const ProgressMenuState({super.items, super.categories});

  @override
  String toString() => 'ProgressMenuState';
}

final class SuccessfulMenuState extends MenuState {
  const SuccessfulMenuState({super.items, super.categories});

  @override
  String toString() => 'SuccessfulMenuState';
}

final class ErrorMenuState extends MenuState {
  const ErrorMenuState({super.items, super.categories});

  @override
  String toString() => 'ErrorMenuState';
}

final class IdleMenuState extends MenuState {
  const IdleMenuState({super.items, super.categories});

  @override
  String toString() => 'IdleMenuState';
}
