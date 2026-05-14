part of 'remove_cart_item_bloc.dart';

@immutable
sealed class RemoveCartItemEvent {}

class RemoveItemEvent extends RemoveCartItemEvent {
  final String productId;
  RemoveItemEvent({required this.productId});
}