import 'package:inventory/screens/settings.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  late final SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    getServerURL();
  }

  String? getServerURL() {
    String? url = prefs.getString('SERVER_URL');
    if (url != null) SettingsPage.fullUrl = url;
    return url;
  }

  void saveServerURL(String value) async {
    await prefs.setString('SERVER_URL', value);
  }
}
