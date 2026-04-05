import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';

import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class CreateExpenseUsecase {
  CreateExpenseUsecase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, Unit>> call(ExpenseEntity request) {
    return _repository.createExpense(request);
  }
}
