import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/app_colors.dart';
import '../bloc/order_bloc.dart';
import 'widgets/order_list.dart';
import '../../../common/extensions/context_extensions.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.mediaQuery.size.height * 0.81,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    context.l10n.yourOrder,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(const CancelOrderEvent());
                      context.navigator.pop();
                    },
                    icon: const Icon(
                      Icons.delete_outlined,
                      size: 24,
                      color: AppColors.iconDelete,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.divider),
            Expanded(
              child: OrderList(
                items: context.watch<OrderBloc>().state.items,
              ),
            ),
            BlocListener<OrderBloc, OrderState>(
              listenWhen: (previous, current) =>
                  current is SuccessfulOrderState || current is ErrorOrderState,
              listener: (context, state) {
                if (state is SuccessfulOrderState) {
                  context.scaffoldMessenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                        context.l10n.orderSuccess,
                        style: context.textTheme.titleLarge
                            ?.copyWith(color: AppColors.white),
                      ),
                    ),
                  );
                  context.navigator.pop();
                } else if (state is ErrorOrderState) {
                  context.scaffoldMessenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(
                        context.l10n.orderFailure,
                        style: context.textTheme.titleLarge
                            ?.copyWith(color: AppColors.white),
                      ),
                    ),
                  );
                  context.navigator.pop();
                }
              },
              child: TextButton(
                onPressed: () {
                  context.read<OrderBloc>().add(const SubmitOrderEvent());
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  context.l10n.makeOrder,
                  style: context.textTheme.titleLarge
                      ?.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
