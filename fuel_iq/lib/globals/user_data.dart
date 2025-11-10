//calories and macros change notifiers


// Your existing code
String getTodaysDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString();
  final day = now.day.toString();
  return "$day-$month-$year";
}

String todaysDate = getTodaysDate();
