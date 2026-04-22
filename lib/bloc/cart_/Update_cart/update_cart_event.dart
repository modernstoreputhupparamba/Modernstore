part of 'update_cart_bloc.dart';

@immutable
sealed class UpdateCartEvent {}

class UpdateCartQuantity extends UpdateCartEvent {
  final String productId;
  final num quantity;


  UpdateCartQuantity({required this.productId, required this.quantity});
}