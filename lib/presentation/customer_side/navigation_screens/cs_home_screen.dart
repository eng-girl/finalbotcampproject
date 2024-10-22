
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/cubit/category_cubit.dart';
import '../../../bloc/cubit/product_cubit.dart'; // Import ProductCubit
import '../../../bloc/state/category_state.dart';
import '../../../bloc/state/product_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/productCard.dart';
import '../cart_screen.dart';
import '../cs_product_details_screen.dart';
import '../product_by_category.dart'; // Import ProductState

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the HomeScreen is initialized
    BlocProvider.of<ProductCubit>(context).fetchProducts();
  }

  final Map<String, String> categoryIcons = {
    'مجوهرات': 'assets/icons/jewelry.svg', // Custom jewelry icon
    'ديكور منزلي': 'assets/icons/decore.svg', // Custom home decor icon
    'منتجات العناية': 'assets/icons/care.svg', // Custom care products icon
    'كروشيه': 'assets/icons/yarn.svg', // Custom yarn (crochet) icon
    'شموع': 'assets/icons/candle.svg', // Custom candle icon
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFEEEDED)
                    : AppColors.lightText,
              ),
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()))
              },
            ),
          ),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        title: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Text(
            'الرئيسية',
            style: TextStyle(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          BlocProvider.of<ProductCubit>(context).fetchProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //search
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.cardsBackgroundDark
                            : AppColors.white,
                      ),
                      elevation: const MaterialStatePropertyAll(0),
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.only(
                            right: screenWidth * 0.03),
                      ),
                      constraints: BoxConstraints.tightFor(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.05,
                      ),
                      controller: controller,
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      hintText: "أبحث عن المنتجات ",
                      leading: const Icon(Icons.search),
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List.generate(5, (index) {
                      final String item = 'item $index ';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  }),
                ),
                //cate
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الفئات",
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "عرض الكل",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<CategoryCubit, CategoryState>(
                  // CategoryBlocBuilder
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                    } else if (state is CategoryLoaded) {
                      return SizedBox(
                        height: screenHeight * 0.13,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.02,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            String category = state.categories[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductsByCategory(category: category),
                                  ),
                                );
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? AppColors.avatarBackgrounddark
                                              : AppColors.cardsBackgroundLight,
                                          radius: 30,
                                          child: SvgPicture.asset(
                                            categoryIcons[category] ??
                                                'assets/icons/default_icon.svg',
                                            // Fallback if category icon not found
                                            height: screenHeight * 0.038,
                                            width: screenHeight * 0.038,
                                            color:
                                                AppColors.primary, // Icon color
                                          ),
                                        ),
                                        Text(
                                          state.categories[index],
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.032,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      );
                    } else if (state is CategoryError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(
                          child: Text("التصنيفات غير موجودة"));
                    }
                  },
                ),

                //products
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.02,
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.04,
                  ),
                  child: Text(
                    "أخر العروض",
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                    } else if (state is ProductLoaded) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: screenWidth * 0.02,
                          mainAxisSpacing: screenHeight* 0.01,
                          crossAxisCount: screenWidth > 600 ? 3 : 2, // Number of columns
                          childAspectRatio: 0.84, // Aspect ratio for each card
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
                    } else if (state is ProductError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text("المنتجات غير موجودة"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
