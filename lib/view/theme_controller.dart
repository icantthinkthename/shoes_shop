import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_shop/controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPushNotifications = true;
  bool isEmailNotifications = false;

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Appearance Section
            _buildSectionHeader('Appearance', subtitleColor),
            Container(
              color: cardColor,
              child: GetBuilder<ThemeController>(
                builder: (controller) => _buildSwitchTile(
                  icon: controller.isDarkMode 
                      ? Icons.dark_mode_outlined 
                      : Icons.wb_sunny_outlined,
                  title: 'Dark Mode',
                  textColor: textColor,
                  value: controller.isDarkMode,
                  onChanged: (value) async {
                    await controller.setTheme(value);
                    Get.snackbar(
                      'Theme Changed',
                      controller.isDarkMode 
                          ? 'Dark mode enabled' 
                          : 'Dark mode disabled',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.deepOrange.withOpacity(0.9),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 8,
                      duration: const Duration(seconds: 1),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionHeader('Notifications', subtitleColor),
            Container(
              color: cardColor,
              child: Column(
                children: [
                  _buildNotificationTile(
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications about\norders and promotions',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    value: isPushNotifications,
                    onChanged: (value) {
                      setState(() {
                        isPushNotifications = value;
                      });
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  _buildNotificationTile(
                    title: 'Email Notifications',
                    subtitle: 'Receive email updates about your\norders',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    value: isEmailNotifications,
                    onChanged: (value) {
                      setState(() {
                        isEmailNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Section
            _buildSectionHeader('Privacy', subtitleColor),
            Container(
              color: cardColor,
              child: Column(
                children: [
                  _buildNavigationTile(
                    icon: Icons.shield_outlined,
                    iconColor: Colors.brown,
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDark: isDark,
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 60,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  _buildNavigationTile(
                    icon: Icons.description_outlined,
                    iconColor: Colors.brown,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    isDark: isDark,
                    onTap: () {
                      // Navigate to terms of service
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionHeader('About', subtitleColor),
            Container(
              color: cardColor,
              child: _buildNavigationTile(
                icon: Icons.info_outline,
                iconColor: Colors.brown,
                title: 'App Version',
                subtitle: '1.0.0',
                textColor: textColor,
                subtitleColor: subtitleColor,
                isDark: isDark,
                onTap: () {
                  // Show app info
                },
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color? color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required Color textColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(
        icon,
        color: Colors.orange,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepOrange,
        activeTrackColor: Colors.deepOrange.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required Color textColor,
    required Color? subtitleColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: subtitleColor,
            height: 1.4,
          ),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.deepOrange,
        activeTrackColor: Colors.deepOrange.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color? subtitleColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: subtitleColor,
          ),
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
}