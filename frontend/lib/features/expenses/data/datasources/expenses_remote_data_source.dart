import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/network/network_manager.dart';

import '../models/expense_model.dart';

abstract class ExpensesRemoteDataSource {
  Future<void> createExpense(ExpenseModel request);
}

class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  ExpensesRemoteDataSourceImpl(this._networkManager);

  final NetworkManager _networkManager;

  @override
  Future<void> createExpense(ExpenseModel request) async {
    await _networkManager.post(ApiConstants.expenses, data: request.toJson());
  }
}
