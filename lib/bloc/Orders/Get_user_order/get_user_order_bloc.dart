import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:modern_grocery/repositery/api/Orders/GetUserOrder_api.dart';
import 'package:modern_grocery/repositery/model/Orders/Get_user_order_Model.dart';



part 'get_user_order_event.dart';
part 'get_user_order_state.dart';

class GetUserOrderBloc extends Bloc<GetUserOrderEvent, GetUserOrderState> {
  final GetUserOrderApi getUserOrderApi;

  GetUserOrderBloc({required this.getUserOrderApi})
      : super(GetUserOrderInitial()) {
    on<FetchGetUserOrders>((event, emit) async {
      emit(GetUserOrderLoading());
      try {
        final model = await getUserOrderApi.getUserOrders();
        emit(GetUserOrderLoaded(getUserOrderModel: model));
      } catch (e) {
        emit(GetUserOrderError(message: e.toString()));
      }
    });
  }
}
