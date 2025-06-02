import 'package:drift/drift.dart';

import '../../../common/database/database.dart';
import '../models/dto/menu_item_dto.dart';

extension MenuItemDatabaseMapper on MenuItemDto {
  MenuItemsCompanion toDatabaseItem() {
    return MenuItemsCompanion.insert(
      id: Value(id),
      name: name,
      description: Value(description),
      imageUrl: Value(imageUrl),
      categoryId: category['id'] as int,
    );
  }
}
