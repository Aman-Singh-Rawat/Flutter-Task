// ignore_for_file: file_names
import 'package:flutter_task/presentation/screens/post_listing_screen.dart';
import 'package:flutter_task/presentation/screens/splash_screen.dart';
import 'package:flutter_task/routes/routes.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoutes {
  List<GetPage> getRoutes() {
    return [
      GetPage(name: Routes.initial, page: () => const SplashScreen()),
      GetPage(name: Routes.postListScreen, page: () => const PostListingScreen()),
    ];
  }
}
