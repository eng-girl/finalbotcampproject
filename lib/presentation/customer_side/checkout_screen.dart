import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/order_cubit.dart';
import '../../core/theme/app_colors.dart';
import 'customer_orderes_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final int itemsQuantity;
  final double totalCost;
  final double appFee;
  final List<dynamic> cartItems;
  const CheckoutScreen({
    Key? key,
    required this.itemsQuantity,
    required this.totalCost,
    required this.appFee,
    required this.cartItems, // Add this line

  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final double delivery = 10;
  String _selectedPaymentMethod = 'نقداً';

  final TextEditingController _phoneController =
  TextEditingController(text: '0923456789');

  @override
  Widget build(BuildContext context) {
    final orderCubit = context.read<OrderCubit>();
    String customerId = '66fe79dd77bf08be9b85fcfa';
    String storeId = '66fe79c377bf08be9b85fcf5';
    print("Cart Items: ${widget.cartItems}");

    List<Map<String, dynamic>> products = widget.cartItems.map((item) {
      return {
        'productId': item['id'], // Replace with actual field from your cartItems
        'quantity': item['quantity'], // Adjust as per your cartItems structure
        'image': item['images'], // Adjust as per your cartItems structure
      };
    }).toList();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تأكيد الطلب'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.04),
                child: Text('عنوان التوصيل',
                    style:
                    TextStyle(fontSize: screenWidth* 0.045, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding:  EdgeInsets.all(screenWidth* 0.04),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardsBackgroundDark
                        : AppColors.cardsBackgroundLight,
                    borderRadius: BorderRadius.circular(screenWidth* 0.02), // Consistent border radius
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.transparent, // Transparent background for container decoration
                      ),
                    ),
                    onPressed: () {},
                    child:  Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight*0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('المنزل', style: TextStyle(fontSize: screenWidth* 0.04)),
                              Text('2972 Westheimer Rd. Santa Ana.',
                                  style: TextStyle(
                                      fontSize: screenWidth* 0.036, color: Colors.grey)),
                            ],
                          ),
                          Icon(Icons.arrow_back_ios_new_rounded)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Text('رقم الهاتف',
                    style:
                    TextStyle(fontSize: screenWidth* 0.045, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(  vertical: screenHeight * 0.012,  // 1.2% of screen height
                    horizontal: screenWidth * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardsBackgroundDark
                        : AppColors.cardsBackgroundLight,
                    borderRadius: BorderRadius.circular(screenWidth* 0.02), // Consistent border radius
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: 'أدخل رقم الهاتف',
                      contentPadding:
                       EdgeInsets.symmetric(vertical: screenHeight * 0.015,  // 1.5% of screen height
                           horizontal: screenWidth * 0.04),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border around the text field
                        borderRadius: BorderRadius.circular(screenWidth* 0.02), // Apply border radius here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(screenWidth* 0.02),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(screenWidth* 0.02),
                      ),
                    ),
                  ),
                ),
              ),

               Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Text('طريقة الدفع',
                    style:
                    TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
              ),
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,  // 1% of screen height
                        horizontal: screenWidth * 0.04),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.cardsBackgroundDark
                            : AppColors.cardsBackgroundLight,
                        borderRadius: BorderRadius.circular(  screenWidth * 0.02), // Consistent border radius
                      ),
                      child: RadioListTile<String>(
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: AppColors.primary,
                        title: Row(
                          children: [
                             SizedBox(width:  screenWidth* 0.02),
                             Text('نقداً', style: TextStyle(fontSize: screenWidth* 0.04)),
                          ],
                        ),
                        value: 'نقداً',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,  // 1% of screen height
                        horizontal: screenWidth * 0.04),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.cardsBackgroundDark
                            : AppColors.cardsBackgroundLight,
                        borderRadius:  BorderRadius.circular(
                            screenWidth * 0.02), // Consistent border radius
                      ),
                      child: RadioListTile<String>(
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: AppColors.primary,
                        title: Row(
                          children: [
                             SizedBox(width: screenWidth* 0.02,),
                             Text('سداد', style: TextStyle(fontSize: screenWidth* 0.04)),
                          ],
                        ),
                        value: 'سداد',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBackground
                : AppColors.cardsBackgroundLight,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.grey,
                offset: const Offset(1, 2),
                blurRadius: 4,
              )
            ],
          ),
          child: Padding(
            padding:  EdgeInsets.all(screenWidth* 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الملخص',
                        style: TextStyle(
                            fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                     Text('العناصر ', style: TextStyle(fontSize: screenWidth * 0.04)),
                    Text('${widget.itemsQuantity}'),
                  ],
                ),
                const Divider(thickness: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('سعر المنتجات', style: TextStyle(fontSize: screenWidth * 0.04)),
                    Text(
                        '${(widget.totalCost - widget.appFee).toStringAsFixed(2)} د.ل',
                        style:  TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('عمولة التطبيق', style: TextStyle(fontSize: screenWidth * 0.04)),
                    Text('${widget.appFee.toStringAsFixed(2)} د.ل',
                        style:  TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('سعر التوصيل', style: TextStyle(fontSize: screenWidth * 0.04,)),
                    Text('${delivery.toStringAsFixed(2)} د.ل',
                        style:  TextStyle(fontSize: screenWidth * 0.04,)),
                  ],
                ),
                const Divider(thickness: 1),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.01,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('السعر الإجمالي ',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                      Text(
                          '${(widget.totalCost + delivery).toStringAsFixed(2)} د.ل',
                          style:  TextStyle(
                              fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: screenHeight*0.02),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        print(widget.cartItems);

                        // Prepare the order details
                        double totalAmount = widget.totalCost + delivery;
                        String shippingAddress = '2972 Westheimer Rd. Santa Ana.'; // Replace with actual shipping address

                        await orderCubit.createOrder(
                          customerId: customerId,
                          storeId: storeId,
                          products: products,
                          totalAmount: totalAmount,
                          shippingAddress: shippingAddress,
                          paymentMethod: _selectedPaymentMethod,
                        );

                        // Show a success message or navigate
                        _showOrderSuccessDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding:  EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                            horizontal: screenWidth * 0.04),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular( screenWidth * 0.02)),
                      ),
                      child:  Text('إنشاء الطلب',
                          style: TextStyle(fontSize: screenWidth * 0.04)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}
void _showOrderSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              'تم إرسال الطلب !',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the buttons
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: AppColors.primary, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                    child: Text('متابعة التصفح'),
                  ),
                ),
                SizedBox(width: 10), // Adds spacing between the buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: AppColors.primary, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Close the dialog and navigate to OrdersScreen
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomerOrders()),
                      );
                    },
                    child: Text('عرض طلباتي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
