import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../models/time_slot.dart';
import '../services/booking_service.dart';
import '../models/booking.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;

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
  final BookingService _bookingService = BookingService();
  List<TimeSlot> _timeSlots = [];
  int? _selectedHour;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  Future<void> _loadTimeSlots() async {
    try {
      final slots = await _bookingService.getAvailableTimeSlots(
        widget.room.id,
        widget.selectedDate,
      );
      setState(() {
        _timeSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading time slots: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);
    final user = authProvider.user;

    return AlertDialog(
      title: Text('Book Room ${widget.room.name}'),
      content: user == null
          ? const Text('You need to be logged in to book a room.')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your existing code to display available slots
                // ...
                Wrap(
                  children: _timeSlots.map((slot) {
                    return ChoiceChip(
                      label: Text('${slot.hour}:00'),
                      selected: _selectedHour == slot.hour,
                      onSelected: slot.isAvailable
                          ? (selected) {
                              setState(() {
                                _selectedHour = selected ? slot.hour : null;
                              });
                            }
                          : null,
                      backgroundColor:
                          slot.isAvailable ? null : Colors.grey[300],
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
                  try {
                    final booking = Booking(
                      id: '',
                      roomId: widget.room.id,
                      date: widget.selectedDate,
                      startHour: _selectedHour!,
                      duration: 12,
                      userId: user!.uid, // Use the actual user ID
                    );
                    await _bookingService.createBooking(booking);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Room booked successfully!'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to book room: $e'),
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
