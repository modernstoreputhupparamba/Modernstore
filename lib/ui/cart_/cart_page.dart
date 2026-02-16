import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/cart_/GetAllUserCart/get_all_user_cart_bloc.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/bottom_navigationbar.dart';
import 'package:modern_grocery/ui/delivery/delivery_address.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/cart_/Update_cart/update_cart_bloc.dart';
import '../../repositery/model/Cart/getAllUserCart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
    // Trigger the API call when the page loads
    context.read<GetAllUserCartBloc>().add(fetchGetAllUserCartEvent());
  }

  // final List<Map<String, dynamic>> favourites = [
  //   {
  //     'name': 'Banana',
  //     'image': 'assets/Banana.png',
  //     'price': 80,
  //     'mrp': 100,
  //   },
  //   {
  //     'name': 'Carrot',
  //     'image': 'assets/Carrot.png',
  //     'price': 80,
  //     'mrp': 100,
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFF0A0909),
            leading: BackButton(
              color: const Color(0xffFCF8E8),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationBarWidget(initialIndex: 0,),
                  ),
                );
              },
            ),
            title: Center(
              child: Text(
                languageService.getString('cart'),
                style: GoogleFonts.poppins(
                  color: Color(0xFFFCF8E8),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.24,
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: 50.w,
              )
            ],
          ),
          backgroundColor: const Color(0XFF0A0909),
          body: BlocListener<UpdateCartBloc, UpdateCartState>(
            listener: (context, state) {
              if (state is UpdateCartSuccess) {
                // Refresh the cart list after a successful update
                context
                    .read<GetAllUserCartBloc>()
                    .add(fetchGetAllUserCartEvent());
              } else if (state is UpdateCartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<GetAllUserCartBloc, GetAllUserCartState>(
              builder: (context, state) {
                if (state is GetAllUserCartLoading) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        children: [
                          SizedBox(height: 18.h),
                          Column(
                            children: List.generate(
                                3, (index) => _buildCartItemShimmer()),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetAllUserCartLoaded) {
                  final cartModel =
                      context.read<GetAllUserCartBloc>().getAllUserCartModel;

                  final List<AllCartItems> cartItems =
                      cartModel.data?.allCartItems ?? [];

                  // ✅ EMPTY CART UI
                  if (cartItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_shopping_cart_outlined,
                            size: 80.sp,
                            color: const Color(0xFFFCF8E8),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            languageService.getString('cart_empty'),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFCF8E8),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationBarWidget(initialIndex: 0,),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5E9B5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Shop Now',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // ✅ CART LIST UI
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        children: [
                          SizedBox(height: 18.h),
                          Column(
                            children: cartItems.map((item) {
                              return FavouriteItemCard(
                                productId: item.product?.id ?? '',
                                item: {
                                  'name': item.product?.name ?? 'No Name',
                                  'image': (item.product?.images?.isNotEmpty ??
                                          false)
                                      ? item.product!.images!.first
                                      : null,
                                  'quantity': item.quantity ?? 1,
                                  'price': item.totalAmount ?? 0,
                                  'mrp': item.totalAmount ?? 0,
                                },
                                languageService: languageService,
                              );
                            }).toList(),
                          ),
                          _buildCheckoutSection(languageService),
                        ],
                      ),
                    ),
                  );
                } else if (state is GetAllUserCartError) {
                  return Center(
                    child: Text(
                      languageService.getString('error_loading_cart'),
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0808),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xDBFCF8E8), width: 1.w),
        ),
        child: Row(
          children: [
            Container(
              width: 106.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 150.w, height: 20.h, color: Colors.black),
                  SizedBox(height: 10.h),
                  Container(width: 100.w, height: 14.h, color: Colors.black),
                ],
              ),
            ),
            Container(
              height: 38.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(LanguageService languageService) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: languageService.getString('promo_code'),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5E9B5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                child: Text(
                  languageService.getString('apply'),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          BlocBuilder<GetAllUserCartBloc, GetAllUserCartState>(
            builder: (context, state) {
              num totalPrice = 0.0; // ✅ FIX: Initialize as a double
              if (state is GetAllUserCartLoaded) {
                final cartModel =
                    context.read<GetAllUserCartBloc>().getAllUserCartModel;
                if (cartModel != null &&
                    cartModel.data != null &&
                    cartModel.data?.allCartItems != null) {
                  totalPrice = cartModel.data?.totalCartAmount ?? 0.0;
                }
              }
              return Column(
                children: [
                  _buildPriceRow(languageService.getString('price'),
                      '₹${totalPrice?.toStringAsFixed(2)}', languageService),
                  _buildPriceRow(languageService.getString('discount'), '₹5.00',
                      languageService),
                  _buildPriceRow(languageService.getString('delivery_charge'),
                      '₹20.00', languageService),
                  Divider(color: Colors.white70, thickness: 1.h),
                  _buildPriceRow(
                      languageService.getString('grand_total'),
                      '₹${(totalPrice + 15).toStringAsFixed(2)}',
                      languageService,
                      isBold: true),
                ],
              );
            },
          ),
          SizedBox(height: 30.h),
          Text(
            languageService.getString('payment_method'),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          _buildPaymentOption(languageService.getString('cash_on_delivery')),
          _buildPaymentOption("Online Payment / UPI", isDisabled: true),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddress(
                            Deliverytype: selectedPaymentMethod,
                            deliveryCharge: 20,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5E9B5),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                languageService.getString('place_order'),
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String label, String price, LanguageService languageService,
      {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18.sp : 16.sp,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18.sp : 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method, {bool isDisabled = false}) {
    return GestureDetector(
      onTap: isDisabled
          ? null
          : () => setState(() => selectedPaymentMethod = method),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selectedPaymentMethod == method
                  ? Color(0xFFF5E9B5)
                  : Colors.transparent,
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                method,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                selectedPaymentMethod == method
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Color(0xFFF5E9B5),
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouriteItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final String productId;
  final LanguageService languageService;

  const FavouriteItemCard({
    Key? key,
    required this.item,
    required this.productId,
    required this.languageService,
  }) : super(key: key);

  @override
  State<FavouriteItemCard> createState() => _FavouriteItemCardState();
}

class _FavouriteItemCardState extends State<FavouriteItemCard> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = (widget.item['quantity'] as int?) ?? 1;
  }

  void _updateQuantity(BuildContext context, String? type, String productId) {
    context.read<UpdateCartBloc>().add(UpdateCartQuantity(
          productId: productId,
          type: type!,
        ));
  }

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final price = _parseDouble(widget.item['price']) ?? 0.0;
    final mrp = _parseDouble(widget.item['mrp']) ?? 1.0;
    final discountPercentage =
        mrp > 0 ? ((1 - price / mrp) * 100).toStringAsFixed(0) : '0';

    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0808),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xDBFCF8E8), width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 106.w,
            height: 110.h,
            decoration: BoxDecoration(
              color: Color(0xF4CCC9BC),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: widget.item['image'] != null
                ? (widget.item['image'].toString().startsWith('http')
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                          widget.item['image'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/placeholder.png',
                                  fit: BoxFit.contain),
                        ),
                    )
                    : Image.asset(
                        widget.item['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/placeholder.png',
                                fit: BoxFit.contain),
                      ))
                : Image.asset('assets/placeholder.png', fit: BoxFit.contain),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 9.h),
                Text(
                  widget.item['name'] as String? ??
                      widget.languageService.getString('no_name'),
                  style: GoogleFonts.poppins(
                    color: Color(0xFFFCF8E8),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      '${widget.languageService.getString('mrp')} ₹${mrp.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Color(0xCEB4B2A9),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 40.w),
                    Text(
                      '₹${price.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        color: Color(0xFFFCF8E8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$discountPercentage% ${widget.languageService.getString('discount_20_off').split(' ').last}',
                  style: GoogleFonts.poppins(
                    color: Color(0xCE7FFC83),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 38.h,
            width: 90.w,
            decoration: BoxDecoration(
              color: Color(0xFFEFECE1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() => count > 1 ? count-- : count = 1);
                    _updateQuantity(context, 'decrease', widget.productId);
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                    size: 20.w,
                  ),
                ),
                Spacer(),
                Text(
                  '$count',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() => count++);
                    _updateQuantity(context, 'increase', widget.productId);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 20.w,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Widget _buildCartItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0808),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xDBFCF8E8), width: 1.w),
        ),
        child: Row(
          children: [
            Container(
              width: 106.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 150.w, height: 20.h, color: Colors.black),
                  SizedBox(height: 10.h),
                  Container(width: 100.w, height: 14.h, color: Colors.black),
                ],
              ),
            ),
            Container(
              height: 38.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
