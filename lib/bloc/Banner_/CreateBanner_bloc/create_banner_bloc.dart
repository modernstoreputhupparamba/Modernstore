import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modern_grocery/repositery/api/banner/CreateBanner_api.dart';
import 'package:modern_grocery/repositery/model/Banner/CreateBanner_model.dart';
import 'package:meta/meta.dart';

part 'create_banner_event.dart';
part 'create_banner_state.dart';

class CreateBannerBloc extends Bloc<CreateBannerEvent, CreateBannerState> {
  final CreatebannerApi api;

  CreateBannerBloc({required this.api}) : super(CreateBannerInitial()) {
    on<FetchCreateBannerEvent>((event, emit) async {
      emit(CreateBannerLoading());
      try {
        final result = await api.uploadBanner(
          title: event.title,
          category: event.category,
          type: event.type,
          categoryId: event.categoryId,
          link: event.link,
          imageFile: event.imagePath,        // ✅ File -> File
          onSendProgress: event.onSendProgress, // ❗ but unused in API
        );
        emit(CreateBannerLoaded(result: result));
      } catch (e) {
        emit(CreateBannerError(message: e.toString()));
      }
    });
  }
}

