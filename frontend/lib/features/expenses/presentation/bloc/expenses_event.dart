import 'package:equatable/equatable.dart';

class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class SubmitExpenseEvent extends ExpensesEvent {
  const SubmitExpenseEvent({
    required this.amount,
    required this.category,
    required this.merchant,
    required this.date,
    required this.paymentMode,
    required this.notes,
  });

  final double amount;
  final String category;
  final String merchant;
  final DateTime date;
  final String paymentMode;
  final String notes;

  @override
  List<Object?> get props => <Object?>[
        amount,
        category,
        merchant,
        date,
        paymentMode,
        notes,
      ];
}
