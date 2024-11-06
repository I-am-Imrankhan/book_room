import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompactWeeklyView extends StatelessWidget {
  final Function(DateTime) onDaySelected;

  const CompactWeeklyView({super.key, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    List<DateTime> next7Days = [];
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      next7Days.add(today.add(Duration(days: i)));
    }

    return Center(
      child: SizedBox(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: next7Days.length,
          itemBuilder: (context, index) {
            DateTime date = next7Days[index];
            return GestureDetector(
              onTap: () => onDaySelected(date),
              child: Card(
                child: AspectRatio(
                  aspectRatio: 1, // Ensure the item has a consistent aspect ratio
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date)),
                      Text(DateFormat('d').format(date)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}