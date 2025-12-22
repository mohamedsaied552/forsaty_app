import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final error = await _authService.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _emailSent = false;
      });
    } else {
      setState(() {
        _emailSent = true;
        _errorMessage = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
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
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // ✅ correct
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
                      _emailSent
                          ? 'Password reset email has been sent to your email address. Please check your inbox.'
                          : 'Please enter your Email to reset the password',
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildEmailField(
                          controller: _emailController,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                          enabled: !_emailSent,
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // Error message display
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Success message display
                        if (_emailSent)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[300]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Password reset email sent successfully!',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Reset Password button
                        _buildGradientButton(
                          context: context,
                          text: _isLoading
                              ? 'SENDING...'
                              : _emailSent
                                  ? 'RESEND EMAIL'
                                  : 'Reset Password',
                          onPressed: _emailSent || _isLoading
                              ? (_emailSent ? _resetPassword : null)
                              : _resetPassword,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
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
    bool enabled = true,
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
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        enabled: enabled,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Email is required.';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
            return 'Enter a valid email.';
          }
          return null;
        },
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
    required VoidCallback? onPressed,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Container(
      width: screenWidth * 0.85,
      height: isTablet ? 50 : screenHeight * 0.06,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3D62), Color(0xFF60A3D9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3D62).withOpacity(0.25),
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
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
