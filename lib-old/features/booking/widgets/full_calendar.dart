import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/canlendar_utils.dart'; // Ensure correct spelling

class FullCalendar extends StatelessWidget {
  final DateTime currentDate;

  FullCalendar({super.key, DateTime? initialDate})
      : currentDate = initialDate ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(5, (index) {
          // Start each week on Monday
          final weekStart =
              _calculateStartOfWeek(currentDate).add(Duration(days: index * 7));
          bool isCurrentWeek = CanlendarUtils.isCurrentWeek(weekStart);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space between children
              children: [
                // Week number and month name on the left
                Container(
                  alignment: Alignment.centerLeft, // Align to the left
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      // Month name
                      Text(
                        DateFormat('MMMM')
                            .format(weekStart), // Display the full month name
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isCurrentWeek ? Colors.red : Colors.black,
                        ),
                      ),
                      // Week number
                      Text(
                        'W${CanlendarUtils.getWeekOfYear(weekStart)} ${isCurrentWeek ? "(Current)" : ""}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isCurrentWeek ? Colors.red : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Days of the week on the right
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (dayIndex) {
                      final dayDate = weekStart.add(Duration(days: dayIndex));
                      bool isToday = dayDate == DateTime.now();

                      return Container(
                        decoration: BoxDecoration(
                          color: isCurrentWeek
                              ? Colors.red[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('EEE').format(dayDate),
                              style: TextStyle(
                                fontSize: 8,
                                color:
                                    isCurrentWeek ? Colors.red : Colors.black,
                              ),
                            ),
                            Text(
                              dayDate.day.toString(),
                              style: TextStyle(
                                fontSize: 8,
                                color: isToday
                                    ? Colors.blue
                                    : (isCurrentWeek
                                        ? Colors.red
                                        : Colors.black),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Helper function to calculate the start of the week (Monday)
  DateTime _calculateStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysToSubtract));
  }
}
