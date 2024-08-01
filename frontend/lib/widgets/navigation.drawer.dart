import 'package:flutter/material.dart';

class CustomDrawerNavigation {
  late BuildContext _context;
  int _selectedIndex;

  CustomDrawerNavigation(BuildContext ctx, int index)
      : _context = ctx,
        _selectedIndex = index;

  Widget getDrawerNavigation() {
    return Drawer(
        elevation: 1,
        child: ListView(
          children: [
            DrawerHeader(
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Image.asset('assets/logos/logo-nobg.png'),
                  ),
                  const Text(
                    'Component Hub',
                    style: TextStyle(fontFamily: 'Orbitron', fontSize: 20),
                  )
                ],
              ),
            ),
            ListTile(
              trailing: const Icon(Icons.inventory),
              title: const Text("Inventory"),
              iconColor: _selectedIndex == 0 ? Color(0xff0f78d8) : Colors.black,
              textColor: _selectedIndex == 0 ? Color(0xff0f78d8) : Colors.black,
              onTap: () => onTapNavigation(0),
            ),
            ListTile(
              trailing: const Icon(Icons.qr_code_scanner),
              title: const Text("Scanner"),
              iconColor: _selectedIndex == 1 ? Color(0xff0f78d8) : Colors.black,
              textColor: _selectedIndex == 1 ? Color(0xff0f78d8) : Colors.black,
              onTap: () => onTapNavigation(1),
            ),
            ListTile(
              trailing: const Icon(Icons.settings),
              title: const Text("Settings"),
              iconColor: _selectedIndex == 2 ? Color(0xff0f78d8) : Colors.black,
              textColor: _selectedIndex == 2 ? Color(0xff0f78d8) : Colors.black,
              onTap: () => onTapNavigation(2),
            ),
          ],
        ));
  }

  void onTapNavigation(int value) {
    //setState(() {
    if (_selectedIndex == value) {
      debugPrint("Aktueller Screen");
    } else {
      _selectedIndex = value;
      switch (value) {
        case 0:
          Navigator.pushReplacementNamed(_context, '/inventory');
          break;
        case 1:
          Navigator.pushReplacementNamed(_context, '/scanner');
          break;
        case 2:
          Navigator.pushReplacementNamed(_context, '/settings');
          break;
      }
    }
  }
}
