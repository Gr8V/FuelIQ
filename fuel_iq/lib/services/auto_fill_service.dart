import 'package:fuel_iq/data/local/daily_data_storage.dart';
import 'package:fuel_iq/models/nutrition_data_model.dart';
import '../models/daily_data_model.dart';
import '../utils/date_utils.dart';

class AutoFillService {
  /// Automatically fills missing days between the last stored date and today.
  /// Ensures continuous daily data history.
  static Future<void> autoFillMissingDays() async {
    final all = DailyDataStorage().getAllData();
    final today = DateUtilsExt.todayDate();

    // If empty, create today's entry with default targets
    if (all.isEmpty) {
      final newDay = DailyDataModel();
      await DailyDataStorage().saveDailyData(
        date: DateUtilsExt.format(today),
        data: newDay.toJson(),
      );
      return;
    }

    // Sort stored dates
    final dates = all.keys.toList()
      ..sort((a, b) =>
          DateUtilsExt.parse(a).compareTo(DateUtilsExt.parse(b)));

    final lastStored = DateUtilsExt.parse(dates.last);

    // Already up to date
    if (DateUtilsExt.isSameDay(lastStored, today)) return;

    // Continue from lastStored+1 day → today
    DateTime cursor = lastStored.add(const Duration(days: 1));

    // Get last day's targets to reuse
    final lastDay = DailyDataModel.fromJson(all[dates.last]);

    while (!DateUtilsExt.isAfter(cursor, today)) {
      final newDay = DailyDataModel(
        nutrition: NutritionData(
          targets: lastDay.nutrition.targets,
        )
      );

      await DailyDataStorage().saveDailyData(
        date: DateUtilsExt.format(cursor),
        data: newDay.toJson(),
      );

      cursor = cursor.add(const Duration(days: 1));
    }
  }
}
