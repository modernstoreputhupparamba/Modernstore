import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/userprofile/userprofile_bloc.dart';
import 'package:provider/provider.dart';
import 'package:modern_grocery/bloc/delivery_/userdelivery%20addrees/userdeliveryaddress_bloc.dart';

import 'package:modern_grocery/repositery/model/user/getUserDlvAddresses.dart';
import 'package:modern_grocery/repositery/model/user/getUserProfile.dart';
import 'package:modern_grocery/services/language_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  bool _controllersInitialized = false;

  GetUserProfile? _profileData;
  GetUserDlvAddresses? _addressData;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserprofileBloc>(context).add(fetchUserprofile());
    BlocProvider.of<UserdeliveryaddressBloc>(context)
        .add(FetchUserdeliveryaddressEvent());
  }

  @override
  void dispose() {
    if (_controllersInitialized) {
      nameController.dispose();
      phoneController.dispose();
      addressController.dispose();
    }
    super.dispose();
  }

void _initializeControllers() {
  nameController = TextEditingController(
    text: _profileData?.user.name ?? '',
  );

  phoneController = TextEditingController(
    text: _profileData?.user.phoneNumber ?? '',
  );

  String deliveryAddress = '';

  if (_addressData?.data != null && _addressData!.data!.isNotEmpty) {
    deliveryAddress = _addressData!.data!.first.address ?? '';
  }

  addressController = TextEditingController(
    text: deliveryAddress,
  );

  _controllersInitialized = true;
}


  void _saveChanges() {
    // final updatedName = nameController.text.trim();
    // final updatedPhone = phoneController.text.trim();
    // final updatedAddress = addressController.text.trim();
    // if (updatedName.isNotEmpty && updatedPhone.isNotEmpty) {
    //   BlocProvider.of<UserprofileBloc>(context).add(
    //     UpdateUserProfileEvent(
    //       name: updatedName,
    //       phoneNumber: updatedPhone,
    //     ),
    //   );

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Profile updated successfully')),
    //   );
    //   Navigator.pop(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocBuilder<UserprofileBloc, UserprofileState>(
          builder: (context, profileState) {
            if (profileState is Userprofileloading) {
              return Scaffold(
                backgroundColor: const Color(0xFF0A0909),
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            if (profileState is UserprofileError) {
              return Scaffold(
                backgroundColor: const Color(0xFF0A0909),
                body: Center(
                  child: Text(
                    languageService.getString('profile_unavailable'),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              );
            }
            if (profileState is Userprofileloaded) {
              _profileData =
                  BlocProvider.of<UserprofileBloc>(context).getUserProfile;

              return BlocBuilder<UserdeliveryaddressBloc,
                  UserdeliveryaddressState>(
                builder: (context, addressState) {
                  if (addressState is UserdeliveryaddressLoading) {
                    return Scaffold(
                      backgroundColor: const Color(0xFF0A0909),
                      body: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (addressState is UserdeliveryaddressError) {
                    return Scaffold(
                      backgroundColor: const Color(0xFF0A0909),
                      body: Center(
                        child: Text(
                          languageService.getString('address_unavailable'),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    );
                  }
                 if (addressState is UserdeliveryaddressLoaded) {
  _addressData = addressState.addresses as GetUserDlvAddresses?;

  if (!_controllersInitialized) {
    _initializeControllers();
  }



                    return Scaffold(
                      backgroundColor: const Color(0xFF0A0909),
                      appBar: AppBar(
                        backgroundColor: const Color(0xFF0A0909),
                        elevation: 0,
                        leading: const BackButton(color: Colors.white),
                        title: Text(
                          languageService.getString('edit_profile'),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundImage:
                                      _profileData?.user.profileImage != null
                                          ? NetworkImage(
                                              _profileData!.user.profileImage)
                                          : null,
                                  backgroundColor: Colors.grey[600],
                                  child: _profileData?.user.profileImage == null
                                      ? Icon(
                                          Icons.person,
                                          size: 40.sp,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 16.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              _profileData?.user.name ??
                                  languageService.getString('user_name'),
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xffC4C1B4)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    languageService.getString('name'),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  buildEditableField(
                                      controller: nameController),
                                  SizedBox(height: 20.h),
                                  Text(
                                    languageService.getString('phone_number'),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  buildEditableField(
                                      controller: phoneController),
                                  SizedBox(height: 20.h),
                                  Text(
                                    languageService.getString('address'),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  buildEditableField(
                                      controller: addressController,
                                      maxLines: 3),
                                  SizedBox(height: 30.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50.h,
                                    child: ElevatedButton(
                                      onPressed: _saveChanges,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFCF8E8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      child: Text(
                                        languageService
                                            .getString('save_changes'),
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF0A0909),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget buildEditableField({
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffC4C1B4)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: GoogleFonts.poppins(
                color: const Color(0xffC4C1B4),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: '',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(
            Icons.edit,
            color: const Color(0xffC4C1B4),
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}
