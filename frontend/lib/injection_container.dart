import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'core/network/network_manager.dart';
import 'features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'features/dashboard/data/repositories_impl/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'features/expenses/data/repositories_impl/expenses_repository_impl.dart';
import 'features/expenses/domain/repositories/expenses_repository.dart';
import 'features/expenses/domain/usecases/create_expense_usecase.dart';
import 'features/expenses/presentation/bloc/expenses_bloc.dart';
import 'features/insights/data/datasources/insights_remote_data_source.dart';
import 'features/insights/data/repositories_impl/insights_repository_impl.dart';
import 'features/insights/domain/repositories/insights_repository.dart';
import 'features/insights/domain/usecases/get_insights_usecase.dart';
import 'features/insights/presentation/bloc/insights_bloc.dart';
import 'features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'features/onboarding/data/repositories_impl/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/onboarding/domain/usecases/submit_onboarding_usecase.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(Dio.new);
  sl.registerLazySingleton<NetworkManager>(() => NetworkManager(sl<Dio>()));
  sl.registerLazySingleton<Uuid>(Uuid.new);

  _registerOnboarding();
  _registerExpenses();
  _registerDashboard();
  _registerInsights();
}

void _registerOnboarding() {
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(sl<SubmitOnboardingUsecase>()),
  );
  sl.registerLazySingleton<SubmitOnboardingUsecase>(
    () => SubmitOnboardingUsecase(sl<OnboardingRepository>()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<OnboardingRemoteDataSource>()),
  );
  sl.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(sl<NetworkManager>()),
  );
}

void _registerExpenses() {
  sl.registerFactory<ExpensesBloc>(
    () => ExpensesBloc(sl<CreateExpenseUsecase>(), sl<Uuid>()),
  );
  sl.registerLazySingleton<CreateExpenseUsecase>(
    () => CreateExpenseUsecase(sl<ExpensesRepository>()),
  );
  sl.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(sl<ExpensesRemoteDataSource>()),
  );
  sl.registerLazySingleton<ExpensesRemoteDataSource>(
    () => ExpensesRemoteDataSourceImpl(sl<NetworkManager>()),
  );
}

void _registerDashboard() {
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(sl<GetDashboardUsecase>()),
  );
  sl.registerLazySingleton<GetDashboardUsecase>(
    () => GetDashboardUsecase(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl<DashboardRemoteDataSource>()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl<NetworkManager>()),
  );
}

void _registerInsights() {
  sl.registerFactory<InsightsBloc>(
    () => InsightsBloc(sl<GetInsightsUsecase>()),
  );
  sl.registerLazySingleton<GetInsightsUsecase>(
    () => GetInsightsUsecase(sl<InsightsRepository>()),
  );
  sl.registerLazySingleton<InsightsRepository>(
    () => InsightsRepositoryImpl(sl<InsightsRemoteDataSource>()),
  );
  sl.registerLazySingleton<InsightsRemoteDataSource>(
    () => InsightsRemoteDataSourceImpl(sl<NetworkManager>()),
  );
}
