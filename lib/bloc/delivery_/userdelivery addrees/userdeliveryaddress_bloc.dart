import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/User/GetUserDlvAddresses_api.dart';
import 'package:modern_grocery/repositery/model/user/getUserDlvAddresses.dart';

part 'userdeliveryaddress_event.dart';
part 'userdeliveryaddress_state.dart';

class UserdeliveryaddressBloc
    extends Bloc<UserdeliveryaddressEvent, UserdeliveryaddressState> {
  final GetUserDeliveryAddressesApi api = GetUserDeliveryAddressesApi();

  UserdeliveryaddressBloc() : super(const UserdeliveryaddressInitial()) {
    on<FetchUserdeliveryaddressEvent>((event, emit) async {
      emit(const UserdeliveryaddressLoading());

      try {
        final response = await api.getGetUserDlvAddresses();

        emit(UserdeliveryaddressLoaded(response));
      } catch (e) {
        emit(UserdeliveryaddressError(e.toString()));
      }
    });
  }
}
