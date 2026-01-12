import 'package:hive_ce/hive.dart';

class QuickAccessStorage {
  static Box get _box => Hive.box('quickAccessBox');

  // Read
  Map<String, dynamic> getSavedFoods() {
    return Map<String, dynamic>.from(_box.get('saved_foods', defaultValue: {}));
  }

  // Write
  Future<void> saveAllFoods(Map<String, dynamic> foods) async{
    await _box.put('saved_foods', foods);
  }

}