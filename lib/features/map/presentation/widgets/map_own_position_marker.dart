import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jourscape/shared_widgets/location/direction_painter.dart';
import 'package:latlong2/latlong.dart';

class MapOwnPositionMarker extends StatefulWidget {
  const MapOwnPositionMarker({super.key});

  @override
  State<MapOwnPositionMarker> createState() => _MapOwnPositionMarkerState();
}

class _MapOwnPositionMarkerState extends State<MapOwnPositionMarker> {
  Position? ownLivePosition;

  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    _startLocationStream();

    super.initState();
  }

  void _startLocationStream() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((
      Position newLocation,
    ) {
      if (mounted) {
        setState(() {
          ownLivePosition = newLocation;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ownLivePosition == null) {
      return const MarkerLayer(markers: []);
    }
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(ownLivePosition!.latitude, ownLivePosition!.longitude),
          height: 15,
          width: 15,

          child: StreamBuilder(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error reading heading: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              double? direction = snapshot.data!.heading;

              if (direction == null) {
                return const Center(
                  child: Text('Device does not have sensors !'),
                );
              }
              final double rotationAngle = direction * (pi / 180);
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating arrow
                  Transform.rotate(
                    angle: rotationAngle,
                    child: CustomPaint(
                      painter: DirectionConePainter(lineColor: Colors.blue),
                      size: const Size(20, 20),
                    ),
                  ),

                  // Location dot
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
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
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
