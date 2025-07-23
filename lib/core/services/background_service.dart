import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jourscape/core/services/get_postition.dart';
import 'package:jourscape/features/gps_tracking/data/datasources/gps_coordinate_local_datasource.dart';
import 'package:jourscape/features/gps_tracking/data/repositories/gps_coordinate_repository_impl.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the initialization and configuration of the Flutter Background Service.
class BackgroundServiceManager {
  static const String _notificationChannelId = 'my_foreground';
  static const int _foregroundNotificationId = 888;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Configure notification channels for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _notificationChannelId,
        'Jourscape Background Service',
        description:
            'This channel is used for important app background activity.',
        importance: Importance.low,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    // Initialize notification settings for both platforms
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );

    // Configure the background service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStartBackgroundService,
        isForegroundMode: true,
        notificationChannelId: _notificationChannelId,
        initialNotificationTitle: 'Jourscape is Active',
        initialNotificationContent: 'Monitoring device movement...',
        foregroundServiceNotificationId: _foregroundNotificationId,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onStartBackgroundService,
        onBackground: onIosBackground,
      ),
    );

    // Start the service
    service.startService();
  }

  /// Requests notification permissions for Android 13+
  static void requestNotificationPermission() {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }
}

// Global/static variables for sensor handling within the isolate
StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
bool _isMoving = false;
DateTime? _lastMovementTime;
Timer? _stationaryDetectionTimer;
const double _accelThreshold = 3;
const double _gyroThreshold = 5;
const Duration _stationaryDelay = Duration(seconds: 5);
const double distanceInMetersThreshold = 20;

// Position tracking
Position? _currentLocation;
// Repositories instance for the background isolate
late GpsCoordinateRepository _gpsCoordinateRepository;
late GpsCoordinateLocalDataSourceImpl _gpsLocalCoordinateDataSource;

/// Entry point for iOS background fetches (must be top-level)
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add('iOS Background: ${DateTime.now().toIso8601String()}');
  await preferences.setStringList('log', log);

  return true;
}

/// Entry point for the background service (must be top-level)
@pragma('vm:entry-point')
void onStartBackgroundService(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(
    'background_service_init',
    DateTime.now().toIso8601String(),
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  _gpsLocalCoordinateDataSource = GpsCoordinateLocalDataSourceImpl();
  _gpsCoordinateRepository = GPSCoordinateRepositoryImpl(
    localDataSource: _gpsLocalCoordinateDataSource,
  );

  // --------- Sensor Data Processing Logic ---------

  void processSensorData({
    required double x,
    required double y,
    required double z,
    required double threshold,
    required String sensorType,
  }) {
    final double magnitude = sqrt(x * x + y * y + z * z);

    if (magnitude > threshold) {
      if (!_isMoving) {
        _isMoving = true;
        service.invoke('movement_status', {'isMoving': true});
      }
      _lastMovementTime = DateTime.now();
      _stationaryDetectionTimer?.cancel();
      _stationaryDetectionTimer = null;
    } else {
      if (_isMoving && _stationaryDetectionTimer == null) {
        _stationaryDetectionTimer = Timer(_stationaryDelay, () {
          if (_isMoving &&
              _lastMovementTime != null &&
              DateTime.now().difference(_lastMovementTime!) >=
                  _stationaryDelay) {
            _isMoving = false;
            service.invoke('movement_status', {'isMoving': false});
          }
          _stationaryDetectionTimer = null;
        });
      }
    }
  }

  // Start listening to sensor events
  _userAccelerometerSubscription = userAccelerometerEvents.listen((event) {
    processSensorData(
      x: event.x,
      y: event.y,
      z: event.z,
      threshold: _accelThreshold,
      sensorType: 'Accelerometer',
    );
  });

  _gyroscopeSubscription = gyroscopeEvents.listen((event) {
    processSensorData(
      x: event.x,
      y: event.y,
      z: event.z,
      threshold: _gyroThreshold,
      sensorType: 'Gyroscope',
    );
  });

  // --- Service Control and Communication ---

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      _updateForegroundNotification(service, flutterLocalNotificationsPlugin);
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      _updateForegroundNotification(
        service,
        flutterLocalNotificationsPlugin,
        isBackground: true,
      );
    });
  }

  service.on('stopService').listen((event) {
    _userAccelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _stationaryDetectionTimer?.cancel();
    service.stopSelf();
  });

  // Initial foreground notification setting
  if (service is AndroidServiceInstance) {
    _updateForegroundNotification(
      service,
      flutterLocalNotificationsPlugin,
      initial: true,
    );
  }

  // Regular periodic updates for notification and data transmission
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        await _updateForegroundNotification(
          service,
          flutterLocalNotificationsPlugin,
        );
      }
    }

    // Example of getting location periodically
    double distanceInMeters = 0;
    try {
      Position newPosition = await determinePosition();

      if (_currentLocation != null) {
        distanceInMeters = Geolocator.distanceBetween(
          newPosition.latitude,
          newPosition.longitude,
          _currentLocation!.latitude,
          _currentLocation!.longitude,
        );
      }
      _currentLocation = newPosition;
    } catch (e) {}
    if (distanceInMeters > distanceInMetersThreshold &&
        _isMoving &&
        _currentLocation != null) {
      _gpsCoordinateRepository.createCoordinate(
        GpsCoordinateEntity(
          id: 0,
          longitude: _currentLocation!.longitude,
          latitude: _currentLocation!.latitude,
          timestamp: _currentLocation!.timestamp,
          accuracy: _currentLocation!.accuracy,
          altitude: _currentLocation!.altitude,
          altitudeAccuracy: _currentLocation!.altitudeAccuracy,
          heading: _currentLocation!.heading,
          headingAccuracy: _currentLocation!.headingAccuracy,
          speed: _currentLocation!.speed,
          speedAccuracy: _currentLocation!.speedAccuracy,
        ),
      );
    }

    // Send the status back to the UI
    service.invoke('movement_status', {
      'isMoving': _isMoving,
      'timestamp': DateTime.now().toIso8601String(),
      'position': _currentLocation,
    });
  });
}

/// Helper to update the foreground notification
Future<void> _updateForegroundNotification(
  AndroidServiceInstance service,
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {
  bool initial = false,
  bool isBackground = false,
}) async {
  String title;

  if (initial) {
    title = 'Jourscape Active';
  } else if (isBackground) {
    title = 'Jourscape';
  } else {
    title = 'Jourscape ${_isMoving ? 'moving' : 'stationary'}';
  }

  service.setForegroundNotificationInfo(title: title, content: '');

  // Show a persistent notification when in foreground mode
  if (!isBackground) {
    flutterLocalNotificationsPlugin.show(
      BackgroundServiceManager._foregroundNotificationId,
      title,
      '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          BackgroundServiceManager._notificationChannelId,
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  } else {
    flutterLocalNotificationsPlugin.cancel(
      BackgroundServiceManager._foregroundNotificationId,
    );
  }
}
