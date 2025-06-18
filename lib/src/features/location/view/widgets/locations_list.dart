import 'package:effective_flutter_course/src/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/app_colors.dart';
import '../../bloc/map/map_bloc.dart';
import '../../models/location.dart';

class LocationsList extends StatelessWidget {
  final List<Location> locations;

  const LocationsList({super.key, required this.locations});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      context.l10n.ourCoffeeShops,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.divider),
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return SizedBox(
                      height: 40,
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          location.address,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                        onTap: () {
                          context.read<MapBloc>().add(
                                ChangeLocationEvent(location: location),
                              );
                          Navigator.of(context)
                            ..pop(location)
                            ..pop(location);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
