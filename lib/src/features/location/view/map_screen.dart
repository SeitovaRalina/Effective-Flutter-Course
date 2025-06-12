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

const Point _omsk = Point(
  latitude: 54.98,
  longitude: 73.36,
);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final YandexMapController _mapController;
  late final List<PlacemarkMapObject> _points;
  CameraPosition? _userLocation;

  @override
  void initState() {
    super.initState();
    _points = _getPlacemarkObjects(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
      return Scaffold(
        body: YandexMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            _mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target: _omsk,
                  zoom: 10,
                ),
              ),
            );
            if (state is LocationSuccess) {
              await _mapController.toggleUserLayer(visible: true);
            } else if (state is LocationPermissionDenied ||
                state is LocationServiceDisabled) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.noLocationPermission),
                  ),
                );
              });
            }
          },
          mapObjects: _points,
          onUserLocationAdded: (view) async {
            _userLocation = await _mapController.getUserCameraPosition();
            if (_userLocation != null) {
              await _mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  _userLocation!.copyWith(zoom: 15),
                ),
                animation: const MapAnimation(
                  type: MapAnimationType.linear,
                  duration: 0.3,
                ),
              );
            }
            return view.copyWith(
              pin: view.pin.copyWith(
                opacity: 1,
              ),
            );
          },
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
    });
  }

  List<PlacemarkMapObject> _getPlacemarkObjects(BuildContext context) {
    List<Location>? locations = context.read<MapBloc>().state.locations;
    if (locations != null) {
      List<PlacemarkMapObject> points = locations
          .map(
            (point) => PlacemarkMapObject(
              mapId: MapObjectId('MapObject ${point.address}'),
              point: Point(latitude: point.lat, longitude: point.lng),
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
              onTap: (_, __) => {
                _mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: point.lat,
                        longitude: point.lng,
                      ),
                      zoom: 15,
                    ),
                  ),
                  animation: const MapAnimation(
                    type: MapAnimationType.linear,
                    duration: 0.3,
                  ),
                ),
                showModalBottomSheet<void>(
                  elevation: 1,
                  context: context,
                  builder: (___) => BlocProvider.value(
                    value: context.read<MapBloc>(),
                    child: SizedBox(
                      height: 166,
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
                            SizedBox(
                              height: 52,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    point.address,
                                    style: context.textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextButton(
                                onPressed: () {
                                  context.read<MapBloc>().add(
                                      ChangeLocationEvent(location: point));
                                  Navigator.of(context)
                                    ..pop(point)
                                    ..pop(point);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.blue,
                                  minimumSize: const Size(double.maxFinite, 56),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                  ),
                ),
              },
            ),
          )
          .toList();
      return points;
    } else {
      return [];
    }
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
