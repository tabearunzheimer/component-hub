import 'dart:convert';

import 'package:flutter/material.dart';

class SecondIdentifier extends StatefulWidget {
  List<String> identifiers;
  bool editMode;

  SecondIdentifier({
    super.key,
    required this.identifiers,
    this.editMode = false,
  });

  @override
  _SecondIdentifierState createState() => _SecondIdentifierState();

  get numberInputState => _SecondIdentifierState;
}

class _SecondIdentifierState extends State<SecondIdentifier> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = json.encode(widget.identifiers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Sub Locations"),
      expandedAlignment: Alignment.topLeft,
      controlAffinity: ListTileControlAffinity.leading,
      trailing: IconButton(
        onPressed: () {
          setState(() {
            if (widget.editMode) {
              apiRequest();
            }
            widget.editMode ^= true;
          });
        },
        icon: widget.editMode ? const Icon(Icons.save) : const Icon(Icons.edit),
      ),
      children: [
        widget.editMode
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  controller: _controller,
                ),
              )
            : Wrap(
                children: widget.identifiers
                    .map((e) => ListTile(
                          title: Text(e),
                        ))
                    .toList(),
              ),
      ],
    );
  }

  void apiRequest() {
    widget.identifiers = json.decode(_controller.text).cast<String>().toList();
  }
}
