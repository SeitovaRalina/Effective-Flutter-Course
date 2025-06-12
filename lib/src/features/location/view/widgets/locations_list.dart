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
                      padding: const EdgeInsets.only(left: 10, right: 24),
                      child: InkWell(
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                        ),
                        onTap: () => Navigator.of(context)
                          ..pop()
                          ..pop(),
                      ),
                    ),
                    Text(
                      context.l10n.ourCoffeeshops,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.divider),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 40,
                      child: ListTile(
                        title: Text(
                          locations[index].address,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        onTap: () {
                          context.read<MapBloc>().add(
                                ChangeLocationEvent(location: locations[index]),
                              );
                          Navigator.of(context)
                            ..pop(locations[index])
                            ..pop(locations[index]);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: locations.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
