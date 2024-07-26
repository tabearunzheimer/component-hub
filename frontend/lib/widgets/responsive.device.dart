import 'package:flutter/material.dart';

class ResponsiveDeviceLayout extends StatefulWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveDeviceLayout(
      {super.key,
      required this.mobile,
      required this.tablet,
      required this.desktop});

  @override
  _ResponsiveDeviceLayoutState createState() => _ResponsiveDeviceLayoutState();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  get numberInputState => _ResponsiveDeviceLayoutState;
}

class _ResponsiveDeviceLayoutState extends State<ResponsiveDeviceLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1100) {
        return widget.desktop;
      } else if (constraints.maxWidth >= 650) {
        return widget.tablet;
      } else {
        return widget.mobile;
      }
    });
  }
}
