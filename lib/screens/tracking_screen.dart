import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_type_selector.dart';
import '../widgets/stats_display.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String? _selectedActivityType;

  void _startTracking() async {
    if (_selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity type')),
      );
      return;
    }

    context.read<ActivityProvider>().startActivity(_selectedActivityType!);
    context.read<LocationProvider>().startTracking();
  }

  void _stopTracking() async {
    context.read<LocationProvider>().stopTracking();
    context.read<ActivityProvider>().endActivity();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity saved!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Activity'),
        elevation: 0,
      ),
      body: Consumer2<LocationProvider, ActivityProvider>(
        builder: (context, locationProvider, activityProvider, _) {
          final isTracking = locationProvider.isTracking;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isTracking)
                  ActivityTypeSelector(
                    selectedType: _selectedActivityType,
                    onTypeSelected: (type) {
                      setState(() => _selectedActivityType = type);
                    },
                  )
                else
                  Expanded(
                    child: StatsDisplay(
                      activity: activityProvider.currentActivity!,
                      currentLocation: locationProvider.currentLocation,
                      totalDistance: locationProvider.getTotalDistance(),
                    ),
                  ),
                const SizedBox(height: 16),
                if (locationProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Error: ${locationProvider.errorMessage}',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ElevatedButton.large(
                  onPressed: isTracking ? _stopTracking : _startTracking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTracking ? Colors.red : Colors.green,
                  ),
                  child: Text(
                    isTracking ? 'Stop Tracking' : 'Start Tracking',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
