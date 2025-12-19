import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_grocery/services/language_service.dart';
import 'package:provider/provider.dart';

class AddNewAddressPage extends StatefulWidget {
  const AddNewAddressPage({super.key});

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String _addressType = 'Home';

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          backgroundColor: const Color(0XFF0A0909),
          appBar: AppBar(
            backgroundColor: const Color(0XFF0A0909),
            leading: const BackButton(color: Color(0xffFCF8E8)),
            title: Text(
              languageService.getString('add_new_address'),
              style: GoogleFonts.poppins(
                color: const Color(0xFFFCF8E8),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                      _addressController, languageService.getString('address')),
                  SizedBox(height: 20.h),
                  _buildTextField(
                      _cityController, languageService.getString('city')),
                  SizedBox(height: 20.h),
                  _buildTextField(
                      _stateController, languageService.getString('state')),
                  SizedBox(height: 20.h),
                  _buildTextField(
                      _zipController, languageService.getString('zip_code')),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5E9B5),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement save address logic
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      languageService.getString('save_address'),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: const Color(0xFFFCF8E8)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: const Color(0x8CFCF8E8)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffC4C1B4)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF5E9B5)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}