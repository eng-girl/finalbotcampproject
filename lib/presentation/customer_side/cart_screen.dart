
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/cart_cubit.dart';
import '../../bloc/state/cart_state.dart';
import '../../core/theme/app_colors.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cartCubit = context.read<CartCubit>();
    final user = BlocProvider.of<AuthCubit>(context).currentUser;
    const double appFee = 1.00; // Example static fee

    cartCubit.fetchCartItems(user!.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('السلة'),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error.isNotEmpty) {
              return Center(child: Text(state.error));
            } else if (state.cartItems.isEmpty) {
              return const Center(child: Text('سلة التسوق فارغة'));
            } else {
              // Calculate total quantity and total cost
              int totalQuantity = 0;
              double totalCost = 0.0;

              for (var item in state.cartItems) {
                int quantity = item['quantity'] is int
                    ? item['quantity']
                    : int.tryParse(item['quantity'].toString()) ?? 1;
                double price = (item['productId']['price'] ?? 0.0) * quantity;

                totalQuantity += quantity;
                totalCost += price;
              }

              totalCost += appFee;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = state.cartItems[index];
                        final product = item['productId'];

                        // Ensure quantity is treated as an int
                        int quantity;
                        if (item['quantity'] is int) {
                          quantity = item['quantity'];
                        } else if (item['quantity'] is String) {
                          quantity = int.tryParse(item['quantity']) ?? 1;
                        } else {
                          quantity = 1; // Default value
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.01,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02),
                          child: Dismissible(
                            key: Key(product['_id']),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: const Color(0x4ff30000),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              child:
                                  const Icon(Icons.delete_forever, color: Colors.red),
                            ),
                            onDismissed: (direction) {
                              cartCubit.removeFromCart(user.id, product['_id']);
                              cartCubit.fetchCartItems(user.id);
                            },
                            child: Card(
                              elevation: 0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.cardsBackgroundDark
                                  : AppColors.white,
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.network(
                                      product['thumbnail'],
                                      width: screenWidth * 0.2,
                                      height: screenHeight * 0.1,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: screenWidth * 0.2,
                                          height: screenHeight * 0.1,
                                          color: Colors.grey,
                                          child: const Center(
                                              child:
                                                  Text('الصورة غير موجودة')),
                                        );
                                      },
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ??
                                                'Unknown Product',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.036,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          Text(
                                            '${(product['price'] ?? 0.0).toStringAsFixed(2)} د.ل',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          child: Ink(
                                            height: screenHeight * 0.035,
                                            width: screenWidth * 0.07,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.02)),
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? AppColors.darkBackground
                                                  : AppColors.lightBackground,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColors.darkText
                                                    : AppColors.lightText,
                                                size: screenWidth * 0.03,
                                              ),
                                              onPressed: () {
                                                if (quantity > 1) {
                                                  cartCubit
                                                      .updateCartItemQuantity(
                                                    user.id,
                                                    product['_id'],
                                                    quantity - 1,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          child: Text('$quantity'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              screenWidth * 0.02),
                                          child: Ink(
                                            height: screenHeight * 0.035,
                                            width: screenWidth * 0.07,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.02)),
                                              color: AppColors.primary,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? AppColors.lightText
                                                    : AppColors.darkText,
                                                size: screenWidth * 0.03,
                                              ),
                                              onPressed: () {
                                                cartCubit
                                                    .updateCartItemQuantity(
                                                  user.id,
                                                  product['_id'],
                                                  quantity + 1,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkBackground
                            : AppColors.cardsBackgroundLight,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.grey,
                            offset: const Offset(1, 2),
                            blurRadius: 4,
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.01,
                          right: screenWidth * 0.04,
                          left: screenWidth * 0.04,
                          bottom: screenHeight * 0.02),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الملخص',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('العناصر ',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                              Text('$totalQuantity'),
                            ],
                          ),
                          const Divider(
                            thickness: 0.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('سعر المنتجات',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                              Text(
                                  '${(totalCost - appFee).toStringAsFixed(2)} د.ل',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('عمولة التطبيق',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                              Text('${appFee.toStringAsFixed(2)} د.ل',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04)),
                            ],
                          ),
                          const Divider(thickness: 1),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(TextSpan(
                                    text: 'السعر الإجمالي ',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: '(غير شامل التوصيل)',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.normal))
                                    ])),
                                Text('${totalCost.toStringAsFixed(2)} د.ل',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: screenHeight*0.02),

                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                                itemsQuantity: totalQuantity,
                                                totalCost: totalCost,
                                                appFee: appFee,
                                              cartItems: state.cartItems

                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015,
                                      horizontal: screenWidth * 0.04),
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.02),
                                  ),
                                ),
                                child: Text('تأكيد الطلب',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
