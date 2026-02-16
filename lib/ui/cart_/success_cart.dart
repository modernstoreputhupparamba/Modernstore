import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:provider/provider.dart';

class SuccessCart extends StatefulWidget {
  const SuccessCart({super.key});

  @override
  State<SuccessCart> createState() => _SuccessCartState();
}

class _SuccessCartState extends State<SuccessCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _shadowAnimation;
  bool _showSecondImage = false;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(
          milliseconds: 800), // Very slow blink - 1 second each way
      vsync: this,
    );

    _shadowAnimation = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Very very very slow blink animation (3 blinks) - only shadow

    // First blink - very slow
    await _blinkController.forward();
    await _blinkController.reverse();
    await Future.delayed(const Duration(milliseconds: 800));

    // Second blink - very slow
    await _blinkController.forward();
    await _blinkController.reverse();
    await Future.delayed(const Duration(milliseconds: 800));

    // Third blink - very slow
    await _blinkController.forward();
    await _blinkController.reverse();

    // Wait before switching to second image
    await Future.delayed(const Duration(milliseconds: 1000));

    // Switch to second image
    if (mounted) {
      setState(() {
        _showSecondImage = true;
      });
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
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
              children: [
                SizedBox(height: 316.h),
                SizedBox(
                  height: 184.h,
                  width: 184.w,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: !_showSecondImage
                        ? AnimatedBuilder(
                            key: const ValueKey('firstImage'),
                            animation: _shadowAnimation,
                            builder: (context, child) {
                              return Container(
                                height: 154.h,
                                width: 154.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF5E9B5)
                                          .withOpacity(_shadowAnimation.value),
                                      blurRadius: 30,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/cart.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 184.h,
                            width: 184.w,
                            child: Image.asset(
                              key: const ValueKey('secondImage'),
                              'assets/Property 1=Variant7 (2).png',
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  languageService.getString(
                    'successfully added to cart',
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF5E9B5),
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
