part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboardModel;
  DashboardLoaded({required this.dashboardModel});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});
}