import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failure.dart';

import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> submitOnboarding(OnboardingEntity request);
}
