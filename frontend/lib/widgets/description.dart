import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  String text;
  bool editMode;

  Description({
    super.key,
    required this.text,
    this.editMode = false,
  });

  @override
  _DescriptionState createState() => _DescriptionState();

  get numberInputState => _DescriptionState;
}

class _DescriptionState extends State<Description> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      title: const Text("Description"),
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
            : Text(
                widget.text,
              ),
      ],
    );
  }

  void apiRequest() {
    widget.text = _controller.text;
  }
}
