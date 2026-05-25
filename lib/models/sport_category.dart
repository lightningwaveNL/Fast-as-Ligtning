class SportCategory {
  final int? id;
  final String name;
  final String emoji;
  final bool isCustom;

  SportCategory({
    this.id,
    required this.name,
    required this.emoji,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory SportCategory.fromMap(Map<String, dynamic> map) {
    return SportCategory(
      id: map['id'],
      name: map['name'],
      emoji: map['emoji'],
      isCustom: map['isCustom'] == 1,
    );
  }

  SportCategory copyWith({
    int? id,
    String? name,
    String? emoji,
    bool? isCustom,
  }) {
    return SportCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
