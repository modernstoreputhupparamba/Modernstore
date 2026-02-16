import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';
import 'package:modern_grocery/bloc/Product_/get_all_product/get_all_product_bloc.dart';
import 'package:modern_grocery/services/language_service.dart'; // Add this import
import 'package:modern_grocery/ui/products/Product_list.dart';
import 'package:modern_grocery/ui/products/product_details.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback? onFavTap;
  const SearchPage({super.key, this.onFavTap});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late LanguageService languageService;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool get _isSearching => _searchController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    languageService = LanguageService();
    BlocProvider.of<GetAllCategoriesBloc>(context).add(fetchGetAllCategories());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

void _onSearchChanged() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<GetAllProductBloc>().add(fetchGetAllProduct(query));
      setState(() {
        
      });
    } else {
      // clear product results and show categories
      context.read<GetAllProductBloc>().add(fetchGetAllProduct(''));
      setState(() {}); // forces AnimatedSwitcher to show categories based on _isSearching
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0909),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 72.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use a SizedBox to balance the trailing IconButton
                SizedBox(width: 50.w),
                Expanded(
                  child: Text(
                    languageService.getString('find_products'), // Localized text
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      color: appColor.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (widget.onFavTap != null) {
                      widget.onFavTap!();
                    }
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    color: Color(0xFFF5E9B5),
                    size: 22.sp,
                  ),
                ),
              ],
            ),
  
     
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: appColor.secondaryText, width: 2.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(color: Color(0x91FCF8E8)),
                decoration: InputDecoration(
                  hintText: languageService
                      .getString('search_something'), // Localized text
                  hintStyle: GoogleFonts.poppins(
                      color: appColor.primaryText, fontSize: 14.sp),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Color(0x91FCF8E8)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 36.h),
            Expanded(
              child: _isSearching
                  ? _buildProductSearchResult()
                  : _buildCategoryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesLoading) {
          return _buildShimmerGrid();
        }
        if (state is GetAllCategoriesError) {
          return Center(
              child: Text(
                  languageService.getString('categories_not_recognized'),
                  style: GoogleFonts.poppins(color: Colors.white)));
        }
        if (state is GetAllCategoriesLoaded) {
          final categories = state.categories;
          if (categories.isEmpty) {
            return Center(
                child: Text(languageService.getString('no_categories_found'),
                    style: GoogleFonts.poppins(color: Colors.white)));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(
                  category.name, category.image, category.id);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductSearchResult() {
    return BlocBuilder<GetAllProductBloc, GetAllProductState>(
      builder: (context, state) {
        if (state is GetAllProductLoading) {
          return _buildShimmerGrid();
        }
        if (state is GetAllProductError) {
          return Center(
              child: Text(languageService.getString('failed_load_products'),
                  style: GoogleFonts.poppins(color: Colors.white)));
        }
        if (state is GetAllProductLoaded) {
          final products = state.getAllProduct.data ?? [];
          if (products.isEmpty) {
            return Center(
                child: Text(languageService.getString('no_products_found'),
                    style: GoogleFonts.poppins(color: Colors.white)));
          }
          // Using FruitCard from Product_list.dart
          return _buildProductGridView(products);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, String categoryId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Product_list(CategoryId: categoryId,nav_type: 'home')),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          decoration: BoxDecoration(
            color: appColor.primaryText,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column( //
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage( // Use CachedNetworkImage
                  imageUrl: imageUrl,
                  height: 128.h,
                  width: 160.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors( // Shimmer placeholder
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  // errorBuilder: (context, error, stackTrace) {
                  //   return const Icon(Icons.broken_image, color: Colors.grey); // Error icon
                  // },
                ),
              ),
              SizedBox(height: 13.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 27.w),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridView(List<dynamic> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.63,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return FruitCard(
          product: product.toJson(),
          languageService: languageService,
          nav_type: 'search',
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
              color: Colors.grey[900], borderRadius: BorderRadius.circular(22.r)),
        ),
      ),
    );
  }
}
