import 'package:flutter/foundation.dart';
import 'room.dart';

class RoomProvider with ChangeNotifier {
  final List<Room> _rooms = [
    Room(
      id: '1',
      name: 'Conference Room A',
      capacity: 10,
      isAvailable: true,
      pricePerHour: 50,
    ),
    Room(
      id: '2',
      name: 'Meeting Room B',
      capacity: 6,
      isAvailable: true,
      pricePerHour: 30,
    ),
    Room(
      id: '3',
      name: 'Board Room',
      capacity: 15,
      isAvailable: true,
      pricePerHour: 75,
    ),
  ];

  List<Room> get rooms => [..._rooms];

  void bookRoom(String roomId) {
    final roomIndex = _rooms.indexWhere((room) => room.id == roomId);
    if (roomIndex >= 0) {
      _rooms[roomIndex] = Room(
        id: _rooms[roomIndex].id,
        name: _rooms[roomIndex].name,
        capacity: _rooms[roomIndex].capacity,
        isAvailable: false,
        pricePerHour: _rooms[roomIndex].pricePerHour,
      );
      notifyListeners();
    }
  }
}