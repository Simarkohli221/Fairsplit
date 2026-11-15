
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepository {
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await DioClient.dio.post(
      ApiConstants.login,
      data: {
        "username": request.email,
        "password": request.password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await DioClient.dio.post(
      ApiConstants.register,
      data: {
        "full_name": fullName,
        "email": email,
        "password": password,
      },
    );
  }
}
