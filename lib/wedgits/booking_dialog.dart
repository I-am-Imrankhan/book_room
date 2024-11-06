import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/firebase_service.dart';
import '../models/booking.dart';

class BookingDialog extends StatefulWidget {
  final Room room;
  final DateTime selectedDate;

  const BookingDialog({
    super.key,
    required this.room,
    required this.selectedDate,
  });

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final FirebaseService _firebaseService = FirebaseService();
  List<int> _availableHours = [];
  int? _selectedHour;

  @override
  void initState() {
    super.initState();
    _loadAvailableHours();
  }

  Future<void> _loadAvailableHours() async {
    final List<int> hours = [];
    for (int hour = 9; hour <= 18; hour++) {
      if (await _firebaseService.isTimeSlotAvailable(
          widget.room.id, widget.selectedDate, hour)) {
        hours.add(hour);
      }
    }
    setState(() {
      _availableHours = hours;
    });
  }

  String _formatHour(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Book ${widget.room.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Available Time Slots:'),
          const SizedBox(height: 16),
          if (_availableHours.isEmpty)
            const Text('No available time slots')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableHours.map((hour) {
                return ChoiceChip(
                  label: Text(_formatHour(hour)),
                  selected: _selectedHour == hour,
                  onSelected: (selected) {
                    setState(() {
                      _selectedHour = selected ? hour : null;
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedHour == null
              ? null
              : () async {
                  final booking = Booking(
                    id: DateTime.now().toString(),
                    roomId: widget.room.id,
                    date: widget.selectedDate,
                    startHour: _selectedHour!,
                    duration: 3,
                    userId: 'user_id', // Replace with actual user ID
                  );
                  await _firebaseService.createBooking(booking);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Room booked successfully!'),
                      ),
                    );
                  }
                },
          child: const Text('Book'),
        ),
      ],
    );
  }
}