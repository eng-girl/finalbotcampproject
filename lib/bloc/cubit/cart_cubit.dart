import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../state/cart_state.dart';

// i know its not the proper way but it works it ygly but works

class CartCubit extends Cubit<CartState> {
  final Dio dio;

  CartCubit(this.dio) : super(CartState());

  Future<void> addToCart(String userId, String productId, int quantity) async {
    try {
      final response = await dio.post(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems(userId); // Fetch updated cart items after adding
      } else {
        print('Failed to add product to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> fetchCartItems(String userId) async {
    emit(CartState(
        isLoading: true,
        cartItems:
            state.cartItems)); // Preserve the previous state while loading

    try {
      final response = await dio.get('${ApiConstants.customersCart}$userId');
      final List<Map<String, dynamic>> cartItems =
          List<Map<String, dynamic>>.from(response.data['cart']);

      emit(CartState(cartItems: cartItems)); // Update with fetched cart data
    } catch (e) {
      print('Error fetching cart items: $e');
      emit(CartState(
          error: 'Failed to fetch cart items', cartItems: state.cartItems));
    }
  }

  Future<void> updateCartItemQuantity(
      String userId, String productId, int quantity) async {
    try {
      final response = await dio.put(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems(
            userId); // Fetch updated cart items after updating quantity
      } else {
        print('Failed to update cart item quantity');
      }
    } catch (e) {
      print('Error updating cart item quantity: $e');
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      final response = await dio.delete(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems(userId); // Fetch updated cart items after removal
      } else {
        print('Failed to remove product from cart');
      }
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }
}

/* import 'package:bloc/bloc.dart';
import 'package:craft_it/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../state/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final Dio dio;

  CartCubit(this.dio) : super(CartInitial());

  Future<void> addToCart(String userId, String productId, int quantity) async {
    try {
      emit(CartLoading());
      final response = await dio.post(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems(userId); // Fetch updated cart items after adding
      } else {
        emit(CartError('Failed to add product to cart'));
      }
    } catch (e) {
      emit(CartError('Error adding to cart: $e'));
    }
  }

  Future<void> fetchCartItems(String userId) async {
    emit(CartLoading());

    try {
      final response = await dio.get('${ApiConstants.customersCart}$userId');
      final List<Map<String, dynamic>> cartItems =
          List<Map<String, dynamic>>.from(response.data['cart']);

      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to fetch cart items: $e'));
    }
  }

  Future<void> updateCartItemQuantity(
      String userId, String productId, int quantity) async {
    try {
      emit(CartLoading());
      final response = await dio.put(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        print('Update Response: ${response.data}');

        // Ensure you're accessing the correct part of the response
        final cartData = response.data['data']; // Get the 'data' object
        if (cartData != null && cartData['cart'] is List) {
          final List<Map<String, dynamic>> updatedCartItems =
              List<Map<String, dynamic>>.from(cartData['cart']);
          emit(CartLoaded(updatedCartItems)); // Emit the new cart items
        } else {
          emit(CartError('Invalid response structure: ${response.data}'));
        }
      } else {
        emit(CartError('Failed to update cart item quantity'));
      }
    } catch (e) {
      emit(CartError('Error updating cart item quantity: $e'));
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      emit(CartLoading());
      final response = await dio.delete(
        '${ApiConstants.customersCart}$userId',
        data: {
          'productId': productId,
        },
      );

      if (response.statusCode == 200) {
        print('Remove Response: ${response.data}');

        // Ensure you're accessing the correct part of the response
        final cartData = response.data['data']; // Get the 'data' object
        if (cartData != null && cartData['cart'] is List) {
          final List<Map<String, dynamic>> updatedCartItems =
              List<Map<String, dynamic>>.from(cartData['cart']);
          emit(CartLoaded(updatedCartItems)); // Emit the new cart items
        } else {
          emit(CartError('Invalid response structure: ${response.data}'));
        }
      } else {
        emit(CartError('Failed to remove product from cart'));
      }
    } catch (e) {
      emit(CartError('Error removing product from cart: $e'));
    }
  }
}
*/