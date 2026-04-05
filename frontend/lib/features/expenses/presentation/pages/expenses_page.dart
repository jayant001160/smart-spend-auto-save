import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/utils/input_validators.dart';
import 'package:frontend/core/widgets/app_gradient_background.dart';
import 'package:frontend/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:frontend/features/expenses/presentation/bloc/expenses_event.dart';
import 'package:frontend/features/expenses/presentation/bloc/expenses_state.dart';
import 'package:frontend/features/expenses/presentation/widgets/expenses_sync_status_banner.dart';
import 'package:frontend/features/expenses/presentation/widgets/selection_dropdown.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;
  String? _selectedPaymentMode;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _submit() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date is required')),
      );
      return;
    }

    context.read<ExpensesBloc>().add(
          SubmitExpenseEvent(
            amount: double.parse(_amountController.text.trim()),
            category: _selectedCategory!,
            merchant: _merchantController.text.trim(),
            date: _selectedDate!,
            paymentMode: _selectedPaymentMode!,
            notes: _notesController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpensesBloc, ExpensesState>(
      listener: (BuildContext context, ExpensesState state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Expense Entry')),
        body: AppGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    BlocBuilder<ExpensesBloc, ExpensesState>(
                      buildWhen:
                          (ExpensesState previous, ExpensesState current) =>
                              previous.status != current.status ||
                              previous.errorMessage != current.errorMessage,
                      builder: (BuildContext context, ExpensesState state) {
                        return ExpensesSyncStatusBanner(
                          status: state.status,
                          errorMessage: state.errorMessage,
                          onRetry: _submit,
                        );
                      },
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (String? value) =>
                          InputValidators.positiveNumber(value, 'Amount'),
                    ),
                    const SizedBox(height: 12),
                    SelectionDropdown(
                      label: 'Category',
                      value: _selectedCategory,
                      items: AppConstants.expenseCategories,
                      onChanged: (String? value) => setState(() {
                        _selectedCategory = value;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _merchantController,
                      decoration: const InputDecoration(labelText: 'Merchant'),
                      validator: (String? value) =>
                          InputValidators.requiredText(value, 'Merchant'),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Select date'
                            : 'Date: ${_selectedDate!.toIso8601String().split('T').first}',
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 12),
                    SelectionDropdown(
                      label: 'Payment mode',
                      value: _selectedPaymentMode,
                      items: AppConstants.paymentModes,
                      onChanged: (String? value) => setState(() {
                        _selectedPaymentMode = value;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<ExpensesBloc, ExpensesState>(
                        builder: (BuildContext context, ExpensesState state) {
                          return ElevatedButton(
                            onPressed: state.isSubmitting ? null : _submit,
                            child: state.isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Save expense'),
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
