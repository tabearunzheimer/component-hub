import 'package:inventory/models/part.model.dart';

class ProjectModel {
  int projectId;
  String docs;
  String name;
  String description;
  //files
  Map<String, String> urls;
  //images
  List<PartModel> parts;
  DateTime created;
  DateTime lastUpdated;

  ProjectModel({
    required this.docs,
    required this.name,
    required this.description,
    required this.urls,
    required this.parts,
    required this.created,
    required this.lastUpdated,
    required this.projectId,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'docs': String docs,
        'name': String name,
        'description': String description,
        'urls': Map<String, String> urls,
        'parts': List<PartModel> parts,
        'created': DateTime created,
        'lastUpdated': DateTime lastUpdated,
        "projectId": int projectId,
      } =>
        ProjectModel(
            docs: docs,
            name: name,
            description: description,
            urls: urls,
            parts: parts,
            created: created,
            lastUpdated: lastUpdated,
            projectId: projectId),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  static onSearch(List<ProjectModel> list, String value) {
    List<ProjectModel> filtered = [];
    value = value.toLowerCase();
    for (ProjectModel element in list) {
      if (element.description.toLowerCase().contains(value) ||
          element.name.toLowerCase().contains(value)) {
        filtered.add(element);
      }
    }
    return filtered;
  }
}

List<ProjectModel> projects = [
  ProjectModel(
      docs: "https://example.com/project_docs.zip",
      name: "Project Phoenix",
      description: "Development of a new prototype",
      urls: {"website": "https://projectphoenix.com"},
      parts: parts, // Reference the parts list from above
      created: DateTime.now().subtract(Duration(days: 60)),
      lastUpdated: DateTime.now(),
      projectId: 1),
  ProjectModel(
    docs: "",
    name: "Inventory Management System",
    description: "System to track parts and locations",
    urls: {},
    parts: [],
    created: DateTime.now().subtract(Duration(days: 365)),
    lastUpdated: DateTime.now().subtract(Duration(days: 14)),
    projectId: 1,
  ),
];
