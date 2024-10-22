import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/order.dart';

class OrderRepository {
  final Dio dio = Dio();

  Future<List<Order>> getOrdersByUserId(String userId) async {
    try {
      final response = await dio.get('${ApiConstants.orders}/store/$userId'); // Update the endpoint accordingly

      // Log the response for debugging
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((order) => Order.fromJson(order)).toList();
        } else {
          print('Unexpected response format: ${response.data}');
        }
      }
    } catch (e) {
      print('Error fetching orders by user ID: $e');
    }
    return [];
  }

  Future<Order> createOrder({
    required String customerId,
    required String storeId,
    required List<Map<String, dynamic>> products,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final response = await dio.post('${ApiConstants.orders}', data: {
        'customer': customerId,
        'store': storeId,
        'products': products,
        'totalAmount': totalAmount,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
      });

      if (response.statusCode == 201) {
        return Order.fromJson(response.data); // Adjust as needed
      } else {
        throw Exception('Failed to create order: ${response.data}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

}