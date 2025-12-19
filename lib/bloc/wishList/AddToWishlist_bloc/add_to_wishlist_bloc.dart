import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/fav/addToWishlist_api.dart';
import 'package:modern_grocery/repositery/model/Wishlist/addToWishlist_model.dart';

part 'add_to_wishlist_event.dart';
part 'add_to_wishlist_state.dart';

class AddToWishlistBloc extends Bloc<AddToWishlistEvent, AddToWishlistState> {
  final AddToWishlistApi addToWishlistApi = AddToWishlistApi();

  late AddToWishlistMode addToWishlistMode;

  AddToWishlistBloc() : super(AddToWishlistInitial()) {
    on<fetchAddToWishlistEvent>((event, emit) async {
      emit(AddToWishlistLoading());
      try {
        addToWishlistMode = await addToWishlistApi.getAddToWishlistMode(event.productId);
        emit(AddToWishlistLoaded());
      } catch (e) {
        print("Add to Wishlist Error: $e");
        emit(AddToWishlistError());
      }
    });
  }
}
