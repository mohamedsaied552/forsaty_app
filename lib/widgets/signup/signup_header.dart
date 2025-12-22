import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 240 : 180,
              maxHeight: isTablet ? 220 : 160,
            ),
            child: Image.asset(
              'assets/create.png',
              width: isTablet ? 240 : 180,
              height: isTablet ? 220 : 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: isTablet ? 240 : 180,
                  height: isTablet ? 220 : 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image,
                    size: isTablet ? 60 : 40,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Text(
          'CREATE ACCOUNT',
          style: TextStyle(
            fontSize: isTablet ? 30 : (screenWidth * 0.085).clamp(22, 26),
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1B384A),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
