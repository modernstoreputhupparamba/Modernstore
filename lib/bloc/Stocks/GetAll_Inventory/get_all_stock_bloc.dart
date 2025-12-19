import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


import '../../../repositery/api/inventory/getallinventory_api.dart';
import '../../../repositery/model/Inventory/getAllnventory.dart';

part 'get_all_stock_event.dart';
part 'get_all_stock_state.dart';

class GetAllStockBloc extends Bloc<GetAllStockEvent, GetAllStockState> {
  final GetAllInventoryApi getAllStockApi = GetAllInventoryApi();

  GetAllStockBloc() : super(GetAllStockInitial()) {
    on<FetchAllStock>((event, emit) async {
      emit(GetAllStockLoading());
      try {
        final model = await getAllStockApi.getGetAllnventory();
        emit(GetAllStockLoaded(stockModel: model));
      } catch (e) {
        emit(GetAllStockError(message: e.toString()));
      }
    });
  }
}