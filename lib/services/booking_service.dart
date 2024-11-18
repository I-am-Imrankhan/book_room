import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/time_slot.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TimeSlot>> getAvailableTimeSlots(
      String roomId, DateTime date) async {
    List<TimeSlot> availableSlots = [];

    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();
    for (int hour = 9; hour <= 18; hour += 2) {
      bool isAvailable = true;
      for (var doc in querySnapshot.docs) {
        int startHour = doc['startHour'];
        int duration = doc['duration'];
        if (hour >= startHour && hour < startHour + duration) {
          isAvailable = false;
          break;
        }
      }
      availableSlots.add(TimeSlot(hour: hour, isAvailable: isAvailable));
    }
    return availableSlots;
  }

  Future<void> createBooking(Booking booking) async {
    // Check if the time slot is still available
    final availableSlots =
        await getAvailableTimeSlots(booking.roomId, booking.date);
    final isSlotAvailable = availableSlots
        .where((slot) =>
            slot.hour >= booking.startHour &&
            slot.hour < booking.startHour + booking.duration)
        .every((slot) => slot.isAvailable);

    if (!isSlotAvailable) {
      throw Exception('Time slot is no longer available');
    }

    // Create the booking
    await _firestore.collection('bookings').add({
      'id': booking.id,
      'roomId': booking.roomId,
      'roomName': booking.roomName,
      'date': Timestamp.fromDate(booking.date),
      'startHour': booking.startHour,
      'duration': booking.duration,
      'userId': booking.userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList());
  }

  Future<void> deleteBooking(String bookingId) async {
    final querySnapshot = await _firestore
        .collection('bookings')
        .where('id', isEqualTo: bookingId)
        .get();
    for (var doc in querySnapshot.docs) {
      await _firestore.collection('bookings').doc(doc.id).delete();
    }
  }
}
