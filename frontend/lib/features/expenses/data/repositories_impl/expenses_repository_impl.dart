import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:frontend/features/expenses/data/models/expense_model.dart';
import 'package:frontend/features/expenses/domain/entities/expense_entity.dart';
import 'package:frontend/features/expenses/domain/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(this._remoteDataSource);

  final ExpensesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Unit>> createExpense(ExpenseEntity request) async {
    try {
      await _remoteDataSource.createExpense(ExpenseModel.fromEntity(request));
      return const Right<Failure, Unit>(unit);
    } on NetworkException catch (error) {
      return Left<Failure, Unit>(NetworkFailure(error.message));
    } on CacheException catch (error) {
      return Left<Failure, Unit>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, Unit>(ServerFailure(error.message));
    } catch (_) {
      return const Left<Failure, Unit>(
        ServerFailure('Unexpected error while adding expense'),
      );
    }
  }
}
