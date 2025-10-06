import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'filter_bottom_sheet.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  // All products data
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
  // Filter state
  String selectedCategory = 'All';
  double minPrice = 0;
  double maxPrice = 1000;

  // Get filtered products
  List<Map<String, dynamic>> get filteredProducts {
    return allProducts.where((product) {
      // Category filter
      bool categoryMatch = selectedCategory == 'All' || 
                          product['category'] == selectedCategory;
      
      // Price filter
      bool priceMatch = product['price'] >= minPrice && 
                       product['price'] <= maxPrice;
      
      return categoryMatch && priceMatch;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedCategory: selectedCategory,
        minPrice: minPrice,
        maxPrice: maxPrice,
        onApplyFilter: (category, min, max) {
          setState(() {
            selectedCategory = category;
            minPrice = min;
            maxPrice = max;
          });
        },
      ),
    );
  }

  int calculateDiscount(double price, double oldPrice) {
    if (oldPrice == 0) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'All';
                        minPrice = 0;
                        maxPrice = 1000;
                      });
                    },
                    child: Text('Reset Filters'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
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
              color: Colors.grey.withOpacity(0.1),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$discountPercent% Off',
                        style: TextStyle(
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
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_outline, color: Colors.grey, size: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      if (oldPrice > 0)
                        Text(
                          '\$${oldPrice.toStringAsFixed(2)}',
                          style: TextStyle(
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