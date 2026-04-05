// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingModel _$OnboardingModelFromJson(Map<String, dynamic> json) =>
    OnboardingModel(
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      goalName: json['goalName'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      targetDate: json['targetDate'] as String,
    );

Map<String, dynamic> _$OnboardingModelToJson(OnboardingModel instance) =>
    <String, dynamic>{
      'monthlyIncome': instance.monthlyIncome,
      'goalName': instance.goalName,
      'targetAmount': instance.targetAmount,
      'targetDate': instance.targetDate,
    };
