import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modern_grocery/bloc/Banner_/CreateBanner_bloc/create_banner_bloc.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';
import 'package:modern_grocery/widgets/app_color.dart';
import 'package:modern_grocery/bloc/Product_/get_all_product/get_all_product_bloc.dart';

import '../../bloc/Banner_/GetAllBannerBloc/get_all_banner_bloc.dart';

// ... imports stay the same

class RecentPage extends StatefulWidget {
  final String imagePath;
  const RecentPage({super.key, required this.imagePath});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  // Simplified to one category name controller
  final _linkController = TextEditingController();

  String? _selectedType;
  String? _selectedCategoryId;
  String? _selectedProductId;
  String? _selectedBannerCategory;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    context.read<GetAllCategoriesBloc>().add(fetchGetAllCategories());
    context.read<GetAllProductBloc>().add(fetchGetAllProduct(''));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

Future<void> _saveImage(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select type')),
    );
    return;
  }

  // if (_selectedType == 'category' && _selectedCategoryId == null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Please select category')),
  //   );
  //   return;
  // }

  // if (_selectedType == 'product' && _selectedProductId == null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Please select product')),
  //   );
  //   return;
  // }

  final file = File(widget.imagePath);
  if (!file.existsSync()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error: Image file not found')),
    );
    return;
  }

  context.read<CreateBannerBloc>().add(
    FetchCreateBannerEvent(
      title: _titleController.text,
        category: _selectedBannerCategory!,
      type: _selectedType!,
      categoryId:
          _selectedType == 'category' ? _selectedCategoryId! : null,
      productId:
          _selectedType == 'product' ? _selectedProductId : null,
      link: _linkController.text,
      imagePath: file,
      onSendProgress: (sent, total) {
        if (!mounted) return;
        setState(() {
          _uploadProgress = total == 0 ? 0 : sent / total;
        });
      },
    ),
  );
}

  // Modified TextField helper to support 'readOnly'
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = true,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(color: appColor.textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: appColor.textColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          filled: true,
          fillColor: appColor.backgroundColor,
        ),
        validator: isRequired
            ? (value) =>
                (value == null || value.isEmpty) ? 'Please enter $label' : null
            : null,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesLoading) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LinearProgressIndicator(),
          );
        }
        if (state is GetAllCategoriesLoaded) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              hint: const Text("Select Category",
                  style: TextStyle(color: appColor.textColor)),
              items: state.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name,
                      style: const TextStyle(color: appColor.textColor)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              dropdownColor: Color(0xff282828),
              decoration: InputDecoration(
                labelText: 'Select Category ID',
                labelStyle: const TextStyle(color: appColor.textColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                filled: true,
                fillColor: appColor.backgroundColor,
              ),
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
            ),
          );
        }
        return const Text("Error loading categories",
            style: TextStyle(color: Colors.red));
      },
    );
  }

  Widget _buildProductDropdown() {
    return BlocBuilder<GetAllProductBloc, GetAllProductState>(
      builder: (context, state) {
        if (state is GetAllProductLoading) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: LinearProgressIndicator(),
          );
        }
        if (state is GetAllProductLoaded) {
          final products = state.getAllProduct.data ?? [];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedProductId,
              hint: const Text("Select Product",
                  style: TextStyle(color: appColor.textColor)),
              items: products.map((product) {
                return DropdownMenuItem<String>(
                  value: product.id,
                  child: Text(product.name ?? 'Unknown',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: appColor.textColor)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductId = value;
                });
              },
              dropdownColor: const Color(0xff282828),
              decoration: InputDecoration(
                labelText: 'Select Product',
                labelStyle: const TextStyle(color: appColor.textColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                filled: true,
                fillColor: appColor.backgroundColor,
              ),
              validator: (value) =>
                  value == null ? 'Please select a product' : null,
            ),
          );
        }
        return const Text("Error loading products",
            style: TextStyle(color: Colors.red));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(title: const Text('Banner Management')),
      body: BlocListener<CreateBannerBloc, CreateBannerState>(
        listener: (context, state) {
          if (state is CreateBannerLoading) {
            setState(() => _isUploading = true);
          } else if (state is CreateBannerLoaded) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Banner saved successfully!'),
                  backgroundColor: Colors.green),
            );
            context.read<GetAllBannerBloc>().add(FetchGetAllBannerEvent());
            Navigator.of(context).pop();
          } else if (state is CreateBannerError) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.blue),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image Preview
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: FileImage(File(widget.imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Progress
                if (_isUploading) ...[
                  LinearProgressIndicator(value: _uploadProgress),
                  const SizedBox(height: 10),
                ],

                _buildTextField(
                    label: 'Banner Title', controller: _titleController),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ['product', 'category'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type,
                            style: const TextStyle(color: appColor.textColor)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() {
                      _selectedType = val;
                      _selectedCategoryId = null;
                      _selectedProductId = null;
                    }),
                    dropdownColor: const Color(0xff282828),
                    decoration: InputDecoration(
                      labelText: 'Type',
                      labelStyle: const TextStyle(color: appColor.textColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      filled: true,
                      fillColor: appColor.backgroundColor,
                    ),
                    validator: (v) => v == null ? 'Please select type' : null,
                  ),
                ),

                if (_selectedType == 'category') _buildCategoryDropdown(),
                if (_selectedType == 'product') _buildProductDropdown(),

                // Banner Category (Dropdown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedBannerCategory,
                    items: ['home', 'product'].map((val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val,
                            style: const TextStyle(color: appColor.textColor)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() {
                      _selectedBannerCategory = val;
                    }),
                    dropdownColor: const Color(0xff282828),
                    decoration: InputDecoration(
                      labelText: 'Banner Category',
                      labelStyle: const TextStyle(color: appColor.textColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      filled: true,
                      fillColor: appColor.backgroundColor,
                    ),
                    validator: (v) =>
                        v == null ? 'Please select banner category' : null,
                  ),
                ),

                _buildTextField(
                    label: 'Link (URL)',
                    controller: _linkController,
                    isRequired: false),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _isUploading ? null : () => _saveImage(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: appColor.buttonColor,
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator()
                      : const Text('Save Banner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
