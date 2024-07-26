class LocationModel {
  String name;
  String secondIdentifier;
  String description;

  LocationModel(
      {required this.name,
      required this.secondIdentifier,
      required this.description});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'secondIdentifier': String secondIdentifier,
        'description': String description,
      } =>
        LocationModel(
          name: name,
          secondIdentifier: secondIdentifier,
          description: description,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

List<LocationModel> locations = [
  LocationModel(
      name: "Warehouse A",
      secondIdentifier: "WH-001",
      description: "Main warehouse for storing parts."),
  LocationModel(
      name: "Workshop",
      secondIdentifier: "WS-01",
      description: "Workshop where parts are assembled."),
  LocationModel(
      name: "Retail Store",
      secondIdentifier: "RS-123",
      description: "Store where parts are sold to customers."),
];
