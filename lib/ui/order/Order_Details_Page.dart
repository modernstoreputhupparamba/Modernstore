import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Orders/Cancel_order/cancel_order_bloc.dart';
import 'package:modern_grocery/repositery/model/Orders/Get_user_order_Model.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatelessWidget {
  final Orders order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelOrderBloc, CancelOrderState>(
        listener: (context, state) {
      if (state is CancelOrderLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFFF5E9B5)),
          ),
        );
      } else if (state is CancelOrderLoaded) {
        Navigator.pop(context); // Close loading dialog
        if (state.cancelOrderModel.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.cancelOrderModel.message ??
                  "Order cancelled successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Return to previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.cancelOrderModel.message ??
                    "Failed to cancel order")),
          );
        }
      } else if (state is CancelOrderError) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, child: Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0A0909),
          appBar: AppBar(
            backgroundColor: const Color(0XFF0A0909),
            elevation: 0,
            leading: const BackButton(color: Color(0xffFCF8E8)),
            title: Text(
              "Order Details",
              style: GoogleFonts.poppins(
                color: const Color(0xFFFCF8E8),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section (ID, Date, Status)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow("Order ID",
                          order.orderNo ?? order.id?.substring(0, 8) ?? "N/A"),
                      SizedBox(height: 10.h),
                      _buildInfoRow("Date", _formatDate(order.createdAt)),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: GoogleFonts.poppins(
                                color: Colors.white70, fontSize: 14.sp),
                          ),
                          _buildStatusBadge(order.orderStatus ?? "Pending"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Items Section
                Text(
                  "Items",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFCF8E8),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.orderItems?.length ?? 0,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = order.orderItems![index];
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  "Product Name: ${item.productId?.name ?? 'N/A'}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 14.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "Qty: ${item.quantity}",
                                style: GoogleFonts.poppins(
                                    color: Colors.white54, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Text(
                            "₹${item.itemTotalAmount?.toStringAsFixed(2) ?? '0.00'}",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFFF5E9B5),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Shipping & Payment
                _buildInfoRow(
                  languageService.getString('address'),
                  [
                    order.shippingAddress?.address,
                    order.shippingAddress?.city,
                    order.shippingAddress?.pincode,
                  ].where((e) => e != null && e!.isNotEmpty).join(', '),
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(languageService.getString('payment_method'),
                    order.paymentMethod?.toString() ?? "N/A"),

                SizedBox(height: 24.h),
                Divider(color: Colors.white24),
                SizedBox(height: 10.h),

                // Price Breakdown
                _buildInfoRow(languageService.getString('price'),
                    "₹${order.itemsTotalAmount?.toStringAsFixed(2) ?? '0.00'}"),
                SizedBox(height: 8.h),
                _buildInfoRow(languageService.getString('delivery_charge'),
                    "₹${order.deliveryCharge?.toStringAsFixed(2) ?? '0.00'}"),
                SizedBox(height: 12.h),
                _buildInfoRow(languageService.getString('grand_total'),
                    "₹${order.finalAmount?.toStringAsFixed(2) ?? '0.00'}",
                    isBold: true),
                SizedBox(height: 30.h),
                if (order.orderStatus?.toLowerCase() != 'delivered' &&
                    order.orderStatus?.toLowerCase() != 'cancelled')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (order.id != null) {
                          _showCancelReasonDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Cancel Order",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 180.w,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: isBold ? 16.sp : 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              color: isBold ? const Color(0xFFF5E9B5) : Colors.white,
              fontSize: isBold ? 16.sp : 14.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status.toLowerCase() == 'delivered'
        ? Colors.green
        : (status.toLowerCase() == 'cancelled' ? Colors.red : Colors.orange);
    return Text(status,
        style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold));
  }

  void _showCancelReasonDialog(BuildContext context) {
    final cancelOrderBloc = context.read<CancelOrderBloc>();
    final List<String> reasons = [
      "Changed my mind",
      "Ordered by mistake",
      "Found a better price",
      "Delivery time too long",
      "Other"
    ];
    String selectedReason = reasons[0];
    TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1C),
              title: Text(
                "Select Cancellation Reason",
                style:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 18.sp),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...reasons.map((reason) {
                      return RadioListTile<String>(
                        title: Text(
                          reason,
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 14.sp),
                        ),
                        value: reason,
                        groupValue: selectedReason,
                        activeColor: const Color(0xFFF5E9B5),
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value!;
                          });
                        },
                      );
                    }),
                    if (selectedReason == "Other")
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: TextField(
                          controller: otherReasonController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter reason...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color(0xFF333333),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("Cancel",
                      style: GoogleFonts.poppins(color: Colors.white54)),
                ),
                TextButton(
                  onPressed: () {
                    String finalReason = selectedReason;
                    if (selectedReason == "Other") {
                      if (otherReasonController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please enter a reason")),
                        );
                        return;
                      }
                      finalReason = otherReasonController.text.trim();
                    }
                    Navigator.pop(dialogContext);
                    cancelOrderBloc.add(
                        CancelOrder(orderId: order.id!, reason: finalReason));
                  },
                  child: Text("Confirm",
                      style:
                          GoogleFonts.poppins(color: const Color(0xFFF5E9B5))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateStr;
    }
  }
}
