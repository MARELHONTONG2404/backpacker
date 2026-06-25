import 'package:flutter/material.dart';

import 'animated_backpacker_background.dart';

/// Background animasi marketplace Backpacker (auth & splash).
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedBackpackerBackground();
  }
}

/// Background animasi lembut untuk halaman utama — adaptif terang / gelap.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBackpackerBackground(subtle: true, night: isDark);
  }
}
