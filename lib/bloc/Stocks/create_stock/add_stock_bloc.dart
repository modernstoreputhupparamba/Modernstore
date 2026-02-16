import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/inventory/add_inventory_api.dart';

part 'add_stock_event.dart';
part 'add_stock_state.dart';

class AddStockBloc extends Bloc<AddStockEvent, AddStockState> {
  final AddInventoryApi addInventoryApi = AddInventoryApi();

  AddStockBloc() : super(AddStockInitial()) {
    on<SubmitStock>((event, emit) async {
      emit(AddStockLoading());
      try {
        await addInventoryApi.addInventory(
          productId: event.productId,
          quantity: event.quantity,
        );
        emit(AddStockSuccess());
      } catch (e) {
        emit(AddStockFailure(error: e.toString()));
      }
    });
  }
}