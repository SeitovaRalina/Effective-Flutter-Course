import 'package:bloc/bloc.dart';
import 'package:effective_flutter_course/src/features/order/data/order_repository.dart';
import 'package:equatable/equatable.dart';

import '../../menu/models/menu_item.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository _orderRepository;

  OrderBloc({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const IdleOrderState()) {
    on<OrderEvent>((event, emit) async {
      switch (event) {
        case ChangeItemQuantityEvent():
          await _changeItemQuantity(event, emit);
        case SubmitOrderEvent():
          await _submitOrder(event, emit);
        case CancelOrderEvent():
          await _cancelOrder(event, emit);
      }
    });
  }
  Future<void> _changeItemQuantity(
      ChangeItemQuantityEvent event, Emitter<OrderState> emit) async {
    final items = Map.of(state.items);
    if (event.quantity > 0) {
      items[event.item] = event.quantity;
    } else {
      items.remove(event.item);
    }

    final totalPrice = items.entries
        .map((e) => e.key.price * e.value)
        .fold(0, (a, b) => a + b);

    emit(ProgressOrderState(items: items, totalPrice: totalPrice));
  }

  Future<void> _submitOrder(
      SubmitOrderEvent event, Emitter<OrderState> emit) async {
    final items = state.items;
    if (items.isEmpty) return;

    emit(ProgressOrderState(items: items, totalPrice: state.totalPrice));

    try {
      final positions = items.map((key, value) => MapEntry(key.id, value));
      await _orderRepository.submitOrder(
          positions, 'fcmToken'); // Replace with actual FCM token
      emit(const SuccessfulOrderState());
    } catch (_) {
      emit(ErrorOrderState(items: items, totalPrice: state.totalPrice));
    } finally {
      emit(IdleOrderState(items: state.items, totalPrice: state.totalPrice));
    }
  }

  Future<void> _cancelOrder(
      CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(const IdleOrderState());
  }
}
