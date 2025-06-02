import 'package:json_annotation/json_annotation.dart';

import '../../../../common/database/database.dart';

part 'menu_category_dto.g.dart';

@JsonSerializable()
class MenuCategoryDto {
  final int id;
  final String slug;

  const MenuCategoryDto({
    required this.id,
    required this.slug,
  });

  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryDtoFromJson(json);

  static fromDatabase(MenuCategory category) {
    return MenuCategoryDto(
      id: category.id,
      slug: category.name,
    );
  }
}
