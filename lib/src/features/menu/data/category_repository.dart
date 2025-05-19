import '../models/dto/menu_category_dto.dart';
import '../models/menu_category.dart';
import '../utils/category_mapper.dart';
import 'data_sources/categories_data_source.dart';

abstract interface class ICategoryRepository {
  Future<List<MenuCategory>> loadCategories();
}

final class CategoriesRepository implements ICategoryRepository {
  final ICategoriesDataSource _networkCategoriesDataSource;

  const CategoriesRepository({
    required ICategoriesDataSource networkCategoriesDataSource,
  }) : _networkCategoriesDataSource = networkCategoriesDataSource;

  @override
  Future<List<MenuCategory>> loadCategories() async {
    var dtos = <MenuCategoryDto>[];
    dtos = await _networkCategoriesDataSource.fetchCategories();
    return dtos.map((e) => e.toModel()).toList();
  }
}
