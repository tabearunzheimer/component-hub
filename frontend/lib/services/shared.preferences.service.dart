import 'package:inventory/screens/settings.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  SharedPreferences? prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    getServerURL();
  }

  Future<String?> getServerURL() async {
    if (prefs == null) await init();
    String? url = prefs!.getString('SERVER_URL');

    print('value $url');
    print('prefs $prefs');
    if (url != null) SettingsPage.fullUrl = url;
    return url;
  }

  void saveServerURL(String value) async {
    if (prefs == null) await init();
    await prefs!.setString('SERVER_URL', value);
  }
}
