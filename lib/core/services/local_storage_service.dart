import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';

class LocalStorageService {
  late final SharedPreferences _preferences;

  // Fully called and awaited inside main.dart to eliminate asynchronous startup race conditions
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  Future<bool> clear() async {
    return await _preferences.clear();
  }

  // Auth token methods
  Future<bool> setAuthToken(String token) async {
    return await setString(StorageConstants.authToken, token);
  }

  String? getAuthToken() {
    return getString(StorageConstants.authToken);
  }

  Future<bool> removeAuthToken() async {
    return await remove(StorageConstants.authToken);
  }

  // User data methods
  Future<bool> setUserData(String userData) async {
    return await setString(StorageConstants.userData, userData);
  }

  String? getUserData() {
    return getString(StorageConstants.userData);
  }

  Future<bool> removeUserData() async {
    return await remove(StorageConstants.userData);
  }

  // Cart data methods
  Future<bool> setCartData(String cartData) async {
    return await setString(StorageConstants.cartData, cartData);
  }

  String? getCartData() {
    return getString(StorageConstants.cartData);
  }

  Future<bool> removeCartData() async {
    return await remove(StorageConstants.cartData);
  }
}