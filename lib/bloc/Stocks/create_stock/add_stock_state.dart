part of 'add_stock_bloc.dart';

@immutable
abstract class AddStockState {}

class AddStockInitial extends AddStockState {}

class AddStockLoading extends AddStockState {}

class AddStockSuccess extends AddStockState {}

class AddStockFailure extends AddStockState {
  final String error;
  AddStockFailure({required this.error});
}