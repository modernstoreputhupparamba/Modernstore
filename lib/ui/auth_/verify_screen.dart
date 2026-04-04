import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/Login_/Send_otp/send_otp_bloc.dart';
import 'package:modern_grocery/bloc/Login_/login/login_bloc.dart';
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
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNodes[0].requestFocus();
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
  }

  @override
  void dispose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String getOTP() => otpControllers.map((c) => c.text).join();

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

    context.read<LoginBloc>().add(
          fetchlogin(
            phoneNumber: '91${widget.phoneNo}',
            otp: otp,
          ),
        );
  }

  void _handleResendOTP(BuildContext context) {
    for (var controller in otpControllers) {
      controller.clear();
    }

    focusNodes[0].requestFocus();

    context.read<SendOtpBloc>().add(
          SendOtpRequested(phoneNumber: '91${widget.phoneNo}'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            ScaffoldMessenger.of(context).clearSnackBars();

            if (state is loginBlocLoading) {
              setState(() => isLoading = true);
            }

            if (state is loginBlocLoaded) {
              setState(() => isLoading = false);

              final token = state.login.accessToken ?? '';
              final userType = state.login.user?.role ?? '';
              final userId = state.login.user?.id ?? '';
              final role=state.login.user!.role;

              final prefs = await SharedPreferences.getInstance();

              final results = await Future.wait([
                prefs.setString('token', token),
                prefs.setString('userType', userType),
                prefs.setString('role', role!),
                prefs.setString('number', widget.phoneNo),
                prefs.setString('userId', userId),
                prefs.setBool('isLoggedIn', true),


              ]);

              final isSaved = !results.contains(false);

              // 🔥 Determine admin AFTER saving
              final bool isAdmin = userType?.toLowerCase() == 'admin';

              if (!mounted) return;

              if (isSaved) {
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
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Failed to save data locally. Please try again."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }

            if (state is loginBlocError) {
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
                        onTap: isLoading ? null : () => _handleVerify(context),
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
