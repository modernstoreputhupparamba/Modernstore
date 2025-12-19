import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';
import 'package:modern_grocery/localization/app_localizations.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/products/Product_list.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:modern_grocery/widgets/fontstyle.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch categories if they are not already loaded
    final state = context.read<GetAllCategoriesBloc>().state;
    if (state is! GetAllCategoriesLoaded) {
      context.read<GetAllCategoriesBloc>().add(fetchGetAllCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    final lang = languageService.currentLanguage;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0909),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0909),
        elevation: 0,
        title: Text(
          AppLocalizations.getString('categories', lang),
          style: fontStyles.heading2,
        ),
        leading: BackButton(color: appColor.primaryText),
      ),
      body: BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
        builder: (context, state) {
          if (state is GetAllCategoriesLoading) {
            return GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey[900]!,
                highlightColor: Colors.grey[800]!,
                child: Column(
                  children: [
                    CircleAvatar(radius: 40.r, backgroundColor: Colors.white),
                    SizedBox(height: 10.h),
                    Container(width: 60.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ),
            );
          }

          if (state is GetAllCategoriesError) {
            return Center(
              child: Text(
                AppLocalizations.getString('failed_load_categories', lang),
                style: fontStyles.errorstyle,
              ),
            );
          }

          if (state is GetAllCategoriesLoaded) {
            final categories = state.categories;
            return GridView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isNetworkImage = category.image.startsWith('http');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Product_list(
                              CategoryId: category.id, nav_type: 'home')),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: const Color(0xFFFCF8E8),
                        child: ClipOval(
                          child: isNetworkImage
                              ? CachedNetworkImage(
                                  imageUrl: category.image,
                                  fit: BoxFit.cover,
                                  width: 80.r,
                                  height: 80.r,
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/placeholder.png',
                                          fit: BoxFit.cover),
                                )
                              : Image.asset(
                                  'assets/placeholder.png',
                                  fit: BoxFit.cover,
                                  width: 80.r,
                                  height: 80.r,
                                ),
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: fontStyles.primaryTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: appColor.textColor2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
