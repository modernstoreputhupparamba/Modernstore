import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/Orders/update_order_status_api.dart';

part 'update_order_status_event.dart';
part 'update_order_status_state.dart';

class UpdateOrderStatusBloc extends Bloc<UpdateOrderStatusEvent, UpdateOrderStatusState> {
  final UpdateOrderStatusApi api = UpdateOrderStatusApi();

  UpdateOrderStatusBloc() : super(UpdateOrderStatusInitial()) {
    on<UpdateOrderStatus>((event, emit) async {
      emit(UpdateOrderStatusLoading());
      try {
        await api.updateOrderStatus(event.orderId, event.status);
        emit(UpdateOrderStatusSuccess(message: "Order status updated successfully"));
      } catch (e) {
        emit(UpdateOrderStatusFailure(error: e.toString()));
      }
    });
  }
}