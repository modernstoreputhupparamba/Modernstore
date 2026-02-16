import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:provider/provider.dart';

import '../../bloc/delivery_/userdelivery addrees/userdeliveryaddress_bloc.dart';
import 'add_new_address_page.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserdeliveryaddressBloc()..add(FetchUserdeliveryaddressEvent()),
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return Scaffold(
            backgroundColor: const Color(0XFF0A0909),
            appBar: AppBar(
              backgroundColor: const Color(0XFF0A0909),
              leading: const BackButton(color: Color(0xffFCF8E8)),
              title: Text(
                languageService.getString('my_address'),
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFCF8E8),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<UserdeliveryaddressBloc,
                        UserdeliveryaddressState>(
                      builder: (context, state) {
                        if (state is UserdeliveryaddressLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFFF5E9B5)));
                        } else if (state is UserdeliveryaddressError) {
                          return Center(
                              child: Text(state.message,
                                  style: GoogleFonts.poppins(color: Colors.red)));
                        } else if (state is UserdeliveryaddressLoaded) {
                          final addresses =
                              state.addresses.data ?? [];
                          if (addresses.isEmpty) {
                            return Center(
                                child: Text("No addresses found",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)));
                          }
                          return ListView.separated(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final item = addresses[index];
                              String fullAddress = item.address ?? "";
                              if (item.city != null) fullAddress += ", ${item.city}";
                              if (item.pincode != null) fullAddress += ", ${item.pincode}";
                              return _buildAddressCard('Home', fullAddress);
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 20.h),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5E9B5),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddNewAddressPage()),
                      ).then((_) {
                        if (context.mounted) {
                          context
                              .read<UserdeliveryaddressBloc>()
                              .add(FetchUserdeliveryaddressEvent());
                        }
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: Text(
                      languageService.getString('add_new_address'),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
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

  Widget _buildAddressCard(String type, String address) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0xffC4C1B4)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Color(0xFFF5E9B5)),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              address,
              style: GoogleFonts.poppins(
                  color: const Color(0xFFFCF8E8), fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}