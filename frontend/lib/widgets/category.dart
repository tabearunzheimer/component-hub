import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String title;
  bool editMode = false;

  CategoryWidget({super.key, required this.title, this.editMode = false});

  @override
  Widget build(BuildContext context) {
    return editMode ? buildEditMode() : buildNormalMode(context);
  }

  static showEditMode(BuildContext context, List<String> categories) {
    String? selectedValue;
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose a Category"),
              DropdownButton<String>(
                value: selectedValue,
                items: categories.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? value) => {
                  //TODO
                },
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          );
        });
  }

  Widget buildEditMode() {
    return Container();
  }

  Widget buildNormalMode(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10.0), // Set border radius
        ),
        child: Text(title),
      ),
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed('/inventory', arguments: title);
      },
    );
  }
}
