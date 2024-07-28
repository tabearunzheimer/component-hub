import 'dart:convert';

import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  Map<String, String> resources;
  bool editMode = false;

  Resources({
    super.key,
    required this.resources,
  });

  @override
  _ResourcesState createState() => _ResourcesState();

  get numberInputState => _ResourcesState;
}

class _ResourcesState extends State<Resources> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = json.encode(widget.resources);
    print('init ${_controller.text}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Resources"),
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
          : widget.resources.entries
              .map((entry) => ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                  ))
              .toList(),
    );
  }

  Map<String, String>? check() {
    try {
      return Map.castFrom(json.decode(_controller.text.toString()));
    } catch (e) {
      // TODO: show error msg
      return null;
    }
  }

  void apiRequest() {
    if (widget.editMode) {
      Map<String, String>? result = check();
      print(result);
      print(widget.resources);
      if (result != null) {
        widget.resources = result;
      } else {
        // TODO: show error msg
        return;
      }
    }

    setState(() {
      widget.editMode ^= true;
    });
  }
}
