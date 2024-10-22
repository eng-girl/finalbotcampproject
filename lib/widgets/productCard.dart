import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final String thumbnail;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.price,
    required this.thumbnail,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Format price with currency

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: screenHeight / 4.5, // Smaller height for card
        width: screenWidth / 2.8, // Smaller width for card
        child: Card(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardsBackgroundDark
              : AppColors.white,
          elevation: 0, // Lowered the shadow slightly
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.02),
                    topRight: Radius.circular(screenWidth * 0.02)),
                child: CachedNetworkImage(
                  imageUrl: thumbnail,
                  height: screenHeight / 6,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.005),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.035, // Smaller, responsive font size
                      ),
                      overflow: TextOverflow.ellipsis, // Handle long text
                    ),
                    Divider(
                      indent: screenWidth *
                          0.01,
                      endIndent: screenWidth *
                          0.01,
                      height: screenHeight *
                          0.003,
                    ),
                    Text(
                      '$price د.ل ',
                      style: TextStyle(
                        fontSize: screenWidth * 0.033,
                        // Smaller, responsive font size
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
