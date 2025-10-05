import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final String category;
  final double price;
  final String imagePath;
  final String? size;
  int quantity;

  CartItem({
    required this.title,
    required this.category,
    required this.price,
    required this.imagePath,
    this.size,
    this.quantity = 1,
  });

  // Generate unique key for cart item (title + size)
  String get key => size != null ? '$title-$size' : title;
}

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems {
    int total = 0;
    for (var item in _items) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Add item to cart
  void addToCart(CartItem item) {
    // Check if item already exists
    int existingIndex = _items.indexWhere((cartItem) => cartItem.key == item.key);
    
    if (existingIndex != -1) {
      // Item exists, increase quantity
      _items[existingIndex].quantity += item.quantity;
    } else {
      // New item, add to cart
      _items.add(item);
    }
    
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Increase quantity
  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // Decrease quantity
  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if item is in cart
  bool isInCart(String title, String? size) {
    String key = size != null ? '$title-$size' : title;
    return _items.any((item) => item.key == key);
  }
}