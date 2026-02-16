part of 'get_all_stock_bloc.dart';

@immutable
abstract class GetAllStockState {}

class GetAllStockInitial extends GetAllStockState {}

class GetAllStockLoading extends GetAllStockState {}

class GetAllStockLoaded extends GetAllStockState {
  final GetAllnventory stockModel;
  GetAllStockLoaded({required this.stockModel});
}

class GetAllStockError extends GetAllStockState {
  final String message;
  GetAllStockError({required this.message});
}