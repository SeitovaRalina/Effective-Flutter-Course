import 'package:dio/dio.dart';

import '../models/dto/order_request_dto.dart';
import 'data_sources/order_data_source.dart';

abstract interface class IOrderRepository {
  Future<void> submitOrder(Map<int, int> positions, String fcmToken);
}

final class OrderRepository implements IOrderRepository {
  final IOrderDataSource _networkOrderDataSource;

  const OrderRepository({
    required IOrderDataSource networkOrderDataSource,
  }) : _networkOrderDataSource = networkOrderDataSource;

  @override
  Future<void> submitOrder(Map<int, int> positions, String fcmToken) async {
    final stringMap =
        positions.map((key, value) => MapEntry(key.toString(), value));
    final dto = OrderRequestDto(
      positions: stringMap,
      token: fcmToken,
    );
    try {
      await _networkOrderDataSource.createOrder(dto);
    } on DioException catch (e) {
      throw Exception('Failed to submit order: $e');
    }
  }
}
