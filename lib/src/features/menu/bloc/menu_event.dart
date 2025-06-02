part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategoriesEvent extends MenuEvent {
  const LoadCategoriesEvent();

  @override
  String toString() => 'LoadCategoriesEvent';
}

final class LoadPageEvent extends MenuEvent {
  const LoadPageEvent();

  @override
  String toString() => 'LoadPageEvent';
}
