import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_shop/controllers/auth_controller.dart';
import 'package:shoes_shop/view/signin_screen.dart';
import 'setting_screen.dart';
import 'theme_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final ThemeProvider _themeProvider = ThemeProvider();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(_onThemeChanged);
    _loadUserData();
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  Future<void> _loadUserData() async {
    userData = await _authController.getUserData();
    setState(() {
      isLoading = false;
    });
  }

  String _getDisplayName() {
    if (userData != null && userData!['name'] != null) {
      return userData!['name'];
    }
    return _authController.user?.displayName ?? 'User';
  }

  String _getEmail() {
    if (userData != null && userData!['email'] != null) {
      return userData!['email'];
    }
    return _authController.user?.email ?? 'user@example.com';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeProvider.isDarkMode;
    final backgroundColor = isDark ? Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: Text(
          'My Account',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    width: double.infinity,
                    color: cardColor,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.deepOrange,
                          child: Text(
                            _getDisplayName()[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Name
                        Text(
                          _getDisplayName(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Email
                        Text(
                          _getEmail(),
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Edit Profile Button
                        OutlinedButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Menu Items
                  Container(
                    color: cardColor,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          iconColor: Colors.deepOrange,
                          textColor: textColor,
                          isDark: isDark,
                          onTap: () {
                            // Navigate to orders
                          },
                        ),
                        Divider(
                          height: 1,
                          indent: 60,
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                        ),
                        _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Shipping Address',
                          iconColor: Colors.deepOrange,
                          textColor: textColor,
                          isDark: isDark,
                          onTap: () {
                            // Navigate to shipping address
                          },
                        ),
                        Divider(
                          height: 1,
                          indent: 60,
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          iconColor: Colors.deepOrange,
                          textColor: textColor,
                          isDark: isDark,
                          onTap: () {
                            // Navigate to help center
                          },
                        ),
                        Divider(
                          height: 1,
                          indent: 60,
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          iconColor: Colors.deepOrange,
                          textColor: textColor,
                          isDark: isDark,
                          onTap: () {
                            _showLogoutDialog(context, isDark, cardColor, textColor);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 24,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark, Color cardColor, Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: Text(
          'Logout',
          style: TextStyle(color: textColor),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: textColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _authController.signOut();
              Get.offAll(() => const SigninScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}