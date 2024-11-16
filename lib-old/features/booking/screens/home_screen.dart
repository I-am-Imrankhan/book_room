import 'package:flutter/material.dart';
import '../widgets/compact_week_view.dart';
import 'rooms_screen.dart'; // Import the new screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose a date to book a room',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CompactWeeklyView(
                onDaySelected: (date) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomsScreen(date: date),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}