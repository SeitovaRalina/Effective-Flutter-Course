part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class ChangeItemQuantityEvent extends OrderEvent {
  final MenuItem item;
  final int quantity;

  const ChangeItemQuantityEvent({
    required this.item,
    required this.quantity,
  });

  @override
  String toString() =>
      'ChangeItemQuantityEvent(item: $item, quantity: $quantity)';

  @override
  List<Object> get props => [item, quantity];
}

final class SubmitOrderEvent extends OrderEvent {
  const SubmitOrderEvent();

  @override
  String toString() => 'SubmitOrderEvent';
}

final class CancelOrderEvent extends OrderEvent {
  const CancelOrderEvent();

  @override
  String toString() => 'CancelOrderEvent';
}
