import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/product/createProduct_api.dart';
import 'package:modern_grocery/repositery/model/product/createProduct_model.dart';

part 'create_product_event.dart';
part 'create_product_state.dart';

class CreateProductBloc extends Bloc<CreateProductEvent, CreateProductState> {
  final CreateProductApi createProductApi = CreateProductApi();

  CreateProductBloc() : super(CreateProductInitial()) {
    on<fetchCreateProduct>((event, emit) async {
      emit(CreateProductILoading());
      try {
        final model = await createProductApi.uploadProduct(
            productName: event.productName,
            productDescription: event.productDescription,
            price: event.price,
            imageFile: event.imageFile,
            categoryId: event.categoryId,
            discountPercentage: event.discountPercentage,
            productDetails: event.productDescription,
            unit: event.unit);
        emit(CreateProductLoaded(createProduct: CreateProductModel()));
      } catch (e) {
        emit(CreateProductError(message: e.toString()));
      }
    });
  }
}
