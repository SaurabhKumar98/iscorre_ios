// lib/data/repo/communityr/report_repository.dart

import 'package:firstedu/core/network/api_client.dart';
import 'package:firstedu/core/network/api_endpoint.dart';

class ReportRepository {
  final ApiClient _apiClient;

  ReportRepository(this._apiClient);

  Future<void> reportPost(String postId, String reason) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoint.userForums}/$postId/report',
        data: {'reason': reason},
      );
      
      if (response.data == null) {
        throw Exception('Failed to submit report');
      }
      
      return;
    } catch (e) {
      throw Exception('Failed to submit report: ${e.toString()}');
    }
  }
}