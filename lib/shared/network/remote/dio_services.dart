import 'package:agre_lens_app/shared/network/local/cash_helper.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://finalgraduationproject.runasp.net/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveDataWhenStatusError: true,
  ));

  AuthService() {
    setupDio();
  }

  void setupDio() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        String? token = CacheHelper.getData(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      'identity/identities/login',
      data: {
        "email": email,
        "Password": password,
      },
    );
  }

  Future<Response> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    String? phoneNumber,
  }) async {
    return await _dio.post(
      'identity/identities/register',
      data: {
        "FullName": fullName,
        "email": email,
        "password": password,
        "ConfirmPassword": confirmPassword,
        if (phoneNumber != null && phoneNumber.isNotEmpty) "phoneNumber": phoneNumber,
      },
    );
  }
}