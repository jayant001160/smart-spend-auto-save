import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';

import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUsecase {
  GetDashboardUsecase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, DashboardEntity>> call() {
    return _repository.getDashboard();
  }
}
