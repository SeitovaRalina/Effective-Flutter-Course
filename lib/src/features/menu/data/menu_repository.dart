import '../models/dto/menu_item_dto.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import 'data_sources/menu_data_source.dart';

abstract interface class IMenuRepository {
  Future<List<MenuItem>> loadMenuItems({required MenuCategory category, int page = 0, int limit = 25});
}

final class MenuRepository implements IMenuRepository {
  final IMenuDataSource _networkMenuDataSource;

  const MenuRepository({
    required IMenuDataSource networkMenuDataSource,
  }) :  _networkMenuDataSource = networkMenuDataSource;

  @override
  Future<List<MenuItem>> loadMenuItems({required MenuCategory category, int page = 0, int limit = 25}) async {
    var dtos = <MenuItemDto>[];
    dtos = await _networkMenuDataSource.fetchMenuItems(categoryId: '1', page: page, limit: limit);
    return dtos.map((e) => e.toModel()).toList();
  }
}