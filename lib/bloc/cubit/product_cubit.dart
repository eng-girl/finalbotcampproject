import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/product_model.dart';
import '../state/product_state.dart';


class ProductCubit extends Cubit<ProductState> {
  final Dio dio;

  ProductCubit(this.dio) : super(ProductInitial());
  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final response = await dio.get(ApiConstants.allProducts);

      // Log the entire response data to inspect it
      print("Response: ${response.data}"); // Log the raw response data

      if (response.statusCode == 200) {
        // Ensure 'data' is present and 'products' is a List
        if (response.data['data'] != null && response.data['data']['products'] != null) {
          List<Product> products = (response.data['data']['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          // Log the fetched product thumbnails
          print("Fetched products: ${products.map((p) => p.thumbnail).toList()}");
          emit(ProductLoaded(products));
        } else {
          emit(ProductError('Product list is null in response.'));
        }
      } else {
        emit(ProductError('Failed to load products: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    }
  }
Future<void> fetchProductsByCategory(String category) async {
    try {
      emit(ProductLoading());
      final response = await dio.get('${ApiConstants.allProducts}$category');

      // Log the entire response data to inspect it
      print("Response: ${response.data}"); // Log the raw response data

      if (response.statusCode == 200) {
        // Ensure 'data' is present and 'products' is a List
        if (response.data['data'] != null && response.data['data']['products'] != null) {
          List<Product> products = (response.data['data']['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          // Log the fetched product thumbnails
          print("Fetched products: ${products.map((p) => p.thumbnail).toList()}");
          emit(ProductLoaded(products));
        } else {
          emit(ProductError('Product list is null in response.'));
        }
      } else {
        emit(ProductError('Failed to load products: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    }
  }

}