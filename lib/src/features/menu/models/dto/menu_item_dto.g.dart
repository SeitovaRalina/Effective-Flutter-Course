// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemDto _$MenuItemDtoFromJson(Map<String, dynamic> json) => MenuItemDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as Map<String, dynamic>,
      imageUrl: json['imageUrl'] as String?,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
