import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jourscape/core/services/get_postition.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_all_coordinates_notifier.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_coordinates_by_date_notifier.dart';
import 'package:jourscape/features/map/presentation/widgets/map_own_position_marker.dart';
import 'package:jourscape/features/map/presentation/provider/map_provider.dart';
import 'package:jourscape/features/map/presentation/widgets/map_bottom_sheet.dart';
import 'package:jourscape/features/map/presentation/widgets/map_screen_overlay.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    ref.read(gpsAllCoordinatesNotifierProvider.notifier).getAllCoordinates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToOwnLocation();
      ref.read(mapStateNotifierProvider.notifier).listenSelf((prev, next) {
        if (next == 'history' && prev != next) {
          DateTime time = DateTime.now();
          ref
              .read(gpsCoordinatesByDateNotifierProvider.notifier)
              .getCoordinatesByDate(
                DateTime(time.year, time.month, time.day - 1),
              );
        }
      });
    });
  }

  Polyline? today;

  Future<void> jumpToOwnLocation() async {
    try {
      Position position = await determinePosition();
      mapController.move(LatLng(position.latitude, position.longitude), 15);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    String mapState = ref.watch(mapStateNotifierProvider);
    AsyncValue<List<GpsCoordinateEntity>?> coordinates = ref.watch(
      gpsCoordinatesByDateNotifierProvider,
    );
    ref.listen(gpsPolylineByDateProvider, (prev, next) {
      if (next != null && next.points.isNotEmpty && next.points.length > 1) {
        today = next;
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(next.points),
            padding: EdgeInsets.fromLTRB(
              10,
              10,
              10,
              MediaQuery.sizeOf(context).height / 2,
            ),
          ),
        );
      } else if (next == null) {
        today = null;
      }
    });
    List<Polyline>? allPolylines = ref.watch(gpsAllPolylinesProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(51.5167, 9.9167),
                initialZoom: 5,
              ),
              mapController: mapController,
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),

                if (mapState == 'history') ...[
                  if (today != null) PolylineLayer(polylines: [today!]),
                  MarkerLayer(
                    markers: [
                      ...coordinates.when(
                        data: (data) =>
                            data
                                ?.map(
                                  (e) => Marker(
                                    width: 8,
                                    height: 8,
                                    point: e.latlng,
                                    child: InkWell(
                                      onTap: () {
                                        debugPrint('e.latlng');
                                      },
                                      child: Container(
                                        width: 8, // Size of the dot
                                        height: 8, // Size of the dot
                                        decoration: const BoxDecoration(
                                          color: Colors
                                              .red, // Solid blue for the center dot
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList() ??
                            [],
                        error: (a, b) => [],
                        loading: () => [],
                      ),
                    ],
                  ),
                ],
                if (mapState != 'history') ...[
                  if (allPolylines != null)
                    PolylineLayer(polylines: allPolylines),
                ],
                const MapOwnPositionMarker(),
              ],
            ),
          ),
          if (mapState == 'history') ...[
            MapBottomSheet(
              onDateChanged: (p0) {
                ref
                    .read(gpsCoordinatesByDateNotifierProvider.notifier)
                    .getCoordinatesByDate(DateTime(p0.year, p0.month, p0.day));
              },
            ),
          ],
          MapScreenOverlay(jumpToOwnLocation: jumpToOwnLocation),
        ],
      ),
    );
  }
}
