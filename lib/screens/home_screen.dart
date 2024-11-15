import 'package:book_room/models/booking.dart';
import 'package:book_room/screens/login_screen.dart';
import 'package:book_room/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'rooms_screen.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<DateTime> _getNext7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day + index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingService = BookingService();
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);
    final user = authProvider.user;
    final days = _getNext7Days();

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
        mainAxisAlignment: MainAxisAlignment.center,
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
              : Flexible(
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
                        scrollDirection: Axis.horizontal,
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                          ],
                                        ),
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
                                const SizedBox(height: 4),
                                Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                        onPressed: () async {
                                          await bookingService
                                              .deleteBooking(booking.roomId, user.uid, booking.startHour);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.cancel),
                                        color: Colors.white,
                                        onPressed: () async {
                                          //await bookingService  .deleteBooking(booking.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          const SizedBox(height: 20),
          const Text(
            'Select a Date',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = days[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomsScreen(selectedDate: day),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(day),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM d').format(day),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
