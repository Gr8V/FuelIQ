//calories and macros change notifiers

String getTodaysDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString();
  final day = now.day.toString();
  return "$day-$month-$year";
}
String todaysDate = getTodaysDate();
String appBarTitle = todaysDate;

double caloriesTarget = 2300;
double proteinTarget = 150;
double carbsTarget =  250;
double fatsTarget = 70;
double waterTarget = 3;