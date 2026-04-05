import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:frontend/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:frontend/features/expenses/presentation/pages/expenses_page.dart';
import 'package:frontend/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:frontend/features/insights/presentation/bloc/insights_event.dart';
import 'package:frontend/features/insights/presentation/pages/insights_page.dart';
import 'package:frontend/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:frontend/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:frontend/injection_container.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<OnboardingBloc>(create: (_) => sl<OnboardingBloc>()),
        BlocProvider<ExpensesBloc>(create: (_) => sl<ExpensesBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),
        BlocProvider<InsightsBloc>(
          create: (_) => sl<InsightsBloc>()..add(const FetchInsightsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Spend Auto Save',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _HomeNavigator(),
      ),
    );
  }
}

class _HomeNavigator extends StatefulWidget {
  const _HomeNavigator();

  @override
  State<_HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<_HomeNavigator> {
  int _index = 0;

  final List<Widget> _pages = const <Widget>[
    OnboardingPage(),
    ExpensesPage(),
    DashboardPage(),
    InsightsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.person_add_alt),
            label: 'Onboarding',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_card),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}
