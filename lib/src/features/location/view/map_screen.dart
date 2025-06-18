import 'package:effective_flutter_course/src/common/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/image_sources.dart';
import '../bloc/location/location_bloc.dart';
import '../bloc/map/map_bloc.dart';
import '../models/location.dart';
import 'widgets/locations_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  YandexMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(const InitLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) async {
          if (state is ErrorLocationState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  context.l10n.noLocationAccess,
                  style: context.textTheme.titleLarge
                      ?.copyWith(color: AppColors.white),
                ),
              ),
            );
          } else if (state is SuccessfulLocationState &&
              _mapController != null) {
            await _mapController!.toggleUserLayer(visible: true);
            await _mapController!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: Point(
                    latitude: state.location!.lat,
                    longitude: state.location!.lng,
                  ),
                  zoom: 13,
                ),
              ),
              animation: const MapAnimation(
                type: MapAnimationType.linear,
                duration: 0.3,
              ),
            );
          }
        },
        child: YandexMap(
          onMapCreated: (controller) async {
            _mapController = controller;

            const defPosition = OmskLocation();
            await controller.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: Point(
                    latitude: defPosition.lat,
                    longitude: defPosition.lng,
                  ),
                  zoom: 10,
                ),
              ),
            );
          },
          mapObjects: _getPlacemarkObjects(context),
          onUserLocationAdded: (view) async {
            return view.copyWith(
              pin: view.pin.copyWith(
                opacity: 1,
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.small(
              onPressed: () => Navigator.pop(context),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              heroTag: "btn1",
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColors.black,
              ),
            ),
            FloatingActionButton.small(
              onPressed: () => _navigateToLocationList(context),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              heroTag: "btn2",
              child: const Icon(
                Icons.map_outlined,
                size: 20,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  List<PlacemarkMapObject> _getPlacemarkObjects(BuildContext context) {
    final locations = context.read<MapBloc>().state.locations ?? [];
    return locations
        .map(
          (location) => PlacemarkMapObject(
              mapId: MapObjectId('MapObject ${location.address}'),
              point: Point(latitude: location.lat, longitude: location.lng),
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    ImageSources.mapPoint,
                  ),
                  anchor: const Offset(0.5, 1),
                  scale: 0.1,
                ),
              ),
              onTap: (_, __) => _onPlacemarkTapped(location)),
        )
        .toList();
  }

  void _onPlacemarkTapped(Location location) async {
    if (_mapController == null) return;

    await _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: location.lat,
            longitude: location.lng,
          ),
          zoom: 15,
        ),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.linear,
        duration: 0.3,
      ),
    );

    if (!mounted) return;

    showModalBottomSheet<void>(
      elevation: 1,
      context: context,
      builder: (_) => SizedBox(
        height: 166,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 48,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      location.address,
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {
                    context
                        .read<MapBloc>()
                        .add(ChangeLocationEvent(location: location));
                    Navigator.of(context)
                      ..pop(location)
                      ..pop(location);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    minimumSize: const Size(double.maxFinite, 56),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    context.l10n.choose,
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToLocationList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<MapBloc>(),
          child: LocationsList(
            locations: context.read<MapBloc>().state.locations ?? <Location>[],
          ),
        ),
      ),
    );
  }
}
