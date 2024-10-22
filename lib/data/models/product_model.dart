class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String material;
  final String category;
  final String? subcategory;
  final List<String> colors;
  final String storeOwner;
  final String timeToBeCreated;
  final List<String> images;
  final String thumbnail;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.material,
    required this.category,
    this.subcategory,
    required this.colors,
    required this.storeOwner,
    required this.timeToBeCreated,
    required this.images,
    required this.thumbnail,
    this.stock = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      material: json['material'],
      category: json['category'],
      subcategory: json['subcategory'],
      colors: List<String>.from(json['colors'] ?? []),
      storeOwner: json['storeOwner'],
      timeToBeCreated: json['timeToBeCreated'],
      images: List<String>.from(json['images'] ?? []),
      thumbnail: json['thumbnail'],
      stock: json['stock'] ?? 0,
    );
  }
}
