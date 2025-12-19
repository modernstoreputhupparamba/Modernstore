import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


import '../../../repositery/api/product/updateProduct_api.dart';
import '../../../repositery/model/product/updateProduct_model.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final UpdateProductApi updateProductApi = UpdateProductApi();

  UpdateProductBloc() : super(UpdateProductInitial()) {
    on<FetchUpdateProduct>((event, emit) async {
      emit(UpdateProductLoading());
      try {
        final model = await updateProductApi.updateProduct(
          productId: event.productId,
          productName: event.productName,
          productDescription: event.productDescription,
          price: event.price,
          imageFile: event.imageFile, // Can be null
          categoryId: event.categoryId,
          discountPercentage: event.discountPercentage,
          unit: event.unit,
        );
        emit(UpdateProductLoaded(updateProduct: model));
      } catch (e) {
        emit(UpdateProductError(message: e.toString()));
      }
    });
  }
}