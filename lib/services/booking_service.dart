import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/time_slot.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all available time slots for a room on a specific date
  Future<List<TimeSlot>> getAvailableTimeSlots(
      String roomId, DateTime date) async {
    // Implement the logic to fetch available time slots from Firestore
    // This is a placeholder implementation
    List<TimeSlot> availableSlots = [];

    // Fetch bookings for the room on the specified date
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    DateTime startOfDayUtc = startOfDay.toUtc();
    DateTime endOfDayUtc = endOfDay.toUtc();

    QuerySnapshot querySnapshot = await _firestore
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        /* .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDayUtc))
      .where('date', isLessThan: Timestamp.fromDate(endOfDayUtc)) */
        .get();

    // Process the bookings to determine available slots
    // This is a simplified example
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
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data()))
            .toList());
  }

  Future<void> deleteBooking(
      String roomId, String userId, int startHour) async {
    final querySnapshot = await _firestore
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        .where('userId', isEqualTo: userId)
        .where("startHour", isEqualTo: startHour)
        .get();
    for (var doc in querySnapshot.docs) {
      await _firestore.collection('bookings').doc(doc.id).delete();
    }
  }
}
