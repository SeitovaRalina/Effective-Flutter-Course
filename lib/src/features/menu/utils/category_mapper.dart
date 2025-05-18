import '../models/dto/menu_category_dto.dart';
import '../models/menu_category.dart';

extension CategoryMapper on MenuCategoryDto {
  MenuCategory toModel() {
    return MenuCategory();
  }
}