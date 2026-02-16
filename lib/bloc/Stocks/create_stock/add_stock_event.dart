part of 'add_stock_bloc.dart';

@immutable
abstract class AddStockEvent {}

class SubmitStock extends AddStockEvent {
  final String productId;
  final int quantity;

  SubmitStock({
    required this.productId,
    required this.quantity,
  });
}