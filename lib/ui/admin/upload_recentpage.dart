import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modern_grocery/bloc/Banner_/CreateBanner_bloc/create_banner_bloc.dart';
import 'package:modern_grocery/repositery/api/banner/CreateBanner_api.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';
import 'package:modern_grocery/widgets/app_color.dart';

import '../../bloc/Banner_/GetAllBannerBloc/get_all_banner_bloc.dart';

class RecentPage extends StatefulWidget {
  final String imagePath;
  const RecentPage({super.key, required this.imagePath});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController(); // kept because you use it in event
    final _category_nameController = TextEditingController(); // kept because you use it in event

  final _typeController = TextEditingController();
  final _linkController = TextEditingController();

  String? _selectedCategoryId;
  double _uploadProgress = 0.0;
  bool _isUploading = false; // Add this to track loading state

  @override
  void initState() {
    super.initState();
    // Fetch categories from parent-provided GetAllCategoriesBloc
    context.read<GetAllCategoriesBloc>().add(fetchGetAllCategories());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _saveImage(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    // Dropdown already has a validator, but keeping this guard for safety.
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
    category: _category_nameController.text,
    type: _typeController.text,
    categoryId: _selectedCategoryId!,
    link: _linkController.text,
    imagePath: file, // ✅ File
    onSendProgress: (sent, total) {
      if (!mounted) return;
      setState(() {
        _uploadProgress = total == 0 ? 0 : sent / total;
      });
    },
  ),
);

print(_titleController.text);
print(_categoryController.text);
print(_typeController.text);
print(_selectedCategoryId);
print(_linkController.text);
print(file);

  }

  Widget _buildTextField({
    required String label,
    required TextEditingController? controller,
    bool isRequired = true,
    int maxLines = 1,
  }) {
    return controller == null ? const SizedBox.shrink() : Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: appColor.textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: appColor.textColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: appColor.accentColor),
          ),
          filled: true,
          fillColor: appColor.backgroundColor,
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildImagePreview() {
    final file = File(widget.imagePath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    } else {
      return const Center(
        child: Text(
          'Image not found',
          style: TextStyle(color: appColor.textColor, fontSize: 16),
        ),
      );
    }
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetAllCategoriesError) {
          return const Text(
            'Failed to load categories',
            style: TextStyle(color: Colors.red),
          );
        }
        if (state is GetAllCategoriesLoaded) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              items: state.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(
                    // Use the category name from the dropdown item for the text field
                    category.name,
                    style: const TextStyle(color: appColor.textColor),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Find the selected category to update the text controller
                  final selectedCategory = state.categories.firstWhere((cat) => cat.id == value);
                  _categoryController.text = selectedCategory.name;
                  _selectedCategoryId = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: const TextStyle(color: appColor.textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor.accentColor),
                ),
                filled: true,
                fillColor: appColor.backgroundColor,
              ),
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    // ✅ BlocProvider is now handled in main.dart or at the route level
    //
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.backgroundColor,
        foregroundColor: appColor.textColor,
        title: const Text('Banner Management'),
      ),
      body: BlocListener<CreateBannerBloc, CreateBannerState>(
        listener: (context, state) {
          if (state is CreateBannerLoading) {
            print('Banner Loading');
            setState(() => _isUploading = true);
          } else if (state is CreateBannerLoaded) {
            print('Banner Loaded');
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Banner saved successfully!'),
                  backgroundColor: Colors.green),
            );
            // Refresh previous screen's banners
            context.read<GetAllBannerBloc>().add(FetchGetAllBannerEvent());
            Navigator.of(context).pop();
          } else if (state is CreateBannerError) {
            setState(() => _isUploading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image preview
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _buildImagePreview(),
                ),
                const SizedBox(height: 24),

                // Upload progress
                if (_isUploading && _uploadProgress > 0 && _uploadProgress < 1) ...[
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      appColor.accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: appColor.textColor),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Banner Details',
                  style: const TextStyle(
                    color: appColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTextField(label: 'Title', controller: _titleController),
                _buildTextField(label: 'Category', controller: _category_nameController),
                _buildTextField(label: 'Type', controller: _typeController),
                _buildCategoryDropdown(),
                _buildTextField(
                  label: 'Link (Optional)',
                  controller: _linkController,
                  isRequired: false,
                ),
                // This field is now populated automatically by the dropdown
                _buildTextField(label: 'Category Name', controller: null),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _isUploading ? null : () => _saveImage(context),
                  icon: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isUploading ? 'Uploading...' : 'Save Banner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.buttonColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
                      