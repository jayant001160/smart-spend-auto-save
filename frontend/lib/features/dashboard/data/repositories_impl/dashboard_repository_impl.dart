import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:frontend/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._remoteDataSource);

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final model = await _remoteDataSource.getDashboard();
      return Right<Failure, DashboardEntity>(model.toEntity());
    } on NetworkException catch (error) {
      return Left<Failure, DashboardEntity>(NetworkFailure(error.message));
    } on CacheException catch (error) {
      return Left<Failure, DashboardEntity>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, DashboardEntity>(ServerFailure(error.message));
    } catch (_) {
      return const Left<Failure, DashboardEntity>(
        ServerFailure('Unexpected error while fetching dashboard'),
      );
    }
  }
}
