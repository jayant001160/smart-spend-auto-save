import 'package:frontend/features/insights/domain/entities/insight_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'insight_model.g.dart';

@JsonSerializable()
class InsightModel {
  const InsightModel({
    required this.title,
    required this.description,
    required this.type,
  });

  final String title;
  final String description;
  final String type;

  factory InsightModel.fromJson(Map<String, dynamic> json) =>
      _$InsightModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsightModelToJson(this);

  InsightEntity toEntity() {
    return InsightEntity(
      title: title,
      description: description,
      type: type,
    );
  }
}
