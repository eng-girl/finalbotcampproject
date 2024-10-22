import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/product_cubit.dart';
import '../../bloc/state/product_state.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/productCard.dart';
import 'cs_product_details_screen.dart';

class ProductsByCategory extends StatefulWidget {
  String category;

  ProductsByCategory({super.key, required this.category});

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  @override
  void initState() {
    super.initState();
    // Fetch products by category when the screen is initialized
    BlocProvider.of<ProductCubit>(context)
        .fetchProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
          if (state is ProductLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }

          if (state is ProductLoaded) {
            return GridView.builder(
              padding:  EdgeInsets.all(screenWidth*0.02),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight* 0.01,
                crossAxisCount: screenWidth > 600 ? 3 : 2, // Number of columns
                childAspectRatio: 0.84,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(
                  productName: product.name,
                  price: product.price,
                  thumbnail: product.thumbnail,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }else if (state is ProductError) {
            return Center(child: Text('No products found.'));
          }else {
            return const Center(child: Text('No products found.'));
          }
        }),
      ),
    );
  }
}
