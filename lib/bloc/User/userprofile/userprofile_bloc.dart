import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/User/getUserProfile_api.dart';
import 'package:modern_grocery/repositery/model/user/getUserProfile.dart';

part 'userprofile_event.dart';
part 'userprofile_state.dart';

class UserprofileBloc extends Bloc<UserprofileEvent, UserprofileState> {
  GetUserProfileApi getuserprofileApi = GetUserProfileApi();

  late GetUserProfile getUserProfile;

  UserprofileBloc() : super(UserprofileInitial()) {
    on<fetchUserprofile>((event, emit) async {
      emit(Userprofileloading());
      try {
        getUserProfile = await getuserprofileApi.getGetUserProfile();
        emit(Userprofileloaded(
          user: getUserProfile,
        ));
      } catch (e) {
        print('UserProfile Error: $e');
     
        if (e.toString().contains('401') || e.toString().contains('Invalid token')) {
          print('Token is invalid or expired');
        }
        emit(UserprofileError());
      }
    });
  }
}
