import 'package:cached_network_image/cached_network_image.dart';
import 'package:effective_flutter_course/src/theme/image_sources.dart';
import 'package:flutter/material.dart';

import '../../../../localization/generated/app_localizations.dart';
import '../../../menu/models/menu_item.dart';

class OrderList extends StatelessWidget {
  final Map<MenuItem, int> items;
  const OrderList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> orderList = items.entries.expand((item) {
      return List.generate(item.value, (index) => item.key);
    }).toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final item = orderList[index];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: item.imageUrl ?? ImageSources.placeholder,
            placeholder: (context, url) => const Center(
              child: SizedBox.shrink(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
            width: 55,
          ),
          title: Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Text(
            AppLocalizations.of(context)!.price(item.price),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: orderList.length,
    );
  }
}
