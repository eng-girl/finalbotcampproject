

import 'package:flutter/cupertino.dart';


class CartState {
  final List<Map<String, dynamic>> cartItems;
  final bool isLoading;
  final String error;

  CartState({this.cartItems = const [], this.isLoading = false, this.error = ''});
}

//
// @immutable
// sealed class CartState {}
//
// class CartInitial extends CartState {}
//
// class CartLoading extends CartState {}
//
// class CartLoaded extends CartState {
//   final List<Map<String, dynamic>> cartItems;
//
//   CartLoaded(this.cartItems);
// }
//
// class CartError extends CartState {
//   final String message;
//
//   CartError(this.message);
// }
