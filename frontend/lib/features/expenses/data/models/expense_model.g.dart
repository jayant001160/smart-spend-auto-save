// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
      requestId: json['requestId'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      merchant: json['merchant'] as String,
      date: json['date'] as String,
      paymentMode: json['paymentMode'] as String,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'amount': instance.amount,
      'category': instance.category,
      'merchant': instance.merchant,
      'date': instance.date,
      'paymentMode': instance.paymentMode,
      'notes': instance.notes,
    };
