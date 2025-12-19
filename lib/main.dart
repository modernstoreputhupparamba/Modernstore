import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modern_grocery/bloc/Banner_/DeleteBanner_bloc/delete_banner_bloc.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';
import 'package:modern_grocery/bloc/Login_/verify/verify_bloc.dart';
import 'package:modern_grocery/bloc/Orders/Get_All_Order/get_all_orders_bloc.dart';
import 'package:modern_grocery/bloc/userprofile/userprofile_bloc.dart';
import 'package:modern_grocery/bloc/wishList/AddToWishlist_bloc/add_to_wishlist_bloc.dart';
import 'package:modern_grocery/bloc/Banner_/CreateBanner_bloc/create_banner_bloc.dart';
import 'package:modern_grocery/bloc/Banner_/GetAllBannerBloc/get_all_banner_bloc.dart';
import 'package:modern_grocery/bloc/cart_/GetAllUserCart/get_all_user_cart_bloc.dart';
import 'package:modern_grocery/bloc/GetById/getbyid_bloc.dart';
import 'package:modern_grocery/bloc/Categories_/GetCategoryProducts/get_category_products_bloc.dart';
import 'package:modern_grocery/bloc/wishList/GetToWishlist_bloc/get_to_wishlist_bloc.dart';
import 'package:modern_grocery/bloc/cart_/addCart_bloc/add_cart_bloc.dart';
import 'package:modern_grocery/bloc/delivery_/addDeliveryAddress/add_delivery_address_bloc.dart';
import 'package:modern_grocery/bloc/Categories_/createCategory/create_category_bloc.dart';
import 'package:modern_grocery/bloc/Product_/createProduct/create_product_bloc.dart';
import 'package:modern_grocery/bloc/Product_/get_all_product/get_all_product_bloc.dart';
import 'package:modern_grocery/bloc/Login_/login/login_bloc.dart';
import 'package:modern_grocery/bloc/Product_/offerproduct/offerproduct_bloc.dart';
import 'package:modern_grocery/bloc/wishList/remove%20towish/removetowishlist_bloc.dart';
import 'package:modern_grocery/bloc/delivery_/userdelivery%20addrees/userdeliveryaddress_bloc.dart';
import 'package:modern_grocery/localization/app_localizations_delegate.dart';
import 'package:modern_grocery/repositery/api/Cart/addCart_api.dart';
import 'package:modern_grocery/repositery/api/Categories/createCategory_api.dart';
import 'package:modern_grocery/repositery/api/api_client.dart';
import 'package:modern_grocery/repositery/api/banner/CreateBanner_api.dart';
import 'package:modern_grocery/repositery/api/product/getbyidproduct_api.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/repositery/api/Cart/updateCart_api.dart';
import 'package:modern_grocery/ui/splash_screen.dart';
import 'package:provider/provider.dart';

import 'bloc/Dashboard/dashboard_bloc.dart';
import 'bloc/Orders/Create_Order/create_order_bloc.dart';
import 'bloc/Stocks/GetAll_Inventory/get_all_stock_bloc.dart';
import 'bloc/Stocks/create_stock/add_stock_bloc.dart';
import 'bloc/Categories_/Edit_category/edit_category_bloc.dart';
import 'bloc/cart_/Update_cart/update_cart_bloc.dart';
import 'repositery/api/Delivery/GetUserDlvAddresses_api.dart';
import 'repositery/api/Orders/Create_order_Api.dart';

String basePath = "https://modern-store-backend.onrender.com/api";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageService(),
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return ScreenUtilInit(
            designSize: const Size(430, 917),
            minTextAdapt: true,
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LoginBloc(),
                  ),
                  BlocProvider(
                    create: (context) => VerifyBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetAllCategoriesBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddDeliveryAddressBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddCartBloc(
                      addCartApi: AddCartApi(apiClient: ApiClient()),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GetbyidBloc(
                      getbyidproductApi: GetbyidproductApi(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GetAllBannerBloc(),
                  ),
                  BlocProvider(
                    create: (context) => DeleteBannerBloc(),
                  ),

                  BlocProvider(
                    create: (context) => CreateCategoryBloc(
                      createcategoryApi: CreatecategoryApi(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => CreateProductBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetAllProductBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UserprofileBloc(),
                  ),
                  BlocProvider(
                    create: (context) => UserdeliveryaddressBloc(),
                  ),

                  BlocProvider(
                    create: (context) => OfferproductBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddToWishlistBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetToWishlistBloc(),
                  ),
                  // ✅ CreateBannerBloc is now provided in upload_recentpage.dart
                  //    where it is used, to ensure a fresh instance for each upload.
                  BlocProvider(
                      create: (context) =>
                          CreateBannerBloc(api: CreatebannerApi())),
                  // BEVERAGES BLOC - First Instance
                  BlocProvider(
                    create: (context) => GetCategoryProductsBloc(),
                  ),
                  // VEGETABLES BLOC - Second Instance for multiple categories
                  BlocProvider(
                    create: (context) => GetCategoryProductsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetAllUserCartBloc(),
                  ),
                  BlocProvider(
                    create: (context) => RemovetowishlistBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetAllOrdersBloc(),
                  ),
                  BlocProvider(
                    create: (context) => GetAllStockBloc(),
                  ),
                  BlocProvider(
                    create: (context) => DashboardBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddStockBloc(),
                  ),
                  BlocProvider(
                    create: (context) => EditCategoryBloc(),
                  ),
                  BlocProvider(
                      create: (context) => CreateOrderBloc(
                          createOrderApi:
                              CreateOrderApi(apiClient: ApiClient()))),
                  BlocProvider(
                    create: (context) => UpdateCartBloc(
                      updateCartApi: UpdateCartApi(apiClient: ApiClient()),
                    ),
                  ),
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Modern Store',
                  theme: ThemeData(
                    useMaterial3: true,
                  ),
                  locale: languageService.locale,
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('hi', 'IN'),
                    Locale('ml', 'IN'),
                  ],
                  home: const SplashScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
