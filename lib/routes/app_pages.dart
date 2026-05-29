import 'package:get/get.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/product_details_screen.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/profile_screen.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;
  static const LOGIN = Routes.LOGIN;
  static const HOME = Routes.HOME;
  static const PRODUCT_DETAILS = Routes.PRODUCT_DETAILS;
  static const CART = Routes.CART;
  static const PROFILE = Routes.PROFILE;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.LOGIN, page: () => const LoginScreen()),
    GetPage(name: Routes.HOME, page: () => const HomeScreen()),
    GetPage(name: Routes.PRODUCT_DETAILS, page: () => const ProductDetailsScreen()),
    GetPage(name: Routes.CART, page: () => const CartScreen()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileScreen()),
  ];
}

class Routes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PRODUCT_DETAILS = '/product-details';
  static const CART = '/cart';
  static const PROFILE = '/profile';
}