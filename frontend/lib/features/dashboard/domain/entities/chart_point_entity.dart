import 'package:equatable/equatable.dart';

class ChartPointEntity extends Equatable {
  const ChartPointEntity({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  List<Object?> get props => <Object?>[label, value];
}
