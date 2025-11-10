//calories and macros change notifiers


String getTodaysDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString();
  final day = now.day.toString();
  return "$day-$month-$year";
}

String todaysDate = getTodaysDate();


final defaultCaloriesTarget = 2300;
final defaultProteinTarget = 150;
final defaultCarbsTarget = 250;
final defaultFatsTarget = 70;
final defaultWaterTarget = 3;