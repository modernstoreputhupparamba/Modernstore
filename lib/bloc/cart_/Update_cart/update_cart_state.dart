part of 'update_cart_bloc.dart';

@immutable
sealed class UpdateCartState {}

class UpdateCartInitial extends UpdateCartState {}

class UpdateCartLoading extends UpdateCartState {}

class UpdateCartSuccess extends UpdateCartState {}

class UpdateCartError extends UpdateCartState {
  final String message;
  UpdateCartError(this.message);
}