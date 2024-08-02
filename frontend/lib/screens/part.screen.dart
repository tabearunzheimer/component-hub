import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/models/part.model.dart';
import 'package:inventory/services/nfc.service.dart';
import 'package:inventory/widgets/category.dart';
import 'package:inventory/widgets/description.dart';
import 'package:inventory/widgets/number.input.dart';
import 'package:inventory/widgets/resources.dart';
import 'package:inventory/widgets/responsive.device.dart';
import 'package:inventory/widgets/scaffold.dart';
import 'package:inventory/widgets/specs.dart';
import 'package:inventory/widgets/vendor.dart';

class PartPage extends StatefulWidget {
  final int? partId;

  const PartPage({super.key, required this.partId});

  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {
  String? selectedLocation;
  NumberInput stock = const NumberInput(initialValue: 123);
  PartModel part = parts[1];

  @override
  void initState() {
    debugPrint('PartScreen received partId: ${widget.partId}');
    if (widget.partId != null) {
      part =
          parts.firstWhere((element) => element.componentId == widget.partId);
    }
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
                        part.name,
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
                                        onPressed: () => nfc.ndefWrite(
                                            part.name, part.componentId),
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
                    children: part.category.split(';').map((category) {
                      return CategoryWidget(
                        title: category,
                      );
                    }).toList(),
                  ),
                  const NumberInput(initialValue: 123),
                  GestureDetector(
                    onTap: () {
                      // Handle location selection
                      setState(() {
                        Navigator.pushNamed(context, '/locations-page',
                            arguments: part.location);
                      });
                    },
                    child: Row(
                      children: [
                        Text('Location: ${part.location.toString()}'),
                        Text(part.location.toString() ??
                            "yxz"), // replace with name
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Description(text: part.description),
                  Specs(specs: part.specs),
                  Resources(resources: part.urls),
                  Vendor(vendor: part.vendorInfo),
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
