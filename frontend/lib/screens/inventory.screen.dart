import 'package:flutter/material.dart';
import 'package:inventory/models/location.model.dart';
import 'package:inventory/models/part.model.dart';
import 'package:inventory/models/project.model.dart';
import 'package:inventory/widgets/scaffold.dart';
import 'package:intl/intl.dart';

class InventoryPage extends StatefulWidget {
  String? category;

  InventoryPage({super.key, required this.title, this.category});

  final String title;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool sortAscendingProject = true;
  int sortColumnIndexProject = 0;
  int sortColumnIndexStorage = 0;
  bool sortAscendingStorage = true;
  int sortColumnIndexInventory = 0;
  bool sortAscendingInventory = true;

  @override
  void initState() {
    // TODO: add to filter
    // print(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Hub",
      index: 0,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildInventory(),
          buildLocation(),
          buildProject(),
        ],
      ),
      tabBar: const TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.category),
          ),
          Tab(
            icon: Icon(Icons.shelves),
          ),
          Tab(
            icon: Icon(Icons.tips_and_updates),
          ),
        ],
      ),
    );
  }

  Widget buildInventory() {
    return buildDataTable(
      ["Component", "Description", "Category", "Stock"],
      parts.map((part) {
        return [
          part.name,
          part.description,
          part.category,
          part.stock.toString(),
        ];
      }).toList(),
      sortColumnIndex: sortColumnIndexInventory,
      sortAscending: sortAscendingInventory,
      onSort: onSortInventory,
    );
  }

  Widget buildLocation() {
    return buildDataTable(
      ["Location", "Place", "Description"],
      locations.map((location) {
        return [location.name, location.secondIdentifier, location.description];
      }).toList(),
      sortColumnIndex: sortColumnIndexStorage,
      sortAscending: sortAscendingStorage,
      onSort: onSortLocation,
    );
  }

  Widget buildProject() {
    return buildDataTable(
      ["Name", "Description", "Created", "Last Updated"],
      projects.map((project) {
        return [
          project.name,
          project.description,
          DateFormat('yyyy-MM-dd HH:mm').format(project.created),
          DateFormat('yyyy-MM-dd HH:mm').format(project.lastUpdated),
        ];
      }).toList(),
      sortColumnIndex: sortColumnIndexProject,
      sortAscending: sortAscendingProject,
      onSort: onSortProject,
    );
  }

  Widget buildDataTable(List<String> columns, List<List<String>> rows,
      {required int sortColumnIndex,
      required bool sortAscending,
      required void Function(int columnIndex, bool ascending) onSort}) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            const Text("Search and Filter"),
            const Padding(padding: EdgeInsets.only(right: 10)),
            const Expanded(
              child: SearchBar(),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.filter_list),
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        const Divider(
          color: Colors.grey,
        ),
        LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  sortAscending: sortAscending,
                  sortColumnIndex: sortColumnIndex,
                  columns: columns.map((column) {
                    return DataColumn(
                      label: Text(column),
                      onSort: onSort,
                    );
                  }).toList(),
                  rows: rows.map((row) {
                    return DataRow(
                      selected: false,
                      onSelectChanged: (bool? value) {
                        setState(() {});
                      },
                      cells: row.map((entry) {
                        return DataCell(Text(entry), onTap: () {
                          Navigator.pushNamed(context, '/parts-page',
                              arguments: 123);
                        });
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onSortLocation(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      locations.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      locations.sort((a, b) => ascending
          ? a.secondIdentifier.compareTo(b.secondIdentifier)
          : b.secondIdentifier.compareTo(a.secondIdentifier));
    } else if (columnIndex == 2) {
      locations.sort((a, b) => ascending
          ? a.description.compareTo(b.description)
          : b.description.compareTo(a.description));
    }

    setState(() {
      sortColumnIndexStorage = columnIndex;
      sortAscendingStorage = ascending;
    });
  }

  void onSortInventory(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      parts.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      parts.sort((a, b) => ascending
          ? a.description.compareTo(b.description)
          : b.description.compareTo(a.description));
    } else if (columnIndex == 2) {
      parts.sort((a, b) => ascending
          ? a.category.compareTo(b.category)
          : b.category.compareTo(a.category));
    } else if (columnIndex == 3) {
      parts.sort((a, b) =>
          ascending ? a.stock.compareTo(b.stock) : b.stock.compareTo(a.stock));
    }

    setState(() {
      sortColumnIndexInventory = columnIndex;
      sortAscendingInventory = ascending;
    });
  }

  void onSortProject(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      projects.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      projects.sort((a, b) => ascending
          ? a.description.compareTo(b.description)
          : b.description.compareTo(a.description));
    } else if (columnIndex == 2) {
      projects.sort((a, b) => ascending
          ? a.created.compareTo(b.created)
          : b.created.compareTo(a.created));
    } else if (columnIndex == 3) {
      projects.sort((a, b) => ascending
          ? a.lastUpdated.compareTo(b.lastUpdated)
          : b.lastUpdated.compareTo(a.lastUpdated));
    }

    setState(() {
      sortColumnIndexProject = columnIndex;
      sortAscendingProject = ascending;
    });
  }
}
