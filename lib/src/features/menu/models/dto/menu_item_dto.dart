import 'package:json_annotation/json_annotation.dart';

part 'menu_item_dto.g.dart';

@JsonSerializable()
class MenuItemDto {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic> category;
  final String imageUrl;
  final List<Map<String, dynamic>> prices;

  const MenuItemDto(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.imageUrl,
      required this.prices});

  factory MenuItemDto.fromJson(Map<String, dynamic> json) =>
      _$MenuItemDtoFromJson(json);
}
