import 'cart_item_model.dart';

class CartModel {
  final int id;
  final List<CartItemModel> products;
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  CartModel({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    List<CartItemModel> productsList = [];
    if (json['products'] != null) {
      productsList = (json['products'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    }

    return CartModel(
      id: json['id'] ?? 0,
      products: productsList,
      total: (json['total'] ?? 0).toDouble(),
      discountedTotal: (json['discountedTotal'] ?? 0).toDouble(),
      userId: json['userId'] ?? 0,
      totalProducts: json['totalProducts'] ?? productsList.length,
      totalQuantity: json['totalQuantity'] ?? productsList.fold<int>(0, (sum, item) => sum + item.quantity),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((item) => item.toJson()).toList(),
      'total': total,
      'discountedTotal': discountedTotal,
      'userId': userId,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
    };
  }

  CartModel copyWith({
    int? id,
    List<CartItemModel>? products,
    double? total,
    double? discountedTotal,
    int? userId,
    int? totalProducts,
    int? totalQuantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      products: products ?? this.products,
      total: total ?? this.total,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      userId: userId ?? this.userId,
      totalProducts: totalProducts ?? this.totalProducts,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}