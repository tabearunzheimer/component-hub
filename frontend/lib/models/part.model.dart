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
