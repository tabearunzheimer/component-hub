import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  final int initialValue;

  const NumberInput({super.key, required this.initialValue});

  @override
  _NumberInputState createState() => _NumberInputState();

  get numberInputState => _NumberInputState;
}

class _NumberInputState extends State<NumberInput> {
  int _value = 0;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void increment() {
    setState(() {
      _value++;
      onChanged(_value);
    });
  }

  void decrement() {
    if (_value > 0) {
      setState(() {
        _value--;
        onChanged(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Stock: ",
        ),
        _editMode ? editMode() : normalMode()
      ],
    );
  }

  onChanged(int value) {
    setState(() {
      _value = value;
    });
  }

  updateMode() {
    setState(() {
      _editMode ^= true;
    });
  }

  Widget normalMode() {
    return Row(
      children: [
        Text(_value.toString()),
        IconButton(
          onPressed: updateMode,
          icon: const Icon(
            Icons.edit,
          ),
        ),
      ],
    );
  }

  Widget editMode() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: TextField(
            controller: TextEditingController(text: _value.toString()),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              try {
                final parsedValue = int.parse(newValue);
                if (parsedValue >= 0) {
                  setState(() {
                    _value = parsedValue;
                    onChanged(_value); // Update parent on change
                  });
                }
              } catch (e) {
                // Handle invalid input (e.g., non-numeric characters)
              }
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: increment,
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: decrement,
        ),
        IconButton(
          onPressed: updateMode,
          icon: const Icon(Icons.save),
        ),
      ],
    );
  }
}
