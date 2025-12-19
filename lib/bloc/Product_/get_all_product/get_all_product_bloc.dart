import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/product/getallproduct_api.dart';
import 'package:modern_grocery/repositery/model/product/getAllProduct.dart';

part 'get_all_product_event.dart';
part 'get_all_product_state.dart';

class GetAllProductBloc extends Bloc<GetAllProductEvent, GetAllProductState> {
  GetallproductApi getallproductApi = GetallproductApi();

  late GetAllProduct getAllProduct;

  GetAllProductBloc() : super(GetAllProductInitial()) {
    on<fetchGetAllProduct>((event, emit) async {
      emit(GetAllProductLoading());

      try {
        getAllProduct = await getallproductApi.getGetAllProduct(
          event.query,
        );
        emit(GetAllProductLoaded(
          getAllProduct: getAllProduct,
        ));
      } catch (e) {
        print(e);
        emit(GetAllProductError());
      }
      // TODO: implement event handler
    });
  }
}
