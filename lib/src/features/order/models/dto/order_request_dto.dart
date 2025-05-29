import 'package:json_annotation/json_annotation.dart';

part 'order_request_dto.g.dart';

@JsonSerializable()
class OrderRequestDto {
  final Map<String, int> positions;
  final String token;

  const OrderRequestDto({
    required this.positions,
    required this.token,
  });

  Map<String, dynamic> toJson() => _$OrderRequestDtoToJson(this);
}
