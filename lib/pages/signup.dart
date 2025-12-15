import 'package:flutter/material.dart';
import 'package:forsaty/pages/login.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../logic/user/user_bloc.dart'; 
// import '../logic/user/user_event.dart'; 
// import '../logic/user/user_state.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

enum UserRole { Worker, Employer }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole selectedRole = UserRole.Worker;
  final _formKey = GlobalKey<FormState>(); 
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

    Future<void> _signup() async { // Added signup function for server-side validation
    setState(() {
      _errorMessage = null; // Reset error message
    });

    if (!_formKey.currentState!.validate()) return; // Validate fields before submission

    try {
      // Create user with Firebase Authentication
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store additional user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': selectedRole == UserRole.Worker ? 'Worker' : 'Employer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to login screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = 'This email is already registered.'; // Error message
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          _errorMessage = 'Password is too weak.'; // Error message
        });
      } else {
        setState(() {
          _errorMessage = e.message; // Other errors
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Catch-all error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? screenWidth * 0.15 : 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.03,
                      ), // Reduced from 0.06
                      // Top illustration image - smaller size
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 240 : 180, // Reduced sizes
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

                      SizedBox(
                        height: screenHeight * 0.025,
                      ), // Reduced from 0.04
                      // Title
                      Column(
                        children: [
                          Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: isTablet
                                  ? 30
                                  : (screenWidth * 0.085).clamp(
                                      22,
                                      26,
                                    ), // Reduced
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1B384A),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.025),
                      _buildRoleSelection(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        isTablet: isTablet,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        icon: Icons.person_outline,
                        validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Name is required.'; // Validation
                            return null;
                          },
                      ),

                      SizedBox(
                        height: screenHeight * 0.015,
                      ), // Reduced from 0.02
                      // Email field
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                         validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Email is required.';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) return 'Enter a valid email.';
                            return null;
                          },
                      ),

                      SizedBox(
                        height: screenHeight * 0.015,
                      ), // Reduced from 0.02
                      // Password field
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Password is required.';
                            if (value.length < 6) return 'Password must be at least 6 characters.';
                            return null;
                          },
                      ),

                      SizedBox(
                        height: screenHeight * 0.015,
                      ), // Reduced from 0.02
                      // Confirm Password field
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Confirm password is required.';
                            if (value != _passwordController.text) return 'Passwords do not match.'; // Confirm password validation
                            return null;
                          },
                      ),
                      if (_errorMessage != null) // Display error messages
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),

                      SizedBox(
                        height: screenHeight * 0.025,
                      ), // Reduced from 0.04
                      // SIGN UP button
                      _buildGradientButton(
                        context: context,
                        text: 'SIGN UP',
                        onPressed: _signup, 
                      ),

                      SizedBox(
                        height: screenHeight * 0.025,
                      ), // Reduced from 0.035
                      // Divider with text
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Text(
                              '–Or signup with–',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet
                                    ? 14
                                    : (screenWidth * 0.032).clamp(
                                        11,
                                        14,
                                      ), // Reduced
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
                      ),

                      SizedBox(
                        height: screenHeight * 0.02,
                      ), // Reduced from 0.03
                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF326789),
                            onPressed: () {
                              // Facebook signup
                            },
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          _buildSocialButton(
                            icon: Icons.g_mobiledata,
                            color: const Color(0xFFDB4437),
                            onPressed: () {
                              // Google signup
                            },
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          _buildSocialButton(
                            icon: Icons.apple,
                            color: Colors.black,
                            onPressed: () {
                              // Apple signup
                            },
                          ),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * 0.025,
                      ), // Reduced from 0.035
                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet
                                  ? 14
                                  : (screenWidth * 0.032).clamp(
                                      11,
                                      14,
                                    ), // Reduced
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
                                fontSize: isTablet
                                    ? 14
                                    : (screenWidth * 0.032).clamp(
                                        11,
                                        14,
                                      ), // Reduced
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * 0.02,
                      ), // Reduced bottom spacing
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Container(
      height: isTablet
          ? 55
          : screenHeight * 0.06, // Fixed height to prevent overflow
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
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
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: isTablet
              ? 16
              : (screenWidth * 0.038).clamp(13, 16), // Reduced
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: isTablet
                ? 16
                : (screenWidth * 0.038).clamp(13, 16), // Reduced
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: isTablet
                ? 22
                : (screenWidth * 0.045).clamp(18, 22), // Reduced
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                    size: isTablet
                        ? 22
                        : (screenWidth * 0.045).clamp(18, 22), // Reduced
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: isTablet ? 16 : screenHeight * 0.015, // Reduced
          ),
        ),
        validator: validator,
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
    final isTablet = screenWidth > 600;

    return Container(
      width: isTablet ? 300 : screenWidth * 0.85,
      height: isTablet ? 55 : screenHeight * 0.06, // Reduced height
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A3D62), // Dark navy
            Color(0xFF60A3D9), // Sky blue
          ],
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
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet
                    ? 16
                    : (screenWidth * 0.038).clamp(13, 16), // Reduced
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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

  Widget _buildRoleSelection({
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildRoleOption(
            role: UserRole.Worker,
            label: 'Worker',
            arabicLabel: 'عامل',
            icon: Icons.construction,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: _buildRoleOption(
            role: UserRole.Employer,
            label: 'Employer',
            arabicLabel: 'صاحب شغل',
            icon: Icons.business_center,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required UserRole role,
    required String label,
    required String arabicLabel,
    required IconData icon,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        height: isTablet ? 90 : screenHeight * 0.11,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F8FF) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0A3D62) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0A3D62).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0A3D62) : Colors.grey[600],
              size: isTablet ? 28 : (screenWidth * 0.06).clamp(22, 28),
            ),
            SizedBox(height: screenHeight * 0.008),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 14 : (screenWidth * 0.035).clamp(12, 14),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF0A3D62) : Colors.grey[700],
              ),
            ),
            Text(
              arabicLabel,
              style: TextStyle(
                fontSize: isTablet ? 12 : (screenWidth * 0.03).clamp(10, 12),
                color: isSelected ? const Color(0xFF0A3D62) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
