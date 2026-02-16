import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/fav/getToWishlist_api.dart';
import 'package:modern_grocery/repositery/model/Wishlist/getToWishlist_model.dart';

part 'get_to_wishlist_event.dart';
part 'get_to_wishlist_state.dart';

class GetToWishlistBloc extends Bloc<GetToWishlistEvent, GetToWishlistState> {
  GettowishlistApi gettowishlistApi = GettowishlistApi();

  late GetToWishlistModel getToWishlistModel;
  GetToWishlistBloc() : super(GetToWishlistInitial()) {
    on<fetchGetToWishlistEvent>((event, emit) async {
      emit(GetToWishlistLoading());
      try {
        getToWishlistModel = await gettowishlistApi.getGetToWishlistModel();
        emit(GetToWishlistLoaded());
      } catch (e) {
        print(e);
        emit(GetToWishlistError());
      }
    });
  }
}
