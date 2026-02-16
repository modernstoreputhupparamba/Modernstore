part of 'update_order_status_bloc.dart';

@immutable
abstract class UpdateOrderStatusEvent {}

class UpdateOrderStatus extends UpdateOrderStatusEvent {
  final String orderId;
  final String status;

  UpdateOrderStatus({required this.orderId, required this.status});
}