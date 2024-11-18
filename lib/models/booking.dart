import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      id: data['id'],
      roomId: data['roomId'],
      roomName: data['roomName'],
      date: (data['date'] as Timestamp).toDate(),
      startHour: data['startHour'],
      duration: data['duration'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'date': date,
      'startHour': startHour,
      'duration': duration,
      'userId': userId,
    };
  }
}
