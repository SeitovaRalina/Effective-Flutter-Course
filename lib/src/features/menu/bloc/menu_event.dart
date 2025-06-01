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

final class LoadOneCategoryEvent extends MenuEvent {
  const LoadOneCategoryEvent(this.category);
  final MenuCategory category;

  @override
  String toString() => 'LoadOneCategoryEvent(category: $category)';
}
