import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_grocery/bloc/Categories_/GetAllCategories/get_all_categories_bloc.dart';

import 'package:modern_grocery/bloc/Product_/createProduct/create_product_bloc.dart'; // Keep this for the dialog
import 'package:modern_grocery/bloc/Product_/update_product/update_product_bloc.dart';
import 'package:modern_grocery/bloc/Product_/get_all_product/get_all_product_bloc.dart';
import 'package:modern_grocery/repositery/model/product/getAllProduct.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:badges/badges.dart' as badges;

import '../../widgets/utils.dart';

// Constants for reusability
class _AppConstants {
  static const primaryColor = Color(0xFFF5E9B5);
  static const backgroundColor = Color(0XFF0A0909);
  static const textColor = Color(0xFFFCF8E8);
  static const accentColor = Colors.green;
  static const buttonColor = Color(0xFFFFF1C5);
  static const dialogRadius = 12.0;
  static const cardShadowColor =
      Colors.black54; // Corrected from Colors.black54
  static const cardHeight = 270.0;
  static const cardWidth = 190.0;
}

class AdminProduct extends StatefulWidget {
  const AdminProduct({super.key});

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  File? _image;
  String? _imageFileType;
  bool _isUploading = false;
List<String>? networkImageUrls; // Changed from single String to List
  String? selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch all products and categories when the widget initializes
    BlocProvider.of<GetAllProductBloc>(context).add(fetchGetAllProduct(''));
    BlocProvider.of<GetAllCategoriesBloc>(context).add(fetchGetAllCategories());
  }

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? _selectedUnit;
  final List<String> _unitOptions = ["KG", "G", "MG", "LTR", "PCS", "BOX", "PACKET"];
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    nameController.dispose();
    priceController.dispose();
    discountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _requestImagePermission() async {
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  Future<void> _pickImage() async {
    final isGranted = await _requestImagePermission();
    if (!isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access photos is denied')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final bytes = await imageFile.readAsBytes();

        final isJpeg = bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8;
        final isPng = bytes.length > 4 &&
            bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47;

        if (!isJpeg && !isPng) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Only JPEG or PNG images are allowed'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _image = imageFile;
          _imageFileType = isJpeg ? 'jpeg' : 'png';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocListener<CreateProductBloc, CreateProductState>(
          // Use the CreateProductBloc from the parent context
          listener: (ctx, state) {
            if (state is CreateProductILoading) {
              setState(() => _isUploading = true);
            } else {
              setState(() => _isUploading = false);
            }

            if (state is CreateProductLoaded) {
              // ✅ Clear form + image
              setState(() {
                _image = null;
                networkImageUrls = null;
                selectedCategoryId = null;
                nameController.clear();
                priceController.clear();
                _selectedUnit = null;
                discountController.clear();
                descriptionController.clear();
              });

              // ✅ Refresh product list
              context.read<GetAllProductBloc>().add(fetchGetAllProduct(
                ''
              ));

              // ✅ Close dialog
              Navigator.of(dialogContext).pop();

              // ✅ Show success
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is CreateProductError) {
              Utils().toastMessage(state.message);

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //         'Failed to create product: ${state.message}'),
              //     backgroundColor: Colors.red,
              //     duration: const Duration(seconds: 0),
              //   ),
              // );
              print(state.message);
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_AppConstants.dialogRadius),
            ), // Use constant
            backgroundColor:
                const Color(0xFFFCF8E8), // Light background for dialog
            title: const Text(
              'Add Product',
              style: TextStyle(color: Color(0xFF0A0909)), // Dark text
            ), // Use constant
            content:
                _buildAddProductForm(), // just extracted below for cleanliness
            actions: _buildDialogActions(context),
          ),
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, Data productData) {
    // Prefill data for editing
    nameController.text = productData.name ?? '';
    priceController.text = productData.basePrice?.toString() ?? '';
    _selectedUnit = null;
    if (productData.unit != null) {
      if (_unitOptions.contains(productData.unit!.toUpperCase())) {
        _selectedUnit = productData.unit!.toUpperCase();
      }
    }
    discountController.text = productData.discountPercentage?.toString() ?? '';
    descriptionController.text = productData.description ?? '';
    selectedCategoryId = productData.category?.id;
    networkImageUrls = productData.images; // Assign the full list
    _image = null; // Clear local image when starting an edit

    showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            // Provide UpdateProductBloc locally to the dialog
            BlocProvider(create: (context) => UpdateProductBloc()),
          ],
          child: BlocListener<UpdateProductBloc, UpdateProductState>(
            listener: (ctx, state) {
              if (state is UpdateProductLoading) {
                setState(() => _isUploading = true);
              } else {
                setState(() => _isUploading = false);
              }

              if (state is UpdateProductLoaded) {
                // Clear form + image
                setState(() {
                  _image = null;
                  networkImageUrls = null;
                  selectedCategoryId = null;
                  nameController.clear();
                  priceController.clear();
                  _selectedUnit = null;
                  discountController.clear();
                  descriptionController.clear();
                });

                // Refresh product list
                context.read<GetAllProductBloc>().add(fetchGetAllProduct(''));

                // Close dialog
                Navigator.of(dialogContext).pop();

                // Show success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is UpdateProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update product: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Builder(
              builder: (innerContext) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_AppConstants.dialogRadius),
                  ),
                  backgroundColor: const Color(0xFFFCF8E8),
                  title: const Text(
                    'Edit Product',
                    style: TextStyle(color: Color(0xFF0A0909)),
                  ),
                  content: _buildAddProductForm(),
                  actions: _buildDialogActions(innerContext, productData),
                );
              },
            ),
          ),
        );
      },
    );
  }

   Widget _buildAddProductForm() {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Product Name', 'Required'),
                  SizedBox(height: 12.h),
                  
                  // Safe Category Dropdown
                  BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
                    builder: (context, state) {
                      if (state is GetAllCategoriesLoaded) {
                        // CRITICAL FIX: Ensure the selected ID exists in the items list
                        final bool valueExists = state.categories.any((c) => c.id == selectedCategoryId);
                        
                        return DropdownButtonFormField<String>(
                          value: valueExists ? selectedCategoryId : null,
                          items: state.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? ''))).toList(),
                          onChanged: (val) => setState(() => selectedCategoryId = val),
                          decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                          validator: (v) => v == null ? 'Required' : null,
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(priceController, 'Price', 'Req', keyboardType: TextInputType.number)),
                      SizedBox(width: 8.w),
                      Expanded(child: _buildTextField(discountController, 'Disc%', 'Req', keyboardType: TextInputType.number)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    items: _unitOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _selectedUnit = newValue);
                    },
                    style: const TextStyle(color: Color(0xFF0A0909), fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(descriptionController, 'Description', 'Required', maxLines: 3),
                  SizedBox(height: 16.h),

                  // Image Picker Button
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(_image == null ? "Pick Image" : "Change New Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _AppConstants.buttonColor,
                      minimumSize: Size(double.infinity, 40.h),
                    ),
                  ),

                  // --- IMAGE LIST SECTION ---
                  if (_image != null || (networkImageUrls != null && networkImageUrls!.isNotEmpty)) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: (networkImageUrls?.length ?? 0) + (_image != null ? 1 : 0),
                        separatorBuilder: (context, index) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          if (_image != null && index == 0) {
                            return _buildImageItem(Image.file(_image!, fit: BoxFit.cover), "New");
                          }
                          final netIndex = _image != null ? index - 1 : index;
                          return _buildImageItem(
                            Image.network(networkImageUrls![netIndex], fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.error)),
                            "Existing"
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildImageItem(Widget imageWidget, String label) {
  return Column(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 100.w,
            color: Colors.grey[200],
            child: imageWidget,
          ),
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        label,
        style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
      ),
    ],
  );
}
  Widget _buildTextField(
      TextEditingController controller, String label, String validationMsg,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.multiline}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF0A0909)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
          value == null || value.trim().isEmpty ? validationMsg : null,
    );
  }

  List<Widget> _buildDialogActions(BuildContext context, [Data? productData]) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();

          // Clear form state on cancel
          setState(() {
            _image = null;
            selectedCategoryId = null;
            nameController.clear();
            descriptionController.clear();
            priceController.clear();
            _selectedUnit = null;
            discountController.clear();
            _isUploading = false;
          });
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.blue),
          semanticsLabel: 'Cancel dialog',
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF1C5),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_AppConstants.dialogRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
        onPressed: _isUploading
            ? null
            : () {
                if (!_formKey.currentState!.validate() ||
                    selectedCategoryId == null) {
                  return;
                }

                if (productData == null) {
                  // Creating a new product
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please select an image for the new product'),
                          backgroundColor: Colors.red),
                    );
                    return;
                  }
                  context.read<CreateProductBloc>().add(
                        fetchCreateProduct(
                          productName: nameController.text.trim(),
                          productDescription: descriptionController.text.trim(),
                          categoryId: selectedCategoryId!,
                          price: priceController.text.trim(),
                          unit: _selectedUnit!,
                          imageFile: _image!,
                          discountPercentage: (double.tryParse(
                                      discountController.text.trim()) ??
                                  0.0)
                              .toString(),
                        ),
                      );
                } else {
                  // Editing an existing product
                  // Use the UpdateProductBloc from the dialog's context
                  context.read<UpdateProductBloc>().add(FetchUpdateProduct(
                        productId: productData.id!,
                        productName: nameController.text.trim(),
                        productDescription: descriptionController.text.trim(),
                        price: priceController.text.trim(),
                        unit: _selectedUnit!,
                        categoryId: selectedCategoryId!,
                        discountPercentage:
                            (double.tryParse(discountController.text.trim()) ??
                                    0.0)
                                .toString(),
                        imageFile: _image, // Pass the new image if selected
                      ));
                }
              },
        child: _isUploading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Save',
                semanticsLabel: 'Save product button',
              ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // _buildAppBar(),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerRight, // Add Product Button
                child: GestureDetector(
                  onTap: () => _showAddProductDialog(context),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline_outlined,
                            color: Colors.black, size: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          'Add Products',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          semanticsLabel: 'Add products button',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(child: _buildCategorizedProductList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _AppConstants.textColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        badges.Badge(
          badgeContent:
              Text('3', style: TextStyle(color: Colors.white, fontSize: 10.sp)),
          badgeStyle: badges.BadgeStyle(
            badgeColor: _AppConstants.accentColor,
            padding: EdgeInsets.all(6.w),
          ),
          child:
              SvgPicture.asset('assets/Group.svg', width: 24.w, height: 24.h),
        ),
        SizedBox(width: 24.w),
        SvgPicture.asset('assets/Group 6918.svg', width: 24.w, height: 24.h),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        // Icon(Icons.search, color: _AppConstants.textColor.withOpacity(0.57)),
        SizedBox(width: 8.w),
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
             style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search products...",
              hintStyle: TextStyle(color: const Color(0x91FCF8E8)),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xFFFCF8E8), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color(0xFFFCF8E8), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
               prefixIcon: Icon(Icons.search, color: Colors.white54, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildCategorizedProductList() {
  return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
    builder: (context, categoryState) {
      if (categoryState is GetAllCategoriesLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (categoryState is GetAllCategoriesError) {
        return const Center(
          child: Text(
            'Failed to load categories',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      if (categoryState is GetAllCategoriesLoaded) {
        final categories = categoryState.categories;

        return BlocBuilder<GetAllProductBloc, GetAllProductState>(
          builder: (context, productState) {
            if (productState is GetAllProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productState is GetAllProductError) {
              return const Center(
                child: Text(
                  'Failed to load products',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (productState is GetAllProductLoaded) {
              final allProducts = productState.getAllProduct.data ?? [];

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 16.h),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  final categoryProducts = allProducts.where((p) {
                    if (p.category?.id != category.id) return false;

                    if (_searchQuery.isEmpty) return true;

                    final matchesName =
                        (p.name?.toLowerCase() ?? '').contains(_searchQuery);
                    final matchesCategory =
                        (category.name?.toLowerCase() ?? '')
                            .contains(_searchQuery);

                    return matchesName || matchesCategory;
                  }).toList();

                  if (categoryProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: _buildSectionTitle(
                          category.name ?? 'Unnamed Category',
                        ),
                      ),

                      /// 👇 GridView for products
                     GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: categoryProducts.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
    crossAxisSpacing: 12.w,
    mainAxisSpacing: 12.h,
    childAspectRatio: 0.65,
  ),
  itemBuilder: (context, i) {
    final product = categoryProducts[i];
    return _ProductCard(
      product: product,
      onEdit: () => _showEditProductDialog(context, product),
    );
  },
),
                    ],
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        );
      }

      return const SizedBox.shrink();
    },
  );
}
//   Widget _buildProductList(List<Data> products) {
//     final isTablet = MediaQuery.of(context).size.width > 600;
//     final height = isTablet ? 280.0 : _AppConstants.cardHeight.h;

//     return SizedBox(
//       height: height,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return Padding(
//             padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w, right: 12.w),
//             child: _ProductCard(
//                 product: product,
//                 onEdit: () => _showEditProductDialog(context, product)),
//           );
//         },
//       ),
//     );
//   }
}

class _ProductCard extends StatelessWidget {
  final Data product; // Use the actual model
  final VoidCallback onEdit;

  const _ProductCard({required this.product, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final cardWidth = isTablet ? 200.0 : _AppConstants.cardWidth.w;
    final cardHeight = isTablet ? 280.0 : _AppConstants.cardHeight.h;
    final imageHeight = isTablet ? 150.0 : 150.h;

    final imageUrl =
        (product.images?.isNotEmpty ?? false) ? product.images![0] : '';
    final discountPercentage = product.discountPercentage ?? 0;
    final basePrice = product.basePrice ?? 0;
    final discountedPrice = basePrice - (basePrice * discountPercentage / 100);

    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: _AppConstants.cardShadowColor,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: _AppConstants.textColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r), // Use imageUrl
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 16.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _AppConstants.accentColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.name ?? 'Unnamed Product',
                    style: TextStyle(
                      color: _AppConstants.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                // SizedBox(width: 8.w),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/product note.svg',
                    color: _AppConstants.buttonColor,
                    width: 16.w,
                    semanticsLabel: 'Edit product icon',
                  ),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 12.w),
          //   child: Row(
          //     children: List.generate(5, (index) {
          //       // Placeholder for rating
          //       return Icon(
          //         index < 4 ? Icons.star : Icons.star_border,
          //         color: const Color(0xFFFFD500),
          //         size: 16.w,
          //       );
          //     }),
          //   ),
          // ),
          // SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  '₹${discountedPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: _AppConstants.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'MRP ₹${basePrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              discountPercentage > 0
                  ? '${discountPercentage.toStringAsFixed(0)}% OFF'
                  : '',
              style: TextStyle(
                color: _AppConstants.accentColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
