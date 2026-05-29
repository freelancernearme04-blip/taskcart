import 'dart:convert';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/products_response_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({required ApiService apiService}) : _apiService = apiService;

  Future<ProductsResponseModel> getProducts() async {
    try {
      final response = await _apiService.get(ApiConstants.products);
      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to parse catalog listings from network endpoints.');
      }
    } catch (e) {
      throw Exception('Get products layout exception mismatch: $e');
    }
  }

  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response = await _apiService.get('${ApiConstants.productDetails}$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Unable to fetch detailed object descriptor payload definitions.');
      }
    } catch (e) {
      throw Exception('Get target description exception criteria: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categories);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) {
            // Safe mapping checks covering explicit object variants introduced by contemporary API schemas
            if (item is Map && item.containsKey('slug')) {
              return item['slug'].toString();
            }
            return item.toString();
          }).toList();
        }
        return [];
      } else {
        throw Exception('Failed to extract catalog classification indices.');
      }
    } catch (e) {
      throw Exception('Category extraction execution model layout crash: $e');
    }
  }

  Future<ProductsResponseModel> searchProducts(String query) async {
    try {
      final response = await _apiService.get('${ApiConstants.search}?q=$query');
      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Online search stream validation failed.');
      }
    } catch (e) {
      throw Exception('Catalog index match filtering structural error: $e');
    }
  }

  Future<ProductsResponseModel> getProductsByCategory(String category) async {
    try {
      final response = await _apiService.get('${ApiConstants.categoryProducts}$category');
      if (response.statusCode == 200) {
        return ProductsResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Targeted classification lookup failed.');
      }
    } catch (e) {
      throw Exception('Classification query logic structural error: $e');
    }
  }
}