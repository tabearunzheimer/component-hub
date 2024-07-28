class PartModel {
  String name;
  String category;
  String description;
  String imageUrl;
  int stock;
  List<VendorPartInfo> vendorInfo;
  Map<String, String> urls;
  Map<String, String> specs;
  int location;
  int componentId;
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
    required this.componentId,
    required this.specs,
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
        "componentId": int componentId,
        "specs": Map<String, String> specs,
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
          componentId: componentId,
          specs: specs,
        ),
      _ => throw const FormatException('Failed to load part.'),
    };
  }

  static onSearch(List<PartModel> list, String value) {
    List<PartModel> filtered = [];
    value = value.toLowerCase();
    for (PartModel element in list) {
      if (element.description.toLowerCase().contains(value) ||
          element.name.toLowerCase().contains(value) ||
          element.category.toLowerCase().contains(value)) filtered.add(element);
    }
    return filtered;
  }
}

class VendorPartInfo {
  DateTime lastBought;
  String name;
  double price;
  VendorPartInfo(
      {required this.lastBought, required this.name, required this.price});

  factory VendorPartInfo.fromJson(Map<String, dynamic> json) {
    try {
      // Extract values from the JSON map
      final lastBoughtString = json['lastBought'] as String;
      final name = json['name'] as String;
      final price = json['price'] as double?; // Check for null

      // Validate and parse values
      if (lastBoughtString == null || name == null || price == null) {
        throw FormatException('Missing required fields in vendor info.');
      }

      return VendorPartInfo(
        lastBought: DateTime.parse(lastBoughtString),
        name: name,
        price: price!, // Use non-null assertion after validation
      );
    } on FormatException catch (e) {
      // Handle parsing errors (e.g., invalid date format)
      print('Error parsing vendor info: $e');
      rethrow; // Rethrow the exception for further handling
    } catch (e) {
      // Handle other unexpected errors
      print('Unexpected error parsing vendor info: $e');
      rethrow; // Rethrow the exception for further handling
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'lastBought': lastBought.toIso8601String(),
      'name': name,
      'price': price,
    };
  }
}

List<PartModel> parts = [
  PartModel(
    name: 'Blue Widget',
    category: 'Electronics',
    description: 'A compact blue widget for small spaces.',
    imageUrl: 'https://example.com/blue_widget.jpg',
    stock: 8,
    vendorInfo: [
      VendorPartInfo(
          lastBought: DateTime(2023, 10, 25), name: 'Supplier C', price: 8.99),
      VendorPartInfo(
          lastBought: DateTime(2024, 01, 12), name: 'Supplier D', price: 9.25),
    ],
    urls: {
      'manual': 'https://example.com/blue_widget_manual.pdf',
      'datasheet': 'https://example.com/blue_widget_datasheet.pdf',
    },
    specs: {
      'weight': '150g',
      'dimensions': '8x4x2 cm',
    },
    location: 124,
    componentId: 457,
  ),
  PartModel(
    name: 'Red Widget',
    category: 'Electronics',
    description: 'A versatile red widget for various applications.',
    imageUrl: 'https://example.com/red_widget.jpg',
    stock: 12,
    vendorInfo: [
      VendorPartInfo(
          lastBought: DateTime(2023, 11, 15), name: 'Supplier A', price: 9.99),
      VendorPartInfo(
          lastBought: DateTime(2024, 02, 28), name: 'Supplier B', price: 10.50),
    ],
    urls: {
      'manual': 'https://example.com/manual.pdf',
      'datasheet': 'https://example.com/datasheet.pdf',
    },
    specs: {
      'weight': '200g',
      'dimensions': '10x5x3 cm',
    },
    location: 123,
    componentId: 456,
  )
];
