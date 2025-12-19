import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/Cart/addCart_api.dart';
import 'package:modern_grocery/repositery/api/Cart/updateCart_api.dart' show UpdateCartApi;

part 'update_cart_event.dart';
part 'update_cart_state.dart';

class UpdateCartBloc extends Bloc<UpdateCartEvent, UpdateCartState> {
  final UpdateCartApi updateCartApi;

  UpdateCartBloc({required this.updateCartApi,}) : super(UpdateCartInitial()) {
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
  }

  Future<void> _onUpdateCartQuantity(
    UpdateCartQuantity event,
    Emitter<UpdateCartState> emit,
  ) async {
    emit(UpdateCartLoading());
    try {
      await updateCartApi.updateCartQuantity(event.productId, event.type);
      emit(UpdateCartSuccess());
    } catch (e) {
      emit(UpdateCartError('Failed to update cart: $e'));
    }
  }
}