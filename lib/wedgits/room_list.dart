import 'package:book_room/wedgits/room_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room_provider.dart';

class RoomList extends StatelessWidget {
  const RoomList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) {
        final rooms = roomProvider.rooms;
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return RoomCard(room: rooms[index]);
            },
          ),
        );
      },
    );
  }
}