import 'package:effective_flutter_course/src/features/menu/models/dto/menu_category_dto.dart';
import 'package:effective_flutter_course/src/features/menu/utils/category_mapper.dart';

import '../models/dto/menu_item_dto.dart';
import '../models/menu_item.dart';

extension MenuItemsMapper on MenuItemDto {
  MenuItem toModel() {
    final String rubPrice =
        prices.where((p) => p['currency'] == 'RUB').first['value'];

    return MenuItem(
      id: id,
      name: name,
      category: MenuCategoryDto.fromJson(category).toModel(),
      imageUrl: imageUrl,
      price: double.parse(rubPrice).round(),
    );
  }
}
