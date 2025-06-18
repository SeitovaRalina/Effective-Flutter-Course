import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/app_colors.dart';
import '../../../../common/extensions/context_extensions.dart';
import '../../bloc/location/location_bloc.dart';
import '../../bloc/map/map_bloc.dart';
import '../map_screen.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) => current is! IdleMapState,
      builder: (context, state) {
        final location = state.currentLocation;

        return SizedBox(
          height: 40,
          child: InkWell(
            onTap: () => {_navigateToMap(context)},
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 10),
                  child: Icon(
                    location != null
                        ? Icons.location_on_outlined
                        : Icons.location_off_outlined,
                    color: AppColors.blue,
                    size: 24,
                  ),
                ),
                Text(
                  location?.address ?? context.l10n.noLocation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToMap(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<MapBloc>.value(value: context.read<MapBloc>()),
            BlocProvider<LocationBloc>.value(
                value: context.read<LocationBloc>()),
          ],
          child: const MapScreen(),
        ),
      ),
    );
  }
}
