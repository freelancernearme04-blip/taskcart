import 'product_model.dart';

class ProductsResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    List<ProductModel> productsList = [];
    if (json['products'] != null) {
      productsList = (json['products'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    }

    return ProductsResponseModel(
      products: productsList,
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((item) => item.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }
}