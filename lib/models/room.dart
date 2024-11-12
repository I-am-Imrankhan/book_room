class Room {
  final String id;
  final String name;
  final int capacity;
  final double pricePerHour;
  final bool isAvailable;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.pricePerHour,
    this.isAvailable = true,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'pricePerHour': pricePerHour,
      'isAvailable': isAvailable,
    };
  }
}