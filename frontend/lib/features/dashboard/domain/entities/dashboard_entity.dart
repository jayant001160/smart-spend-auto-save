import 'package:equatable/equatable.dart';
import 'package:frontend/features/dashboard/domain/entities/chart_point_entity.dart';
import 'package:frontend/features/insights/domain/entities/insight_entity.dart';

class DashboardEntity extends Equatable {
  const DashboardEntity({
    required this.weeklySpend,
    required this.monthlySpend,
    required this.remainingBudget,
    required this.goalProgress,
    required this.recommendation,
    required this.chartPoints,
    required this.insights,
  });

  final double weeklySpend;
  final double monthlySpend;
  final double remainingBudget;
  final double goalProgress;
  final String recommendation;
  final List<ChartPointEntity> chartPoints;
  final List<InsightEntity> insights;

  @override
  List<Object?> get props => <Object?>[
        weeklySpend,
        monthlySpend,
        remainingBudget,
        goalProgress,
        recommendation,
        chartPoints,
        insights,
      ];
}
