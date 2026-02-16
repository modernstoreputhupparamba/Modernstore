import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/Cart/addCart_api.dart';

part 'add_cart_event.dart';
part 'add_cart_state.dart';

class AddCartBloc extends Bloc<AddCartEvent, AddCartState> {
  final AddCartApi addCartApi;

  AddCartBloc({required this.addCartApi}) : super(AddCartInitial()) {
    on<FetchAddCart>(_onFetchAddCart);
  }

  Future<void> _onFetchAddCart(
    FetchAddCart event,
    Emitter<AddCartState> emit,
  ) async {
    emit(AddCartLoading());
    try {
      final response = await addCartApi.getAddCartModel(
        event.productId,
        event.quantity,
      );
      emit(AddCartLoaded(response));
    } catch (e) {
      emit(AddCartError('Failed to add to cart: $e'));
    }
  }
}
