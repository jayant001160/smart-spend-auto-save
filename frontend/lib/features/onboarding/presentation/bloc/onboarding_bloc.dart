import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/submission_status.dart';
import 'package:frontend/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:frontend/features/onboarding/domain/usecases/submit_onboarding_usecase.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._submitOnboardingUsecase)
      : super(const OnboardingState()) {
    on<SubmitOnboardingEvent>(_onSubmit);
  }

  final SubmitOnboardingUsecase _submitOnboardingUsecase;

  Future<void> _onSubmit(
    SubmitOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: SubmissionStatus.submitting, clearError: true));
    final result = await _submitOnboardingUsecase(
      OnboardingEntity(
        monthlyIncome: event.monthlyIncome,
        goalName: event.goalName,
        targetAmount: event.targetAmount,
        targetDate: event.targetDate,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: SubmissionStatus.success,
          clearError: true,
        ),
      ),
    );
  }
}
