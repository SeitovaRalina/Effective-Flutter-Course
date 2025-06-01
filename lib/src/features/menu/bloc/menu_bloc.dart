import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/category_repository.dart';
import '../data/menu_repository.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';

part 'menu_event.dart';
part 'menu_state.dart';

const _pageLimit = 25;

final class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _menuRepository;
  final ICategoryRepository _categoryRepository;

  int _currentCategoryIndex = 0;
  int _currentPage = 0;
  bool _hasMore = true;

  MenuBloc({
    required IMenuRepository menuRepository,
    required ICategoryRepository categoryRepository,
  })  : _menuRepository = menuRepository,
        _categoryRepository = categoryRepository,
        super(const IdleMenuState()) {
      on<LoadCategoriesEvent>(_loadCategories);
      on<LoadPageEvent>(_loadMenuItems);
      on<LoadOneCategoryEvent>(_loadOneCategoryItems);
  }

  Future<void> _loadCategories(
      LoadCategoriesEvent event, Emitter<MenuState> emit) async {
    emit(ProgressMenuState(items: state.items));
    try {
      final categories = await _categoryRepository.loadCategories();
      emit(SuccessfulMenuState(categories: categories, items: List.empty()));
      add(const LoadPageEvent());
    } on Object {
      emit(ErrorMenuState(categories: state.categories, items: state.items));
    } finally {
      emit(IdleMenuState(categories: state.categories, items: state.items));
    }
  }

  Future<void> _loadMenuItems(
      LoadPageEvent event, Emitter<MenuState> emit) async {
    final categories = state.categories;
    if (categories == null || categories.isEmpty || _currentCategoryIndex >= categories.length) return;
    final currentCategory = categories[_currentCategoryIndex];

    emit(ProgressMenuState(categories: categories, items: state.items));

    try {
      final items = await _menuRepository.loadMenuItems(
          category: currentCategory, page: _currentPage, limit: _pageLimit);

      final updatedItems = List<MenuItem>.from(state.items ?? [])..addAll(items);
      _hasMore = items.length == _pageLimit;

      if (_hasMore) {
        _currentPage++;
      } else {
        _currentCategoryIndex++;
        _currentPage = 0;
        _hasMore = true;
      }

      emit(SuccessfulMenuState(categories: state.categories, items: updatedItems));
    } on Object {
      emit(ErrorMenuState(categories: state.categories, items: state.items));
    } finally {
      emit(IdleMenuState(categories: state.categories, items: state.items));
    }
  }

  void _loadOneCategoryItems(LoadOneCategoryEvent event, Emitter<MenuState> emit) async {
    final category = event.category;
    if (state.categories?.contains(category) ?? false) {
      emit(ProgressMenuState(categories: state.categories, items: state.items));
      try {
        final items = await _menuRepository.loadMenuItems(
            category: category, limit: _pageLimit);
        final updatedItems = List<MenuItem>.from(state.items ?? [])..addAll(items);
        emit(SuccessfulMenuState(categories: state.categories, items: updatedItems));
      } on Object {
        emit(ErrorMenuState(categories: state.categories, items: state.items));
      } finally {
        emit(IdleMenuState(categories: state.categories, items: state.items));
      }
    }
  }
}
