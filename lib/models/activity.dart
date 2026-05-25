import 'package:intl/intl.dart';

class Activity {
  final int? id;
  final String type;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistance;
  final double averageSpeed;
  final int caloriesBurned;
  final List<LocationPoint> path;

  Activity({
    this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.totalDistance,
    required this.averageSpeed,
    required this.caloriesBurned,
    required this.path,
  });

  bool get isActive => endTime == null;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  String get durationString {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '\$hours:\${minutes.toString().padLeft(2, '0')}:\${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedStartTime => DateFormat('MMM d, yyyy HH:mm').format(startTime);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'totalDistance': totalDistance,
      'averageSpeed': averageSpeed,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      type: map['type'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      totalDistance: map['totalDistance'],
      averageSpeed: map['averageSpeed'],
      caloriesBurned: map['caloriesBurned'],
      path: [],
    );
  }
}

class LocationPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final DateTime timestamp;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      latitude: map['latitude'],
      longitude: map['longitude'],
      altitude: map['altitude'],
      speed: map['speed'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
