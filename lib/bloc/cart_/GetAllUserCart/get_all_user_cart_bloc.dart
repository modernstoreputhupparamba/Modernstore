import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/Cart/getAllUserCart_api.dart';
import 'package:modern_grocery/repositery/model/Cart/getAllUserCart_model.dart';

part 'get_all_user_cart_event.dart';
part 'get_all_user_cart_state.dart';

class GetAllUserCartBloc
    extends Bloc<GetAllUserCartEvent, GetAllUserCartState> {
  GetallusercartApi getallusercartApi = GetallusercartApi();

  late GetAllUserCartModel getAllUserCartModel;
  GetAllUserCartBloc() : super(GetAllUserCartInitial()) {
    on<fetchGetAllUserCartEvent>((event, emit) async {
      emit(GetAllUserCartLoading());

      try {
        getAllUserCartModel = await getallusercartApi.getGetAllUserCartModel();
        emit(GetAllUserCartLoaded());
      } catch (e) {
        print(e);
        emit(GetAllUserCartError());
      }
      
    });
  }
}
