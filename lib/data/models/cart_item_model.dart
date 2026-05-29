class CartItemModel {
  final int id;
  final String title;
  final double price;
  final int quantity;
  final double total;
  final double discountPercentage;
  final double discountedPrice;
  final String thumbnail;
  final int productId;

  CartItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.thumbnail,
    required this.productId,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    double rawPrice = (json['price'] ?? 0).toDouble();
    double rawDiscount = (json['discountPercentage'] ?? 0).toDouble();

    return CartItemModel(
      id: json['id'] ?? json['productId'] ?? 0,
      title: json['title'] ?? '',
      price: rawPrice,
      quantity: json['quantity'] ?? 1,
      total: (json['total'] ?? (rawPrice * (json['quantity'] ?? 1))).toDouble(),
      discountPercentage: rawDiscount,
      discountedPrice: (json['discountedPrice'] ?? (rawPrice - (rawPrice * rawDiscount / 100))).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      productId: json['productId'] ?? json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'total': total,
      'discountPercentage': discountPercentage,
      'discountedPrice': discountedPrice,
      'thumbnail': thumbnail,
      'productId': productId,
    };
  }

  CartItemModel copyWith({
    int? id,
    String? title,
    double? price,
    int? quantity,
    double? total,
    double? discountPercentage,
    double? discountedPrice,
    String? thumbnail,
    int? productId,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      thumbnail: thumbnail ?? this.thumbnail,
      productId: productId ?? this.productId,
    );
  }
}