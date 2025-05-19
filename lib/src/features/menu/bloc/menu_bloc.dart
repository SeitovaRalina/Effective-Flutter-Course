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

  MenuBloc({
    required IMenuRepository menuRepository,
    required ICategoryRepository categoryRepository,
  })  : _menuRepository = menuRepository,
        _categoryRepository = categoryRepository,
        super(const IdleMenuState()) {
    on<MenuEvent>((event, emit) async {
      switch (event) {
        case LoadCategoriesEvent():
          await _loadCategories(event, emit);
        case LoadPageEvent():
          await _loadMenuItems(event, emit);
      }
    });
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
      rethrow;
    } finally {
      emit(IdleMenuState(categories: state.categories, items: state.items));
    }
  }

  Future<void> _loadMenuItems(
      LoadPageEvent event, Emitter<MenuState> emit) async {
    final categories = state.categories;
    if (categories == null || categories.isEmpty) return;

    emit(ProgressMenuState(categories: categories, items: state.items));

    final List<MenuItem> allItems = [];

    try {
      for (final category in categories) {
        int page = 0;
        bool hasMore = true;

        while (hasMore) {
          final items = await _menuRepository.loadMenuItems(
              category: category, page: page, limit: _pageLimit);
          allItems.addAll(items);
          hasMore = items.length == _pageLimit;
          page++;
        }
      }
      emit(SuccessfulMenuState(categories: state.categories, items: allItems));
    } on Object {
      emit(ErrorMenuState(categories: state.categories, items: allItems));
      rethrow;
    } finally {
      emit(IdleMenuState(categories: state.categories, items: allItems));
    }
  }
}
