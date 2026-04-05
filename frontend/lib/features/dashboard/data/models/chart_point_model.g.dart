// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartPointModel _$ChartPointModelFromJson(Map<String, dynamic> json) =>
    ChartPointModel(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$ChartPointModelToJson(ChartPointModel instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};
