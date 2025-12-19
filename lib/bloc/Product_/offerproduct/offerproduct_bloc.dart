import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/product/offerproduct_api.dart';
import 'package:modern_grocery/repositery/model/product/offerproduct%20model.dart';

part 'offerproduct_event.dart';
part 'offerproduct_state.dart';

class OfferproductBloc extends Bloc<OfferproductEvent, OfferproductState> {
  OfferproductApi offerproductApi = OfferproductApi();
  late OfferproductModel offerproductModel;

  OfferproductBloc() : super(OfferproductInitial()) {
    on<fetchOfferproductEvent>((event, emit) async {
      emit(OfferproductLoading());
      try {
        offerproductModel = await offerproductApi.getOfferproductModel();
        emit(OfferproductLoaded(
          offerproductModel: offerproductModel,
        ));
      } catch (e) {
        if (kDebugMode) { 
          print(e);
        }
        emit(OfferproductError());
      }
    });
  }
}
