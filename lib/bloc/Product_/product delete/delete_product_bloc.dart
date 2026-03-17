import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositery/api/product/delete_product_api.dart';
import '../../../repositery/model/product/delete_product_model.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final DeleteProductApi deleteProductApi = DeleteProductApi();

  DeleteProductBloc() : super(DeleteProductInitial()) {
    on<FetchDeleteProduct>((event, emit) async {
      emit(DeleteProductLoading());
      try {
        final model = await deleteProductApi.deleteProduct(
          productId: event.productId,
        );
        emit(DeleteProductLoaded(deleteProductModel: model));
      } catch (e) {
        emit(DeleteProductError(message: e.toString()));
      }
    });
  }
}