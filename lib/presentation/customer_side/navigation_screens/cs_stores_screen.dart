import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cubit/store_cubit.dart';
import '../../../bloc/state/store_state.dart';
import '../../../core/theme/app_colors.dart';
import '../cart_screen.dart';
import '../cs_store_details_screen.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding:  EdgeInsets.all(screenWidth* 0.02),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFEEEDED)
                    : AppColors.lightText,
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                )
              },
            ),
          ),
        ],
        title: Padding(
          padding:  EdgeInsets.all(screenWidth* 0.02),
          child: Text(
            'المتاجر',
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
          BlocProvider.of<StoreCubit>(context).fetchAllStores();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SearchAnchor(
                    builder: (BuildContext context, SearchController controller) {
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
                          height:screenHeight * 0.05,
                        ),
                        controller: controller,
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        hintText: "أبحث عن المتاجر ",
                        leading: const Icon(Icons.search),
                      );
                    },
                    suggestionsBuilder:
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
                    },
                  ),
                ),

                // Store List
                BlocBuilder<StoreCubit, StoreState>(
                    builder: (context, state) {
                      if (state is StoreLoading) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                      } else if (state is StoresLoaded) {
                        final stores = state.stores;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
                          padding: EdgeInsets.only(left: screenWidth*0.025, right: screenWidth*0.025),
                          itemCount: stores.length,
                          itemBuilder: (context, index) {
                            final store = stores[index];
                            double randomRating = 1.0 + Random().nextDouble() * (5.0 - 1.0);
                            return Card( shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth* 0.02),
                            ),

                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.cardsBackgroundDark
                                  : AppColors.cardsBackgroundLight,
                              elevation: 0,
                              margin:  EdgeInsets.symmetric(vertical: screenHeight*0.015),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StoreDetailsScreen(store: store),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(screenWidth* 0.02),
                                      child: store.image != null
                                          ? CachedNetworkImage(
                                        imageUrl: store.image.toString(),
                                        width: double.infinity,
                                        height:  screenHeight *0.19,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const Center(
                                            child:
                                            CircularProgressIndicator(
                                              color: AppColors.primary,
                                            )),
                                        errorWidget: (context, url, error) =>
                                        const Center(
                                            child: Icon(Icons.error)),
                                      )
                                          : const Icon(Icons.store,
                                          ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.all(screenWidth*0.03),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                store.name,
                                                style:  TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: screenWidth*0.045,
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: AppColors.primary,
                                                    size: screenWidth*0.04,
                                                  ),
                                                  Text(randomRating.toStringAsFixed(1),)
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is StoreError) {
                        return Center(child: Text(state.message));
                        print(state.message);
                      } else {
                        return const Center(child: Text("المتاجر غير موجودة"));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
