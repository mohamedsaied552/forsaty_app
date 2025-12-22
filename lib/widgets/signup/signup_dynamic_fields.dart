import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/signup_validators.dart';

class SignupDynamicFields extends StatelessWidget {
  final UserRole selectedRole;
  final TextEditingController phoneController;
  final TextEditingController skillsController;
  final TextEditingController jobNameController;

  const SignupDynamicFields({
    super.key,
    required this.selectedRole,
    required this.phoneController,
    required this.skillsController,
    required this.jobNameController,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.015),
          CustomTextField(
            controller: phoneController,
            hintText: 'Phone Number (Optional)',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: SignupValidators.validatePhone,
          ),
          if (selectedRole == UserRole.Worker) ...[
            SizedBox(height: screenHeight * 0.015),
            CustomTextField(
              controller: skillsController,
              hintText: 'Skills ',
              icon: Icons.work_outline,
              keyboardType: TextInputType.text,
              validator: SignupValidators.validateOptional,
            ),
          ],
          if (selectedRole == UserRole.Employer) ...[
            SizedBox(height: screenHeight * 0.015),
            CustomTextField(
              controller: jobNameController,
              hintText: 'Job Name (Optional)',
              icon: Icons.business_outlined,
              keyboardType: TextInputType.text,
              validator: SignupValidators.validateOptional,
            ),
          ],
        ],
      ),
    );
  }
}

