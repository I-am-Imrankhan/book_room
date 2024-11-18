import 'package:book_room/models/booking.dart';
import 'package:book_room/screens/login_screen.dart';
import 'package:book_room/screens/new_booking_screen.dart';
import 'package:book_room/services/booking_service.dart';
import 'package:book_room/widgets/button_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingService = BookingService();
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Room'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'My Bookings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          user == null
              ? const Center(child: Text('Please log in to see your bookings.'))
              : Expanded(
                  child: StreamBuilder<List<Booking>>(
                    stream: bookingService.getUserBookings(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading bookings.'));
                      }
                      final bookings = snapshot.data ?? [];
                      if (bookings.isEmpty) {
                        return const Center(child: Text('No bookings found.'));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          final weekNumber =
                              DateFormat('MMM').format(booking.date);
                          return Container(
                            margin: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(100),
                                right: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(100),
                                          right: Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            weekNumber,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd')
                                                .format(booking.date),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room: ${booking.roomName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Date: ${DateFormat('MMM d').format(booking.date)}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Time: ${booking.startHour}:00 - ${booking.startHour + booking.duration}:00',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () async {
                                    await bookingService.deleteBooking(booking.id);
                                  },
                                ),
                                /* IconButton(
                                  icon: const Icon(Icons.cancel),
                                  color: Colors.white,
                                  onPressed: () async {
                                  },
                                ), */
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          const SizedBox(height: 20),
          ButtonLink(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewBookingScreen()),
            ),
            text: "Create Booking",
          ),
        ],
      ),
    );
  }
}
