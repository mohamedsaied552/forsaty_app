import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? actionCode; // For password reset from email link
  
  const ResetPasswordScreen({super.key, this.actionCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
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

    String? error;
    
    if (widget.actionCode != null) {
      // Password reset from email link
      error = await _authService.confirmPasswordReset(
        code: widget.actionCode!,
        newPassword: _passwordController.text.trim(),
      );
    } else {
      // Update password for logged-in user
      error = await _authService.updatePassword(_passwordController.text.trim());
    }

    setState(() {
      _isLoading = false;
    });

    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Title
                Text(
                  'Set a new password',
                  style: TextStyle(
                    fontSize: isTablet
                        ? 20
                        : (screenWidth * 0.05).clamp(18, 20).toDouble(),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 8),

                // Subtitle
                SizedBox(
                  width: screenWidth * 0.85,
                  child: Text(
                    'Create a new password. Ensure it differs from previous ones for security',
                    style: TextStyle(
                      fontSize: isTablet
                          ? 14
                          : (screenWidth * 0.035).clamp(12, 14).toDouble(),
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 30),

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

                // Password field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildPasswordField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Enter new password',
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                const SizedBox(height: 20),

                // Confirm Password field
                _buildPasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  hintText: 'Re-enter password',
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                const SizedBox(height: 30),

                // Update Password button
                Center(
                  child: _buildGradientButton(
                    text: _isLoading ? 'UPDATING...' : 'Update Password',
                    onPressed: _isLoading ? null : _updatePassword,
                    screenWidth: screenWidth,
                    isTablet: isTablet,
                  ),
                ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet
                ? 14
                : (screenWidth * 0.035).clamp(12, 14).toDouble(),
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        // TextField
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required.';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters.';
              }
              if (label == 'Confirm Password' &&
                  value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
            style: TextStyle(
              fontSize: isTablet
                  ? 16
                  : (screenWidth * 0.038).clamp(13, 16).toDouble(),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isTablet
                    ? 16
                    : (screenWidth * 0.038).clamp(13, 16).toDouble(),
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey[600],
                size: isTablet
                    ? 22
                    : (screenWidth * 0.045).clamp(18, 22).toDouble(),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                  size: isTablet
                      ? 22
                      : (screenWidth * 0.045).clamp(18, 22).toDouble(),
                ),
                onPressed: onToggleVisibility,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Container(
      width: screenWidth * 0.85,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3D62), Color(0xFF60A3D9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
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
                      fontSize: 16,
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
