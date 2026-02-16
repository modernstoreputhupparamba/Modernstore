import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modern_grocery/bloc/Login_/login/login_bloc.dart';

import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/auth_/verify_screen.dart';
import 'package:modern_grocery/ui/location/location_page.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:modern_grocery/widgets/fontstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = '+91';
  String selectedCountryFlag = '🇮🇳';
  bool isLoading = false; // This will now be controlled by the BlocListener

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    final fullPhoneNumber = phoneController.text.trim();
    print('Logging in with $fullPhoneNumber');

    BlocProvider.of<LoginBloc>(context).add(fetchlogin(
      phoneNumber: fullPhoneNumber,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is loginBlocLoaded) {
              // --- FIX: Stop loading ---
              setState(() {
                isLoading = false;
              });

              final token = state.login.accessToken;
              final userType = state.login.user?.role;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token!);
              await prefs.setString('userType', userType!);
              print('token saved: $token');

              final String numberToSave = phoneController.text.trim();
              await prefs.setString('number', numberToSave);
              print('Number saved: $numberToSave');

              if (!mounted) return; // Check if widget is still mounted
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyScreen(
                    phoneNo:
                        '${phoneController.text.trim()}',
                  ),
                ),
              );
            } else if (state is loginBlocError) {
              // --- FIX: Stop loading ---
              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // --- REFACTORED SNACKBAR ---
                  content: Text(
                    languageService.getString(
                      'login_error',
                    ),
                    style: fontStyles.errorstyle2, // White text
                  ),
                  backgroundColor: appColor.errorColor, // Use appColor
                ),
              );
            } else if (state is loginBlocLoading) {
              // --- FIX: Start loading ---
              setState(() {
                isLoading = true;
              });
            }
          },
          child: Scaffold(
            backgroundColor: appColor.backgroundColor, // Use appColor
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.05 * screenWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.05 * screenHeight),

                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF1C1C1C),
                                  title: Text(
                                    // --- REFACTORED STYLE ---
                                    languageService.getString(
                                      'skip_warning_title',
                                    ),
                                    style: fontStyles.heading2.copyWith(
                                      color: appColor.textColor,
                                    ),
                                  ),
                                  content: Text(
                                    // --- REFACTORED STYLE ---
                                    languageService.getString(
                                      'skip_warning_message',
                                    ),
                                    style: fontStyles.primaryTextStyle.copyWith(
                                      color: appColor.textColor2,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        // --- REFACTORED STYLE ---
                                        languageService.getString(
                                          'cancel',
                                        ),
                                        style: fontStyles.primaryTextStyle
                                            .copyWith(
                                          color: appColor.textColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LocationPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        // --- REFACTORED STYLE ---
                                        languageService.getString(
                                          'continue',
                                        ),
                                        style: fontStyles.heading2.copyWith(
                                          color: appColor.errorColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 55.w,
                            height: 27.h,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0.00, -1.00),
                                end: Alignment(0, 1),
                                colors: [Color(0xFFF5E9B5), Color(0xFF8F8769)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                // --- REFACTORED STYLE ---
                                languageService.getString(
                                  'skip',
                                ),
                                style: fontStyles.caption.copyWith(
                                  color: appColor.textColor3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 0.08 * screenHeight),

                      // Logo image with shadow
                      Center(
                        child: SizedBox(
                          width: 0.7 * screenWidth,
                          height: 0.25 * screenHeight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 0.6 * screenWidth,
                                  height: 37.h,
                                  decoration: const ShapeDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(1.00, 0.00),
                                      end: Alignment(-1, 0),
                                      colors: [
                                        Color(0xFFFFFDD4),
                                        Color(0xC1FCF8E8)
                                      ],
                                    ),
                                    shape: OvalBorder(),
                                  ),
                                ),
                              ),
                              Image.asset(
                                "assets/Group 3 (1).png",
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 0.05 * screenHeight),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.02 * screenWidth),
                        child: Text(
                          // --- REFACTORED STYLE ---
                          languageService.getString(
                            'enter_your_number',
                          ),
                          style: fontStyles.heading2.copyWith(
                            color: appColor.textColor,
                            fontSize: 25.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 13.h),

                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.02 * screenWidth),
                        child: Text(
                          // --- REFACTORED STYLE ---
                          languageService.getString(
                            'mobile_number',
                          ),
                          style: fontStyles.primaryTextStyle.copyWith(
                            color: appColor.textColor2,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Phone input
                      Row(
                        children: [
                          // Country code dropdown
                          Container(
                            width: 0.2 * screenWidth,
                            height: 54.h,
                            decoration: ShapeDecoration(
                              color: appColor.textColor3, // Use appColor
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 2, color: appColor.textColor2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: DropdownButton<String>(
                                value: selectedCountryFlag,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: appColor.iconColor), // Use appColor
                                isExpanded: true,
                                underline: Container(),
                                dropdownColor: appColor.textColor3,
                                items: [
                                  DropdownMenuItem(
                                    value: '🇮🇳',
                                    child: Center(
                                      child: Text(
                                        '🇮🇳 +91',
                                        // --- REFACTORED STYLE ---
                                        style: fontStyles.primaryTextStyle
                                            .copyWith(
                                          color: appColor.textColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '🇺🇸',
                                    child: Center(
                                      child: Text(
                                        '🇺🇸 +1',
                                        // --- REFACTORED STYLE ---
                                        style: fontStyles.primaryTextStyle
                                            .copyWith(
                                          color: appColor.textColor,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: '🇬🇧',
                                    child: Center(
                                      child: Text(
                                        '🇬🇧 +44',
                                        // --- REFACTORED STYLE ---
                                        style: fontStyles.primaryTextStyle
                                            .copyWith(
                                          color: appColor.textColor,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedCountryFlag = value!;
                                    if (value == '🇮🇳')
                                      selectedCountryCode = '+91';
                                    if (value == '🇺🇸')
                                      selectedCountryCode = '+1';
                                    if (value == '🇬🇧')
                                      selectedCountryCode = '+44';
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 0.02 * screenWidth),

                          // Phone input
                          Expanded(
                            child: Container(
                              height: 54.h,
                              decoration: ShapeDecoration(
                                color: appColor.textColor3, // Use appColor
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2, color: appColor.textColor2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: TextFormField(
                                controller: phoneController,
                                // --- REFACTORED STYLE ---
                                style: fontStyles.primaryTextStyle.copyWith(
                                  color: appColor.textColor,
                                  letterSpacing: 3.8,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 15.h),
                                  hintText: languageService.getString(
                                    'enter_mobile_hint',
                                  ),
                                  // --- REFACTORED STYLE ---
                                  hintStyle:
                                      fontStyles.primaryTextStyle.copyWith(
                                    color: const Color(0x99F5E9B5),
                                    letterSpacing: 1.2,
                                    fontSize: 16.sp,
                                  ),
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter mobile number";
                                  } else if (!RegExp(r'^[0-9]{10}$')
                                      .hasMatch(value)) {
                                    return "Enter valid 10-digit number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 0.1 * screenHeight),

                      // Continue button
                      Center(
                        child: GestureDetector(
                          // --- FIX: Corrected onTap logic ---
                          onTap: isLoading
                              ? null // Disable button when loading
                              : () {
                                  if (phoneController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          languageService.getString(
                                            'please_enter_phone',
                                          ),
                                          style: fontStyles.errorstyle2,
                                        ),
                                        backgroundColor: appColor.errorColor,
                                      ),
                                    );
                                    return;
                                  }
                                  _handleLogin(context); // Call login
                                },
                          child: Container(
                            width: 0.7 * screenWidth,
                            height: 54.h,
                            decoration: ShapeDecoration(
                              color: isLoading
                                  ? appColor.loadingColor // Use appColor
                                  : appColor.textColor, // Use appColor
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
                                  : Center(
                                      child: Text(
                                        languageService.getString(
                                          'continue',
                                        ),
                                        // --- This was already correct ---
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
