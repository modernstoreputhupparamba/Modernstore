import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/Stocks/GetAll_Inventory/get_all_stock_bloc.dart';
import '../../repositery/model/Inventory/getAllnventory.dart';
import 'add_stock_page.dart';

class AdminStock extends StatefulWidget {
  const AdminStock({super.key});

  @override
  _AdminStockState createState() => _AdminStockState();
}

class _AdminStockState extends State<AdminStock> {
  final TextEditingController _searchController = TextEditingController();
  List<Data> _allStocks = [];
  List<Data> _filteredStocks = [];

  @override
  void initState() {
    super.initState();
    context.read<GetAllStockBloc>().add(FetchAllStock());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStocks = _allStocks.where((stock) => stock.productId?.name?.toLowerCase().contains(query) ?? false).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0A0909),
      body: Column(
        children: [
          SizedBox(height: 44.h),
          _buildAppBar(),
          SizedBox(height: 40.h),
          _buildSearchBar(),
          SizedBox(height: 20.h),
          Expanded(child: _buildStockBloc()),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Spacer(), // Uses available space to push items to the right
        badges.Badge(
          badgeContent: const Text('3', style: TextStyle(color: Colors.white)),
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          child: SvgPicture.asset('assets/Group.svg'),
        ),
        SizedBox(width: 16),
        IconButton(
          icon: SvgPicture.asset('assets/Group 6918.svg'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search here",
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
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddStockPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1C5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockBloc() {
    return BlocBuilder<GetAllStockBloc, GetAllStockState>(
      builder: (context, state) {
        if (state is GetAllStockLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[800]!,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          );
        }

        if (state is GetAllStockError) {
          return Center(
            child: Text(
              'Failed to load stock: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is GetAllStockLoaded) {
          _allStocks = state.stockModel.data ?? [];
          if (_searchController.text.isEmpty) _filteredStocks = _allStocks;
          final stocks = _filteredStocks;
          if (stocks.isEmpty) {
            return const Center(
              child: Text(
                'No stock data found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30.w,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.black), // Background color for header
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.black), // Row background color
              border: TableBorder.all(color: const Color(0xFFF5E9B5)),
              columns: const [
                DataColumn(
                  label: Text('SL No', style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label: Text('Product Name',
                      style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label: Text('Unit', style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label: Text('Qty In Stock',
                      style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label:
                      Text('Sold Qty', style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label: Text('Total Stock',
                      style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
                DataColumn(
                  label:
                      Text('Actions', style: TextStyle(color: Color(0xFFF5E9B5))),
                ),
              ],
              rows: stocks.asMap().entries.map((entry) {
                int index = entry.key;
                var stock = entry.value;

                return DataRow(cells: [
                  DataCell(Text((index + 1).toString(),
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(stock.productId?.name ?? 'N/A',
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(stock.unit ?? 'N/A',
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(stock.quantityInStock?.toString() ?? '0',
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(stock.soldQuantity?.toString() ?? '0',
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(stock.totalStock?.toString() ?? '0',
                      style: const TextStyle(color: Colors.white))),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFFF5E9B5)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddStockPage(stockToEdit: stock)),
                        );
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        }

        return const Center(
          child: Text('No stock data available.',
              style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
