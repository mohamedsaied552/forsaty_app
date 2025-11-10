import 'package:flutter/material.dart';
import 'package:forsaty/pages/forgot_pass.dart';
import 'package:forsaty/pages/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final _ = screenWidth > 600;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Curved header shapes
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.35,
            child: Stack(
              children: [
                Positioned.fill(
                  top: 0,
                  left: MediaQuery.of(context).size.width * 0.0,
                  child: Image.asset(
                    'assets/Subtract.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),

                // Logo
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.8,
                      left: MediaQuery.of(context).size.width * 1,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width * 0.09),
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: MediaQuery.of(context).size.width * 0.27,
                      child: Image.asset(
                        'assets/Group 2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.35,
            child: Image.asset(
              'assets/logo 2.png',
              width: MediaQuery.of(context).size.width * 0.3,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.45,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Username field
                          _buildTextField(
                            controller: _usernameController,
                            hintText: 'Username',
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 12),

                          // Forgot Password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to forgot password screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // LOG IN button
                          _buildGradientButton(
                            context: context,
                            text: 'LOG IN',
                            onPressed: () {
                              // Handle login
                            },
                          ),
                          const SizedBox(height: 30),

                          // Divider with text
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  '-Or login with-',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 2, 0, 0),
                                    fontSize: 16,
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
                          const SizedBox(height: 24),

                          // Social login buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                icon: Icons.facebook,
                                color: const Color(0xFF1877F2),
                                onPressed: () {
                                  // Facebook login
                                },
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                icon: Icons.g_mobiledata,
                                color: const Color(0xFFDB4437),
                                onPressed: () {
                                  // Google login
                                },
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                icon: Icons.apple,
                                color: Colors.black,
                                onPressed: () {
                                  // Apple login
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Color.fromARGB(98, 0, 0, 0),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Create new',
                                  style: TextStyle(
                                    color: Color(0xFF326789),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A3D62), // Dark navy
            Color(0xFF60A3D9), // Light blue
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3D62).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
              style: const TextStyle(
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

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
      ),
    );
  }
}
