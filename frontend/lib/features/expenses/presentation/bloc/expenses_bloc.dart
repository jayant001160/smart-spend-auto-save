import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/submission_status.dart';
import 'package:frontend/features/expenses/domain/entities/expense_entity.dart';
import 'package:frontend/features/expenses/domain/usecases/create_expense_usecase.dart';
import 'package:uuid/uuid.dart';

import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc(this._createExpenseUsecase, this._uuid)
      : super(const ExpensesState()) {
    on<SubmitExpenseEvent>(_onSubmitExpense);
  }

  final CreateExpenseUsecase _createExpenseUsecase;
  final Uuid _uuid;

  Future<void> _onSubmitExpense(
    SubmitExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(state.copyWith(status: SubmissionStatus.submitting, clearError: true));

    final result = await _createExpenseUsecase(
      ExpenseEntity(
        requestId: _uuid.v4(),
        amount: event.amount,
        category: event.category,
        merchant: event.merchant,
        date: event.date,
        paymentMode: event.paymentMode,
        notes: event.notes,
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
