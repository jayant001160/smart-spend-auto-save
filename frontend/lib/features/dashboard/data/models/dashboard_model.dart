import 'package:frontend/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:frontend/features/insights/data/models/insight_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chart_point_model.dart';

part 'dashboard_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardModel {
  const DashboardModel({
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
  final List<ChartPointModel> chartPoints;
  final List<InsightModel> insights;

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);

  factory DashboardModel.fromApiResponse(Map<String, dynamic> json) {
    final Map<String, dynamic> payload =
        (json['data'] as Map<String, dynamic>? ?? json);

    final Map<String, dynamic> categoryBreakdown =
        (payload['categoryBreakdown'] as Map<String, dynamic>? ??
            <String, dynamic>{});
    final List<ChartPointModel> chartPoints = categoryBreakdown.entries
        .map(
          (MapEntry<String, dynamic> entry) => ChartPointModel(
            label: entry.key,
            value: (entry.value as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();

    final List<dynamic> rawInsights =
        payload['insights'] as List<dynamic>? ?? <dynamic>[];
    final List<InsightModel> insights = rawInsights
        .whereType<String>()
        .toList()
        .asMap()
        .entries
        .map(
          (MapEntry<int, String> entry) => InsightModel(
            title: 'Insight ${entry.key + 1}',
            description: entry.value,
            type: 'info',
          ),
        )
        .toList();

    final num recommendationAmount = payload['recommendedSave'] as num? ?? 0;

    return DashboardModel(
      weeklySpend: (payload['weeklySpend'] as num?)?.toDouble() ?? 0,
      monthlySpend: (payload['monthlySpend'] as num?)?.toDouble() ?? 0,
      remainingBudget: (payload['remainingBudget'] as num?)?.toDouble() ?? 0,
      goalProgress: (payload['goalProgress'] as num?)?.toDouble() ?? 0,
      recommendation:
          'Recommended auto-save this week: INR ${recommendationAmount.round()}',
      chartPoints: chartPoints,
      insights: insights,
    );
  }

  DashboardEntity toEntity() {
    return DashboardEntity(
      weeklySpend: weeklySpend,
      monthlySpend: monthlySpend,
      remainingBudget: remainingBudget,
      goalProgress: goalProgress,
      recommendation: recommendation,
      chartPoints:
          chartPoints.map((ChartPointModel e) => e.toEntity()).toList(),
      insights: insights.map((InsightModel e) => e.toEntity()).toList(),
    );
  }
}
