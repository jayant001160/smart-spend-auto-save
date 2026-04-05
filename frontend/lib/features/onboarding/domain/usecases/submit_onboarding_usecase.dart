import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';

import '../entities/onboarding_entity.dart';
import '../repositories/onboarding_repository.dart';

class SubmitOnboardingUsecase {
  SubmitOnboardingUsecase(this._repository);

  final OnboardingRepository _repository;

  Future<Either<Failure, Unit>> call(OnboardingEntity request) {
    return _repository.submitOnboarding(request);
  }
}
