import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modern_grocery/bloc/Product_/get_all_product/get_all_product_bloc.dart';
import 'package:modern_grocery/bloc/Stocks/GetAll_Inventory/get_all_stock_bloc.dart';
import '../../bloc/Stocks/create_stock/add_stock_bloc.dart';

// ✅ FIX: Import the model that the BLOC uses. 
// We alias it as 'GetAllProductModel' to distinguish it clearly.
import 'package:modern_grocery/repositery/model/product/getAllProduct.dart' 
    as GetAllProductModel;
import 'package:modern_grocery/repositery/model/Inventory/getAllnventory.dart'
    as GetAllInventoryModel;

// ❌ REMOVE the mismatched model
// import '../../repositery/model/product/get_all_product_by_category_id_model.dart' as GetAllProduct;

class AddStockPage extends StatefulWidget {
  final GetAllInventoryModel.Data? stockToEdit;
  const AddStockPage({super.key, this.stockToEdit});

  @override
  _AddStockPageState createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();

  // ✅ Update type to match the import alias
  GetAllProductModel.Data? _selectedProduct;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    context.read<GetAllProductBloc>().add(fetchGetAllProduct(''));

    if (widget.stockToEdit != null) {
      _quantityController.text =
          widget.stockToEdit!.quantityInStock?.toString() ?? '';
      // The product dropdown will be set in the BlocBuilder once products are loaded
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.stockToEdit != null;

  void _submitStock() {
    // The logic remains the same for both add and edit, as we are "adding" stock quantity.
    if (_formKey.currentState!.validate()) {
      if (_selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a product.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid quantity.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.read<AddStockBloc>().add(
            SubmitStock(
              // ✅ Ensure sId is accessible here
              productId: _selectedProduct!.id!,
              quantity: quantity,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0A0909),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Stock' : 'Add New Stock'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFFCF8E8),
        elevation: 0,
      ),
      body: BlocListener<AddStockBloc, AddStockState>(
        listener: (context, state) {
          if (state is AddStockLoading) {
            setState(() => _isSaving = true);
          } else if (state is AddStockSuccess) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Stock updated successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.read<GetAllStockBloc>().add(FetchAllStock());
            Navigator.of(context).pop();
          } else if (state is AddStockFailure) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add stock: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProductDropdown(),
                SizedBox(height: 20.h),
                // ... Rest of your text fields (no changes needed here) ...
                TextFormField(
                  controller: _quantityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity to Add',
                    labelStyle: const TextStyle(color: Color(0x91FCF8E8)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFFCF8E8)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFFFF1C5)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid positive number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: _isSaving ? null : _submitStock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF1C5),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          _isEditing ? 'Update Stock' : 'Save Stock',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
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

  Widget _buildProductDropdown() {
    return BlocBuilder<GetAllProductBloc, GetAllProductState>(
      builder: (context, state) {
        if (state is GetAllProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetAllProductLoaded) {
          // ✅ FIX: Renamed variable 'Data' to 'productList' to avoid confusion with the Class name 'Data'
          final productList = state.getAllProduct.data ?? [];

          if (productList.isEmpty) {
            return const Text(
              'No products found.',
              style: TextStyle(color: Colors.white),
            );
          }

          // If editing, find and set the selected product once the list is loaded.
          if (_isEditing && _selectedProduct == null) {
            final initialProduct = productList.firstWhere(
              (p) => p.id == widget.stockToEdit!.productId!.id,
              orElse: () => productList.first,
            );
            _selectedProduct = initialProduct;
          }

          // ✅ Update Dropdown type to GetAllProductModel.Data
          return DropdownButtonFormField<GetAllProductModel.Data>(
            value: _selectedProduct,
            items: productList.map((product) {
              return DropdownMenuItem<GetAllProductModel.Data>(
                value: product,
                child: Text(
                  product.name ?? 'Unnamed Product',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: _isEditing
                ? null // Disable changing product when editing
                : (GetAllProductModel.Data? newValue) {
                    setState(() {
                      _selectedProduct = newValue;
                    });
                  },
            decoration: InputDecoration(
              labelText: 'Select Product',
              labelStyle: const TextStyle(color: Color(0x91FCF8E8)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFFCF8E8)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFFFF1C5)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            disabledHint: _selectedProduct != null ? Text(_selectedProduct!.name ?? 'Unnamed Product', style: const TextStyle(color: Colors.white70)) : null,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
          );
        }

        if (state is GetAllProductError) {
          return const Text(
            'Failed to load products',
            style: TextStyle(color: Colors.red),
          );
        }

        return const Center(
          child: Text(
            'Loading products...',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}