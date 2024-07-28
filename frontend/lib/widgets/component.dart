import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory/models/part.model.dart';

class Component extends StatefulWidget {
  List<PartModel> components;
  bool editMode = false;

  Component({
    super.key,
    required this.components,
  });

  @override
  _ComponentState createState() => _ComponentState();

  get numberInputState => _ComponentState;
}

class _ComponentState extends State<Component> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Components"),
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
          : widget.components
              .map((componentInfo) => ListTile(
                    title: Text(componentInfo.name),
                    trailing: Text(componentInfo.stock
                        .toString()), // TODO: update with amount for project
                  ))
              .toList(),
    );
  }

  void toTextFieldString() {
    _controller.text = "[\n";
    for (PartModel component in widget.components) {
      _controller.text += '  ${json.encode(component.toJson())},\n';
    }
    _controller.text += "]";
  }

  void toComponentPart() {
    List<PartModel> components = [];
    final jsonString = _controller.text
        .substring(1, _controller.text.length - 1); // Remove brackets
    final componentList = jsonString.split(',\n');
    for (final componentString in componentList) {
      if (componentString.isEmpty) continue;
      final componentJson = json.decode(componentString);
      components.add(PartModel.fromJson(componentJson));
    }
    widget.components = components;
  }

  void apiRequest() {
    if (widget.editMode) {
      toComponentPart();
      // send PUT api request
    } else {
      toTextFieldString();
    }

    setState(() {
      widget.editMode ^= true;
    });
  }
}
