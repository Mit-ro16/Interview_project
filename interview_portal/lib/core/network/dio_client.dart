import 'package:dio/dio.dart';
import 'package:interview_portal/core/constants/api_constants.dart';
import 'package:interview_portal/core/network/failure.dart';
import 'package:interview_portal/core/shared_prefs/shared_prefs.dart';

class DioClient {
  final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestBody: true,
            responseBody: true,
            error: true,
            requestHeader: false,
            responseHeader: false,
          ),
        );

  
  Future<String?> getToken() async => await SharedPrefs.getToken();

  
  Future<Options> buildAuthHeaders() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw Failure(message: 'Token missing. Please log in again.');
    }

    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  
  Failure handleDioError(DioException e) {
    String message = 'Network error';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timed out. Please check your internet or server.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server took too long to respond.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request took too long to send.';
        break;
      case DioExceptionType.connectionError:
        message = 'Failed to connect to server.';
        break;
      default:
        if (e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map<String, dynamic> && data.containsKey('message')) {
            message = data['message'].toString();
          } else if (data is String) {
            message = data;
          } else {
            message = e.message ?? message;
          }
        } else if (e.message != null) {
          message = e.message!;
        }
    }

    return Failure(message: message);
  }

  
  Future<Response> get(String endpoint) async {
    try {
      final options = await buildAuthHeaders();
      return await dio.get(endpoint, options: options);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  
Future<Response> post(String endpoint, Map<String, dynamic> data,
    {bool auth = true}) async {
  try {
    final options = auth ? await buildAuthHeaders() : null;
    return await dio.post(endpoint, data: data, options: options);
  } on DioException catch (e) {
    throw handleDioError(e);
  }
}


  
  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final options = await buildAuthHeaders();
      return await dio.put(endpoint, data: data, options: options);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  
  Future<Response> delete(String endpoint) async {
    try {
      final options = await buildAuthHeaders();
      return await dio.delete(endpoint, options: options);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
