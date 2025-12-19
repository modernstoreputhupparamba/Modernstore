import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Login_/verify/verify_bloc.dart';
import 'package:modern_grocery/bloc/Login_/verify/verify_event.dart';
import 'package:modern_grocery/repositery/model/user/getUserDlvAddresses.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/admin/admin_navibar.dart';
import 'package:modern_grocery/ui/auth_/enter_screen.dart';
import 'package:modern_grocery/ui/location/location_page.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:modern_grocery/widgets/fontstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottom_navigationbar.dart';

class VerifyScreen extends StatefulWidget {
  final String PhoneNo; // Display format: +91 1234567890

  const VerifyScreen({
    super.key,
    required this.PhoneNo,
    required String phoneNumber,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  bool isLoading = false;
  bool isAdmin = true;
  bool isLoadingAdminStatus = true;
  String UserId = '';

  String cleanNumber(String number) {
    return number.replaceAll(RegExp(r'^\+91'), '');
  }

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  // --- Check Admin Status ---
  Future<void> _checkAdminStatus() async {
    setState(() {
      isLoadingAdminStatus = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      final userType = prefs.getString('userType');
      final isAdminFlag = prefs.getBool('isAdmin');
      UserId = prefs.getString('userId')!;

      // Determine if user is admin based on stored values
      final bool isAdminResult = role == 'admin' ||
          role == 'Admin' ||
          userType == 'admin' ||
          userType == 'Admin' ||
          isAdminFlag == true;

      if (mounted) {
        setState(() {
          isAdmin = isAdminResult;
          isLoadingAdminStatus = false;
        });
      }
    } catch (e) {
      print("Error checking admin status: $e");

      if (mounted) {
        setState(() {
          isAdmin = false;
          isLoadingAdminStatus = false;
        });
      }
    }
  }

  void _handleVerify(BuildContext context) {
    final otp = getOTP();
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            languageService.getString('please_enter_complete_otp'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    BlocProvider.of<VerifyBloc>(context).add(
      fetchVerifyOTPEvent(
        phoneNumber: widget.PhoneNo,
        otp: otp,
      ),
    );
  }

  void _handleResendOTP(BuildContext context) {
    for (var controller in otpControllers) {
      controller.clear();
    }
    if (mounted) {
      focusNodes[0].requestFocus();
    }

    BlocProvider.of<VerifyBloc>(context).add(
      ResendOTPRequested(phoneNumber: widget.PhoneNo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<VerifyBloc, VerifyState>(
          listener: (context, state) {
            ScaffoldMessenger.of(context).clearSnackBars();

            if (state is VerifySuccess) {
              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    languageService.getString('verification_success'),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isAdmin
                              ? AdminNavibar()
                              : UserId.isEmpty
                                  ? NavigationBarWidget()
                                  : LocationPage()));
                }
              });
            } else if (state is VerifyError) {
              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("filed_verfication"),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );

              for (var controller in otpControllers) {
                controller.clear();
              }
              if (mounted) {
                focusNodes[0].requestFocus();
              }
            } else if (state is OTPResent) {
              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    languageService.getString('otp_resent'),
                  ),
                  backgroundColor: Colors.blue, // Use blue for info
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is VerifyLoading) {
              setState(() => isLoading = true);

              // Optional: Show a persistent "Verifying..." SnackBar
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Row(
              //       children: [
              //         const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              //         const SizedBox(width: 20),
              //         Text(languageService.getString('processing')),
              //       ],
              //     ),
              //     duration: const Duration(seconds: 30), // Long duration, cleared on success/error
              //   ),
              // );
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0XFF0A0909),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(
                color: Color(0xffFCF8E8),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterScreen(),
                      ));
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h),

                    Text(
                      languageService.getString('enter_verification_code'),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF5E9B5),
                        fontSize: 29.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.38,
                      ),
                    ),
                    Text(
                      languageService.getString('sent_on_whatsapp'),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFF5E9B5),
                        fontSize: 29.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.38,
                      ),
                    ),
                    SizedBox(height: 25.h),

                    Text(
                      '${languageService.getString('sent_to')} +91${widget.PhoneNo}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xB7FCF8E8),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 56.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 58.w,
                          height: 58.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0808),
                            border: Border.all(
                              width: 1.w,
                              color: focusNodes[index].hasFocus
                                  ? const Color(0xFFF5E9B5)
                                  : const Color(0xFFFCF8E8),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: otpControllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: GoogleFonts.poppins(
                              color: Color(0xFFFCF8E8),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              setState(() {});

                              if (value.isNotEmpty && index < 5) {
                                if (mounted)
                                  focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                // Move to previous field on backspace
                                if (mounted)
                                  focusNodes[index - 1].requestFocus();
                              }

                              if (index == 5 && value.isNotEmpty) {
                                final otp = getOTP();
                                if (otp.length == 6) {
                                  FocusScope.of(context).unfocus();

                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    if (mounted) _handleVerify(context);
                                  });
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 56.h),

                    Center(
                      child: GestureDetector(
                        onTap:
                            isLoading ? null : () => _handleResendOTP(context),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: languageService
                                    .getString('didnt_receive_code'),
                                style: GoogleFonts.poppins(
                                  color: const Color(0xD8FCF8E8),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' ', // Add space
                                style: GoogleFonts.poppins(fontSize: 13.sp),
                              ),
                              TextSpan(
                                text: languageService.getString('resend_code'),
                                style: GoogleFonts.poppins(
                                  color: isLoading
                                      ? const Color(
                                          0x80F5E9B5) // Dim if loading
                                      : const Color(0xFFF5E9B5),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    Center(
                      child: GestureDetector(
                        onTap: isLoading ? null : () => _handleVerify(context),
                        child: Container(
                          width: 281.w,
                          height: 54.h,
                          decoration: ShapeDecoration(
                            color: isLoading
                                ? appColor.loadingColor
                                : appColor.textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      color: appColor.textColor3,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    languageService.getString('verify'),
                                    style: fontStyles.bodyText2.copyWith(
                                      color: appColor.textColor3,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
