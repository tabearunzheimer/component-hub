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
  int sortColumnIndexProject = 0;
  int sortColumnIndexStorage = 0;
  int sortColumnIndexInventory = 0;
  bool sortAscendingStorage = true;
  bool sortAscendingInventory = true;
  bool sortAscendingProject = true;
  final TextEditingController _controller = TextEditingController();
  List<PartModel> partList = parts.toList();
  List<ProjectModel> projectList = projects.toList();
  List<LocationModel> locationList = locations.toList();

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
      partList.map((part) {
        return [
          part.name,
          part.description,
          part.category,
          part.stock.toString(),
          part.componentId.toString(),
        ];
      }).toList(),
      sortColumnIndex: sortColumnIndexInventory,
      sortAscending: sortAscendingInventory,
      onSort: onSortInventory,
      onTap: onTapComponent,
    );
  }

  Widget buildLocation() {
    return buildDataTable(
      ["Location", "Place", "Description"],
      locationList.map((location) {
        return [
          location.name,
          location.secondIdentifier,
          location.description,
          location.locationId.toString()
        ];
      }).toList(),
      sortColumnIndex: sortColumnIndexStorage,
      sortAscending: sortAscendingStorage,
      onSort: onSortLocation,
      onTap: onTapLocation,
    );
  }

  Widget buildProject() {
    return buildDataTable(
      ["Name", "Description", "Created", "Last Updated"],
      projectList.map((project) {
        return [
          project.name,
          project.description,
          DateFormat('yyyy-MM-dd HH:mm').format(project.created),
          DateFormat('yyyy-MM-dd HH:mm').format(project.lastUpdated),
          project.projectId.toString()
        ];
      }).toList(),
      sortColumnIndex: sortColumnIndexProject,
      sortAscending: sortAscendingProject,
      onSort: onSortProject,
      onTap: onTapProject,
    );
  }

  void onTapProject(int id) {
    Navigator.pushNamed(context, '/project-page', arguments: id);
  }

  void onTapLocation(int id) {
    Navigator.pushNamed(context, '/locations-page', arguments: id);
  }

  void onTapComponent(int id) {
    Navigator.pushNamed(context, '/parts-page', arguments: id);
  }

  Widget buildDataTable(
    List<String> columns,
    List<List<String>> rows, {
    required int sortColumnIndex,
    required bool sortAscending,
    required void Function(int columnIndex, bool ascending) onSort,
    required void Function(int id) onTap,
  }) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(padding: EdgeInsets.only(right: 10)),
            Expanded(
              child: SearchBar(
                controller: _controller,
                onChanged: (value) {
                  int tabIndex = DefaultTabController.of(context)!.index;
                  if (value.length >= 3) {
                    onSearch(value, tabIndex);
                  } else {
                    setState(() {
                      switch (tabIndex) {
                        case 0:
                          partList = parts;
                          break;
                        case 1:
                          locationList = locations;
                          break;
                        case 2:
                          projectList = projects;
                          break;
                        default:
                      }
                      partList = parts;
                    });
                  }
                },
              ),
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
                    int tabIndex = DefaultTabController.of(context)!.index;
                    int length;
                    if (tabIndex == 0) {
                      length = 4;
                    } else if (tabIndex == 1) {
                      length = 3;
                    } else {
                      length = 4;
                    }
                    final lastValue = row.last;
                    if (row.length > length) row.removeLast();
                    return DataRow(
                      selected: false,
                      onSelectChanged: (bool? value) {
                        setState(() {});
                      },
                      cells: row.map((entry) {
                        return DataCell(
                          Text(entry),
                          onTap: () => onTap(int.parse(lastValue)),
                        );
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
      locationList.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      locationList.sort((a, b) => ascending
          ? a.secondIdentifier.compareTo(b.secondIdentifier)
          : b.secondIdentifier.compareTo(a.secondIdentifier));
    } else if (columnIndex == 2) {
      locationList.sort((a, b) => ascending
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
      partList.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      partList.sort((a, b) => ascending
          ? a.description.compareTo(b.description)
          : b.description.compareTo(a.description));
    } else if (columnIndex == 2) {
      partList.sort((a, b) => ascending
          ? a.category.compareTo(b.category)
          : b.category.compareTo(a.category));
    } else if (columnIndex == 3) {
      partList.sort((a, b) =>
          ascending ? a.stock.compareTo(b.stock) : b.stock.compareTo(a.stock));
    }

    setState(() {
      sortColumnIndexInventory = columnIndex;
      sortAscendingInventory = ascending;
    });
  }

  void onSearch(String value, int tabViewIndex) {
    setState(() {
      switch (tabViewIndex) {
        case 0:
          partList = PartModel.onSearch(parts, value);
          break;
        case 1:
          locationList = LocationModel.onSearch(locations, value);
          break;
        case 2:
          projectList = ProjectModel.onSearch(projects, value);
          break;
        default:
      }
    });
  }

  void onSortProject(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      projectList.sort((a, b) =>
          ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else if (columnIndex == 1) {
      projectList.sort((a, b) => ascending
          ? a.description.compareTo(b.description)
          : b.description.compareTo(a.description));
    } else if (columnIndex == 2) {
      projectList.sort((a, b) => ascending
          ? a.created.compareTo(b.created)
          : b.created.compareTo(a.created));
    } else if (columnIndex == 3) {
      projectList.sort((a, b) => ascending
          ? a.lastUpdated.compareTo(b.lastUpdated)
          : b.lastUpdated.compareTo(a.lastUpdated));
    }

    setState(() {
      sortColumnIndexProject = columnIndex;
      sortAscendingProject = ascending;
    });
  }
}
