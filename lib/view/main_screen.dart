import 'package:shoes_shop/controllers/navigation_controller.dart';
import 'package:shoes_shop/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'shopping_screen.dart';
import 'wishlist_screen.dart';
import 'account_screen.dart';
import 'widgets/custom_bottom_navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());
    return GetBuilder<ThemeController>(
      builder: (themeController) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Obx(
            () => IndexedStack(
              key: ValueKey(navigationController.currentIndex.value),
              index: navigationController.currentIndex.value,
              children: const[
                HomeScreen(),
                ShoppingScreen(),
                WishlistScreen(),
                AccountScreen(),
              ],
            ), // IndexedStack
          ), // Obx
        ), // AnimatedSwitcher
        bottomNavigationBar: const CustomBottomNavbar(),
      ), // Scaffold // GetBuilder
    );
  }
}