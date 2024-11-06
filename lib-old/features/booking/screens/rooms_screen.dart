import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomsScreen extends StatelessWidget {
  final DateTime date;

  const RoomsScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms for ${DateFormat('EEEE, MMM d').format(date)}'),
      ),
      body: Center(
        child: Text('List of rooms for ${DateFormat('EEEE, MMM d').format(date)}'),
      ),
    );
  }
}