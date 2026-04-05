import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/app_gradient_background.dart';
import 'package:frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:frontend/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:frontend/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:frontend/features/dashboard/presentation/widgets/dashboard_metric_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/recommendation_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/spend_pie_chart.dart';
import 'package:frontend/features/insights/presentation/widgets/insight_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Dashboard')),
      body: AppGradientBackground(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (BuildContext context, DashboardState state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(state.errorMessage!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<DashboardBloc>().add(
                            const FetchDashboardEvent(),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final dashboard = state.data;
            if (dashboard == null) {
              return const Center(child: Text('No dashboard data'));
            }

            return RefreshIndicator(
              onRefresh: () async => context
                  .read<DashboardBloc>()
                  .add(const FetchDashboardEvent()),
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: <Widget>[
                  Text(
                    'Money Health',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track spend and improve your weekly savings decisions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DashboardMetricCard(
                          label: 'Weekly spend',
                          value:
                              'INR ${dashboard.weeklySpend.toStringAsFixed(0)}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardMetricCard(
                          label: 'Monthly spend',
                          value:
                              'INR ${dashboard.monthlySpend.toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DashboardMetricCard(
                          label: 'Remaining budget',
                          value:
                              'INR ${dashboard.remainingBudget.toStringAsFixed(0)}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardMetricCard(
                          label: 'Goal progress',
                          value:
                              '${dashboard.goalProgress.toStringAsFixed(1)}%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SpendPieChart(points: dashboard.chartPoints),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RecommendationCard(recommendation: dashboard.recommendation),
                  const SizedBox(height: 12),
                  Text(
                    'Insights',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...dashboard.insights
                      .map((insight) => InsightCard(insight: insight)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
