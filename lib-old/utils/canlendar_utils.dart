class CanlendarUtils {
  static bool isCurrentWeek(DateTime date) {
    final now = DateTime.now();

    // Calculate the start of the week, which is Monday
    final startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));

    // Calculate the end of the week, which is Sunday
    final endOfCurrentWeek = startOfCurrentWeek.add(const Duration(days: 6));

    // Check if the date falls within the current week range (Monday to Sunday)
    return date.isAtSameMomentAs(startOfCurrentWeek) ||
        (date.isAfter(startOfCurrentWeek) && date.isBefore(endOfCurrentWeek)) ||
        date.isAtSameMomentAs(endOfCurrentWeek);
  }

  // Helper to get the week number of the year
  static int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = date.difference(firstDayOfYear).inDays;
    return ((daysOffset + firstDayOfYear.weekday) / 7).ceil();
  }
}
