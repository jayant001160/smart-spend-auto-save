import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/dashboard/domain/usecases/get_dashboard_usecase.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getDashboardUsecase) : super(const DashboardState()) {
    on<FetchDashboardEvent>(_onFetchDashboard);
  }

  final GetDashboardUsecase _getDashboardUsecase;

  Future<void> _onFetchDashboard(
    FetchDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getDashboardUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          isLoading: false,
          data: dashboard,
          clearError: true,
        ),
      ),
    );
  }
}
