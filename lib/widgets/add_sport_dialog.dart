import 'package:flutter/material.dart';

class AddSportDialog extends StatefulWidget {
  final Function(String name, String emoji) onAdd;
  final List<String> existingCategories;

  const AddSportDialog({
    Key? key,
    required this.onAdd,
    required this.existingCategories,
  }) : super(key: key);

  @override
  State<AddSportDialog> createState() => _AddSportDialogState();
}

class _AddSportDialogState extends State<AddSportDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedEmoji = '⛹️';

  final List<String> _popularEmojis = [
    '🏃', '🚴', '🚶', '⛹️', '🤸', '🏊', '🧗', '⛷️', '🏂', '🤾',
    '🏄', '🚣', '🛹', '⛸️', '🎿', '🏌️', '🏹', '🎯', '🤺', '🥊',
    '🥋', '🥅', '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉',
    '🥏', '🎳', '🏓', '🏸', '🏒', '🥍', '🏑', '🛼', '🛴', '🏇',
    '⛷️', '🎣', '🤿', '🎽', '🏋️', '🤼', '🤸', '⛹️', '🤺', '🏌️',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final name = _nameController.text.trim();
    return name.isNotEmpty &&
        !widget.existingCategories
            .map((c) => c.toLowerCase())
            .contains(name.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Sport Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                hintText: 'e.g., Swimming, Hiking, Skiing',
                border: const OutlineInputBorder(),
                errorText: _nameController.text.isNotEmpty &&
                        widget.existingCategories
                            .map((c) => c.toLowerCase())
                            .contains(_nameController.text.toLowerCase())
                    ? 'Category already exists'
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Emoji',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _selectedEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _popularEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = _popularEmojis[index];
                  final isSelected = _selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.blue[100] : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isValid
              ? () {
                  final name = _nameController.text.trim();
                  widget.onAdd(name, _selectedEmoji);
                }
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
