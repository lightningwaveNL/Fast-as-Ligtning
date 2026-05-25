import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../services/database_service.dart';

class ActivityProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Activity> _activities = [];
  Activity? _currentActivity;

  List<Activity> get activities => _activities;
  Activity? get currentActivity => _currentActivity;

  ActivityProvider() {
    _init();
  }

  Future<void> _init() async {
    await _db.init();
    await loadActivities();
  }

  Future<void> loadActivities() async {
    _activities = await _db.getAllActivities();
    notifyListeners();
  }

  Future<void> startActivity(String type) async {
    _currentActivity = Activity(
      type: type,
      startTime: DateTime.now(),
      totalDistance: 0,
      averageSpeed: 0,
      caloriesBurned: 0,
      path: [],
    );
    notifyListeners();
  }

  Future<void> endActivity() async {
    if (_currentActivity != null) {
      final completed = Activity(
        type: _currentActivity!.type,
        startTime: _currentActivity!.startTime,
        endTime: DateTime.now(),
        totalDistance: _currentActivity!.totalDistance,
        averageSpeed: _currentActivity!.averageSpeed,
        caloriesBurned: _currentActivity!.caloriesBurned,
        path: _currentActivity!.path,
      );
      
      await _db.insertActivity(completed);
      _activities.insert(0, completed);
      _currentActivity = null;
      notifyListeners();
    }
  }

  Future<void> deleteActivity(int id) async {
    await _db.deleteActivity(id);
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void updateCurrentActivityStats(double distance, double avgSpeed, int calories) {
    if (_currentActivity != null) {
      _currentActivity = Activity(
        type: _currentActivity!.type,
        startTime: _currentActivity!.startTime,
        totalDistance: distance,
        averageSpeed: avgSpeed,
        caloriesBurned: calories,
        path: _currentActivity!.path,
      );
      notifyListeners();
    }
  }
}
