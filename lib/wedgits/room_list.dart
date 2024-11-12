import 'package:book_room/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_room/providers/AuthProvider.dart' as auth_provider;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<DateTime> _getNext7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day + index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _getNext7Days();
    final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Room'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select a Date',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return ListTile(
                  title: Text('${day.month}/${day.day}/${day.year}'),
                  onTap: () {
                    // Handle date selection
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}