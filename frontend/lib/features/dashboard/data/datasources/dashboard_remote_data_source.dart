import 'package:frontend/core/constants/api_constants.dart';
import 'package:frontend/core/network/network_manager.dart';
import 'package:frontend/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(this._networkManager);

  final NetworkManager _networkManager;

  @override
  Future<DashboardModel> getDashboard() async {
    final Map<String, dynamic> json =
        await _networkManager.get(ApiConstants.dashboard);
    return DashboardModel.fromApiResponse(json);
  }
}
