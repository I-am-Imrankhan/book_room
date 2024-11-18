import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final DateTime selectedDate;

  const RoomCard({super.key, required this.selectedDate, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(room.name),
        subtitle: Text(
          'Capacity: ${room.capacity} people\nDate: ${selectedDate.toString().split(' ')[0]}',
        ),
        /* trailing: Chip(
          label: Text(
            room.isAvailable ? 'Available' : 'Booked',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor:
              room.isAvailable ? Colors.green : Colors.red,
        ), */
      ),
    );
  }
}