import 'package:flutter/material.dart';

import '../screens/daily_checkin_screen.dart';
import '../screens/home_screen.dart';
import '../services/api_service.dart';
import 'auth_navigation.dart';

/// Setelah autentikasi: tampilkan layar check-in jika perlu, lalu ke beranda.
class PostAuthNavigation {
  const PostAuthNavigation._();

  /// [fromLogin] true setelah login manual — selalu tampilkan layar check-in.
  /// Dari splash (sesi tersimpan): lewati jika sudah check-in hari ini.
  static Future<void> open(BuildContext context, ApiService api, {required bool fromLogin}) async {
    if (!fromLogin) {
      try {
        final profile = await api.fetchCoinProfile();
        if (!context.mounted) return;
        if (!profile.canCheckinToday) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HomeScreen(api: api)),
          );
          return;
        }
      } on ApiException catch (error) {
        if (!context.mounted) return;
        if (error.unauthorized) {
          await redirectToLoginIfUnauthorized(context, api, error);
          return;
        }
        // Gagal memuat profil — tetap tampilkan layar check-in agar user bisa coba lagi.
      }
    }

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DailyCheckinScreen(api: api)),
    );
  }
}
