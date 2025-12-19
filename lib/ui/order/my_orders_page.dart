import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Orders/Get_All_Order/get_all_orders_bloc.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch orders when page loads
    context.read<GetAllOrdersBloc>().add(FetchGetAllOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0A0909),
          appBar: AppBar(
            backgroundColor: const Color(0XFF0A0909),
            elevation: 0,
            leading: const BackButton(color: Color(0xffFCF8E8)),
            title: Text(
              languageService.getString('my_orders'),
              style: GoogleFonts.poppins(
                color: const Color(0xFFFCF8E8),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFF5E9B5),
              labelColor: const Color(0xFFF5E9B5),
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: languageService.getString('all')),
                Tab(text: languageService.getString('delivered')),
                Tab(text: languageService.getString('cancelled')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList("All"),
              _buildOrderList("Delivered"),
              _buildOrderList("Cancelled"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderList(String filterStatus) {
    return BlocBuilder<GetAllOrdersBloc, GetAllOrdersState>(
      builder: (context, state) {
        if (state is GetAllOrdersLoading) {
          return _buildShimmerLoading();
        } else if (state is GetAllOrdersError) {
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        } else if (state is GetAllOrdersLoaded) {
          var orders = state.getAllOrdersModel.orders ?? [];

          // Filter logic
          if (filterStatus == "Delivered") {
            orders = orders
                .where((order) =>
                    order.orderStatus?.toLowerCase() == 'delivered')
                .toList();
          } else if (filterStatus == "Cancelled") {
            orders = orders
                .where((order) =>
                    order.orderStatus?.toLowerCase() == 'cancelled')
                .toList();
          }
          // "All" includes everything

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 60.sp, color: Colors.white24),
                  SizedBox(height: 10.h),
                  Text(
                    Provider.of<LanguageService>(context)
                        .getString('no_orders_found'),
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            itemCount: orders.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${order.orderNo ?? order.id?.substring(0, 8) ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _buildStatusBadge(order.orderStatus ?? 'Pending'),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Items: ${order.orderItems?.length ?? 0}",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "₹${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFF5E9B5),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    const Divider(color: Colors.white12),
                    SizedBox(height: 8.h),
                    Text(
                      _formatDate(order.createdAt),
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'processing':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[800]!,
          child: Container(
            height: 140.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }
}