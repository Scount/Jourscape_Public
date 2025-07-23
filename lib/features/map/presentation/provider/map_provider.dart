import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_all_coordinates_notifier.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_coordinates_by_date_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_provider.g.dart';

@riverpod
Polyline? gpsPolylineByDate(dynamic ref) {
  final AsyncValue<List<GpsCoordinateEntity>?> coordinatesAsyncValue = ref
      .watch(gpsCoordinatesByDateNotifierProvider);

  return coordinatesAsyncValue.whenOrNull(
    data: (data) {
      if (data == null || data.isEmpty) {
        return null;
      }
      return Polyline(
        points: data.map((e) => e.latlng).toList(),
        strokeWidth: 3,
        color: const Color(0xffc55fc9),
      );
    },
  );
}

@riverpod
List<Polyline>? gpsAllPolylines(dynamic ref) {
  final AsyncValue<List<List<GpsCoordinateEntity>?>> coordinatesAsyncValue = ref
      .watch(gpsAllCoordinatesNotifierProvider);

  return coordinatesAsyncValue.whenOrNull(
    data: (data) {
      List<Polyline> allPolylines = [];

      for (var element in data) {
        if (element == null || element.isEmpty) {
          return null;
        }
        allPolylines.add(
          Polyline(
            points: element.map((e) => e.latlng).toList(),
            strokeWidth: 3,
            color: const Color(0xffc55fc9).withAlpha(100),
          ),
        );
      }

      if (allPolylines.isEmpty) {
        return null;
      }
      return allPolylines;
    },
  );
}

@riverpod
class MapStateNotifier extends _$MapStateNotifier {
  @override
  String build() {
    return 'normal';
  }

  Future<void> changeToHistory() async {
    state = 'history';
  }

  Future<void> changeToNormal() async {
    state = 'normal';
  }
}

StateProvider<DateTime> historyDateProvider = StateProvider<DateTime>((_) {
  return DateTime.now();
});
