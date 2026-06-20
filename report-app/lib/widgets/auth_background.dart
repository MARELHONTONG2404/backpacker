import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Background auth/splash dengan fallback gradient jika asset gagal dimuat.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  static const assetPath = 'assets/images/login-background.jpg';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
