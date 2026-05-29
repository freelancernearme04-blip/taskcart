import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository}) : _authRepository = authRepository;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPasswordHidden = true.obs; // Dedicated visibility flag

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() {
    try {
      isLoading.value = true;
      final loggedIn = _authRepository.isLoggedIn();
      isLoggedIn.value = loggedIn;

      if (loggedIn) {
        final cachedUser = _authRepository.getCachedUser();
        if (cachedUser != null) {
          currentUser.value = cachedUser;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({required String username, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final loginResponse = await _authRepository.login(username: username, password: password);
      currentUser.value = loginResponse.toUserModel();
      isLoggedIn.value = true;

      Get.snackbar('Success', 'Login successful', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.HOME); // Fixed route string path references
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Login failed: ${errorMessage.value}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      currentUser.value = null;
      isLoggedIn.value = false;

      Get.snackbar('Success', 'Logged out successfully', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.LOGIN); // Clean architectural navigation references
    } catch (e) {
      Get.snackbar('Error', 'Logout execution anomaly encountered: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> refreshUser() async {
    try {
      isLoading.value = true;
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}