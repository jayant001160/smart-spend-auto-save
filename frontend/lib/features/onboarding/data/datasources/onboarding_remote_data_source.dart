import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/network/network_manager.dart';

import '../models/onboarding_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<void> submitOnboarding(OnboardingModel request);
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl(this._networkManager);

  final NetworkManager _networkManager;

  @override
  Future<void> submitOnboarding(OnboardingModel request) async {
    await _networkManager.post(
      ApiConstants.userProfile,
      data: <String, dynamic>{
        'monthlyIncome': request.monthlyIncome,
        'monthlyBudget': request.monthlyIncome,
      },
    );

    await _networkManager.post(
      ApiConstants.goal,
      data: <String, dynamic>{
        'goalName': request.goalName,
        'targetAmount': request.targetAmount,
        'targetDate': request.targetDate,
      },
    );
  }
}
