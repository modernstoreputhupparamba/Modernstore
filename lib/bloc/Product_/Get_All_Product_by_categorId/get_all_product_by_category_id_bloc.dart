import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


import '../../../repositery/api/product/get_all_product_by_category_id_api.dart';
import '../../../repositery/model/product/get_all_product_by_category_id_model.dart';

part 'get_all_product_by_category_id_event.dart';
part 'get_all_product_by_category_id_state.dart';

class GetAllProductByCategoryIdBloc
    extends Bloc<GetAllProductByCategoryIdEvent, GetAllProductByCategoryIdState> {
  final GetAllProductByCategoryIdApi _api = GetAllProductByCategoryIdApi();

  GetAllProductByCategoryIdBloc() : super(GetAllProductByCategoryIdInitial()) {
    on<FetchAllProductByCategoryId>((event, emit) async {
      emit(GetAllProductByCategoryIdLoading());
      try {
        final products = await _api.getProductsByCategoryId(event.categoryId);
        emit(GetAllProductByCategoryIdLoaded(products));
      } catch (e) {
        emit(GetAllProductByCategoryIdError(e.toString()));
      }
    });
  }
}