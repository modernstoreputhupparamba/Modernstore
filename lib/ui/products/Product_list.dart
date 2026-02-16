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
import 'package:modern_grocery/widgets/fontstyle.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocListener<AddCartBloc, AddCartState>(
                listener: (context, state) {
                  if (state is AddCartLoading) {}
                  if (state is AddCartLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            languageService.getString('item_added_to_cart')),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color:  appColor.secondaryText, width: 2.w),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: languageService.getString('search_something'),
            hintStyle: fontStyles.primaryTextStyle,
            prefixIcon: const Icon(Icons.search, color:  Color(0x91FCF8E8)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
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
          var products = context
                  .read<GetCategoryProductsBloc>()
                  .getCategoryProductsModel
                  .data ??
              [];

          if (_searchQuery.isNotEmpty) {
            products = products
                .where((p) => (p.name?.toLowerCase() ?? '').contains(_searchQuery))
                .toList();
          }

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
          var products = state.offerproductModel.data ?? [];

          if (_searchQuery.isNotEmpty) {
            products = products
                .where((p) => (p.name?.toLowerCase() ?? '').contains(_searchQuery))
                .toList();
          }

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
        childAspectRatio: 0.75,
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
        childAspectRatio: 0.7,
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

class FruitCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final LanguageService languageService;
  final String nav_type;

  const FruitCard({
    super.key,
    required this.product,
    required this.languageService,
    required this.nav_type,
  });

  @override
  State<FruitCard> createState() => _FruitCardState();
}

class _FruitCardState extends State<FruitCard>
    with SingleTickerProviderStateMixin {

  bool isTapped = false;

  void _onAddToCart(BuildContext context) {
    setState(() => isTapped = true);

    context.read<AddCartBloc>().add(
      FetchAddCart(
        productId: widget.product['_id'],
        quantity: 1,
      ),
    );

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() => isTapped = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double basePrice =
        (widget.product['basePrice'] ?? 0).toDouble();

    final double discountPercent =
        (widget.product['discountPercentage'] ?? 0).toDouble();

    final double discountedPrice = discountPercent > 0
        ? basePrice - (basePrice * discountPercent / 100)
        : basePrice;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductDetails(productId: widget.product['_id'] ?? ''),
          ),
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
          children: [

            /// IMAGE
          ClipRRect(
  borderRadius: BorderRadius.circular(10.r),
  child: Container(
    height: 120.h,
    width: double.infinity,
    color: const Color(0xFFCCC9BC),
    child: CachedNetworkImage(
      imageUrl: (widget.product['images'] as List?)?.isNotEmpty == true
          ? widget.product['images'][0]
          : '',
      fit: BoxFit.cover,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Container(color: Colors.white),
      ),
      errorWidget: (_, __, ___) =>
          Image.asset('assets/placeholder.png', fit: BoxFit.cover),
    ),
  ),
),
            SizedBox(height: 8.h),

            /// NAME + CART
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: appColor.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                /// 🔥 BLAST ICON
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: isTapped ? 0.4 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    AnimatedScale(
                      scale: isTapped ? 1.4 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutBack,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: isTapped
                              ? Colors.greenAccent
                              : appColor.iconColor,
                        ),
                        onPressed: () => _onAddToCart(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // /// RATING
            // Row(
            //   children: List.generate(
            //     5,
            //     (i) => Icon(
            //       i < 4 ? Icons.star : Icons.star_border,
            //       size: 14,
            //       color: const Color(0xFFFFD500),
            //     ),
            //   ),
            // ),

            // SizedBox(height: 6.h),

            /// PRICE
            Row(
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
                  'MRP ₹${basePrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            /// DISCOUNT
            if (discountPercent > 0)
              Text(
                '${discountPercent.toInt()}% OFF',
                style: TextStyle(
                  color: appColor.accentColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
