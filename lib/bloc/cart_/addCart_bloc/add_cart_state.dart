part of 'add_cart_bloc.dart';

@immutable
sealed class AddCartState {}

class AddCartInitial extends AddCartState {}

class AddCartLoading extends AddCartState {}

class AddCartLoaded extends AddCartState {
    final AddToCartResponse response;

  AddCartLoaded(this.response);
}

class AddCartError extends AddCartState {
  final String message;

  AddCartError(this.message);
}
