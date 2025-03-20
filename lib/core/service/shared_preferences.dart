import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart'; // Import the updated Constants file

class SharedPreference {
  static SharedPreferences? sharedPref;

  static Future<SharedPreferences> createPref() async {
    if (sharedPref != null) {
      return sharedPref!;
    }
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!;
  }

  static Future<bool> isLoggedIn() async {
    final sharedPref = await createPref();
    return sharedPref.getBool(Constants.isLoggedIn) ?? false; // Now using a string key
  }

  static Future<void> setIsLoggedIn(bool status) async {
    final sharedPref = await createPref();
    await sharedPref.setBool(Constants.isLoggedIn, status); // Now using a string key
  }
}
