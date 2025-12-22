import 'package:flutter/material.dart';
import '../../models/user_role.dart';

class SignupRoleSelection extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;

  const SignupRoleSelection({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _RoleOption(
            role: UserRole.Worker,
            label: 'Worker',
            arabicLabel: 'عامل',
            icon: Icons.construction,
            isSelected: selectedRole == UserRole.Worker,
            onTap: () => onRoleChanged(UserRole.Worker),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: _RoleOption(
            role: UserRole.Employer,
            label: 'Employer',
            arabicLabel: 'صاحب شغل',
            icon: Icons.business_center,
            isSelected: selectedRole == UserRole.Employer,
            onTap: () => onRoleChanged(UserRole.Employer),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  final UserRole role;
  final String label;
  final String arabicLabel;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;
  final bool isTablet;

  const _RoleOption({
    required this.role,
    required this.label,
    required this.arabicLabel,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isTablet ? 90 : (screenHeight * 0.11).clamp(70.0, 90.0),
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
