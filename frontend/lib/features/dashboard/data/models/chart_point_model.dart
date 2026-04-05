import 'package:frontend/features/dashboard/domain/entities/chart_point_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_point_model.g.dart';

@JsonSerializable()
class ChartPointModel {
  const ChartPointModel({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  factory ChartPointModel.fromJson(Map<String, dynamic> json) =>
      _$ChartPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChartPointModelToJson(this);

  ChartPointEntity toEntity() => ChartPointEntity(label: label, value: value);
}
