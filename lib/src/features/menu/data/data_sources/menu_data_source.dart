import 'package:dio/dio.dart';
import '../../models/dto/menu_item_dto.dart';

abstract interface class IMenuDataSource {
  Future<List<MenuItemDto>> fetchMenuItems(
      {required int categoryId, int page = 0, int limit = 25});
}

final class NetworkMenuDataSource implements IMenuDataSource {
  final Dio _dio;

  const NetworkMenuDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<MenuItemDto>> fetchMenuItems(
      {required int categoryId, int page = 0, int limit = 25}) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {
        'category': '$categoryId',
        'page': '$page',
        'limit': '$limit',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((item) => MenuItemDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }
}
