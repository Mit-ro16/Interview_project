import 'package:interview_portal/core/network/dio_client.dart';
import 'package:interview_portal/core/constants/api_constants.dart';

class CandidateRemoteDataSource {
  final DioClient dioClient;

  CandidateRemoteDataSource(this.dioClient);

  Future<List<dynamic>> fetchCandidates() async {
    final response = await dioClient.get(ApiConstants.viewCandidate);
    if (response.data is List) {
      return response.data;
    } else {
      throw Exception("Unexpected response format");
    }
  }
}
