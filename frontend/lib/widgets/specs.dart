import 'dart:convert';

import 'package:flutter/material.dart';

class Specs extends StatefulWidget {
  Map<String, dynamic> specs;
  bool editMode = false;

  Specs({
    super.key,
    required this.specs,
  });

  @override
  _SpecsState createState() => _SpecsState();

  get numberInputState => _SpecsState;
}

class _SpecsState extends State<Specs> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = json.encode(widget.specs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Specs"),
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
          : widget.specs.entries
              .map((entry) => ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                  ))
              .toList(),
    );
  }

  Map<String, dynamic>? check() {
    try {
      return json.decode(_controller.text);
    } catch (e) {
      // TODO: show error msg
      return null;
    }
  }

  void apiRequest() {
    Map<String, dynamic>? result = check();
    if (result != null) {
      widget.specs = result;
      setState(() {
        widget.editMode ^= true;
      });
    } else {
      // TODO: show error msg
    }
  }
}
