import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/cart_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/product_controller.dart';
import '../../presentation/controllers/cart_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<ApiService>(() => ApiService());

    // --- AUTH LAYER (Must be Permanent) ---
    // We use Get.put with permanent: true so authentication data is never wiped during navigation
    Get.put<AuthRepository>(
      AuthRepository(
        apiService: Get.find<ApiService>(),
        localStorageService: Get.find<LocalStorageService>(),
      ),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(
        authRepository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );

    // --- OTHER LAYERS (Can stay lazy) ---
    Get.lazyPut<ProductRepository>(() => ProductRepository(
      apiService: Get.find<ApiService>(),
    ));

    Get.lazyPut<CartRepository>(() => CartRepository(
      apiService: Get.find<ApiService>(),
      localStorageService: Get.find<LocalStorageService>(),
    ));

    Get.lazyPut<ProductController>(() => ProductController(
      productRepository: Get.find<ProductRepository>(),
    ));

    Get.lazyPut<CartController>(() => CartController(
      cartRepository: Get.find<CartRepository>(),
    ));
  }
}