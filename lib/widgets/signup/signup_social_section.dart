import 'package:flutter/material.dart';

class SignupSocialSection extends StatelessWidget {
  const SignupSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.025),
        _buildDivider(screenWidth, isTablet),
        SizedBox(height: screenHeight * 0.02),
        _buildSocialButtons(screenWidth, isTablet),
      ],
    );
  }

  Widget _buildDivider(double screenWidth, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            '–Or signup with–',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTablet ? 14 : (screenWidth * 0.032).clamp(11, 14),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(double screenWidth, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          icon: Icons.facebook,
          color: const Color(0xFF326789),
          onPressed: () {
            // Facebook signup
          },
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(width: screenWidth * 0.05),
        _SocialButton(
          icon: Icons.g_mobiledata,
          color: const Color(0xFFDB4437),
          onPressed: () {
            // Google signup
          },
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(width: screenWidth * 0.05),
        _SocialButton(
          icon: Icons.apple,
          color: Colors.black,
          onPressed: () {
            // Apple signup
          },
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double screenWidth;
  final bool isTablet;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.screenWidth,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: isTablet ? 60 : screenWidth * 0.13,
        height: isTablet ? 60 : screenWidth * 0.13,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: isTablet ? 30 : (screenWidth * 0.06).clamp(20, 28),
        ),
      ),
    );
  }
}

