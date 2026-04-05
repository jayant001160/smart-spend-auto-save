import 'package:frontend/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_model.g.dart';

@JsonSerializable()
class OnboardingModel {
  const OnboardingModel({
    required this.monthlyIncome,
    required this.goalName,
    required this.targetAmount,
    required this.targetDate,
  });

  final double monthlyIncome;
  final String goalName;
  final double targetAmount;
  final String targetDate;

  factory OnboardingModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingModelToJson(this);

  OnboardingEntity toEntity() {
    return OnboardingEntity(
      monthlyIncome: monthlyIncome,
      goalName: goalName,
      targetAmount: targetAmount,
      targetDate: DateTime.parse(targetDate),
    );
  }

  factory OnboardingModel.fromEntity(OnboardingEntity entity) {
    return OnboardingModel(
      monthlyIncome: entity.monthlyIncome,
      goalName: entity.goalName,
      targetAmount: entity.targetAmount,
      targetDate: entity.targetDate.toIso8601String(),
    );
  }
}
