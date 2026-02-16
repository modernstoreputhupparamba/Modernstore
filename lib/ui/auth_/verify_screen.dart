import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Login_/verify/verify_bloc.dart';
import 'package:modern_grocery/bloc/Login_/verify/verify_event.dart';
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
  final String phoneNo;

  const VerifyScreen({
    super.key,
    required this.phoneNo,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(6, (index) => FocusNode());

  bool isLoading = false;
  bool isAdmin = false;
  bool isLoadingAdminStatus = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNodes[0].requestFocus();
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
    return otpControllers.map((c) => c.text).join();
  }

  // ✅ Check Admin Status Safely
  Future<void> _checkAdminStatus() async {
    setState(() => isLoadingAdminStatus = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      final role = prefs.getString('role');
      final userType = prefs.getString('userType');
      final isAdminFlag = prefs.getBool('isAdmin');
      userId = prefs.getString('userId') ?? '';

      final bool isAdminResult = role?.toLowerCase() == 'admin' ||
          userType?.toLowerCase() == 'admin' ||
          isAdminFlag == true;

      if (mounted) {
        setState(() {
          isAdmin = isAdminResult;
          isLoadingAdminStatus = false;
        });
      }
    } catch (e) {
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
        phoneNumber: widget.phoneNo,
        otp: otp,
      ),
    );
  }

  void _handleResendOTP(BuildContext context) {
    for (var controller in otpControllers) {
      controller.clear();
    }

    focusNodes[0].requestFocus();

    BlocProvider.of<VerifyBloc>(context).add(
      ResendOTPRequested(phoneNumber: widget.phoneNo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<VerifyBloc, VerifyState>(
          listener: (context, state) {
            ScaffoldMessenger.of(context).clearSnackBars();

            if (state is VerifyLoading) {
              setState(() => isLoading = true);
            }

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
                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      if (isAdmin) {
                        return AdminNavibar();
                      } else {
                        return userId.isEmpty
                            ? LocationPage()
                            : NavigationBarWidget(initialIndex: 0);
                      }
                    },
                  ),
                );
              });
            }

            if (state is VerifyError) {
              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed verification"),
                  backgroundColor: Colors.red,
                ),
              );

              for (var controller in otpControllers) {
                controller.clear();
              }

              focusNodes[0].requestFocus();
            }

            if (state is OTPResent) {
              setState(() => isLoading = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    languageService.getString('otp_resent'),
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0XFF0A0909),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(
                color: const Color(0xffFCF8E8),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EnterScreen(),
                    ),
                  );
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
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      '${languageService.getString('sent_to')} ${widget.phoneNo}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xB7FCF8E8),
                        fontSize: 17.sp,
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
                          child: Focus(
                            onFocusChange: (_) => setState(() {}),
                            child: TextField(
                              controller: otpControllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFFCF8E8),
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }

                                if (getOTP().length == 6) {
                                  FocusScope.of(context).unfocus();
                                  _handleVerify(context);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 56.h),

                    Center(
                      child: GestureDetector(
                        onTap:
                            isLoading ? null : () => _handleResendOTP(context),
                        child: Text(
                          languageService.getString('resend_code'),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFF5E9B5),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    Center(
                      child: GestureDetector(
                        onTap:
                            isLoading ? null : () => _handleVerify(context),
                        child: Container(
                          width: 281.w,
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: isLoading
                                ? appColor.loadingColor
                                : appColor.textColor,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : Text(
                                    languageService.getString('verify'),
                                    style: fontStyles.bodyText2.copyWith(
                                      color: appColor.textColor3,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
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
