import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../data/category_repository.dart';
import '../data/menu_repository.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';

part 'menu_event.dart';
part 'menu_state.dart';

const _pageLimit = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

final class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;
  final ICategoryRepository _categoryRepository;
  int _currentCategoryIndex = 0;
  int _currentPage = 0;

  MenuBloc({
    required IMenuRepository menuRepository,
    required ICategoryRepository categoryRepository,
  })  : _menuRepository = menuRepository,
        _categoryRepository = categoryRepository,
        super(const IdleMenuState()) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<LoadPageEvent>(_loadMenuItems,
        transformer: throttleDroppable(const Duration(milliseconds: 100)));
  }

  Future<void> _loadCategories(
      LoadCategoriesEvent event, Emitter<MenuState> emit) async {
    emit(ProgressMenuState(items: state.items));
    try {
      final categories = await _categoryRepository.loadCategories();
      emit(SuccessfulMenuState(categories: categories, items: List.empty()));
    } on Object {
      emit(ErrorMenuState(categories: state.categories, items: state.items));
    } finally {
      emit(IdleMenuState(categories: state.categories, items: state.items));
    }
  }

  Future<void> _loadMenuItems(
      LoadPageEvent event, Emitter<MenuState> emit) async {
    List<MenuCategory>? categories = state.categories;
    if (categories == null || categories.isEmpty) return;
    if (_currentCategoryIndex >= categories.length) return;

    final currentCategory = categories[_currentCategoryIndex];
    emit(ProgressMenuState(categories: categories, items: state.items));
    try {
      final items = await _menuRepository.loadMenuItems(
        category: currentCategory,
        page: _currentPage,
        limit: _pageLimit,
      );

      final isFirstPage = _currentPage == 0;
      final isLastPage = items.length < _pageLimit;

      if (isFirstPage && items.isEmpty) {
        _currentCategoryIndex++;
        _currentPage = 0;
        return;
      }
      if (isLastPage) {
        _currentCategoryIndex++;
        _currentPage = 0;
      } else {
        _currentPage++;
      }

      final updatedItems = List<MenuItem>.from(state.items ?? [])
        ..addAll(items);
      emit(SuccessfulMenuState(
          categories: state.categories, items: updatedItems));
    } on Object {
      emit(ErrorMenuState(categories: state.categories, items: state.items));
    } finally {
      emit(IdleMenuState(categories: state.categories, items: state.items));
    }
  }
}
