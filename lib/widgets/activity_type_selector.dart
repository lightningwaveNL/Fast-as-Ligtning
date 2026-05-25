import 'package:flutter/material.dart';

class ActivityTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;

  const ActivityTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final types = [
      {'type': 'running', 'emoji': '🏃', 'label': 'Running'},
      {'type': 'cycling', 'emoji': '🚴', 'label': 'Cycling'},
      {'type': 'walking', 'emoji': '🚶', 'label': 'Walking'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Activity Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: types.length,
          itemBuilder: (context, index) {
            final item = types[index];
            final isSelected = selectedType == item['type'];

            return GestureDetector(
              onTap: () => onTypeSelected(item['type'] as String),
              child: Card(
                elevation: isSelected ? 8 : 2,
                color: isSelected ? Colors.blue : Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['emoji'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
