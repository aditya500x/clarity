import 'package:flutter/material.dart';
import '../../config/colors.dart';

/// Home screen - main landing page (matches index.html exactly)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.htmlBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Top Navigation Bar
              _buildNavBar(context),
              const SizedBox(height: 40),
              
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Title
                    Text(
                      'What do you want help with today?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3A3A3A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Module Cards
                    _buildMenuCard(
                      context,
                      title: 'Break Down a Task',
                      subtitle: 'Turn big assignments into small, manageable steps',
                      iconBgColor: AppColors.htmlIconGreenBg,
                      iconColor: AppColors.htmlIconGreen,
                      icon: Icons.check_box_outlined,
                      onTap: () => Navigator.pushNamed(context, '/tasker'),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildMenuCard(
                      context,
                      title: 'Read Safely',
                      subtitle: 'Sensory-friendly reading with customizable settings',
                      iconBgColor: AppColors.htmlIconBlueBg,
                      iconColor: AppColors.htmlIconBlue,
                      icon: Icons.menu_book_outlined,
                      onTap: () => Navigator.pushNamed(context, '/paragraph'),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildMenuCard(
                      context,
                      title: 'Socratic Buddy',
                      subtitle: 'Get step-by-step help through guided questions',
                      iconBgColor: AppColors.htmlIconPurpleBg,
                      iconColor: AppColors.htmlIconPurple,
                      icon: Icons.chat_bubble_outline,
                      onTap: () => Navigator.pushNamed(context, '/chatbot'),
                    ),
                  ],
                ),
              ),
              
              // Footer Button
              _buildFooterButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF5C9EAD),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              child: Icon(
                Icons.add,
                color: const Color(0xFF5C9EAD),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Clarity',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        // Settings Icon
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/settings'),
          child: Icon(
            Icons.settings_outlined,
            color: AppColors.htmlTextMain,
            size: 24,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.htmlCardBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 20),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17.6,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.4,
                      color: AppColors.htmlTextSub,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chevron
            Text(
              '›',
              style: TextStyle(
                fontSize: 22,
                color: const Color(0xFFA0A0A0),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFooterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/meditate'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.htmlAccentPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: const Color(0xFF2D2D2D),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              "I'm Feeling Overwhelmed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
