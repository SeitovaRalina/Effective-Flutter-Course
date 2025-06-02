import 'package:dio/dio.dart';

import '../../models/dto/order_request_dto.dart';

abstract interface class IOrderDataSource {
  Future<void> createOrder(OrderRequestDto dto);
}

final class NetworkOrderDataSource implements IOrderDataSource {
  final Dio _dio;

  const NetworkOrderDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<void> createOrder(OrderRequestDto dto) async {
    await _dio.post('/orders', data: dto.toJson());
  }
}
