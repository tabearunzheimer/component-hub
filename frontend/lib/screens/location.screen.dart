import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:inventory/models/location.model.dart';
import 'package:inventory/widgets/description.dart';
import 'package:inventory/widgets/name.dart';
import 'package:inventory/widgets/responsive.device.dart';
import 'package:inventory/widgets/scaffold.dart';
import 'package:inventory/widgets/second.identifier.dart';

class LocationPage extends StatefulWidget {
  int? locationId;

  LocationPage({super.key, this.locationId});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationModel location = locations[0];

  @override
  void initState() {
    debugPrint('LocationScreen received locationId: ${widget.locationId}');
    if (widget.locationId != null) {
      location = locations
          .firstWhere((element) => element.locationId == widget.locationId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Location",
      body: ResponsiveDeviceLayout(
        mobile: buildMobile(),
        tablet: buildMobile(),
        desktop: buildDesktop(),
      ),
    );
  }

  buildMobile() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                items: [Image.asset('assets/placeholder/placeholder.png')],
                options: CarouselOptions(
                  aspectRatio: 1,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
            ),
            Name(name: location.name),
            const Divider(),
            Description(text: location.description),
            SecondIdentifier(
              identifiers: [location.secondIdentifier],
            )
          ],
        ),
      ),
    );
  }

  buildDesktop() {
    return Text('TEst');
  }
}
