import 'package:book_room/wedgits/booking_dialog.dart';
import 'package:book_room/wedgits/room_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../services/firebase_service.dart';

class RoomsScreen extends StatelessWidget {
  final DateTime selectedDate;

  const RoomsScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms for ${selectedDate.toString().split(' ')[0]}'),
      ),
      body: StreamBuilder<List<Room>>(
        stream: FirebaseService().getRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => BookingDialog(
                      room: room,
                      selectedDate: selectedDate,
                    ),
                  );
                },
                child: RoomCard(room: room),
              );
            },
          );
        },
      ),
    );
  }
}