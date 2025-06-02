import 'package:dio/dio.dart';

import '../../models/dto/menu_category_dto.dart';

abstract interface class ICategoriesDataSource {
  Future<List<MenuCategoryDto>> fetchCategories();
}

final class NetworkCategoriesDataSource implements ICategoriesDataSource {
  final Dio _dio;

  const NetworkCategoriesDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<MenuCategoryDto>> fetchCategories() async {
    final response = await _dio.get('/products/categories');

    final List<dynamic> categories = response.data['data'];
    return categories
        .map((category) => MenuCategoryDto.fromJson(category))
        .toList();
  }
}
