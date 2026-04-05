import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';
import 'package:frontend/features/insights/domain/entities/insight_entity.dart';

abstract class InsightsRepository {
  Future<Either<Failure, List<InsightEntity>>> getInsights();
}
