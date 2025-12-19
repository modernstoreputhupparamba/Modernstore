part of 'create_order_bloc.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final CreateOrderModel? createOrderModel;

  const CreateOrderSuccess(this.createOrderModel);
}

class CreateOrderFailure extends CreateOrderState {
  final String error;

  const CreateOrderFailure(this.error);
}