import 'dart:io';

import 'package:dio/dio.dart';

import '../models/dto/menu_item_dto.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../utils/menu_item_mapper.dart';
import 'data_sources/menu_data_source.dart';
import 'data_sources/savable_menu_data_source.dart';

abstract interface class IMenuRepository {
  Future<List<MenuItem>> loadMenuItems(
      {required MenuCategory category, int page = 0, int limit = 25});
}

final class MenuRepository implements IMenuRepository {
  final IMenuDataSource _networkMenuDataSource;
  final ISavableMenuDataSource _dbMenuDataSource;

  const MenuRepository({
    required IMenuDataSource networkMenuDataSource,
    required ISavableMenuDataSource dbMenuDataSource,
  })  : _networkMenuDataSource = networkMenuDataSource,
        _dbMenuDataSource = dbMenuDataSource;

  @override
  Future<List<MenuItem>> loadMenuItems(
      {required MenuCategory category, int page = 0, int limit = 25}) async {
    var dtos = <MenuItemDto>[];
    try {
      dtos = await _networkMenuDataSource.fetchMenuItems(
          categoryId: category.id, page: page, limit: limit);
      _dbMenuDataSource.saveMenuItems(menuItems: dtos);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        dtos = await _dbMenuDataSource.fetchMenuItems(
            categoryId: category.id, page: page, limit: limit);
      } else {
        throw Exception('Failed to load menu items: $e');
      }
    }
    return dtos.map((e) => e.toModel()).toList();
  }
}
