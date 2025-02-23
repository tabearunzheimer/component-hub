import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory/screens/about.screen.dart';
import 'package:inventory/screens/inventory.screen.dart';
import 'package:inventory/screens/legal.notice.screen.dart';
import 'package:inventory/screens/location.screen.dart';
import 'package:inventory/screens/part.screen.dart';
import 'package:inventory/screens/privacy.screen.dart';
import 'package:inventory/screens/project.screen.dart';
import 'package:inventory/screens/scanner.screen.dart';
import 'package:inventory/screens/settings.screen.dart';
import 'package:inventory/services/shared.preferences.service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final SharedPreferencesHandler sharedPref = SharedPreferencesHandler();

  MyApp({super.key}) {
    sharedPref.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(64, 122, 222, 1.0),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      home: kIsWeb
          ? DefaultTabController(
              length: 3,
              child: InventoryPage(title: "Inventory"),
            )
          : const ScannerPage(title: "Scanner"),
      initialRoute: kIsWeb ? '/inventory' : '/scanner',
      routes: {
        '/scanner': (context) => const ScannerPage(title: "Scanner"),
        '/about': (context) => AboutPage(),
        '/privacy-policy': (context) => PrivacyPage(title: "Privacy Policy"),
        '/legal-notice': (context) => LegalNoticePage(),
        '/inventory': (context) {
          final category = ModalRoute.of(context)!.settings.arguments
              as String?; // Allow null argument
          return DefaultTabController(
            length: 3,
            child: InventoryPage(title: "Inventory", category: category),
          );
        },
        '/settings': (context) => const SettingsPage(title: "Settings"),
        '/parts-page': (context) {
          final partId = ModalRoute.of(context)!.settings.arguments
              as int?; // Allow null argument
          return PartPage(partId: partId);
        },
        '/locations-page': (context) {
          final locationId = ModalRoute.of(context)!.settings.arguments
              as int?; // Allow null argument
          return LocationPage(locationId: locationId);
        },
        '/project-page': (context) {
          final projectId = ModalRoute.of(context)!.settings.arguments
              as int?; // Allow null argument
          return ProjectPage(projectId: projectId);
        },
      },
    );
  }
}

/*
for InventoryScreen

DefaultTabController(
        length: 3,
        child: const MyHomePage(title: 'Inventory Management'),
      ),
 */