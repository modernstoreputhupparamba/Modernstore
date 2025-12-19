import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/auth_/enter_screen.dart';
import 'package:modern_grocery/ui/settings/Edit_profile.dart';
import 'package:modern_grocery/ui/settings/about_us_page.dart';
import 'package:modern_grocery/ui/settings/help_desk_page.dart';
import 'package:modern_grocery/ui/settings/language_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('userType');
    await prefs.remove('isAdmin');

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EnterScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0A0909),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 23.h),

                Row(
                  children: [
                    SizedBox(width: 10.w),
                    const BackButton(color: Color(0xffffffff)),
                  ],
                ),
                SizedBox(height: 10.h), // Reduced spacing for better flow
                // Title Row (centered)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        languageService.getString("my_account"),
                        textAlign: TextAlign
                            .center, // Ensures centering within Expanded
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFCF8E8),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                // User Avatar and Name (centered)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage:
                            const AssetImage('assets/image 91.png'),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        languageService.getString("user_name"),
                        textAlign: TextAlign.center, // Centers the name
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFCF8E8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 55.h),
                // Sections
                buildSection(
                    languageService, languageService.getString("general"), [
                  buildListTile(
                      Icons.person, languageService.getString("profile"),
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  }),
                  buildListTile(Icons.location_on,
                      languageService.getString("my_address"), onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAddressPage()),
                        );
                      }),
                  buildListTile(
                      Icons.language, languageService.getString("language"),
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LanguagePage()),
                    );
                  }),
                ]),
                buildSection(languageService,
                    languageService.getString("personal_activity"), [
                  buildListTile(Icons.account_balance_wallet,
                      languageService.getString("wallet_points"), onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          languageService.getString("wallet_coming"),
                          style: GoogleFonts.poppins(
                            color: Color(0x80000000),
                          ),
                        ),
                        backgroundColor: const Color(0xFFF5E9B5),
                      ),
                    );
                  }),
                  buildListTile(Icons.rate_review,
                      languageService.getString("customer_review"), onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          languageService.getString("review_coming"),
                          style: GoogleFonts.poppins(
                            color: Color(0x80000000),
                          ),
                        ),
                        backgroundColor: const Color(0xFFF5E9B5),
                      ),
                    );
                  }),
                ]),
                buildSection(
                    languageService, languageService.getString("logout"), [
                  buildListTile(
                      Icons.logout, languageService.getString("logout"),
                      onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: Text(
                          languageService.getString("logout"),
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        content: Text(
                          languageService.getString("logout_confirm"),
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              languageService.getString("cancel"),
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              _logoutUser(context);
                            },
                            child: Text(
                              languageService.getString("logout"),
                              style: GoogleFonts.poppins(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ]),
                buildSection(
                    languageService, languageService.getString("help_desk"), [
                  buildListTile(
                      Icons.support, languageService.getString("help_support"),
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpDeskPage()),
                    );
                  }),
                  buildListTile(
                      Icons.info, languageService.getString("about_us"),
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsPage()),
                    );
                  }),
                  buildListTile(Icons.description,
                      languageService.getString("terms_conditions"), onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          languageService.getString("terms_coming"),
                          style: GoogleFonts.poppins(
                            color: Color(0x80000000),
                          ),
                        ),
                        backgroundColor: const Color(0xFFF5E9B5),
                      ),
                    );
                  }),
                  buildListTile(Icons.privacy_tip,
                      languageService.getString("privacy_policy"), onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          languageService.getString("privacy_coming"),
                          style: GoogleFonts.poppins(
                            color: Color(0x80000000),
                          ),
                        ),
                        backgroundColor: const Color(0xFFF5E9B5),
                      ),
                    );
                  }),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSection(
      LanguageService languageService, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: const Color(0xFFFCF8E8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: const Color(0xffC4C1B4)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(children: children),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget buildListTile(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFCF8E8), size: 24.sp),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFFFCF8E8),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16.sp,
      ),
      onTap: onTap,
    );
  }
}
