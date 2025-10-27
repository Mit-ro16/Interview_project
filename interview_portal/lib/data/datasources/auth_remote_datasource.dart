import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;
  AuthRemoteDataSource(this.dioClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await dioClient.post(
      '${ApiConstants.baseUrl}/${ApiConstants.login}',
      {'email': email, 'password': password},
      auth: false, 
    );
    return res.data as Map<String, dynamic>;
  }
}
