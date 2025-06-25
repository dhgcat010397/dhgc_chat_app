import 'package:intl/intl.dart';

extension LastMessageAtFormatter on DateTime {
  String formatLastMessageAt() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(year, month, day);

    if (messageDay == today) {
      return DateFormat('HH:mm').format(this);
    }

    final startOfWeek = today.subtract(Duration(days: today.weekday - 1)); // Monday
    if (messageDay.isAfter(startOfWeek) && messageDay.isBefore(today)) {
      return DateFormat('E').format(this); // Mon, Tue, etc.
    }

    if (year == now.year) {
      return DateFormat('MMM d').format(this); // Jun 9
    }

    return DateFormat('MMM d, yyyy').format(this); // Mar 2, 2023
  }
}