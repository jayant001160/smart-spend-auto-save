import 'package:frontend/features/expenses/domain/entities/expense_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  const ExpenseModel({
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
  final String date;
  final String paymentMode;
  final String notes;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      requestId: requestId,
      amount: amount,
      category: category,
      merchant: merchant,
      date: DateTime.parse(date),
      paymentMode: paymentMode,
      notes: notes,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      requestId: entity.requestId,
      amount: entity.amount,
      category: entity.category,
      merchant: entity.merchant,
      date: entity.date.toIso8601String(),
      paymentMode: entity.paymentMode,
      notes: entity.notes,
    );
  }
}
