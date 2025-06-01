import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/extensions/context_extensions.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/image_sources.dart';
import '../../../order/bloc/order_bloc.dart';
import '../../models/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final quantity = context.select<OrderBloc, int>(
      (bloc) => bloc.state.items[item] ?? 0,
    );

    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: item.imageUrl ?? ImageSources.placeholder,
                height: 100,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  item.name,
                  style: context.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 24,
                child: quantity > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          QuantityIconButton(
                            icon: Icons.remove,
                            onPressed: () {
                              context.read<OrderBloc>().add(
                                    ChangeItemQuantityEvent(
                                        item: item, quantity: quantity - 1),
                                  );
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.blue,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$quantity',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                          QuantityIconButton(
                            icon: Icons.add,
                            onPressed: () {
                              if (quantity < 10) {
                                context.read<OrderBloc>().add(
                                      ChangeItemQuantityEvent(
                                        item: item,
                                        quantity: quantity + 1,
                                      ),
                                    );
                              } else {
                                context.scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 2),
                                    content: Text(
                                      context.l10n.increaseItemQuantityFailure,
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(color: AppColors.white),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          context.read<OrderBloc>().add(
                                ChangeItemQuantityEvent(
                                  item: item,
                                  quantity: 1,
                                ),
                              );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            context.l10n.price(item.price),
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantityIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const QuantityIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Ink(
        decoration: const ShapeDecoration(
          color: AppColors.blue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 9),
          color: AppColors.white,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
