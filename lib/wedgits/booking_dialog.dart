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
      title: Text('Book ${widget.room.name}'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Available 2-Hour Time Slots:'),
                const SizedBox(height: 16),
                if (_timeSlots.isEmpty)
                  const Text('No available time slots')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _timeSlots.map((slot) {
                      return ChoiceChip(
                        label: Text('${slot.formattedTime} - ${slot.hour + 2}:00'),
                        selected: _selectedHour == slot.hour,
                        onSelected: slot.isAvailable
                            ? (selected) {
                                setState(() {
                                  _selectedHour = selected ? slot.hour : null;
                                });
                              }
                            : null,
                        backgroundColor: slot.isAvailable ? null : Colors.grey[300],
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
                      roomId: widget.room.id,
                      roomName: widget.room.name,
                      date: widget.selectedDate,
                      startHour: _selectedHour!,
                      duration: 2,
                      userId: user!.uid, // Replace with actual user ID
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
                      SnackBar(content: Text('Error booking room: $e')),
                    );
                  }
                },
          child: const Text('Book'),
        ),
      ],
    );
  }
}