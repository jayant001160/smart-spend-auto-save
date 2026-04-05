import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/insights/domain/entities/insight_entity.dart';
import 'package:frontend/features/insights/domain/repositories/insights_repository.dart';

class GetInsightsUsecase {
  GetInsightsUsecase(this._repository);

  final InsightsRepository _repository;

  Future<Either<Failure, List<InsightEntity>>> call() {
    return _repository.getInsights();
  }
}
