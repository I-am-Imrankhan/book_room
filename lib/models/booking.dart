class Booking {
  final String id;
  final String roomId;
  final String roomName;
  final DateTime date;
  final int startHour;
  final int duration;
  final String userId;

  Booking({
    required this.id,
    required this.roomName,
    required this.roomId,
    required this.date,
    required this.startHour,
    required this.duration,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'date': date.toIso8601String(),
      'startHour': startHour,
      'duration': duration,
      'userId': userId,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      roomId: json['roomId'],
      roomName: json['roomName'],
      date: DateTime.parse(json['date']),
      startHour: json['startHour'],
      duration: json['duration'],
      userId: json['userId'],
    );
  }
}