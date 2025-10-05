import 'package:flutter/material.dart';

class WishlistItem {
  final String title;
  final String category;
  final double price;
  final double oldPrice;
  final String imagePath;

  WishlistItem({
    required this.title,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.imagePath,
  });

  // Generate unique key for wishlist item
  String get key => title;
}

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  int get itemCount => _items.length;

  // Add item to wishlist
  void addToWishlist(WishlistItem item) {
    // Check if item already exists
    if (!isInWishlist(item.title)) {
      _items.add(item);
      notifyListeners();
    }
  }

  // Remove item from wishlist
  void removeFromWishlist(String title) {
    _items.removeWhere((item) => item.title == title);
    notifyListeners();
  }

  // Toggle wishlist status
  void toggleWishlist(WishlistItem item) {
    if (isInWishlist(item.title)) {
      removeFromWishlist(item.title);
    } else {
      addToWishlist(item);
    }
  }

  // Check if item is in wishlist
  bool isInWishlist(String title) {
    return _items.any((item) => item.title == title);
  }

  // Clear entire wishlist
  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}