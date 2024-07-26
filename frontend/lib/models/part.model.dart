class PartModel {
  String name;
  String category;
  String description;
  String imageUrl;
  int stock;
  List<VendorPartInfo> vendorInfo;
  Map<String, String> urls;
  int location;
  int id;
  // history
  PartModel({
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.vendorInfo,
    required this.urls,
    required this.location,
    required this.id,
  });

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "name": String name,
        "category": String category,
        "description": String description,
        "imageUrl": String imageUrl,
        "stock": int stock,
        "vendorInfo": List<VendorPartInfo> vendorInfo,
        "urls": Map<String, String> urls,
        "location": int location,
        "id": int id,
      } =>
        PartModel(
          name: name,
          category: category,
          description: description,
          imageUrl: imageUrl,
          stock: stock,
          vendorInfo: vendorInfo,
          urls: urls,
          location: location,
          id: id,
        ),
      _ => throw const FormatException('Failed to load part.'),
    };
  }
}

class VendorPartInfo {
  DateTime lastBought;
  String name;
  double price;
  VendorPartInfo(
      {required this.lastBought, required this.name, required this.price});

  factory VendorPartInfo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'lastBought': DateTime lastBought,
        'name': String name,
        'price': double price,
      } =>
        VendorPartInfo(
          lastBought: lastBought,
          name: name,
          price: price,
        ),
      _ => throw const FormatException('Failed to load vendor info.'),
    };
  }
}

List<PartModel> parts = [
  PartModel(
    name: "ABC-123",
    category: "Electronics",
    description: "Small electronic component",
    imageUrl: "https://example.com/part_image.jpg",
    stock: 100,
    vendorInfo: [
      VendorPartInfo(
          lastBought: DateTime.now().subtract(Duration(days: 30)),
          name: "Supplier X",
          price: 10.50),
    ],
    urls: {"datasheet": "https://example.com/part_datasheet.pdf"},
    location: 1, // Reference to a location from locations list
    id: 1,
  ),
  PartModel(
    name: "DEF-456",
    category: "Mechanics",
    description: "Metal bracket",
    imageUrl: "https://example.com/bracket_image.jpg",
    stock: 5,
    vendorInfo: [
      VendorPartInfo(
          lastBought: DateTime.now().subtract(Duration(days: 7)),
          name: "Manufacturer Y",
          price: 22.00),
    ],
    urls: {},
    location: 2, // Reference to a location from locations list
    id: 2,
  ),
];
