// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      weeklySpend: (json['weeklySpend'] as num).toDouble(),
      monthlySpend: (json['monthlySpend'] as num).toDouble(),
      remainingBudget: (json['remainingBudget'] as num).toDouble(),
      goalProgress: (json['goalProgress'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      chartPoints: (json['chartPoints'] as List<dynamic>)
          .map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      insights: (json['insights'] as List<dynamic>)
          .map((e) => InsightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'weeklySpend': instance.weeklySpend,
      'monthlySpend': instance.monthlySpend,
      'remainingBudget': instance.remainingBudget,
      'goalProgress': instance.goalProgress,
      'recommendation': instance.recommendation,
      'chartPoints': instance.chartPoints.map((e) => e.toJson()).toList(),
      'insights': instance.insights.map((e) => e.toJson()).toList(),
    };
