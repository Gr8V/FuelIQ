class DateUtilsExt {
  static String normalize(String date) {
    final p = date.split('-');
    return '${p[0].padLeft(2, '0')}-${p[1].padLeft(2, '0')}-${p[2]}';
  }

  static DateTime todayDate() {
    final d = DateTime.now();
    return DateTime(d.year, d.month, d.day);
  }

  static String today() => format(todayDate());

  static String format(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  static DateTime parse(String date) {
    final p = date.split('-');
    return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isAfter(DateTime a, DateTime b) {
    return a.isAfter(b) || isSameDay(a, b);
  }
}
