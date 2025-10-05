import 'package:flutter/material.dart';
import 'cart_manager.dart';
import 'wishlist_manager.dart';

class ProductDetailScreen extends StatefulWidget {
  final String title;
  final String category;
  final double price;
  final double oldPrice;
  final String imagePath;

  const ProductDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.imagePath,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = '';
  final CartManager _cartManager = CartManager();
  final WishlistManager _wishlistManager = WishlistManager();

  @override
  void initState() {
    super.initState();
    _wishlistManager.addListener(_onWishlistChanged);
    
    // Set default selected size
    if (needsSizeSelection) {
      selectedSize = isFootwear ? '40' : 'XL';
    }
  }

  @override
  void dispose() {
    _wishlistManager.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    setState(() {});
  }

  // Check if product needs size selection
  bool get needsSizeSelection {
    return widget.category.toLowerCase() == 'footwear' || 
           widget.category.toLowerCase() == 'clothing' ||
           widget.category.toLowerCase() == 'apparel';
  }

  // Check if product is footwear (shoes)
  bool get isFootwear {
    return widget.category.toLowerCase() == 'footwear';
  }

  // Get available sizes based on product type
  List<String> get availableSizes {
    if (isFootwear) {
      return ['38', '39', '40', '41', '42'];
    } else {
      return ['S', 'M', 'L', 'XL'];
    }
  }

  // Get product brand
  String get productBrand {
    if (widget.title.contains('Nike')) return 'Nike';
    if (widget.title.contains('Adidas')) return 'Adidas';
    if (widget.title.contains('Puma')) return 'Puma';
    if (widget.title.contains('New Balance')) return 'New Balance';
    if (widget.title.contains('Converse')) return 'Converse';
    if (widget.title.contains('Vans')) return 'Vans';
    return '';
  }

  // Get product description
  String get productDescription {
    if (isFootwear) {
      // Dynamic descriptions based on product title
      if (widget.title.contains('Nike Air Max')) {
        return 'Experience ultimate comfort with Nike Air Max 270. Featuring the largest Max Air unit yet, providing unrivaled cushioning. Premium mesh upper with synthetic overlays for durability. Perfect for all-day wear with modern design and vibrant colors. Rubber outsole with flex grooves for natural motion.';
      } else if (widget.title.contains('Adidas') || widget.title.contains('Ultraboost')) {
        return 'Revolutionary running shoe with responsive Boost cushioning. Primeknit+ upper adapts to your foot for a sock-like fit. Linear Energy Push system for explosive energy return. Continental rubber outsole for superior grip. Ideal for serious runners and everyday athletes.';
      } else if (widget.title.contains('Puma')) {
        return 'Retro-inspired chunky sneaker with modern tech. RS cushioning for comfort and support. Breathable mesh upper with bold colorways. Rubber outsole for traction. Perfect for streetwear and casual styling. Lightweight yet durable construction.';
      } else if (widget.title.contains('New Balance')) {
        return 'Classic lifestyle sneaker with timeless design. ENCAP midsole technology provides support and durability. Suede and mesh upper for premium look and breathability. Versatile style works with any outfit. Reliable grip and all-day comfort.';
      } else if (widget.title.contains('Converse')) {
        return 'Iconic canvas high-top sneaker. Timeless design that never goes out of style. Durable canvas upper with vulcanized rubber sole. OrthoLite insole for cushioning. Perfect for casual wear and self-expression. A true cultural icon since 1917.';
      } else if (widget.title.contains('Vans')) {
        return 'Classic skate shoe with signature side stripe. Sturdy canvas and suede uppers. Reinforced toe caps for durability. Padded collars for comfort. Waffle rubber outsoles for grip. Perfect for skateboarding and everyday wear.';
      }
      return 'Premium footwear with superior comfort, style, and durability. Designed for all-day wear with high-quality materials and expert craftsmanship.';
    }
    return 'This is a high-quality product designed to meet your needs. Made with premium materials and attention to detail.';
  }

  // Toggle wishlist
  void _toggleWishlist() {
    final wishlistItem = WishlistItem(
      title: widget.title,
      category: widget.category,
      price: widget.price,
      oldPrice: widget.oldPrice,
      imagePath: widget.imagePath,
    );
    
    _wishlistManager.toggleWishlist(wishlistItem);
    
    // Show feedback
    if (_wishlistManager.isInWishlist(widget.title)) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from wishlist'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Add to cart function
  void _addToCart() {
    // Create cart item
    final cartItem = CartItem(
      title: widget.title,
      category: widget.category,
      price: widget.price,
      imagePath: widget.imagePath,
      size: needsSizeSelection ? selectedSize : null,
      quantity: 1,
    );

    // Add to cart using CartManager
    _cartManager.addToCart(cartItem);

    // Show success message
    String message = needsSizeSelection 
        ? 'Added to cart! Size: $selectedSize'
        : 'Added to cart!';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart screen if you have the route set up
            // Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = _wishlistManager.isInWishlist(widget.title);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Color(0xFF4A7C7E),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            widget.imagePath,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: GestureDetector(
                            onTap: _toggleWishlist,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isFavorite ? Colors.red : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_outline,
                                color: isFavorite ? Colors.white : Colors.grey,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Product Info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (productBrand.isNotEmpty) ...[
                                    Text(
                                      productBrand,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.category,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '\$${widget.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Select Size - Only show for footwear/clothing
                        if (needsSizeSelection) ...[
                          Text(
                            'Select Size',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          SizedBox(height: 12),
                          
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: availableSizes.map((size) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: _buildSizeButton(size),
                                );
                              }).toList(),
                            ),
                          ),
                          
                          SizedBox(height: 24),
                        ],
                        
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 8),
                        
                        Text(
                          productDescription,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Buttons - Add to Cart & Buy Now
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Add to Cart Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _addToCart,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.deepOrange, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 12),
                
                // Buy Now Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add to cart first, then navigate to checkout
                        _addToCart();
                        
                        // Navigate to cart/checkout screen
                        // Navigator.pushNamed(context, '/cart');
                        
                        String message = needsSizeSelection 
                            ? 'Purchasing ${widget.title} - Size: $selectedSize'
                            : 'Purchasing ${widget.title}';
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.deepOrange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}