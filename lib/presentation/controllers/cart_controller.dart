import 'package:get/get.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository _cartRepository;

  CartController({required CartRepository cartRepository}) : _cartRepository = cartRepository;

  final Rx<CartModel> cart = CartModel(
    id: 0,
    products: [],
    total: 0,
    discountedTotal: 0,
    userId: 0,
    totalProducts: 0,
    totalQuantity: 0,
  ).obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      cart.value = _cartRepository.getLocalCart();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    try {
      isLoading.value = true;
      final updatedCart = await _cartRepository.addProductToLocalCart(product, quantity: quantity);
      cart.value = updatedCart;

      Get.snackbar('Added', '${product.title} added to shopping cart.', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('Error', 'Failed to insert item parameters: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      isLoading.value = true;
      final updatedCart = await _cartRepository.removeCartItem(productId);
      cart.value = updatedCart;

      Get.snackbar('Removed', 'Item purged from checkout selection.', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete selected item matrix: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    try {
      isLoading.value = true;
      await _cartRepository.clearCart();
      cart.value = CartModel(id: 0, products: [], total: 0, discountedTotal: 0, userId: 0, totalProducts: 0, totalQuantity: 0);
      Get.snackbar('Cleared', 'Shopping basket emptied completely.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to wipe local variables: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  int get totalItems => cart.value.totalQuantity;
  double get totalPrice => cart.value.total;
  double get totalDiscountedPrice => cart.value.discountedTotal;
}