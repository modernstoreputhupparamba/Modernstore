part of 'remove_cart_item_bloc.dart';

@immutable
sealed class RemoveCartItemState {}

final class RemoveCartItemInitial extends RemoveCartItemState {}

final class RemoveCartItemLoading extends RemoveCartItemState {}

final class RemoveCartItemSuccess extends RemoveCartItemState {
  final RemoveCartItemModel model;
  RemoveCartItemSuccess({required this.model});
}

final class RemoveCartItemFailure extends RemoveCartItemState {
  final String error;
  RemoveCartItemFailure({required this.error});
}