import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Product_/Get_All_Product_by_categorId/get_all_product_by_category_id_bloc.dart';
import 'package:modern_grocery/bloc/wishList/AddToWishlist_bloc/add_to_wishlist_bloc.dart';
import 'package:modern_grocery/bloc/GetById/getbyid_bloc.dart';
import 'package:modern_grocery/bloc/cart_/addCart_bloc/add_cart_bloc.dart';
import 'package:modern_grocery/localization/app_localizations.dart';
import 'package:modern_grocery/services/language_service.dart';

import 'package:modern_grocery/ui/bottom_navigationbar.dart';
import 'package:modern_grocery/ui/cart_/success_cart.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/wishList/remove towish/removetowishlist_bloc.dart';
import 'Product_list.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ValueNotifier<int> _quantityNotifier = ValueNotifier(1);
  double _rating = 4.0;

  @override
  void initState() {
    super.initState();
    context.read<GetbyidBloc>().add(FetchGetbyid(widget.productId));
  }

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        final lang = languageService.currentLanguage;

        return MultiBlocListener(
          listeners: [
            BlocListener<AddCartBloc, AddCartState>(
              listener: (context, state) {
                if (state is AddCartLoaded) {
                  if (state.response.success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SuccessCart()),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.response.message.isNotEmpty
                              ? state.response.message
                              : AppLocalizations.getString(
                                  'failed_add_to_cart',
                                  lang,
                                ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else if (state is AddCartError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Add to cart failed: ${state.message}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<GetbyidBloc, GetbyidState>(
              listener: (context, state) {
                if (state is GetbyidLoaded) {
                  final categoryId = state.getByIdProduct.data?.category?.id;
                  if (categoryId != null) {
                    context.read<GetAllProductByCategoryIdBloc>().add(
                          FetchAllProductByCategoryId(categoryId: categoryId),
                        );
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<GetbyidBloc, GetbyidState>(
            builder: (context, state) {
              if (state is GetbyidLoading) {
                return _buildProductDetailsShimmer();
              }

              if (state is GetbyidLoaded) {
                final product = state.getByIdProduct;

                if (product == null || product.data == null) {
                  return Scaffold(
                    backgroundColor: const Color(0xFF0A0909),
                    body: Center(
                      child: Text(
                        AppLocalizations.getString(
                          'product_data_unavailable',
                          lang,
                        ),
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  );
                }

                // ✅ Price calculations
                final double basePrice =
                    (product.data!.basePrice ?? 0).toDouble();

                final double discount =
                    (product.data!.discountPercentage ?? 0).toDouble();

                final double discountedPrice =
                    discount > 0 ? basePrice * (1 - discount / 100) : basePrice;

                final bool hasDiscount = discount > 0;

                // Check for stock. Assumes a 'stock' field on product.data
                final bool isOutOfStock =
                    (product.data!.quantityInStock ?? 0) <= 0;

                // ✅ Wishlist icon state
                final bool isFav = product.data!.inWishlist ?? false;

                return MultiBlocListener(
                    listeners: [
                      BlocListener<AddToWishlistBloc, AddToWishlistState>(
                        listener: (context, wishlistState) {
                          if (wishlistState is AddToWishlistLoaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.getString(
                                    'added_to_wishlist',
                                    lang,
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            context
                                .read<GetbyidBloc>()
                                .add(FetchGetbyid(widget.productId));
                          }
                        },
                      ),
                      BlocListener<RemovetowishlistBloc, RemovetowishlistState>(
                        listener: (context, wishlistState) {
                          if (wishlistState is RemovetowishlistLoaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.getString(
                                    'removed_from_wishlist',
                                    lang,
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            context
                                .read<GetbyidBloc>()
                                .add(FetchGetbyid(widget.productId));
                          }
                        },
                      ),
                    ],
                    child: Scaffold(
                        backgroundColor: const Color(0xFF0A0909),
                        extendBodyBehindAppBar: true,
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: const BackButton(color: Colors.black),
                          ),
                          actions: [
                            Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: IconButton(onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationBarWidget(initialIndex: 3)),
                                  (route) => false,
                                );
                              }, icon: Icon(Icons.shopping_cart_outlined))
                            ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔥 HEADER IMAGE WITH DOT INDICATOR
                              _ProductImageSlider(images: product.data!.images ?? []),

                              // --- Product info ---
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title + fav
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.data!.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xF2FCF8E8),
                                              fontSize: 28.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        BlocSelector<GetbyidBloc, GetbyidState, bool>(
                                          selector: (state) => state is GetbyidLoaded
                                              ? state.getByIdProduct.data?.inWishlist ?? false
                                              : false,
                                          builder: (context, isFav) {
                                            return IconButton(
                                              icon: Icon(
                                                isFav ? Icons.favorite : Icons.favorite_outline,
                                                color: isFav ? Colors.red : appColor.loadingColor,
                                                size: 24.sp,
                                              ),
                                              onPressed: () {
                                                isFav
                                                    ? context.read<RemovetowishlistBloc>().add(
                                                        fetchRemovetowishlistEvent(widget.productId))
                                                    : context.read<AddToWishlistBloc>().add(
                                                        fetchAddToWishlistEvent(widget.productId));
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),

                                    // Price & Quantity
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 💛 Discounted (or normal) price
                                            Text(
                                              '₹${discountedPrice.toStringAsFixed(2)}/${product.data!.unit?.toLowerCase()}',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // 🩶 Show MRP only if discount exists
                                            if (hasDiscount)
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹${basePrice.toStringAsFixed(2)}',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 14.sp,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            Colors.grey),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    '${product.data!.discountPercentage} % OFF',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.green,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        _QuantitySelector(quantityNotifier: _quantityNotifier),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),

                                    // Details
                                    Text(
                                      AppLocalizations.getString(
                                        'product_detail',
                                        lang,
                                      ),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      '${AppLocalizations.getString('category', lang)} - ${product.data!.category!.name}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    ExpandableText(
                                      text: product.data!.description!,
                                      maxLines: 10,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),

                                    // // Review
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       AppLocalizations.getString(
                                    //         'review ',
                                    //         lang,
                                    //       ),
                                    //       style: GoogleFonts.poppins(
                                    //         color: Colors.white,
                                    //         fontSize: 18.sp,
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //     Row(
                                    //       children: [
                                    //         RatingBar.builder(
                                    //           itemSize: 20.sp,
                                    //           unratedColor: Colors.white24,
                                    //           initialRating: _rating,
                                    //           minRating: 1,
                                    //           direction: Axis.horizontal,

                                    //           allowHalfRating: true,
                                    //           itemCount: 5,
                                    //           itemBuilder: (context, _) =>
                                    //               const Icon(
                                    //             Icons.star,
                                    //             color: Color(0xffFFD500),
                                    //           ),
                                    //           onRatingUpdate: (rating) {
                                    //             setState(() => _rating = rating);
                                    //             ScaffoldMessenger.of(context)
                                    //                 .showSnackBar(
                                    //               SnackBar(
                                    //                 content: Text(
                                    //                   AppLocalizations.getString(
                                    //                     'rating_updated',
                                    //                     lang,
                                    //                   ),
                                    //                 ),
                                    //                 duration:
                                    //                     const Duration(seconds: 1),
                                    //               ),
                                    //             );
                                    //           },
                                    //         ),
                                    //         // SizedBox(width: 8.w),
                                    //         // Text('${product} (126 reviews)',
                                    //         //     style: GoogleFonts.poppins(
                                    //         //       color: Colors.white,
                                    //         //       fontSize: 14.sp,
                                    //         //       fontWeight: FontWeight.w600,
                                    //         //     ))
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 40.h),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: _buildBestDealsSection(languageService),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                        bottomNavigationBar: Container(
                            height: 72.h,
                            color: Colors.black, // To match the theme
                            child: _AddToCartButton(
                              isOutOfStock: isOutOfStock,
                              productId: widget.productId,
                              quantityNotifier: _quantityNotifier,
                            ))));
              }

              return Scaffold(
                backgroundColor: const Color(0xFF0A0909),
                body: Center(
                  child: Text(
                    AppLocalizations.getString('unexpected_error', lang),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBestDealsSection(LanguageService languageService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageService.getString('Related_products'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 260.h,
          child: BlocBuilder<GetAllProductByCategoryIdBloc, GetAllProductByCategoryIdState>(
            builder: (context, state) {
              if (state is GetAllProductByCategoryIdLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFF5E9B5)));
              }
              if (state is GetAllProductByCategoryIdLoaded) {
                final products = state.products.data ?? [];
                if (products.isEmpty) return const SizedBox();

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return SizedBox(
                      width: 180.w,
                      child: FruitCard(
                        product: product.toJson(),
                        languageService: languageService,
                        nav_type: 'details',
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetailsShimmer() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0909),
      // ✅ Add a placeholder for the bottom bar in the shimmer state
      bottomNavigationBar: Container(
        height: 72.h, // Approximate height of the button bar
        color: Colors.black,
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[900]!,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Placeholder
              Container(
                height: 300.h + 80.h + 16.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              // Product Info Placeholder
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      height: 28.h,
                      width: 0.7.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Price and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.black,
                            ),
                            SizedBox(width: 12.w),
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.black,
                            ),
                            SizedBox(width: 12.w),
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.black,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Details Title
                    Container(
                      height: 20.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Details Content
                    Container(
                      height: 14.h,
                      width: 0.4.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Container(
                      height: 14.h,
                      width: 0.95.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Container(
                      height: 14.h,
                      width: 0.95.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Container(
                      height: 14.h,
                      width: 0.95.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Container(
                      height: 14.h,
                      width: 0.95.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Container(
                      height: 14.h,
                      width: 0.95.sw,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Review
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Container(
                          height: 20.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _discountBadge(double discount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '${discount.toInt()}% OFF',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProductImageSlider extends StatefulWidget {
  final List<String> images;
  const _ProductImageSlider({required this.images});

  @override
  State<_ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<_ProductImageSlider> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
        color: const Color(0xffDDDACB),
      ),
      child: SizedBox(
        height: 350.h,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final img = widget.images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 140,
                        vertical: 120,
                      ),
                      child: Image.asset(
                        'assets/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              },
            ),
            if (widget.images.length > 1)
              Positioned(
                bottom: 12.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: _currentPage == index ? 10.w : 6.w,
                      height: _currentPage == index ? 10.w : 6.w,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.black : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final ValueNotifier<int> quantityNotifier;
  const _QuantitySelector({required this.quantityNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: quantityNotifier,
      builder: (context, count, child) {
        return Row(
          children: [
            _quantityButton('-', () {
              if (quantityNotifier.value > 1) {
                quantityNotifier.value--;
              }
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey[800],
                child: Text(
                  '$count',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _quantityButton('+', () {
              quantityNotifier.value++;
            }),
          ],
        );
      },
    );
  }

  Widget _quantityButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        minimumSize: Size(40.w, 40.h),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final bool isOutOfStock;
  final String productId;
  final ValueNotifier<int> quantityNotifier;

  const _AddToCartButton({
    required this.isOutOfStock,
    required this.productId,
    required this.quantityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context, listen: false).currentLanguage;
    return BlocBuilder<AddCartBloc, AddCartState>(
      builder: (context, cartState) {
        final isCartLoading = cartState is AddCartLoading;
        return Center(
          child: GestureDetector(
            onTap: isOutOfStock || isCartLoading
                ? null
                : () {
                    context.read<AddCartBloc>().add(
                          FetchAddCart(
                            productId: productId,
                            quantity: quantityNotifier.value,
                          ),
                        );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isOutOfStock ? Colors.grey.shade700 : appColor.primaryText,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: isCartLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(
                      isOutOfStock ? "Out of Stock" : AppLocalizations.getString('add_to_cart', lang),
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: isOutOfStock ? Colors.white54 : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    required this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(text: widget.text, style: widget.style);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final bool overflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              maxLines: _expanded ? null : widget.maxLines,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (overflow)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    _expanded ? 'Show less' : 'Read more...',
                    style: GoogleFonts.poppins(
                      color: appColor.primaryText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
