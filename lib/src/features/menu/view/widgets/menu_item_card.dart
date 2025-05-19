import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/image_sources.dart';
import '../../models/menu_item.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;

  const MenuItemCard({required this.item, super.key});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.item.imageUrl ?? ImageSources.placeholder,
                height: 100,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: AppColors.blue)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.item.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 24,
                child: _quantity > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _iconButton(
                            icon: Icons.remove,
                            onPressed: () {
                              setState(() {
                                if (_quantity > 0) _quantity--;
                              });
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
                                  '$_quantity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                          _iconButton(
                            icon: Icons.add,
                            onPressed: () {
                              setState(() {
                                if (_quantity < 10) {
                                  _quantity++;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .increaseItemQuantityFailure,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _quantity = 1;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .price(widget.item.price),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: AppColors.white),
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

  Widget _iconButton(
      {required IconData icon, required VoidCallback onPressed}) {
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
