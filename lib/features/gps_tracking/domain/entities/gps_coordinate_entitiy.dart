import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class GpsCoordinateEntity extends Equatable {
  final int id;
  final double longitude;
  final double latitude;
  final DateTime timestamp;
  final double? accuracy;
  final double? altitude;
  final double? altitudeAccuracy;
  final double? heading;
  final double? headingAccuracy;
  final double? speed;
  final double? speedAccuracy;
  final int? journeyId;

  const GpsCoordinateEntity({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    this.accuracy,
    this.journeyId,
    this.altitude,
    this.altitudeAccuracy,
    this.heading,
    this.headingAccuracy,
    this.speed,
    this.speedAccuracy,
  });

  GpsCoordinateEntity copyWith({
    int? id,
    double? longitude,
    double? latitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? altitudeAccuracy,
    double? heading,
    double? headingAccuracy,
    double? speed,
    double? speedAccuracy,
    int? journeyId,
  }) {
    return GpsCoordinateEntity(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      altitude: altitude ?? this.altitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitudeAccuracy: altitudeAccuracy ?? this.altitudeAccuracy,
      heading: heading ?? this.heading,
      headingAccuracy: headingAccuracy ?? this.headingAccuracy,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    journeyId,
    longitude,
    latitude,
    altitude,
    timestamp,
    accuracy,
    altitudeAccuracy,
    heading,
    headingAccuracy,
    speed,
    speedAccuracy,
  ];

  LatLng get latlng => LatLng(latitude, longitude);
}
