import 'package:equatable/equatable.dart';

class InsightEntity extends Equatable {
  const InsightEntity({
    required this.title,
    required this.description,
    required this.type,
  });

  final String title;
  final String description;
  final String type;

  @override
  List<Object?> get props => <Object?>[title, description, type];
}
