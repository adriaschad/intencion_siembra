class Variety {
  final String id;
  final String name;
  final int averageCycleDays;
  final bool isPollinizer;
  final String? description;

  Variety({
    required this.id,
    required this.name,
    required this.averageCycleDays,
    required this.isPollinizer,
    this.description,
  });

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
      id: json['_id'],
      name: json['name'],
      averageCycleDays: json['averageCycleDays'],
      isPollinizer: json['isPollinizer'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'averageCycleDays': averageCycleDays,
      'isPollinizer': isPollinizer,
      'description': description,
    };
  }
}
