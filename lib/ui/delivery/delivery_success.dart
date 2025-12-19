import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:provider/provider.dart';

import '../bottom_navigationbar.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Uncomment if using SVG

class DeliverySuccess extends StatefulWidget {
  const DeliverySuccess({super.key});

  @override
  State<DeliverySuccess> createState() => _DeliverySuccessState();
}

class _DeliverySuccessState extends State<DeliverySuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

@override
void initState() {
  super.initState();

  _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );

  // Navigate when animation finishes
  _controller.addStatusListener((status) {
    if (status == AnimationStatus.completed && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const NavigationBarWidget(),
        ),
        (route) => false,
      );
    }
  });

  // Slight delay before animation starts (optional)
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) {
      _controller.forward();
    }
  });
}


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;

    _animation = Tween<double>(
      begin: -100.0, // Start from left side (off-screen)
      end: screenWidth + 100.0, // End at right side (off-screen)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth acceleration and deceleration
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0A0909),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200.h,
                ),
                SizedBox(
                  height: 120.h,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated vehicle
                          Positioned(
                            left: _animation.value,
                            bottom: 20.h,
                            child: Container(
                              height: 90.h,
                              width: 120.w,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/In Transit.png',
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 50.h),
                Text(
                  languageService.getString(
                    'Fast, secure, and at your doorstep\nwithin 1 hour!',
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: appColor.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
