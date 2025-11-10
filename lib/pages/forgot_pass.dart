import 'package:flutter/material.dart';
import 'package:forsaty/pages/otp_verification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? screenWidth * 0.15 : screenWidth * 0.075,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Top illustration image
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 400 : screenWidth * 0.85,
                        maxHeight: isTablet ? 320 : screenHeight * 0.35,
                      ),
                      child: Image.asset(
                        'assets/forgot-password.png',
                        width: isTablet ? 365 : screenWidth * 0.85,
                        height: isTablet ? 294 : screenWidth * 0.68,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: isTablet ? 365 : screenWidth * 0.85,
                            height: isTablet ? 294 : screenWidth * 0.68,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              size: isTablet ? 80 : 60,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Title
                  Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: isTablet
                          ? 24
                          : (screenWidth * 0.055).clamp(18, 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  SizedBox(height: screenHeight * 0.008),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 0 : screenWidth * 0.05,
                    ),
                    child: Text(
                      'Please enter your Email to reset the password',
                      style: TextStyle(
                        fontSize: isTablet
                            ? 14
                            : (screenWidth * 0.035).clamp(12, 14),
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // Email input field
                  _buildEmailField(
                    controller: _emailController,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Reset Password button
                  _buildGradientButton(
                    context: context,
                    text: 'Reset Password',
                    onPressed: () {
                      // Handle password reset
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your email address'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        // TODO: Implement password reset logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password reset link sent to your email',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(
                            email: _emailController.text,
                          ),
                        ),
                      );
                    },
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Back to login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet
                              ? 14
                              : (screenWidth * 0.032).clamp(11, 14),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: const Color(0xFF60A3D9),
                            fontSize: isTablet
                                ? 14
                                : (screenWidth * 0.032).clamp(11, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField({
    required TextEditingController controller,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Container(
      width: screenWidth * 0.85,
      height: isTablet ? 55 : screenHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: isTablet ? 16 : (screenWidth * 0.038).clamp(13, 16),
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: isTablet ? 14 : (screenWidth * 0.035).clamp(12, 14),
          ),
          hintText: 'Enter Your Email',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: isTablet ? 16 : (screenWidth * 0.038).clamp(13, 16),
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.grey[600],
            size: isTablet ? 22 : (screenWidth * 0.045).clamp(18, 22),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: isTablet ? 16 : screenHeight * 0.015,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Container(
      width: screenWidth * 0.85,
      height: isTablet ? 50 : screenHeight * 0.06,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A3D62), // Dark navy
            Color(0xFF60A3D9), // Sky blue
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3D62).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : (screenWidth * 0.038).clamp(13, 16),
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
