import 'package:flutter/material.dart';
import '../models/activity.dart';

class StatsDisplay extends StatelessWidget {
  final Activity activity;
  final LocationPoint? currentLocation;
  final double totalDistance;

  const StatsDisplay({
    Key? key,
    required this.activity,
    required this.currentLocation,
    required this.totalDistance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    totalDistance.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'kilometers',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _StatCard(
                label: 'Duration',
                value: activity.durationString,
              ),
              _StatCard(
                label: 'Avg Speed',
                value: '${activity.averageSpeed.toStringAsFixed(1)} km/h',
              ),
              _StatCard(
                label: 'Current Speed',
                value:
                    '${(currentLocation?.speed ?? 0).toStringAsFixed(1)} km/h',
              ),
              _StatCard(
                label: 'Altitude',
                value: '${(currentLocation?.altitude ?? 0).toStringAsFixed(0)} m',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
