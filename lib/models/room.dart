class Room {
  final String id;
  final String name;
  final int capacity;
  final bool isAvailable;
  final double pricePerHour;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.isAvailable,
    required this.pricePerHour,
  });
}