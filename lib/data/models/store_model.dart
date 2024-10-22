
import 'package:finalproject1/data/models/product_model.dart';

class Store {
  final String image;
  final String name;
  final List<Product>? products; // Now it's a List<Product>
  final int totalOrders;
  final String bio;
  final String contactInfo;

  Store({
    required this.name,
    required this.image,
    this.products,
    required this.totalOrders,
    required this.bio,
    required this.contactInfo,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      image: json['image'],
      name: json['name'],
      products: (json['products'] as List<dynamic>?)
          ?.map((productJson) => Product.fromJson(productJson))
          .toList(),
      totalOrders: json['totalOrders'] ?? 0,
      bio: json['bio'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
    );
  }
}
