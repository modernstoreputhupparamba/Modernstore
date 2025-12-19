import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';

import 'package:modern_grocery/ui/products/Product_list.dart';
import 'package:modern_grocery/bloc/Categories_/createCategory/create_category_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../bloc/Categories_/Edit_category/edit_category_bloc.dart';

// Assuming Category is a class within GetAllCategoriesModel
class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}

class AdminCategory extends StatefulWidget {
  const AdminCategory({super.key});

  @override
  State<AdminCategory> createState() => _AdminCategoryState();
}

class _AdminCategoryState extends State<AdminCategory> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllCategoriesBloc>(context).add(fetchGetAllCategories());
    _searchController.addListener(_onSearchChanged);
  }

  File? _image;
  String? _imageFileType;
  final ImagePicker _picker = ImagePicker();
  String? _networkImageUrl;
  bool _isUploading = false;

  // Controllers and state for search
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allCategories = [];
  List<dynamic> _filteredCategories = [];

  @override
  void dispose() {
    _categoryController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCategories(_searchController.text);
  }

  void _filterCategories(String query) {
    final lowerCaseQuery = query.toLowerCase();

    setState(() {
      if (lowerCaseQuery.isEmpty) {
        _filteredCategories = List.from(_allCategories);
      } else {
        _filteredCategories = _allCategories.where((category) {
          final name = (category.name ?? '').toString().toLowerCase();
          return name.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  Future<bool> _requestImagePermission() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return storageStatus.isGranted;
    }
    return true;
  }

  Future<void> _pickImage() async {
    final isGranted = await _requestImagePermission();
    if (!isGranted) {
      _showSnackBar('Permission to access photos is denied', Colors.red);
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();

      // Validate image format
      final isJpeg = bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8;
      final isPng = bytes.length > 4 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47;

      if (!isJpeg && !isPng) {
        _showSnackBar('Only JPEG or PNG images are allowed', Colors.red);
        return;
      }

      setState(() {
        _image = imageFile;
        _imageFileType = isJpeg ? 'jpeg' : 'png';
      });
    } catch (e) {
      _showSnackBar('Error picking image: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void _resetForm() {
    setState(() {
      _image = null;
      _networkImageUrl = null;
      _categoryController.clear();
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildSearchField(),
              const SizedBox(height: 20),
              _buildAddCategoryButton(),
              const SizedBox(height: 20),
              _buildCategoryGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.print, color: Colors.white, semanticLabel: 'Print'),
        const SizedBox(width: 16),
        Stack(
          children: [
            const Icon(Icons.notifications_none,
                color: Colors.white, semanticLabel: 'Notifications'),
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.orange,
                child: const Text(
                  '10',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                  semanticsLabel: '10 notifications',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        const Icon(Icons.person, color: Colors.white, semanticLabel: 'Profile'),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search here',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF1C5),
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: () => _showAddCategoryDialog(),
        icon: const Icon(Icons.add_circle_outline,
            color: Colors.black, semanticLabel: 'Add'),
        label: const Text('Add Category'),
      ),
    );
  }

  void _showAddCategoryDialog({dynamic categoryData}) {
  // Pre-fill form if editing
  if (categoryData != null) {
    _categoryController.text = categoryData.name ?? '';
    _networkImageUrl = categoryData.image;
    _image = null; // Clear local image when editing
  } else {
    // Clear form if adding
    _resetForm();
  }

  // Keep a reference to the parent context (State's context)
  final parentContext = context;

  showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (dialogContext) {
      return MultiBlocListener(
        listeners: [
          /// CREATE CATEGORY LISTENER
          BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (ctx, state) {
              if (state is CreateCategoryLoaded) {
                _resetForm();
                Navigator.of(dialogContext).pop(); // Close the dialog
                _showSnackBar('Category created successfully', Colors.green);

                // Refresh categories
                ctx.read<GetAllCategoriesBloc>().add(fetchGetAllCategories());
              } else if (state is CreateCategoryError) {
                setState(() => _isUploading = false);
                _showSnackBar(
                  'Failed to create category: ${state.message}',
                  Colors.red,
                );
              }
            },
          ),

          /// EDIT CATEGORY LISTENER
          BlocListener<EditCategoryBloc, EditCategoryState>(
            listener: (ctx, state) {
              if (state is EditCategorySuccess) {
                _resetForm();
                Navigator.of(dialogContext).pop();
                _showSnackBar(
                    'Category updated successfully', Colors.green);

                ctx
                    .read<GetAllCategoriesBloc>()
                    .add(fetchGetAllCategories());
              } else if (state is EditCategoryFailure) {
                setState(() => _isUploading = false);
                _showSnackBar(
                  'Failed to update category: ${state.error}',
                  Colors.red,
                );
              }
            },
          ),
        ],

        /// THE ACTUAL DIALOG UI
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            categoryData == null ? 'Add New Category' : 'Edit Category',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category Name *',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _categoryController,
                  onChanged: (_) {
                    // To update errorText when typing
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter category name',
                    errorText: _categoryController.text.trim().isEmpty &&
                            _isUploading
                        ? 'Category name is required'
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add Image *',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : (_networkImageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: _networkImageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Click to select image',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                )),
                    ),
                  ),
                ),
                if (_isUploading && _image == null && _networkImageUrl == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Image is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _resetForm(); // Reset on cancel
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  _handleCategorySubmission(categoryData: categoryData),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF1C5),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      categoryData == null
                          ? 'Save Category'
                          : 'Update Category',
                    ),
            ),
          ],
        ),
      );
    },
  );
}

  void _handleCategorySubmission({dynamic categoryData}) {
    final isEditing = categoryData != null;
    final name = _categoryController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please provide a category name', Colors.red);
      return;
    }

    // When creating, an image is required. When editing, it's optional.
    if (!isEditing && _image == null) {
      _showSnackBar('Please provide an image for the new category', Colors.red);
      return;
    }

    if (_image != null && !_image!.existsSync()) {
      _showSnackBar('Selected image is invalid', Colors.red);
      return;
    }

    setState(() => _isUploading = true);

    if (isEditing) {
      // Dispatch edit event
      context.read<EditCategoryBloc>().add(SubmitEditCategory(
            categoryId: categoryData.id,
            categoryName: name,
            imageFile: _image, // Can be null
          ));
    } else {
      // Dispatch create event
      setState(() => _isUploading = true);
      context.read<CreateCategoryBloc>().add(
            FetchCreateCategory(
              categoryName: name,
              imageFile: _image!,
            ),
          );
    }
  }

  Widget _buildCategoryGrid() {
    return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesLoading) {
          // Shimmer effect for loading state
          return Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: GridView.builder(
                itemCount: 6, // Placeholder count
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          );
        } else if (state is GetAllCategoriesError) {
          return const Center(
            child: Text(
              'Failed to load categories',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (state is GetAllCategoriesLoaded) {
          final categories = state.categories;

          // Initialize master list once
          if (_allCategories.isEmpty) {
            _allCategories = categories;
            _filteredCategories = List.from(categories);
          }

          if (_filteredCategories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: TextStyle(color: Colors.white),
                semanticsLabel: 'No categories found',
              ),
            );
          }

          return Expanded(
            child: GridView.builder(
              itemCount: _filteredCategories.length, // ✅ use filtered list
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final category =
                    _filteredCategories[index]; // ✅ use filtered list

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Product_list(
                          CategoryId:
                              category.id!, // ✅ use category from filtered list
                          nav_type: 'admin',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E1D1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 250,
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E1D1),
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(category.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          category.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          semanticsLabel: category.name,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              _showSnackBar(
                                                'Category is active',
                                                Colors.grey,
                                              );
                                            },
                                            child: const Text(
                                              'ACTIVE',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              semanticsLabel:
                                                  'Category is active',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_note,
                              color: Colors.white,
                              semanticLabel: 'Edit category',
                            ),
                            onPressed: () {
                              _showAddCategoryDialog(categoryData: category);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
