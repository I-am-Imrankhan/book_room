import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String name;
  final int capacity;
  final List<String> availability; // Example: ["09:00-11:00", "13:00-15:00"]

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.availability,
  });

  // Factory constructor to create a Room object from Firestore data
  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Room(
      id: doc.id, // Use the document ID as the room ID
      name: data['name'] ?? '',
      capacity: data['capacity'] ?? 0,
      availability: List<String>.from(data['availability'] ?? []),
    );
  }

  // Convert a Room object to a map that can be saved in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'capacity': capacity,
      'availability': availability,
    };
  }
}
