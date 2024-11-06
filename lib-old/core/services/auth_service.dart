import '../models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication changes and return UserModel
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user != null
          ? UserModel(uid: user.uid, email: user.email ?? '', role: 'user')
          : null;
    });
  }

  // In core/services/auth_service.dart
  Future<UserModel?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print("User signed in: ${user?.uid}");
      return user != null
          ? UserModel(uid: user.uid, email: user.email ?? '', role: 'user')
          : null;
    } catch (e) {
      print('Error registering: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print("User registered: ${user?.uid}");
      return user != null
          ? UserModel(uid: user.uid, email: user.email ?? '', role: 'user')
          : null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  static bool _canBookMoreSlots() {
    // Logic to check the number of bookings made in the last 7 days
    // For example, query the database to count bookings for the user
    return true; // Implement actual checking logic
  }
  static Future<List<Room>> getRooms() async {
    // Fetch rooms from Firestore
    // This is a placeholder for your Firestore query
    final rooms = [
      Room(
        id: 'room1',
        name: 'Room 1',
        capacity: 4,
        availability: ['09:00-11:00', '13:00-15:00'],
      ),
      Room(
        id: 'room2',
        name: 'Room 2',
        capacity: 6,
        availability: ['10:00-12:00', '14:00-16:00'],
      ),
      Room(
        id: 'room3',
        name: 'Room 3',
        capacity: 8,
        availability: ['11:00-13:00', '15:00-17:00'],
      ),
    ];
    return rooms;
  }
  static List<String> getAvailableTimeSlots(DateTime date) {
    // Define the opening hours
    final openingTime = DateTime(date.year, date.month, date.day, 9);
    final closingTime = DateTime(date.year, date.month, date.day, 19);
    List<String> timeSlots = [];

    for (int hour = 9; hour <= 17; hour++) {
      // 9 AM to 6 PM
      String timeSlot =
          "${hour.toString().padLeft(2, '0')}:00 - ${(hour + 2).toString().padLeft(2, '0')}:00"; // 2-hour slots
      timeSlots.add(timeSlot);
    }
    return timeSlots;
  }



  static void bookTimeSlot(DateTime date, String timeSlot) {
// Function to check booking limit

    // Check booking limits (you may want to implement this as an async call)
    if (_canBookMoreSlots()) {
      // Save booking information to the database
      // This is a placeholder for your database save operation
      final booking = {
        'userId': 'user_id_here', // Replace with actual user ID
        'date': date.toIso8601String(),
        'timeSlot': timeSlot,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Assume you have a function saveBooking() that handles the database operation
      //saveBooking(booking);
    } else {
      // Show a message indicating that the user has reached their booking limit
      print('You can only book 3 time slots in the next 7 days.');
    }
  }

  static Future<List<String>> fetchAvailableTimeSlots(Room room, DateTime date) async {
  // Fetch available time slots for the selected room and date from Firestore
  // Filter out already booked time slots
  // Return the list of available time slots
  final openingTime = DateTime(date.year, date.month, date.day, 9);
    final closingTime = DateTime(date.year, date.month, date.day, 19);
    List<String> timeSlots = [];

    for (int hour = 9; hour <= 17; hour++) {
      // 9 AM to 6 PM
      String timeSlot =
          "${hour.toString().padLeft(2, '0')}:00 - ${(hour + 2).toString().padLeft(2, '0')}:00"; // 2-hour slots
      timeSlots.add(timeSlot);
    }
    return timeSlots;
}

static Future<void> saveBookingToFirestore(Room room, DateTime date, String timeSlot) async {
  await FirebaseFirestore.instance.collection('bookings').add({
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'roomId': room.id,
    'date': date,
    'timeSlot': timeSlot,
  });
}

}
