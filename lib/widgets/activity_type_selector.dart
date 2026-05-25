import 'package:flutter/material.dart';
import '../models/sport_category.dart';
import 'add_sport_dialog.dart';

class ActivityTypeSelector extends StatefulWidget {
  final String? selectedType;
  final Function(String) onTypeSelected;
  final List<SportCategory> sportCategories;
  final Function(String, String) onAddCategory;
  final Function(int)? onDeleteCategory;

  const ActivityTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.sportCategories,
    required this.onAddCategory,
    this.onDeleteCategory,
  }) : super(key: key);

  @override
  State<ActivityTypeSelector> createState() => _ActivityTypeSelectorState();
}

class _ActivityTypeSelectorState extends State<ActivityTypeSelector> {
  @override
  Widget build(BuildContext context) {
    final types = widget.sportCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Activity Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => _showAddCategoryDialog(context),
              icon: const Icon(Icons.add_circle),
              tooltip: 'Add custom category',
            ),
          ],
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
            final isSelected = widget.selectedType == item.name;

            return GestureDetector(
              onTap: () => widget.onTypeSelected(item.name),
              onLongPress: item.isCustom
                  ? () => _showDeleteConfirmation(context, item)
                  : null,
              child: Card(
                elevation: isSelected ? 8 : 2,
                color: isSelected ? Colors.blue : Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (types.any((t) => t.isCustom))
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'Long press custom categories to delete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddSportDialog(
        onAdd: (name, emoji) {
          widget.onAddCategory(name, emoji);
          Navigator.pop(context);
        },
        existingCategories: widget.sportCategories.map((c) => c.name).toList(),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, SportCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text('Remove "${category.name}" category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDeleteCategory?.call(category.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${category.name} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
