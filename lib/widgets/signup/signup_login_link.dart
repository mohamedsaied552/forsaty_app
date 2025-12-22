import 'package:flutter/material.dart';
import 'package:forsaty/pages/login.dart';

class SignupLoginLink extends StatelessWidget {
  const SignupLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 14 : (screenWidth * 0.032).clamp(11, 14),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: Text(
            'login',
            style: TextStyle(
              color: const Color(0xFF326789),
              fontSize: isTablet ? 14 : (screenWidth * 0.032).clamp(11, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

