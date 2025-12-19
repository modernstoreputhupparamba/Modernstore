import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


import '../../repositery/api/Dashboard/dashboard_api.dart';
import '../../repositery/model/Dashboard/dashboard_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardApi dashboardApi = DashboardApi();

  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try {
        final model = await dashboardApi.getDashboardData();
        emit(DashboardLoaded(dashboardModel: model));
      } catch (e) {
        emit(DashboardError(message: e.toString()));
      }
    });
  }
}