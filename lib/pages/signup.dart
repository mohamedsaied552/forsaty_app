import 'package:flutter/material.dart';
import 'package:forsaty/pages/login.dart';
import '../services/auth_service.dart';
import '../models/user_role.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/error_message.dart';
import '../widgets/signup/signup_header.dart';
import '../widgets/signup/signup_role_selection.dart';
import '../widgets/signup/signup_dynamic_fields.dart';
import '../widgets/signup/signup_social_section.dart';
import '../widgets/signup/signup_login_link.dart';
import '../utils/signup_validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  final _jobNameController = TextEditingController();

  // Form state
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // UI state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole selectedRole = UserRole.Worker;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    _jobNameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
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

    final error = await _authService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      role: selectedRole == UserRole.Worker ? 'Worker' : 'Employer',
      skills: selectedRole == UserRole.Worker
          ? _skillsController.text.trim()
          : null,
      jobName: selectedRole == UserRole.Employer
          ? _jobNameController.text.trim()
          : null,
    );

    setState(() {
      _isLoading = false;
    });

    if (error != null) {
      setState(() {
        _errorMessage = error;
      });
    } else {
      _handleSignupSuccess();
    }
  }

  void _handleSignupSuccess() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SignupHeader(),
                        SizedBox(height: screenHeight * 0.025),
                        SignupRoleSelection(
                          selectedRole: selectedRole,
                          onRoleChanged: (role) {
                            setState(() {
                              selectedRole = role;
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildNameField(),
                        SignupDynamicFields(
                          selectedRole: selectedRole,
                          phoneController: _phoneController,
                          skillsController: _skillsController,
                          jobNameController: _jobNameController,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        _buildEmailField(),
                        SizedBox(height: screenHeight * 0.015),
                        _buildPasswordField(),
                        SizedBox(height: screenHeight * 0.015),
                        _buildConfirmPasswordField(),
                        if (_errorMessage != null)
                          ErrorMessage(message: _errorMessage!),
                        SizedBox(height: screenHeight * 0.025),
                        GradientButton(
                          text: _isLoading ? 'CREATING...' : 'SIGN UP',
                          onPressed: _isLoading ? null : _signup,
                          isLoading: _isLoading,
                        ),
                        const SignupSocialSection(),
                        SizedBox(height: screenHeight * 0.025),
                        const SignupLoginLink(),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      hintText: 'Name',
      icon: Icons.person_outline,
      validator: SignupValidators.validateName,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      icon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      validator: SignupValidators.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
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
      validator: SignupValidators.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
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
      validator: (value) => SignupValidators.validateConfirmPassword(
        value,
        _passwordController.text,
      ),
    );
  }
}
