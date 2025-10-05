import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'wishlist_manager.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String selectedCategory = 'All';
  final WishlistManager _wishlistManager = WishlistManager();

  final List<String> categories = ['All', 'Men', 'Women', 'Girls'];

  final List<Map<String, dynamic>> allProducts = [
  {
    'title': 'Nike Air Max 270',
    'category': 'Footwear',
    'price': 159.99,
    'oldPrice': 189.99,
    'image': 'assets/images/shoe.jpg',
    'gender': 'Men',
  },
  {
    'title': 'Adidas Ultraboost 22',
    'category': 'Footwear',
    'price': 189.99,
    'oldPrice': 220.00,
    'image': 'assets/images/shoe2.jpg',
    'gender': 'Men',
  },
  {
    'title': 'Puma RS-X³',
    'category': 'Footwear',
    'price': 129.99,
    'oldPrice': 0.0,
    'image': 'assets/images/shoes2.jpg',
    'gender': 'Women',
  },
  {
    'title': 'New Balance 574',
    'category': 'Footwear',
    'price': 84.99,
    'oldPrice': 110.00,
    'image': 'assets/images/nb574.jpg',
    'gender': 'All',
  },
  {
    'title': 'Converse Chuck Taylor',
    'category': 'Footwear',
    'price': 65.00,
    'oldPrice': 75.00,
    'image': 'assets/images/converse.jpg',
    'gender': 'All',
  },
  {
    'title': 'Vans Old Skool',
    'category': 'Footwear',
    'price': 69.99,
    'oldPrice': 0.0,
    'image': 'assets/images/vans.jpg',
    'gender': 'All',
  },
];

  @override
  void initState() {
    super.initState();
    _wishlistManager.addListener(_onWishlistChanged);
  }

  @override
  void dispose() {
    _wishlistManager.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    setState(() {});
  }

  // Get filtered products based on selected category
  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 'All') {
      return allProducts;
    }
    return allProducts.where((product) {
      return product['gender'] == selectedCategory || product['gender'] == 'All';
    }).toList();
  }

  int calculateDiscount(double price, double oldPrice) {
    if (oldPrice == 0) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
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
    
    // Show feedback
    if (_wishlistManager.isInWishlist(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Shopping',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((category) {
                  bool isSelected = selectedCategory == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: _buildCategoryChip(category, isSelected),
                  );
                }).toList(),
              ),
            ),
          ),

          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(
                  product['title'],
                  product['category'],
                  product['price'],
                  product['oldPrice'],
                  product['image'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    String title,
    String category,
    double price,
    double oldPrice,
    String imagePath,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Discount Badge
                if (discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(title, category, price, oldPrice, imagePath),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
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
            // Product Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        if (oldPrice > 0)
                          Text(
                            '\$${oldPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
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
}