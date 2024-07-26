import 'package:flutter/material.dart';

class ResponsiveOrientationLayout extends StatefulWidget {
  final Widget portrait;
  final Widget landscape;

  const ResponsiveOrientationLayout(
      {super.key, required this.portrait, required this.landscape});

  @override
  _ResponsiveOrientationLayoutState createState() =>
      _ResponsiveOrientationLayoutState();

  get numberInputState => _ResponsiveOrientationLayoutState;
}

class _ResponsiveOrientationLayoutState
    extends State<ResponsiveOrientationLayout> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return widget.portrait;
      } else {
        return widget.landscape;
      }
    });
  }
}
