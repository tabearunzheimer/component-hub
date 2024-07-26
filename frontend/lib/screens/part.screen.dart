import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/services/nfc.service.dart';
import 'package:inventory/widgets/category.dart';
import 'package:inventory/widgets/number.input.dart';
import 'package:inventory/widgets/responsive.device.dart';
import 'package:inventory/widgets/scaffold.dart';

class PartPage extends StatefulWidget {
  final int? partId;

  const PartPage({super.key, required this.partId});

  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {
  String? selectedLocation;
  NumberInput stock = const NumberInput(initialValue: 123);

  @override
  void initState() {
    debugPrint('PartScreen received partId: ${widget.partId}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Component",
      body: ResponsiveDeviceLayout(
        mobile: buildMobile(),
        tablet: buildMobile(),
        desktop: buildDesktop(),
      ),
    );
  }

  Widget buildMobile() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
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
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
            ),
            Container(
              //padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Partname",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      IconButton(
                        // Add label: Add to Project
                        onPressed: () {},
                        icon: const Icon(Icons.assignment_add),
                      ),
                      IconButton(
                        onPressed: () {
                          NFCService nfc = NFCService();
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: nfc.buildWidget(
                                Padding(
                                  padding: const EdgeInsets.all(
                                    10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                          "To write the part info to the Tag enable NFC on your device and hold the device close to the Tag. Press start afterwards."),
                                      IconButton(
                                        onPressed: () => nfc.ndefWrite(),
                                        icon: const Icon(
                                            Icons.wifi_protected_setup),
                                      ),
                                      ValueListenableBuilder<dynamic>(
                                        valueListenable: nfc.result,
                                        builder: (context, value, _) => (value !=
                                                null)
                                            ? Text("$value")
                                            : const CircularProgressIndicator(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        icon: SvgPicture.asset("assets/icons/qr_code_2_add.svg",
                            height: 25,
                            width: 25,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ],
                  ),
                  const Divider(),
                  Wrap(
                    runSpacing: 5,
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("Categories: "),
                      CategoryWidget(title: "Category1"),
                      SizedBox(width: 5),
                      CategoryWidget(title: "Electronics"),
                      SizedBox(width: 5),
                      CategoryWidget(title: "Mechanics"),
                    ],
                  ),
                  const NumberInput(initialValue: 123),
                  Row(
                    children: [
                      Text("Location: "),
                      // Make location clickable
                      GestureDetector(
                        onTap: () {
                          // Handle location selection
                          setState(() {
                            selectedLocation = "yxz";
                          });
                        },
                        child: Text(selectedLocation ?? "yxz"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                    childrenPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    title: Text("Description"),
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                      ),
                    ],
                  ),
                  ExpansionTile(
                    childrenPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    title: Text("Specs"),
                    children: [
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      // Implement logic to receive info as json and build table
                    ],
                  ),
                  ExpansionTile(
                    childrenPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    title: Text("Resources"),
                    children: [
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      // Implement logic to receive info as json and build table
                    ],
                  ),
                  ExpansionTile(
                    childrenPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    title: Text("Vendor Info"),
                    children: [
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      Text('HAHAHA'),
                      // Implement logic to receive info as json and build table
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktop() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("TODO"),
    );
  }

  Widget categoryTag(String category) {
    return GestureDetector(
      onTap: () {
        // Handle category selection
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10.0), // Set border radius
        ),
        child: Text(category),
      ),
    );
  }
}
