import 'package:equatable/equatable.dart';
import 'package:frontend/features/insights/domain/entities/insight_entity.dart';

class InsightsState extends Equatable {
  const InsightsState({
    this.isLoading = false,
    this.items = const <InsightEntity>[],
    this.errorMessage,
  });

  final bool isLoading;
  final List<InsightEntity> items;
  final String? errorMessage;

  InsightsState copyWith({
    bool? isLoading,
    List<InsightEntity>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InsightsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[isLoading, items, errorMessage];
}
