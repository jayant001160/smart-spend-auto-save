import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  const OnboardingEntity({
    required this.monthlyIncome,
    required this.goalName,
    required this.targetAmount,
    required this.targetDate,
  });

  final double monthlyIncome;
  final String goalName;
  final double targetAmount;
  final DateTime targetDate;

  @override
  List<Object?> get props => <Object?>[
        monthlyIncome,
        goalName,
        targetAmount,
        targetDate,
      ];
}
