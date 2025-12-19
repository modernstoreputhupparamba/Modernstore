import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_grocery/bloc/Categories_/GetCategoryProducts/get_category_products_bloc.dart';
import 'package:modern_grocery/bloc/Product_/offerproduct/offerproduct_bloc.dart';
import 'package:modern_grocery/services/language_service.dart'; // Add this import
import 'package:modern_grocery/ui/products/product_details.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/cart_/addCart_bloc/add_cart_bloc.dart';

class Product_list extends StatefulWidget {
  final String CategoryId;
  final String nav_type;
  const Product_list(
      {super.key, required this.CategoryId, required this.nav_type});

  @override
  State<Product_list> createState() => _Product_listState();
}

class _Product_listState extends State<Product_list> {
  late LanguageService languageService; // Add this line

  @override
  void initState() {
    super.initState();
    languageService = LanguageService();
    // If CategoryId is 'offer', fetch offer products. Otherwise, fetch by category.
    if (widget.CategoryId == 'offer') {
      context.read<OfferproductBloc>().add(fetchOfferproductEvent());
    } else {
      context
          .read<GetCategoryProductsBloc>()
          .add(FetchCategoryProducts(categoryId: widget.CategoryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0A0909),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            languageService.getString('Products'), // Localized text
            style: GoogleFonts.poppins(
              color: const Color(0xffF5E9B5),
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: appColor.secondaryText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          SizedBox(
            width: 50.w,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: BlocListener<AddCartBloc, AddCartState>(
          listener: (context, state) {
            if (state is AddCartLoading) {}
            if (state is AddCartLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(languageService.getString('item_added_to_cart')),
                ),
              );
            } else if (state is AddCartError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                'Add to cart failed: ${state.message}',
              )));
            }
            // TODO: implement listener
          },
          child: widget.CategoryId == 'offer'
              ? _buildOfferProductsGrid()
              : _buildCategoryProductsGrid(),
        ),
      ),
    );
  }

  Widget _buildCategoryProductsGrid() {
    return BlocBuilder<GetCategoryProductsBloc, GetCategoryProductsState>(
      key: const Key('category_products_grid'), // Add a key for clarity
      builder: (context, state) {
        if (state is GetCategoryProductsLoading) {
          return _buildShimmerGrid();
        }
        if (state is GetCategoryProductsError) {
          return Center(
              child: Text(
            languageService.getString('failed_load_products'),
            style: TextStyle(color: Colors.white),
          ));
        }
        if (state is GetCategoryProductsLoaded) {
          final products = context
                  .read<GetCategoryProductsBloc>()
                  .getCategoryProductsModel
                  .data ??
              [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                languageService.getString('no_products_found'),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            );
          }
          return _buildProductGridView(products);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildOfferProductsGrid() {
    return BlocBuilder<OfferproductBloc, OfferproductState>(
      key: const Key('offer_products_grid'), // Add a key for clarity
      builder: (context, state) {
        if (state is OfferproductLoading) {
          return _buildShimmerGrid();
        }
        if (state is OfferproductError) {
          return Center(
              child: Text(
            languageService.getString('failed_load_deals'),
            style: TextStyle(color: Colors.white),
          ));
        }
        if (state is OfferproductLoaded) {
          final products = state.offerproductModel.data ?? [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                languageService.getString('no_products_found'),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            );
          }
          return _buildProductGridView(products);
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildProductGridView(List<dynamic> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return FruitCard(
          product: product.toJson(),
          languageService: languageService,
          nav_type: widget.nav_type,
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[900]!,
        highlightColor: Colors.grey[800]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}

class FruitCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final LanguageService languageService; // Add this parameter
  final String nav_type;

  const FruitCard({
    super.key,
    required this.product,
    required this.languageService, // Add this parameter
    required this.nav_type,
  });

  @override
  Widget build(BuildContext context) {
    final double basePrice = product['basePrice']?.toDouble() ?? 0;
    final double discountPercent =
        product['discountPercentage']?.toDouble() ?? 0;

// Calculate discounted price
    final double discountedPrice = discountPercent > 0
        ? basePrice - (basePrice * discountPercent / 100)
        : basePrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetails(productId: product['_id'] ?? '')),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // **Fruit Image Container**
            Container(
              width: 170.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCCC9BC),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: CachedNetworkImage(
                  imageUrl: (product['images'] as List?)?.isNotEmpty == true
                      ? product['images'][0]
                      : '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/placeholder.png',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),

            // // **Fruit Name**
            // Text(
            //   product['name'] ?? 'No Name',
            //   textAlign: TextAlign.center,
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: GoogleFonts.poppins(
            //     color: Colors.white,
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),

            // // **Price & MRP**
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '\u{20B9}${product['basePrice']}',
            //       style: GoogleFonts.poppins(
            //         color: Colors.grey,
            //         fontSize: 14.sp,
            //         decoration: TextDecoration.lineThrough,
            //       ),
            //     ),
            //     SizedBox(width: 5.w),
            //     if (product['discountedPrice'] != null) Text(
            //       '\u{20B9}${product['discountedPrice']}',
            //       style: GoogleFonts.poppins(
            //         color: Colors.white,
            //         fontSize: 14.sp,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),

            // // **Discount**
            // if (product['discountPercentage'] != null && product['discountPercentage'] > 0) Text(
            //   '${product['discountPercentage']}% OFF',
            //   style: GoogleFonts.poppins(
            //     color: Colors.green,
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),

            // // **Add Button**
            // IconButton(
            //   icon: Icon(Icons.add_circle, color: appColor.iconColor),
            //   iconSize: 28.sp,
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(languageService.getString('item_added_to_cart')),
            //       ),
            //     );
            //   },
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product['name'] ?? 'No Name',
                      style: TextStyle(
                        color: appColor.textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: appColor.iconColor),
                    iconSize: 28.sp,
                    onPressed: () {
                      context.read<AddCartBloc>().add(
                            FetchAddCart(
                              productId: product['_id'],
                              quantity: 1,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: List.generate(5, (index) {
                // Placeholder for rating
                return Icon(
                  index < 4 ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD500),
                  size: 16.w,
                );
              }),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Row(
                children: [
                  Text(
                    '₹${discountedPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: appColor.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'MRP ₹${product['basePrice'].toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              product['discountPercentage'] != null &&
                      product['discountPercentage'] > 0
                  ? '${product['discountPercentage'].toString()}% OFF'
                  : ' ',
              style: TextStyle(
                color: appColor.accentColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
