import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, this.email = '#####@gmail.com'});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOtp() {
    final otpCode = _getOtpCode();
    if (otpCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 5 digits'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // TODO: Implement OTP verification logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verifying OTP: $otpCode'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resendOtp() {
    // TODO: Implement resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP resent to your email'),
        backgroundColor: Colors.blue,
      ),
    );
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
                horizontal: isTablet ? screenWidth * 0.15 : screenWidth * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Title
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: isTablet
                          ? 24
                          : (screenWidth * 0.055).clamp(18, 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 0 : screenWidth * 0.05,
                    ),
                    child: Text(
                      'Please enter the OTP sent to your registered Email: ${widget.email}',
                      style: TextStyle(
                        fontSize: isTablet
                            ? 14
                            : (screenWidth * 0.035).clamp(12, 14),
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // OTP input fields
                  _buildOtpFields(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Verify Code button
                  _buildGradientButton(
                    context: context,
                    text: 'Verify Code',
                    onPressed: _verifyOtp,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    isTablet: isTablet,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Resend OTP text
                  _buildResendText(
                    screenWidth: screenWidth,
                    isTablet: isTablet,
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

  Widget _buildOtpFields({
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    final boxSize = isTablet
        ? 55.0
        : (screenWidth * 0.13).clamp(45, 55).toDouble();
    final spacing = isTablet ? 12.0 : screenWidth * 0.025;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing),
          child: _buildOtpBox(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            index: index,
            boxSize: boxSize,
            screenWidth: screenWidth,
          ),
        );
      }),
    );
  }

  Widget _buildOtpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required int index,
    required double boxSize,
    required double screenWidth,
  }) {
    return Container(
      width: boxSize,
      height: boxSize,
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
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: (screenWidth * 0.055).clamp(18, 22),
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 4) {
            // Move to next field
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field on backspace
            _focusNodes[index - 1].requestFocus();
          }
        },
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

  Widget _buildResendText({
    required double screenWidth,
    required bool isTablet,
  }) {
    final fontSize = isTablet
        ? 14.0
        : (screenWidth * 0.032).clamp(11, 14).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: fontSize, color: Colors.black54),
            children: [
              const TextSpan(text: "Haven't got the otp yet? "),
              TextSpan(
                text: 'Resend otp',
                style: const TextStyle(
                  color: Color(0xFF0A3D62),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _resendOtp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
