import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/models/part.model.dart';

class Vendor extends StatefulWidget {
  List<VendorPartInfo> vendor;
  bool editMode = false;

  Vendor({
    super.key,
    required this.vendor,
  });

  @override
  _VendorState createState() => _VendorState();

  get numberInputState => _VendorState;
}

class _VendorState extends State<Vendor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Vendor"),
      controlAffinity: ListTileControlAffinity.leading,
      trailing: IconButton(
        onPressed: () => apiRequest(),
        icon: widget.editMode ? const Icon(Icons.save) : const Icon(Icons.edit),
      ),
      children: widget.editMode
          ? [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  controller: _controller,
                ),
              )
            ]
          : widget.vendor
              .map((vendorInfo) => ListTile(
                    title: Text(vendorInfo.name),
                    subtitle: Text(
                        'Last Bought: ${DateFormat('yyyy-MM-dd HH:mm').format(vendorInfo.lastBought)}'),
                    trailing: Text('\$${vendorInfo.price.toStringAsFixed(2)}'),
                  ))
              .toList(),
    );
  }

  void toTextFieldString() {
    _controller.text = "[\n";
    for (VendorPartInfo vendor in widget.vendor) {
      _controller.text += '  ${json.encode(vendor.toJson())},\n';
    }
    _controller.text += "]";
  }

  void toVendorPart() {
    List<VendorPartInfo> vendor = [];
    final jsonString = _controller.text
        .substring(1, _controller.text.length - 1); // Remove brackets
    final vendorList = jsonString.split(',\n');
    for (final vendorString in vendorList) {
      if (vendorString.isEmpty) continue;
      final vendorJson = json.decode(vendorString);
      vendor.add(VendorPartInfo.fromJson(vendorJson));
    }
    widget.vendor = vendor;
  }

  void apiRequest() {
    if (widget.editMode) {
      toVendorPart();
      // send PUT api request
    } else {
      toTextFieldString();
    }

    setState(() {
      widget.editMode ^= true;
    });
  }
}
