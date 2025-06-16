import 'package:drift/drift.dart';

import '../../../common/database/database.dart';
import '../models/dto/menu_category_dto.dart';

extension CategoryDatabaseMapper on MenuCategoryDto {
  MenuCategoriesCompanion toDatabase() {
    return MenuCategoriesCompanion.insert(
      id: Value(id),
      name: slug,
    );
  }
}
