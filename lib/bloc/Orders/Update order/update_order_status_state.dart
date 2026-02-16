part of 'update_order_status_bloc.dart';

@immutable
abstract class UpdateOrderStatusState {}

class UpdateOrderStatusInitial extends UpdateOrderStatusState {}

class UpdateOrderStatusLoading extends UpdateOrderStatusState {}

class UpdateOrderStatusSuccess extends UpdateOrderStatusState {
  final String message;
  UpdateOrderStatusSuccess({required this.message});
}

class UpdateOrderStatusFailure extends UpdateOrderStatusState {
  final String error;
  UpdateOrderStatusFailure({required this.error});
}