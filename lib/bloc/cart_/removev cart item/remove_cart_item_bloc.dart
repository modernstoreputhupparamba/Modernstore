import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositery/api/Cart/remove_cart_item_api.dart';
import '../../../repositery/model/Cart/remove_cart_item_model.dart';

part 'remove_cart_item_event.dart';
part 'remove_cart_item_state.dart';

class RemoveCartItemBloc extends Bloc<RemoveCartItemEvent, RemoveCartItemState> {
  final RemoveCartItemApi api;

  RemoveCartItemBloc({required this.api}) : super(RemoveCartItemInitial()) {
    on<RemoveItemEvent>((event, emit) async {
      emit(RemoveCartItemLoading());
      try {
        final response = await api.removeCartItem(event.productId);
        emit(RemoveCartItemSuccess(model: response));
      } catch (e) {
        emit(RemoveCartItemFailure(error: e.toString()));
      }
    });
  }
}