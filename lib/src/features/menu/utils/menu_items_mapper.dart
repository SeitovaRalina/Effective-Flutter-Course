import '../models/dto/menu_item_dto.dart';
import '../models/menu_item.dart';

extension MenuItemsMapper on MenuItemDto {
  MenuItem toModel() {
    return MenuItem();
  }
}