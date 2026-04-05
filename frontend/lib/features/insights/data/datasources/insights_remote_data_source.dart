import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/network/network_manager.dart';
import 'package:frontend/features/insights/data/models/insight_model.dart';

abstract class InsightsRemoteDataSource {
  Future<List<InsightModel>> getInsights();
}

class InsightsRemoteDataSourceImpl implements InsightsRemoteDataSource {
  InsightsRemoteDataSourceImpl(this._networkManager);

  final NetworkManager _networkManager;

  @override
  Future<List<InsightModel>> getInsights() async {
    final Map<String, dynamic> json =
        await _networkManager.get(ApiConstants.insights);
    final Map<String, dynamic> payload =
        (json['data'] as Map<String, dynamic>? ?? json);
    final List<dynamic> rawList =
        payload['insights'] as List<dynamic>? ?? <dynamic>[];

    return rawList
        .whereType<String>()
        .toList()
        .asMap()
        .entries
        .map(
          (MapEntry<int, String> entry) => InsightModel(
            title: 'Insight ${entry.key + 1}',
            description: entry.value,
            type: 'info',
          ),
        )
        .toList();
  }
}
