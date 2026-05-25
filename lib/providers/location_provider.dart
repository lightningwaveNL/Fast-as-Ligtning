import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import '../models/activity.dart';

class LocationProvider extends ChangeNotifier {
  LocationPoint? _currentLocation;
  List<LocationPoint> _locations = [];
  bool _isTracking = false;
  String? _errorMessage;

  LocationPoint? get currentLocation => _currentLocation;
  List<LocationPoint> get locations => _locations;
  bool get isTracking => _isTracking;
  String? get errorMessage => _errorMessage;

  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.whileInUse ||
          result == LocationPermission.always;
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> startTracking() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        _errorMessage = 'Location permission denied';
        notifyListeners();
        return;
      }

      _isTracking = true;
      _locations = [];
      _errorMessage = null;
      notifyListeners();

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
        ),
      ).listen(
        (Position position) {
          _currentLocation = LocationPoint(
            latitude: position.latitude,
            longitude: position.longitude,
            altitude: position.altitude,
            speed: position.speed,
            timestamp: DateTime.now(),
          );
          _locations.add(_currentLocation!);
          notifyListeners();
        },
        onError: (error) {
          _errorMessage = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void stopTracking() {
    _isTracking = false;
    notifyListeners();
  }

  void clearLocations() {
    _locations = [];
    _currentLocation = null;
    notifyListeners();
  }

  double calculateDistance(LocationPoint p1, LocationPoint p2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((p2.latitude - p1.latitude) * p) / 2 +
        cos(p1.latitude * p) *
            cos(p2.latitude * p) *
            (1 - cos((p2.longitude - p1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  double getTotalDistance() {
    if (_locations.isEmpty) return 0;
    double total = 0;
    for (int i = 0; i < _locations.length - 1; i++) {
      total += calculateDistance(_locations[i], _locations[i + 1]);
    }
    return total;
  }
}
