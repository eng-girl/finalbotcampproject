import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widgets/productCard.dart';
import 'cs_product_details_screen.dart';
// Import your product model

class StoreDetailsScreen extends StatelessWidget {
  final Store store;

  const StoreDetailsScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            // title: Text(store.name),
            ),
        body: Padding(
          padding:  EdgeInsets.all(screenWidth*0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth*0.1,
                    backgroundColor: Colors.grey[200],
                    // Optional: Background color for the avatar
                    child: store.image != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: store.image!,
                              height: screenHeight * 0.1, // Adjust the multiplier for height
                              width: screenWidth * 0.2,
                              fit: BoxFit.cover,
                              // Cover the CircleAvatar while maintaining aspect ratio
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        : const Icon(Icons.store,
                            size: 40), // Use a smaller size for the icon
                  ),
                   SizedBox(width: screenWidth*0.04),
                  Text(
                    store.name,
                    style:  TextStyle(
                        fontSize: screenWidth*0.06
                        , fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.all(screenWidth*0.02),
                child: Text("${store.bio}"),
              ),
              Padding(
                padding:  EdgeInsets.all(screenWidth*0.02),
                child: Text("تواصل معنا: ${store.contactInfo} "),
              ),
              Padding(
                padding:  EdgeInsets.all(screenWidth*0.02),
                child: Text("منتجاتنا :",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                // Expand to take available space
                child: GridView.builder(
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: screenWidth * 0.02,
                    mainAxisSpacing: screenHeight* 0.01,
                    crossAxisCount: screenWidth > 600 ? 3 : 2, // Number of columns
                    childAspectRatio: 0.82, // Aspect ratio for each card
                  ),
                  itemCount: store.products?.length ?? 0,
                  itemBuilder: (context, index) {
                    final product =
                        store.products![index]; // Get the Product object
                    return ProductCard(
                      productName: product.name,
                      price: product.price,
                      thumbnail: product.thumbnail,
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: product,
store: store,
                              ),
                            ),
                          );
                        }
                        ;
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
