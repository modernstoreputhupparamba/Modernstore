import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modern_grocery/bloc/Orders/Get_All_Order/get_all_orders_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';
import 'admin_order_details_page.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String _selectedFilter = 'All';

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
        BlocBuilder<GetAllOrdersBloc, GetAllOrdersState>(
          builder: (context, state) {
            int count = 0;
            if (state is GetAllOrdersLoaded) {
              count = state.getAllOrdersModel.orders
                      ?.where((element) =>
                          element.orderStatus?.toUpperCase() == 'ORDER_PLACED')
                      .length ??
                  0;
            }
            return badges.Badge(
              badgeContent:
                  Text('$count', style: const TextStyle(color: Colors.white)),
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              showBadge: count > 0,
              child: SvgPicture.asset('assets/Group.svg'),
            );
          },
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
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFCF8E8), width: 2)
            ),
            child: PopupMenuButton<String>(
              icon: SvgPicture.asset('assets/filter.svg'),
              color: const Color(0xFF1C1C1C),
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF333333)),
              ),
              onSelected: (String value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['All', 'Pending', 'Confirmed', 'Shipped', 'Out_for_Delivery', 'Delivered', 'Cancelled']
                    .map((String choice) {
                  String label = choice.replaceAll('_', ' ');
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: _selectedFilter == choice ? const Color(0xFFF5E9B5) : Colors.white,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
          var orders = state.getAllOrdersModel.orders?.reversed.toList() ?? [];

          if (_selectedFilter != 'All') {
            orders = orders.where((order) {
              final status = order.orderStatus?.toLowerCase() ?? '';
              final filter = _selectedFilter.toLowerCase();
              if (filter == 'pending') {
                return status == 'pending' || status == 'order_placed';
              }
              return status == filter;
            }).toList();
          }

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GetAllOrdersBloc>().add(FetchGetAllOrders());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminOrderDetailsPage(order: order),
                      ),
                    );
                  },
                  child: Card(
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
                                order.createdAt?.toString().substring(0, 16) ??
                                    '',
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
                            'Name: ${_getUserName(order.userId)}',
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
                                _printOrder(order);
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
                  ),
                );
              },
            ),
            ),
          );
        }
        return const Center(
            child: Text('No orders yet.', style: TextStyle(color: Colors.white)));
      },
    );
  }

  Future<void> _printOrder(dynamic order) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('INVOICE',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice #: ${order.id?.substring(0, 8) ?? 'N/A'}'),
                  pw.Text(
                      'Date: ${order.createdAt?.toString().substring(0, 10) ?? ''}'),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Customer: ${_getUserName(order.userId)}'),
              pw.Text('Phone: ${_getUserPhone(order.userId)}'),
              pw.Text('Address: ${_getAddress(order.shippingAddress)}'),
              
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: <String>['Item', 'Price', 'Qty', 'Amount'],
                data: order.orderItems?.map<List<String>>((item) {
                      String productName = 'Product';
                      try {
                        productName = (item.productId as dynamic)?.name ?? 'Product';
                      } catch (_) {
                        if (item.productId is Map) {
                          productName = item.productId['name'] ?? 'Product';
                        }
                      }

                      double total = (item.itemTotalAmount ?? 0).toDouble();
                      double qty = (item.quantity ?? 1).toDouble();
                      double unitPrice = qty > 0 ? total / qty : 0;

                      return [
                        productName,
                        unitPrice.toStringAsFixed(2),
                        '${item.quantity}',
                        total.toStringAsFixed(2)
                      ];
                    }).toList() ??
                    [],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                      'Total: ${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  String _getUserName(dynamic userId) {
    if (userId == null) return 'Unknown User';
    if (userId is Map) {
      return userId['name']?.toString() ?? 'Unknown User';
    }
    if (userId is String) return userId;
    try {
      return userId.name?.toString() ?? 'Unknown User';
    } catch (_) {
      return 'Unknown User';
    }
  }

  String _getUserPhone(dynamic userId) {
    if (userId == null) return 'N/A';
    if (userId is Map) {
      return userId['phoneNumber']?.toString() ?? 'N/A';
    }
    try {
      return (userId as dynamic).phoneNumber?.toString() ?? 'N/A';
    } catch (_) {
      return 'N/A';
    }
  }

  String _getAddress(dynamic shippingAddress) {
    if (shippingAddress == null) return 'N/A';
    if (shippingAddress is String) return shippingAddress;
    if (shippingAddress is Map) {
      String addr = shippingAddress['address']?.toString() ?? '';
      String city = shippingAddress['city']?.toString() ?? '';
      String pincode = shippingAddress['pincode']?.toString() ?? '';
      List<String> parts = [addr, city, pincode].where((s) => s.isNotEmpty).toList();
      return parts.isNotEmpty ? parts.join(', ') : 'N/A';
    }
    return 'N/A';
  }
}
