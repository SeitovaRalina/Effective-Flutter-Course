part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  final Map<MenuItem, int> items;
  final int totalPrice;

  const OrderState({
    required this.items,
    required this.totalPrice
  });

  @override
  List<Object> get props => [items, totalPrice];
}

final class ProgressOrderState extends OrderState {
  const ProgressOrderState({
    required super.items,
    required super.totalPrice,
  });

  @override
  String toString() => 'ProgressOrderState';
}

final class SuccessfulOrderState extends OrderState {
  const SuccessfulOrderState() : super(
    items: const {},
    totalPrice: 0,
  );

  @override
  String toString() => 'SuccessfulOrderState';
}

final class ErrorOrderState extends OrderState {
  const ErrorOrderState({
    required super.items,
    required super.totalPrice,
  });

  @override
  String toString() => 'ErrorOrderState';
}

final class IdleOrderState extends OrderState {
  const IdleOrderState({
    super.items = const {},
    super.totalPrice = 0,
  });

  @override
  String toString() => 'IdleOrderState';
}
