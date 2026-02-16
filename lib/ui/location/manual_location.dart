import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/delivery_/addDeliveryAddress/add_delivery_address_bloc.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/bottom_navigationbar.dart';
import 'package:modern_grocery/ui/location/your_location.dart';
import 'package:provider/provider.dart';

class ManualLocation extends StatefulWidget {
  const ManualLocation({super.key});

  @override
  State<ManualLocation> createState() => _ManualLocationState();
}

class _ManualLocationState extends State<ManualLocation> {
  String currentLocation = "Use My Current Location";
  String? apiAddress;
  String selectedAddressType = 'current';

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final languageService =
          Provider.of<LanguageService>(context, listen: false);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack(languageService.getString('location_services_disabled'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack(languageService.getString('location_permissions_denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack(
          languageService.getString('location_permissions_permanently_denied'),
          actionLabel: languageService.getString('settings'),
          action: () {
            Geolocator.openAppSettings();
          },
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

      setState(() {
        currentLocation = address;
      });
    } catch (e) {
      final languageService =
          Provider.of<LanguageService>(context, listen: false);
      _showSnack(
        '${languageService.getString('error_fetching_location')}$e',
      );
    }
  }

  void _showSnack(String message, {String? actionLabel, VoidCallback? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: action!)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<AddDeliveryAddressBloc, AddDeliveryAddressState>(
          listener: (context, state) {
            if (state is AddDeliveryAddressLoaded) {
              setState(() {
                apiAddress = state.DeliveryData as String?;
              });
            } else if (state is AddDeliveryAddressError) {
              _showSnack(languageService.getString('failed_fetch_address_api'));
            } else if (state is AddDeliveryAddressLoading) {
              _showSnack(languageService.getString('loading_address_api'));
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF0A0909),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    SizedBox(height: 150.h),
                    Text(
                      languageService.getString('select_delivery_address'),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFCF8E8),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 23.h),
                    _buildSearchBox(languageService),
                    SizedBox(height: 46.h),
                    _buildAddressRadioSelection(languageService),
                    SizedBox(height: 46.h),
                    _buildAddNewAddress(languageService),
                    SizedBox(height: 200.h),
                    _buildConfirmButton(languageService),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBox(LanguageService languageService) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFCF8E8), width: 2.w),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: GoogleFonts.poppins(color: Color(0x91FCF8E8)),
        decoration: InputDecoration(
          hintText: languageService.getString('search_for_area'),
          hintStyle:
              GoogleFonts.poppins(color: Color(0x91FCF8E8), fontSize: 12.sp),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Color(0x91FCF8E8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildAddressRadioSelection(LanguageService languageService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageService.getString('choose_address'),
          style: GoogleFonts.poppins(
            color: const Color(0xFFFCF8E8),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        _buildRadioTile(
          value: 'current',
          title: currentLocation,
        ),
        SizedBox(height: 20.h),
        if (apiAddress != null)
          _buildRadioTile(
            value: 'api',
            title: apiAddress!,
          ),
      ],
    );
  }

  Widget _buildRadioTile({required String value, required String title}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: selectedAddressType == value
              ? const Color(0xFFF5E9B5)
              : const Color(0xFFFCF8E8),
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedAddressType,
        onChanged: (val) {
          setState(() {
            selectedAddressType = val!;
          });
        },
        activeColor: const Color(0xFFF5E9B5),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              color: const Color(0xFFFCF8E8), fontSize: 14.sp),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAddNewAddress(LanguageService languageService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add, color: Color(0xE8FCF8E8)),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const YourLocation()),
            );
          },
          child: Text(
            languageService.getString('add_new_address'),
            style:
                GoogleFonts.poppins(color: Color(0xE8FCF8E8), fontSize: 15.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(LanguageService languageService) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          String chosenAddress = selectedAddressType == 'current'
              ? currentLocation
              : (apiAddress ?? '');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const NavigationBarWidget(initialIndex: 0,)),
                (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5E9B5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
        ),
        child: Text(
          languageService.getString('confirm address'),
          style: GoogleFonts.poppins(
            color: Color(0xFF0A0808),
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
