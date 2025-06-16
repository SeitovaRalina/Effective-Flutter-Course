import '../../../common/database/database.dart';
import '../models/dto/menu_item_dto.dart';

extension MenuItemPriceMapper on MenuItemDto {
  List<MenuItemPricesCompanion> toDatabasePrices() {
    return prices.map((price) {
      return MenuItemPricesCompanion.insert(
        itemId: id,
        currency: price['currency'] as String,
        value: double.parse(price['value'] as String),
      );
    }).toList();
  }
}
