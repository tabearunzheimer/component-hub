import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar {
  late BuildContext _context;
  int _selectedIndex;

  CustomBottomNavigationBar(BuildContext ctx, int index)
      : _context = ctx,
        _selectedIndex = index;

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: "Inventory",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: "Scanner",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      onTap: onTapNavigation,
      currentIndex: _selectedIndex,
    );
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
