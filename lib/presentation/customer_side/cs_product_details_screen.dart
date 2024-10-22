import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../bloc/cubit/auth_cubit.dart';
import '../../bloc/cubit/cart_cubit.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Store? store;

  const ProductDetailScreen({Key? key, this.store, required this.product})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String? selectedSize;
  String? selectedColor;
  int _quantity = 1; // default quantity

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final user = BlocProvider.of<AuthCubit>(context).currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            // title: Text(widget.product.name),
            ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Carousel
              CarouselSlider.builder(
                itemCount: widget.product.images.length,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    child: Image.network(
                      widget.product.images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: screenHeight * 0.5,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 4 / 3,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.product.images.map((url) {
                    int index = widget.product.images.indexOf(url);
                    return Container(
                      width: screenWidth * 0.02,
                      height: screenHeight * 0.02,
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? AppColors.primary
                            : AppColors.lightGrey,
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Product Details

              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.045),
                    ),
                    const Spacer(),
                    Text(
                      "${widget.product.price.toStringAsFixed(2)} د.ل",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.045,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Product description
              Divider(),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Text(
                  'عن المنتج :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.036,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.02),
                child: Row(
                  children: [
                    Text('المادة : ',
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                        )),
                    Text(widget.product.material,
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Row(
                  children: [
                    Text(
                      'الفئة : ',
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                      ),
                    ),
                    Text(
                      widget.product.category,
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      " / ${widget.product.subcategory} ",
                      style: TextStyle(
                        fontSize: screenWidth * 0.036,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: widget.store != null
                    ? Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: Row(
                          children: [
                            Text('من صنع : '),
                            TextButton(
                              onPressed: () {},
                              child: Text(widget.store!.name,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: screenWidth * 0.036,
                                    // Add any style here
                                  )),
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.02),
                child: Row(
                  children: [
                    Text('مدة الإنشاء : ',
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                        )),
                    Text(widget.product.timeToBeCreated,
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                        )),
                  ],
                ),
              ),
              Divider(),
              Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.01, right: screenWidth * 0.02),
                  child: Text(
                    'وصف للمنتج : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.036,
                    ),
                  )),

              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    bottom: screenHeight * 0.01,
                    right: screenWidth * 0.02),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.036,
                    color: Colors.grey,
                  ),
                ),
              ),
              // Size selection
              // const Text(
              //   'Select Size',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Wrap(
              //   spacing: 8.0,
              //   children: ['S', 'M', 'L', 'XL', 'XXL'].map((size) {
              //     return ChoiceChip(
              //       label: Text(size),
              //       selected: selectedSize == size,
              //       onSelected: (selected) {
              //         setState(() {
              //           selectedSize = selected ? size : null;
              //         });
              //       },
              //     );
              //   }).toList(),
              // ),
              // const SizedBox(height: 16),
              // Color selection
              Divider(),

              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth * 0.02, top: screenHeight * 0.01),
                child: Text(
                  'أختر اللون',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.036,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Wrap(
                  spacing: screenHeight*0.02,
                  children: widget.product.colors.map((color) {
                    return ChoiceChip(
                      labelPadding:
                      EdgeInsets.only(
                        left: screenWidth * 0.01,
                        right: screenWidth * 0.01,
                        bottom:screenHeight * 0.003,
                      ),                      selectedColor: AppColors.selected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth* 0.02),),
                      label: Text(
                        color,
                        style: TextStyle(

                        ),
                      ),
                      selected: selectedColor == color,
                      onSelected: (selected) {
                        setState(() {
                          selectedColor = selected ? color : null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              // Add to Cart Button
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
               EdgeInsets.only( bottom: screenHeight * 0.01, // Adjust for bottom padding
                  right: screenWidth* 0.04, // Adjust for right padding
                  left:screenWidth * 0.04, // Adjust for left padding
                  top: screenHeight * 0.02),
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<CartCubit>()
                  .addToCart(user!.id, widget.product.id, _quantity);
              Fluttertoast.showToast(
                msg: "تمت إضافة المنتج إلى السلة بنجاح",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.lightBackground
                    : AppColors.darkBackground,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.lightText
                    : AppColors.darkText,
                fontSize: screenWidth*0.04,
              );
              // _showAddToCartDialog(context);
            },
            style: ElevatedButton.styleFrom(
              padding:  EdgeInsets.symmetric(
                  vertical: screenHeight * 0.012,
                  horizontal: screenWidth * 0.04
              ),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth* 0.02),
              ),
            ),
            child:  Text(
              'أضف إلى السلة',
              style: TextStyle(fontSize: screenWidth*0.04),
            ),
          ),
        ),
      ),
    );
  }

}
