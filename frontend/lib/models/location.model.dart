class LocationModel {
  String name;
  String secondIdentifier;
  String description;
  int locationId;

  LocationModel(
      {required this.name,
      required this.secondIdentifier,
      required this.description,
      required this.locationId});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'secondIdentifier': String secondIdentifier,
        'description': String description,
        'locationId': int locationId
      } =>
        LocationModel(
            name: name,
            secondIdentifier: secondIdentifier,
            description: description,
            locationId: locationId),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  static onSearch(List<LocationModel> list, String value) {
    List<LocationModel> filtered = [];
    value = value.toLowerCase();
    for (LocationModel element in list) {
      if (element.description.toLowerCase().contains(value) ||
          element.name.toLowerCase().contains(value)) {
        filtered.add(element);
      }
    }
    return filtered;
  }
}

List<LocationModel> locations = [
  LocationModel(
      locationId: 1,
      name: "Warehouse A",
      secondIdentifier: "WH-001",
      description: "Main warehouse for storing parts."),
  LocationModel(
      locationId: 2,
      name: "Workshop",
      secondIdentifier: "WS-01",
      description: "Workshop where parts are assembled."),
  LocationModel(
      locationId: 3,
      name: "Retail Store",
      secondIdentifier: "RS-123",
      description: "Store where parts are sold to customers."),
];
