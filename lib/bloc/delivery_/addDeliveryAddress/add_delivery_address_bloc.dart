import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/User/addDeliveryAddress_api.dart';
import 'package:modern_grocery/repositery/model/user/addDeliveryAddress.dart';


part 'add_delivery_address_event.dart';
part 'add_delivery_address_state.dart';

class AddDeliveryAddressBloc
    extends Bloc<AddDeliveryAddressEvent, AddDeliveryAddressState> {
  AddDeliveryAddressApi addDeliveryAddressApi = AddDeliveryAddressApi();

  AddDeliveryAddressBloc() : super(AddDeliveryAddressInitial()) {
    on<fetchAddDeliveryAddress>((event, emit) async {
      emit(AddDeliveryAddressLoading());
      try {
        final response =
            await addDeliveryAddressApi.getaddDeliveryAddress(event.DeliveryData);
        emit(AddDeliveryAddressLoaded(DeliveryData: response));
      } catch (e) {
        print(e);
        emit(AddDeliveryAddressError());
      }
    });
  }
}
