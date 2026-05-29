import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository;

  ProductController({required ProductRepository productRepository}) : _productRepository = productRepository;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCategoriesLoading = false.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _productRepository.getProducts();
      products.assignAll(response.products);
      filteredProducts.assignAll(response.products);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to read index: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final response = await _productRepository.getCategories();
      categories.assignAll(['All', ...response]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve group indicators: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      searchQuery.value = query;
      if (query.trim().isEmpty) {
        filteredProducts.assignAll(products);
        return;
      }

      isLoading.value = true;
      final response = await _productRepository.searchProducts(query);
      filteredProducts.assignAll(response.products);
    } catch (e) {
      Get.snackbar('Error', 'Query resolution anomaly: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> filterByCategory(String category) async {
    try {
      selectedCategory.value = category;
      isLoading.value = true;

      if (category == 'All') {
        filteredProducts.assignAll(products);
      } else {
        final response = await _productRepository.getProductsByCategory(category);
        filteredProducts.assignAll(response.products);
      }
    } catch (e) {
      Get.snackbar('Error', 'Class sorting calculation crash: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      filteredProducts.assignAll(products);
    }
  }
}