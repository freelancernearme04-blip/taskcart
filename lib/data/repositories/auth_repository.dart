import 'dart:convert';
import '../../core/services/api_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  AuthRepository({
    required ApiService apiService,
    required LocalStorageService localStorageService,
  })  : _apiService = apiService,
        _localStorageService = localStorageService;

  Future<LoginResponseModel> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    try {
      final response = await _apiService.post(ApiConstants.login, body: {
        'username': username,
        'password': password,
        'expiresInMins': expiresInMins,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginResponse = LoginResponseModel.fromJson(data);

        await _localStorageService.setAuthToken(loginResponse.token);
        await _localStorageService.setUserData(jsonEncode(loginResponse.toJson()));
        _apiService.setAuthToken(loginResponse.token);

        return loginResponse;
      } else {
        final Map<String, dynamic> errorMap = jsonDecode(response.body);
        throw Exception(errorMap['message'] ?? 'Authentication Failed');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final token = _localStorageService.getAuthToken();
      if (token == null) throw Exception('No authentication session token discovered.');

      _apiService.setAuthToken(token);
      final response = await _apiService.get(ApiConstants.me);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to synchronize user session profile metrics.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool isLoggedIn() {
    final token = _localStorageService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _localStorageService.removeAuthToken();
    await _localStorageService.removeUserData();
    await _localStorageService.removeCartData();
    _apiService.setAuthToken(null);
  }

  UserModel? getCachedUser() {
    final userData = _localStorageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }
}