import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/Orders/cancel_order_api.dart';
import 'package:modern_grocery/repositery/model/Orders/cancel_order_model.dart';



part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final CancelOrderApi cancelOrderApi = CancelOrderApi();

  CancelOrderBloc() : super(CancelOrderInitial()) {
    on<CancelOrder>((event, emit) async {
      emit(CancelOrderLoading());
      try {
        final model = await cancelOrderApi.cancelOrder(event.orderId, event.reason);
        emit(CancelOrderLoaded(cancelOrderModel: model));
      } catch (e) {
        emit(CancelOrderError(message: e.toString()));
      }
    });
  }
}