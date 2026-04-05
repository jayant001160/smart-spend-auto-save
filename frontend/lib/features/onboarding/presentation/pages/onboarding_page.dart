import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/input_validators.dart';
import 'package:frontend/core/widgets/app_gradient_background.dart';
import 'package:frontend/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:frontend/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:frontend/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:frontend/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:frontend/features/onboarding/presentation/widgets/onboarding_sync_status_banner.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  DateTime? _targetDate;

  @override
  void dispose() {
    _incomeController.dispose();
    _goalNameController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      initialDate: _targetDate ?? now,
    );
    if (selected != null) {
      setState(() {
        _targetDate = selected;
      });
    }
  }

  void _submit() {
    final FormState? formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }
    if (_targetDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target date is required')),
      );
      return;
    }

    context.read<OnboardingBloc>().add(
          SubmitOnboardingEvent(
            monthlyIncome: double.parse(_incomeController.text.trim()),
            goalName: _goalNameController.text.trim(),
            targetAmount: double.parse(_targetAmountController.text.trim()),
            targetDate: _targetDate!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Onboarding submitted successfully')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Onboarding')),
        body: AppGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const OnboardingHeader(),
                    BlocBuilder<OnboardingBloc, OnboardingState>(
                      buildWhen:
                          (OnboardingState previous, OnboardingState current) =>
                              previous.status != current.status ||
                              previous.errorMessage != current.errorMessage,
                      builder: (BuildContext context, OnboardingState state) {
                        return OnboardingSyncStatusBanner(
                          status: state.status,
                          errorMessage: state.errorMessage,
                          onRetry: _submit,
                        );
                      },
                    ),
                    TextFormField(
                      controller: _incomeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Monthly income'),
                      validator: (String? value) =>
                          InputValidators.positiveNumber(
                              value, 'Monthly income'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _goalNameController,
                      decoration: const InputDecoration(labelText: 'Goal name'),
                      validator: (String? value) =>
                          InputValidators.requiredText(value, 'Goal name'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _targetAmountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Target amount'),
                      validator: (String? value) =>
                          InputValidators.positiveNumber(
                              value, 'Target amount'),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        _targetDate == null
                            ? 'Select target date'
                            : 'Target date: ${_targetDate!.toIso8601String().split('T').first}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<OnboardingBloc, OnboardingState>(
                        builder: (BuildContext context, OnboardingState state) {
                          return ElevatedButton(
                            onPressed: state.isSubmitting ? null : _submit,
                            child: state.isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Submit'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
