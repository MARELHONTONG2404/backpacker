import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../theme/app_theme.dart';

/// Layout auth selaras konsep sistem Backpacker.
class SystemAuthShell extends StatelessWidget {
  const SystemAuthShell({
    super.key,
    required this.header,
    required this.child,
    this.showFooter = true,
  });

  final Widget header;
  final Widget child;
  final bool showFooter;

  static const _backgroundAsset = 'assets/images/login-background.jpg';

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        MediaQuery.sizeOf(context).width > 448 ? 400.0 : MediaQuery.sizeOf(context).width - 48;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_backgroundAsset, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.18)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                width: cardWidth,
                padding: const EdgeInsets.fromLTRB(25, 28, 25, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    const SizedBox(height: 24),
                    child,
                  ],
                ),
              ),
            ),
          ),
          if (showFooter)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  AppStrings.footer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Header branding Backpacker untuk halaman auth.
class SystemAuthHeader extends StatelessWidget {
  const SystemAuthHeader({
    super.key,
    required this.title,
    required this.tagline,
    this.description,
  });

  final String title;
  final String tagline;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.backpack_outlined, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tagline,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 10),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ],
    );
  }
}

class SystemAuthField extends StatelessWidget {
  const SystemAuthField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, size: 16, color: AppColors.textSecondary),
          suffixIcon: suffixIcon,
          isDense: true,
        ),
      ),
    );
  }
}
