import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room.dart';
import '../models/booking.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rooms
  Stream<List<Room>> getRooms() {
    return _firestore.collection('rooms').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Room(
          id: doc.id,
          name: data['name'] ?? '',
          capacity: data['capacity'] ?? 0,
          isAvailable: data['isAvailable'] ?? true,
          pricePerHour: (data['pricePerHour'] ?? 0).toDouble(),
        );
      }).toList();
    });
  }

  // Bookings
  Future<List<Booking>> getBookingsForRoom(String roomId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThan: endOfDay.toIso8601String())
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Booking.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  Future<void> createBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toJson());
  }

  Future<bool> isTimeSlotAvailable(
      String roomId, DateTime date, int startHour) async {
    final bookings = await getBookingsForRoom(roomId, date);
    return !bookings.any((booking) =>
        booking.startHour <= startHour && 
        booking.startHour + booking.duration > startHour);
  }
}