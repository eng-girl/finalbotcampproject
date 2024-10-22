/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/cart_cubit.dart';
import '../../bloc/state/cart_state.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final user = BlocProvider
        .of<AuthCubit>(context)
        .currentUser;


    // Fetch cart items when screen loads
    cartCubit.fetchCartItems(user!.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('My Cart')),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.error.isNotEmpty) {
              return Center(child: Text(state.error));
            } else if (state.cartItems.isEmpty) {
              return Center(child: Text('سلة التسوق فارغة'));
            } else {
              return Column(
                children: [
                  Expanded(child:
                  ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      final product = item['productId'];
                      final quantity = item['quantity'];

                      return    ListTile(
                        leading: Image.network(product['images'][0]), // Display the first image
                        title: Text(product['name']),
                        subtitle: Text('Price: \$${product['price']} x $quantity'),
                        trailing: Text('Total: \$${product['price'] * quantity}'),
                      );
                    },
                  )
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
*/

