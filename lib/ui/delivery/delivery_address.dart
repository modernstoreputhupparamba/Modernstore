import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/bloc/delivery_/addDeliveryAddress/add_delivery_address_bloc.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:modern_grocery/ui/delivery/delivery_success.dart';
import 'package:provider/provider.dart';

import '../../bloc/Orders/Create_Order/create_order_bloc.dart';
import '../../bloc/delivery_/userdelivery addrees/userdeliveryaddress_bloc.dart';
import '../bottom_navigationbar.dart';
import '../Home_/add_new_address_page.dart';

class DeliveryAddress extends StatefulWidget {
  final String? Deliverytype;
  final dynamic deliveryCharge;

  const DeliveryAddress({
    super.key,
    required this.Deliverytype,
    required this.deliveryCharge,
  });

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  String? currentLocation;
  bool _isFetchingLocation = false;
  String selectedAddressType = '';
  String? _currentLocationAddressId;
  Placemark? _currentPlace;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<UserdeliveryaddressBloc>()
          .add(FetchUserdeliveryaddressEvent());
      final languageService =
          Provider.of<LanguageService>(context, listen: false);
      _getCurrentLocation(languageService);
    });
  }

  Future<void> _getCurrentLocation(LanguageService languageService) async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        _showSnack(languageService.getString('location_services_disabled'));
        setState(() => _isFetchingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          _showSnack(languageService.getString('location_permissions_denied'));
          setState(() => _isFetchingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        _showSnack(languageService
            .getString('location_permissions_permanently_denied'));
        setState(() => _isFetchingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (!mounted) return;

      Placemark place = placemarks[0];
      String address =
          "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

      setState(() {
        currentLocation = address;
        _currentPlace = place;
        _currentPosition = position;
        _isFetchingLocation = false;
      });

      // Automatically create an address for the current location
      if (mounted && _currentPlace != null && _currentPosition != null) {
        context.read<AddDeliveryAddressBloc>().add(
              fetchAddDeliveryAddress(
                DeliveryData: {
                  "address": currentLocation,
                  "city": _currentPlace!.locality,
                  "pincode": _currentPlace!.postalCode,
                  "country": _currentPlace!.country,
                  "street": _currentPlace!.street,
                  "state": _currentPlace!.administrativeArea,
                  "latitude": _currentPosition!.latitude,
                  "longitude": _currentPosition!.longitude,
                },
              ),
            );
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack(languageService.getString('error_fetching_location'));
      setState(() => _isFetchingLocation = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BlocListener<AddDeliveryAddressBloc, AddDeliveryAddressState>(
          listener: (context, state) {
            if (state is AddDeliveryAddressLoaded) {
              _currentLocationAddressId = state.DeliveryData.data?.id;

              setState(() {}); // refresh UI
            } else if (state is AddDeliveryAddressError) {
              _showSnack(languageService.getString('failed_add_address'));
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF0A0909),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0A0909),
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              title: Text(
                languageService.getString('select_delivery_address'),
                style: GoogleFonts.poppins(
                    color: const Color(0xFFFCF8E8),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      languageService.getString('choose_address'),
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFFCF8E8),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20.h),
                    
                    // CURRENT LOCATION
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: selectedAddressType == 'current'
                              ? const Color(0xFFF5E9B5)
                              : const Color(0xFFFCF8E8),
                          width: 1.5,
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                      languageService.getString('use_my_current_location'),
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFFCF8E8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),
                          RadioListTile<String>(
                            value: 'current',
                            groupValue: selectedAddressType,
                            onChanged: (value) {
                              setState(() => selectedAddressType = value!);
                          
                              if (_currentLocationAddressId == null &&
                                  _currentPlace != null &&
                                  _currentPosition != null) {
                                context.read<AddDeliveryAddressBloc>().add(
                                      fetchAddDeliveryAddress(
                                        DeliveryData: {
                                          "address": currentLocation,
                                          "city": _currentPlace!.locality,
                                          "pincode": _currentPlace!.postalCode,
                                          "country": _currentPlace!.country,
                                          "street": _currentPlace!.street,
                                          "state":
                                              _currentPlace!.administrativeArea,
                                          "latitude": _currentPosition!.latitude,
                                          "longitude": _currentPosition!.longitude,
                                        },
                                      ),
                                    );
                              }
                            },
                            activeColor: const Color(0xFFF5E9B5),
                            title: _isFetchingLocation
                                ? Text(
                                    languageService.getString('fetching_location'),
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFFFCF8E8),
                                        fontSize: 14.sp),
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentLocation ??
                                              languageService.getString(
                                                  'location_not_available'),
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xFFFCF8E8),
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                      // Show loader if creating address
                                      BlocBuilder<AddDeliveryAddressBloc,
                                          AddDeliveryAddressState>(
                                        builder: (context, state) {
                                          if (state is AddDeliveryAddressLoading &&
                                              selectedAddressType == 'current') {
                                            return SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFFF5E9B5),
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // API ADDRESS
                    BlocConsumer<UserdeliveryaddressBloc,
                        UserdeliveryaddressState>(
                      listener: (context, state) {
                        if (state is UserdeliveryaddressError) {
                          _showSnack(languageService
                              .getString('failed_fetch_address_api'));
                        }
                      },
                      builder: (context, state) {
                        if (state is UserdeliveryaddressLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is UserdeliveryaddressLoaded) {
                          final addresses = state.addresses.data ?? [];
                          if (addresses.isEmpty) {
                            return Center(
                              child: Text(
                                languageService.getString('no_addresses_found'),
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFFFCF8E8),
                                    fontSize: 14.sp),
                              ),
                            );
                          }
                          //   return ElevatedButton.icon(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: const Color(0xFFF5E9B5),
                          //       minimumSize: Size(double.infinity, 50.h),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10.r),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const AddNewAddressPage()),
                          //       ).then((_) {
                          //         if (context.mounted) {
                          //           context
                          //               .read<UserdeliveryaddressBloc>()
                          //               .add(FetchUserdeliveryaddressEvent());
                          //         }
                          //       });
                          //     },
                          //     icon: const Icon(Icons.add, color: Colors.black),
                          //     label: Text(
                          //       languageService.getString('add_new_address'),
                          //       style: GoogleFonts.poppins(
                          //         color: Colors.black,
                          //         fontSize: 16.sp,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //   );
                          // }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addresses.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C1C),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: selectedAddressType ==
                                            addresses[index].id
                                        ? const Color(0xFFF5E9B5)
                                        : const Color(0xFFFCF8E8),
                                    width: 1.5,
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  value: addresses[index].id!,
                                  groupValue: selectedAddressType,
                                  onChanged: (value) {
                                    setState(
                                        () => selectedAddressType = value!);
                                  },
                                  activeColor: const Color(0xFFF5E9B5),
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    addresses[index].address ??
                                        languageService
                                            .getString('address_not_available'),
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFFCF8E8),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5E9B5),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddNewAddressPage()),
                        ).then((_) {
                          if (context.mounted) {
                            context
                                .read<UserdeliveryaddressBloc>()
                                .add(FetchUserdeliveryaddressEvent());
                          }
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: Text(
                        languageService.getString('add_new_address'),
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: BlocListener<CreateOrderBloc, CreateOrderState>(
                  listener: (context, state) {
                    if (state is CreateOrderSuccess) {
                      // 1️⃣ Show success screen first
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeliverySuccess()),
                      );
                    } else if (state is CreateOrderFailure) {
                      _showSnack(state.error);
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5E9B5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r)),
                      ),
                      onPressed: () {
                        String? selectedShippingValue;

                        if (selectedAddressType == 'current') {
                          if (_currentLocationAddressId == null) {
                            _showSnack('Please wait, creating address...');
                            return;
                          }
                          selectedShippingValue = _currentLocationAddressId;
                        } else {
                          selectedShippingValue = selectedAddressType;
                        }

                        if (selectedShippingValue == null ||
                            selectedShippingValue.isEmpty) {
                          _showSnack('Please select a delivery address.');
                          return;
                        }

                        context.read<CreateOrderBloc>().add(
                              CreateOrderButtonPressed(
                                shippingAddress: selectedShippingValue,
                                paymentMethod: 'COD',
                                deliveryCharge: widget.deliveryCharge,
                              ),
                            );
                      },
                      child: context.watch<CreateOrderBloc>().state
                              is CreateOrderLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              languageService.getString('continue'),
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
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
