class TimeSlot {
  final int hour;
  final bool isAvailable;

  TimeSlot({
    required this.hour,
    required this.isAvailable,
  });

  String get formattedTime => '${hour.toString().padLeft(2, '0')}:00';
}
