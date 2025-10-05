import 'package:shoes_shop/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find<NavigationController>();

    return Obx(
      () => BottomNavigationBar(
        currentIndex: navigationController.currentIndex.value,
        onTap: (index) => navigationController.changeIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ), // BottomNavigationBarItem
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shopping',
          ), // BottomNavigationBarItem
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outlined),
            label: 'Wishlist',
          ), // BottomNavigationBarItem
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ), // BottomNavigationBarItem
        ],
      ), // BottomNavigationBar
    ); // Obx
  }
}