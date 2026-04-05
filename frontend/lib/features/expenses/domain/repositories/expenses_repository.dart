import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';

import '../entities/expense_entity.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, Unit>> createExpense(ExpenseEntity request);
}
