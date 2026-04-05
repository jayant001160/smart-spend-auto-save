import 'package:equatable/equatable.dart';
import 'package:frontend/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  final bool isLoading;
  final DashboardEntity? data;
  final String? errorMessage;

  DashboardState copyWith({
    bool? isLoading,
    DashboardEntity? data,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[isLoading, data, errorMessage];
}
