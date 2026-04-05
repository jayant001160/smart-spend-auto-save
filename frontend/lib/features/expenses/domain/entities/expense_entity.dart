import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  const ExpenseEntity({
    required this.requestId,
    required this.amount,
    required this.category,
    required this.merchant,
    required this.date,
    required this.paymentMode,
    required this.notes,
  });

  final String requestId;
  final double amount;
  final String category;
  final String merchant;
  final DateTime date;
  final String paymentMode;
  final String notes;

  @override
  List<Object?> get props => <Object?>[
        requestId,
        amount,
        category,
        merchant,
        date,
        paymentMode,
        notes,
      ];
}
