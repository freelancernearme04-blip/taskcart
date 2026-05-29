class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String me = '/auth/me';

  // Product endpoints
  static const String products = '/products';
  static const String productDetails = '/products/';
  static const String categories = '/products/categories';
  static const String search = '/products/search';
  static const String categoryProducts = '/products/category/';

  // Cart endpoints
  static const String addCart = '/carts/add';
  static const String userCart = '/carts/user/';
}