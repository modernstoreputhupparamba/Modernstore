import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modern_grocery/ui/admin/admin_navibar.dart';
import 'package:modern_grocery/ui/bottom_navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modern_grocery/ui/onboarding_page.dart';
import 'package:modern_grocery/ui/location/location_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  String UserId='';

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // --- ADD THIS LOGIC ---
    // Check for any of the admin flags, just like in VerifyScreen
    final role = prefs.getString('role');
    final userType = prefs.getString('userType');
    final isAdminFlag = prefs.getBool('isAdmin');
    UserId = prefs.getString('userId') ?? '';


    final bool isAdmin = role == 'admin' ||
        role == 'Admin' ||
        userType == 'admin' ||
        userType == 'Admin' ||
        isAdminFlag == true;
 

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return; // Always check if widget is still mounted

print(UserId);
        if (token != null && token.isNotEmpty && UserId.isNotEmpty) {
          // --- THIS IS THE UPDATED REDIRECT ---
          if (isAdmin&&UserId.isNotEmpty) {
            // Send admins to AdminNavibar
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminNavibar()),
            );
          } else {
            // Send regular users to LocationPage
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => NavigationBarWidget()),
            );
          }
        } else {
          // No token, send to Onboarding
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5E9B5),
      body: Center(
        child: SizedBox(
          height: 250.h,
          width: 250.w,
          child: const Image(
            image: AssetImage('assets/MODERN.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
