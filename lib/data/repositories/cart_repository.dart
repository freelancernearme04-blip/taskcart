import 'dart:convert';
import '../../core/services/api_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/constants/api_constants.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  CartRepository({
    required ApiService apiService,
    required LocalStorageService localStorageService,
  })  : _apiService = apiService,
        _localStorageService = localStorageService;

  Future<CartModel> addToCart({
    required int userId,
    required List<CartItemModel> products,
  }) async {
    try {
      final response = await _apiService.post(ApiConstants.addCart, body: {
        'userId': userId,
        'products': products.map((p) => {
          'id': p.productId,
          'quantity': p.quantity,
        }).toList(),
      });

      if (response.statusCode == 200) {
        final cart = CartModel.fromJson(jsonDecode(response.body));
        await saveCartLocally(cart);
        return cart;
      } else {
        throw Exception('Could not push synchronous checkout basket parameters to server storage routines.');
      }
    } catch (e) {
      throw Exception('Remote synchronization failure bounds: $e');
    }
  }

  CartModel getLocalCart() {
    final cartData = _localStorageService.getCartData();
    if (cartData != null && cartData.isNotEmpty) {
      return CartModel.fromJson(jsonDecode(cartData));
    }
    return CartModel(
      id: 0,
      products: [],
      total: 0,
      discountedTotal: 0,
      userId: 0,
      totalProducts: 0,
      totalQuantity: 0,
    );
  }

  Future<void> saveCartLocally(CartModel cart) async {
    await _localStorageService.setCartData(jsonEncode(cart.toJson()));
  }

  Future<CartModel> addProductToLocalCart(ProductModel product, {int quantity = 1}) async {
    final cart = getLocalCart();
    final existingItemIndex = cart.products.indexWhere((item) => item.productId == product.id);

    List<CartItemModel> updatedProducts;
    if (existingItemIndex != -1) {
      final existingItem = cart.products[existingItemIndex];
      updatedProducts = List.from(cart.products);
      int finalQuantity = existingItem.quantity + quantity;
      updatedProducts[existingItemIndex] = existingItem.copyWith(
        quantity: finalQuantity,
        total: existingItem.price * finalQuantity,
        discountedPrice: (existingItem.price - (existingItem.price * existingItem.discountPercentage / 100)) * finalQuantity,
      );
    } else {
      double calculatedDiscountPrice = product.price - (product.price * product.discountPercentage / 100);
      final newItem = CartItemModel(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: quantity,
        total: product.price * quantity,
        discountPercentage: product.discountPercentage,
        discountedPrice: calculatedDiscountPrice * quantity,
        thumbnail: product.thumbnail,
        productId: product.id,
      );
      updatedProducts = [...cart.products, newItem];
    }

    final updatedCart = cart.copyWith(
      products: updatedProducts,
      totalProducts: updatedProducts.length,
      totalQuantity: updatedProducts.fold<int>(0, (sum, item) => sum + item.quantity),
      total: updatedProducts.fold<double>(0.0, (sum, item) => sum + item.total),
      discountedTotal: updatedProducts.fold<double>(0.0, (sum, item) => sum + item.discountedPrice),
    );

    await saveCartLocally(updatedCart);
    return updatedCart;
  }

  Future<CartModel> removeCartItem(int productId) async {
    final cart = getLocalCart();
    List<CartItemModel> updatedProducts = cart.products.where((item) => item.productId != productId).toList();

    final updatedCart = cart.copyWith(
      products: updatedProducts,
      totalProducts: updatedProducts.length,
      totalQuantity: updatedProducts.fold<int>(0, (sum, item) => sum + item.quantity),
      total: updatedProducts.fold<double>(0.0, (sum, item) => sum + item.total),
      discountedTotal: updatedProducts.fold<double>(0.0, (sum, item) => sum + item.discountedPrice),
    );

    await saveCartLocally(updatedCart);
    return updatedCart;
  }

  Future<void> clearCart() async {
    await _localStorageService.removeCartData();
  }
}