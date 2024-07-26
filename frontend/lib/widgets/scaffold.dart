import 'package:flutter/material.dart';
import 'package:inventory/widgets/app.bar.dart';
import 'package:inventory/widgets/navigation.bottom.dart';
import 'package:inventory/widgets/navigation.drawer.dart';

class CustomScaffold extends StatefulWidget {
  final Widget body;
  final String title;
  final int? index;
  final TabBar? tabBar;

  const CustomScaffold(
      {super.key,
      required this.body,
      required this.title,
      this.index,
      this.tabBar});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();

  get numberInputState => _CustomScaffoldState;
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: CustomAppBar(context, widget.title, widget.tabBar).appBar,
          drawer: (orientation == Orientation.landscape && widget.index != null)
              ? CustomDrawerNavigation(context, widget.index!)
                  .getDrawerNavigation()
              : null,
          body: widget.body,
          bottomNavigationBar:
              (orientation == Orientation.portrait && widget.index != null)
                  ? CustomBottomNavigationBar(context, widget.index!)
                      .getBottomNavigationBar()
                  : null,
        );
      },
    );
  }
}
