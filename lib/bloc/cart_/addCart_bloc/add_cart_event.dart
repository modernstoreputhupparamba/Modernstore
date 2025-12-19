part of 'add_cart_bloc.dart';

@immutable
sealed class AddCartEvent {}

class FetchAddCart extends AddCartEvent {
  final String productId;
  final int quantity;

  FetchAddCart({required this.productId, required this.quantity});
}