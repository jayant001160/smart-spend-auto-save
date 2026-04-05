import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:frontend/features/insights/domain/entities/insight_entity.dart';
import 'package:frontend/features/insights/domain/repositories/insights_repository.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  InsightsRepositoryImpl(this._remoteDataSource);

  final InsightsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<InsightEntity>>> getInsights() async {
    try {
      final models = await _remoteDataSource.getInsights();
      return Right<Failure, List<InsightEntity>>(
        models.map((model) => model.toEntity()).toList(),
      );
    } on NetworkException catch (error) {
      return Left<Failure, List<InsightEntity>>(NetworkFailure(error.message));
    } on CacheException catch (error) {
      return Left<Failure, List<InsightEntity>>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, List<InsightEntity>>(ServerFailure(error.message));
    } catch (_) {
      return const Left<Failure, List<InsightEntity>>(
        ServerFailure('Unexpected error while fetching insights'),
      );
    }
  }
}
