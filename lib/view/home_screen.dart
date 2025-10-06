import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_shop/controllers/auth_controller.dart';
import 'product_detail_screen.dart';
import 'all_products_screen.dart';
import 'cart_screen.dart';
import 'wishlist_manager.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  int _selectedIndex = 0;
  final WishlistManager _wishlistManager = WishlistManager();
  final ThemeProvider _themeProvider = ThemeProvider();
  final AuthController _authController = Get.find<AuthController>();
  Map<String, dynamic>? userData;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _wishlistManager.addListener(_onWishlistChanged);
    _themeProvider.addListener(_onThemeChanged);
    _loadUserData();
  }

  @override
  void dispose() {
    _wishlistManager.removeListener(_onWishlistChanged);
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    userData = await _authController.getUserData();
    setState(() {
      isLoadingUser = false;
    });
  }

  void _onWishlistChanged() {
    setState(() {});
  }

  void _onThemeChanged() {
    setState(() {});
  }

  String _getDisplayName() {
    if (userData != null && userData!['name'] != null) {
      return userData!['name'];
    }
    return _authController.user?.displayName ?? 'User';
  }

  String _getFirstName() {
    String fullName = _getDisplayName();
    return fullName.split(' ')[0];
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void toggleFavorite(String title, String category, double price, double oldPrice, String imagePath) {
    final wishlistItem = WishlistItem(
      title: title,
      category: category,
      price: price,
      oldPrice: oldPrice,
      imagePath: imagePath,
    );
    
    _wishlistManager.toggleWishlist(wishlistItem);
    
    if (_wishlistManager.isInWishlist(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.favorite, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Added to wishlist')),
            ],
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void toggleDarkMode() async {
    await _themeProvider.toggleTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _themeProvider.isDarkMode 
              ? 'Dark mode enabled' 
              : 'Light mode enabled'
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeProvider.isDarkMode;
    final backgroundColor = isDark ? Color(0xFF121212) : Colors.grey[100];
    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBarColor = isDark ? Color(0xFF2C2C2C) : Colors.grey[200];
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // header section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      isLoadingUser ? '?' : _getDisplayName()[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoadingUser ? 'Hello' : 'Hello ${_getFirstName()}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: textColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_bag_outlined, color: textColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: textColor,
                    ),
                    onPressed: toggleDarkMode,
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: textColor),
                  suffixIcon: Icon(Icons.tune, color: textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: searchBarColor,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Category chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildCategoryChip('All', isDark, cardColor, textColor)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCategoryChip('Men', isDark, cardColor, textColor)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCategoryChip('Women', isDark, cardColor, textColor)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildCategoryChip('Girls', isDark, cardColor, textColor)),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Special sale banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Get Your',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Special Sale',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Up to 40%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Popular Product header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
            ),
            
            // Product grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  children: [
                    _buildProductCard(
                      'Nike Air Max 270',
                      'Footwear',
                      159.99,
                      189.99,
                      'assets/images/shoe.jpg',
                      isDark,
                      cardColor,
                      textColor,
                    ),
                    _buildProductCard(
                      'Adidas Ultraboost 22',
                      'Footwear',
                      189.99,
                      220.00,
                      'assets/images/shoe2.jpg',
                      isDark,
                      cardColor,
                      textColor,
                    ),
                    _buildProductCard(
                      'Puma RS-X³',
                      'Footwear',
                      129.99,
                      0.0,
                      'assets/images/shoes2.jpg',
                      isDark,
                      cardColor,
                      textColor,
                    ),
                    _buildProductCard(
                      'New Balance 574',
                      'Footwear',
                      84.99,
                      110.00,
                      'assets/images/nb574.jpg',
                      isDark,
                      cardColor,
                      textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isDark, Color cardColor, Color textColor) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.deepOrange : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(Icons.check, color: Colors.white, size: 16),
            if (isSelected) const SizedBox(width: 4),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateDiscount(double price, double oldPrice) {
    if (oldPrice == 0) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
  }
  
  Widget _buildProductCard(
    String title,
    String category,
    double price,
    double oldPrice,
    String imagePath,
    bool isDark,
    Color cardColor,
    Color textColor,
  ) {
    int discountPercent = calculateDiscount(price, oldPrice);
    bool isFavorite = _wishlistManager.isInWishlist(title);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              title: title,
              category: category,
              price: price,
              oldPrice: oldPrice,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$discountPercent% Off',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(title, category, price, oldPrice, imagePath),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF2C2C2C) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (oldPrice > 0)
                        Text(
                          '\$${oldPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}