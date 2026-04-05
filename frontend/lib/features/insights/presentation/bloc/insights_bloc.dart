import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/insights/domain/usecases/get_insights_usecase.dart';

import 'insights_event.dart';
import 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  InsightsBloc(this._getInsightsUsecase) : super(const InsightsState()) {
    on<FetchInsightsEvent>(_onFetchInsights);
  }

  final GetInsightsUsecase _getInsightsUsecase;

  Future<void> _onFetchInsights(
    FetchInsightsEvent event,
    Emitter<InsightsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getInsightsUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          isLoading: false,
          items: items,
          clearError: true,
        ),
      ),
    );
  }
}
