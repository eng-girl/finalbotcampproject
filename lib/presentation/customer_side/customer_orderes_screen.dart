// import 'package:craft_it/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/cubit/auth_cubit.dart';
// import '../../bloc/cubit/order_cubit.dart';
// import '../../bloc/state/order_state.dart';
// import '../../data/models/order.dart';
// import '../../data/repo/order_repo.dart';
//
// class CustomerOrders extends StatelessWidget {
//
//   const CustomerOrders({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = BlocProvider.of<AuthCubit>(context).currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Orders'),
//       ),
//       body: BlocProvider(
//         create: (context) => OrderCubit(
//           RepositoryProvider.of<OrderRepository>(context),
//         )..fetchOrdersByUserId(user!.id), // Automatically fetch orders when screen loads
//         child: BlocBuilder<OrderCubit, OrderState>(
//           builder: (context, state) {
//             if (state is OrderLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColors.primary,),
//               );
//             } else if (state is OrderLoaded) {
//               final orders = state.orderList;
//               return ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   return ListTile(
//                     title: Text('Order ID: ${order.id}'),
//                     subtitle: Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
//                     onTap: () {
//                       // You can navigate to order details page or show more info
//                     },
//                   );
//                 },
//               );
//             } else if (state is OrderError) {
//               return Center(
//                 child: Text(state.message),
//               );
//             } else {
//               return const Center(
//                 child: Text('No orders found.'),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Sample order data for demonstration
    final sampleOrders = [
      {
        "id": "24083161",
        "date": "08-08-2024",
        "status": "تم الاستلام",
      },
      {
        "id": "24083162",
        "date": "10-09-2024",
        "status": "قيد التجهيز",
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلباتي'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to home screen
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >=1);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: sampleOrders.length,
          itemBuilder: (context, index) {
            final order = sampleOrders[index];

            return Card(
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01,
                horizontal: screenWidth * 0.04,
              ),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رقم الطلب: ${order["id"]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04, // Adjusted font size
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'التاريخ: ${order["date"]}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035, // Adjusted font size
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${order["status"]}',
                    style: TextStyle(
                      color: order["status"] == "تم الاستلام"
                          ? Colors.green
                          : Colors.orange,
                      fontSize: screenWidth * 0.035, // Adjusted font size
                    ),
                  ),
                  trailing: SizedBox(
                    width: screenWidth * 0.2, // Responsive width for button
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        // Action for details
                      },
                      child: Text(
                        'تفاصيل',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.03, // Adjusted font size
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
