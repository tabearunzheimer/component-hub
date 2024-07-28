import 'package:flutter/material.dart';

class Name extends StatefulWidget {
  String name;
  bool editMode;

  Name({
    super.key,
    required this.name,
    this.editMode = false,
  });

  @override
  _NameState createState() => _NameState();

  get numberInputState => _NameState;
}

class _NameState extends State<Name> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.editMode
            ? [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    controller: _controller,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.editMode) {
                        apiRequest();
                      }
                      widget.editMode ^= true;
                    });
                  },
                  icon: const Icon(Icons.save),
                )
              ]
            : [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.editMode) {
                        apiRequest();
                      }
                      widget.editMode ^= true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
      ),
    );
  }

  void apiRequest() {
    widget.name = _controller.text;
  }
}
