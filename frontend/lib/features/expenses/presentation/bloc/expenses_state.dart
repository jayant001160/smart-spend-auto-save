import 'package:equatable/equatable.dart';
import 'package:frontend/core/constants/submission_status.dart';

class ExpensesState extends Equatable {
  const ExpensesState({
    this.status = SubmissionStatus.idle,
    this.errorMessage,
  });

  final SubmissionStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == SubmissionStatus.submitting;
  bool get isSuccess => status == SubmissionStatus.success;
  bool get hasFailure => status == SubmissionStatus.failure;

  ExpensesState copyWith({
    SubmissionStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ExpensesState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, errorMessage];
}
