import 'package:flutter/material.dart';
import 'routes.dart';

class BookRoomApp extends StatelessWidget {
  const BookRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Room',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
