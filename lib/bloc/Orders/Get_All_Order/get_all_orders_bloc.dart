import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/model/Orders/getAllOrders_model.dart';

import '../../../repositery/api/Orders/getAllOrders_api.dart';

part 'get_all_orders_event.dart';
part 'get_all_orders_state.dart';

class GetAllOrdersBloc extends Bloc<GetAllOrdersEvent, GetAllOrdersState> {
  final GetAllOrdersApi getAllOrdersApi = GetAllOrdersApi();

  GetAllOrdersBloc() : super(GetAllOrdersInitial()) {
    on<FetchGetAllOrders>((event, emit) async {
      emit(GetAllOrdersLoading());
      try {
        final model = await getAllOrdersApi.getAllOrders();
        emit(GetAllOrdersLoaded(getAllOrdersModel: model));
      } catch (e) {
        emit(GetAllOrdersError(message: e.toString()));
      }
    });
  }
}