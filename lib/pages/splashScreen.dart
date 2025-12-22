import 'package:flutter/material.dart';
import 'package:forsaty/pages/login.dart';
import 'package:forsaty/pages/signup.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            // Curved header shapes
            Positioned(
              top: 0,
              left: screenWidth * 0.22,
              child: Image.asset(
                'assets/Rectangle 12.png',
                width: screenWidth * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              left: screenWidth * 0,
              child: Image.asset(
                'assets/Rectangle 11.png',
                width: screenWidth * 0.6,
                fit: BoxFit.contain,
              ),
            ),

            // Main content
            SafeArea(
              child: Container(
                width: screenWidth,
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        // Logo - constrained to prevent overflow
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 412,
                            maxHeight: 422,
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            width: screenWidth * 1,
                            height: screenWidth * 1,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(75),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),
                        // LOG IN button
                        _buildGradientButton(
                          context: context,
                          text: 'LOG IN',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: screenHeight * 0.025),
                        // CREATE ACCOUNT button
                        _buildGradientButton(
                          context: context,
                          text: 'CREATE ACCOUNT',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.065,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3D62), Color(0xFF60A3D9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3D62).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 18),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
