import 'package:drift/drift.dart';

import '../../../../common/database/database.dart';
import '../../models/dto/menu_item_dto.dart';
import '../../utils/menu_item_database_mapper.dart';
import '../../utils/menu_item_price_mapper.dart';
import 'menu_data_source.dart';

abstract interface class ISavableMenuDataSource implements IMenuDataSource {
  Future<void> saveMenuItems({required List<MenuItemDto> menuItems});
}

final class DbMenuDataSource implements ISavableMenuDataSource {
  final MenuDb _menuDb;

  const DbMenuDataSource({required MenuDb menuDb}) : _menuDb = menuDb;

  @override
  Future<List<MenuItemDto>> fetchMenuItems(
      {required int categoryId, int page = 0, int limit = 25}) async {
    final offset = page * limit;

    final query = _menuDb.select(_menuDb.menuItems)
      ..where((tbl) => tbl.categoryId.equals(categoryId))
      ..limit(limit, offset: offset);
    final items = await query.get();

    final category = await (_menuDb.select(_menuDb.menuCategories)
          ..where((tbl) => tbl.id.equals(categoryId)))
        .getSingle();

    final itemIds = items.map((item) => item.id).toList();
    final pricesList = await (_menuDb.select(_menuDb.menuItemPrices)
          ..where((tbl) => tbl.itemId.isIn(itemIds)))
        .get();
    final pricesMap = <int, List<MenuItemPrice>>{};
    for (final price in pricesList) {
      pricesMap.putIfAbsent(price.itemId, () => []).add(price);
    }

    return items.map((item) {
      final prices = pricesMap[item.id] ?? [];
      return MenuItemDto.fromDatabase(item, category, prices);
    }).toList();
  }

  @override
  Future<void> saveMenuItems({required List<MenuItemDto> menuItems}) async {
    await _menuDb.batch((batch) {
      for (final item in menuItems) {
        batch.insert(
          _menuDb.menuItems,
          item.toDatabaseItem(),
          mode: InsertMode.insertOrReplace,
        );
        for (final price in item.toDatabasePrices()) {
          batch.insert(
            _menuDb.menuItemPrices,
            price,
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }
}
