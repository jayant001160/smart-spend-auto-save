import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/widgets/app_gradient_background.dart';
import 'package:frontend/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:frontend/features/insights/presentation/bloc/insights_event.dart';
import 'package:frontend/features/insights/presentation/bloc/insights_state.dart';
import 'package:frontend/features/insights/presentation/widgets/insight_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Insights')),
      body: AppGradientBackground(
        child: BlocBuilder<InsightsBloc, InsightsState>(
          builder: (BuildContext context, InsightsState state) {
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
                      onPressed: () => context.read<InsightsBloc>().add(
                            const FetchInsightsEvent(),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state.items.isEmpty) {
              return const Center(child: Text('No insights available'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (BuildContext context, int index) {
                return InsightCard(insight: state.items[index]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: state.items.length,
            );
          },
        ),
      ),
    );
  }
}
