part of 'update_cart_bloc.dart';

@immutable
sealed class UpdateCartEvent {}

class UpdateCartQuantity extends UpdateCartEvent {
  final String productId;
  final String type;


  UpdateCartQuantity({required this.productId, required this.type});
}