import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../repositery/api/Orders/Create_order_Api.dart';
import '../../../repositery/model/Orders/createOrder_model.dart';
 
part 'create_order_event.dart';
part 'create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final CreateOrderApi createOrderApi;

  CreateOrderBloc({required this.createOrderApi})
      : super(CreateOrderInitial()) {
    on<CreateOrderButtonPressed>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrderButtonPressed event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(CreateOrderLoading());

    try {
      final response = await createOrderApi.createOrder(
       
        shippingAddress: event.shippingAddress,
        paymentMethod: event.paymentMethod,
        deliveryCharge: event.deliveryCharge,
      );

      if (response.success) {
        // The API returns `data` which is a Map that can be parsed by CreateOrderModel.
       CreateOrderModel? createOrderModel;
        if (response.data != null && response.data is Map<String, dynamic>) {
          createOrderModel = CreateOrderModel.fromJson(response.data);
        }
        
        emit(CreateOrderSuccess(createOrderModel));
      } else {
        emit(CreateOrderFailure(
          response.message.isNotEmpty ? response.message : 'Order creation failed',
        ));
      }
    } catch (e) {
      emit(CreateOrderFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
