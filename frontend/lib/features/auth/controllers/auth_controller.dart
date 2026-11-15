
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(false);

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = true;

    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );

      await SecureStorage.saveToken(response.accessToken);
      return true;
    } catch (_) {
      return false;
    } finally {
      state = false;
    }
  }

  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = true;

    try {
      await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      return null;
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data["detail"] != null) {
        return data["detail"].toString();
      }

      return "Registration failed. Please try again.";
    } catch (_) {
      return "Something went wrong. Please try again.";
    } finally {
      state = false;
    }
  }
}
