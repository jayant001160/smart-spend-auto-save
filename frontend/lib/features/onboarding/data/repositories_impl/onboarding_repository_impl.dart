import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:frontend/features/onboarding/data/models/onboarding_model.dart';
import 'package:frontend/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:frontend/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._remoteDataSource);

  final OnboardingRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Unit>> submitOnboarding(
      OnboardingEntity request) async {
    try {
      await _remoteDataSource.submitOnboarding(
        OnboardingModel.fromEntity(request),
      );
      return const Right<Failure, Unit>(unit);
    } on NetworkException catch (error) {
      return Left<Failure, Unit>(NetworkFailure(error.message));
    } on CacheException catch (error) {
      return Left<Failure, Unit>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, Unit>(ServerFailure(error.message));
    } catch (_) {
      return const Left<Failure, Unit>(
        ServerFailure('Unexpected error while onboarding'),
      );
    }
  }
}
