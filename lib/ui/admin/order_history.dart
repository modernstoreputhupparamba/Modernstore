import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modern_grocery/bloc/Orders/Get_All_Order/get_all_orders_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllOrdersBloc>().add(FetchGetAllOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0A0909),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildAppBar(),
          SizedBox(height: 40.h),
          _buildSearchBar(),
          SizedBox(height: 20.h),
          _buildOrderHistoryBloc(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Spacer(), // Uses available space to push items to the right
        badges.Badge(
          badgeContent: const Text('3', style: TextStyle(color: Colors.white)),
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          child: SvgPicture.asset('assets/Group.svg'),
        ),
        SizedBox(width: 16),
        IconButton(
          icon: SvgPicture.asset('assets/Group 6918.svg'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search here",
                hintStyle: TextStyle(color: const Color(0x91FCF8E8)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0xFFFCF8E8), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0xFFFCF8E8), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SvgPicture.asset('assets/filter.svg'),
          )
        ],
      ),
    );
  }

  Widget _buildOrderHistoryBloc() {
    return BlocBuilder<GetAllOrdersBloc, GetAllOrdersState>(
      builder: (context, state) {
        if (state is GetAllOrdersLoading) {
          return Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => Card(
                  color: Colors.white.withOpacity(0.1),
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: SizedBox(height: 150.h),
                ),
              ),
            ),
          );
        }

        if (state is GetAllOrdersError) {
          return Center(
            child: Text(
              'Failed to load orders: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is GetAllOrdersLoaded) {
          final orders = state.getAllOrdersModel.orders ?? [];
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.white.withOpacity(0.1),
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Invoice Number and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice: #${order.id?.substring(0, 8) ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.createdAt?.toString().substring(0, 16) ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // Name
                        Text(
                          'Name: ${order.userId?.name ?? 'Unknown User'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Quantity and Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items: ${order.orderItems?.length ?? 0}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              'Amount: ₹${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // Order Details
                        Text(
                          'Status: ${order.orderStatus ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Print Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add print functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                            ),
                            child: Text(
                              'Print',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
            child: Text('No orders yet.', style: TextStyle(color: Colors.white)));
      },
    );
  }
}
