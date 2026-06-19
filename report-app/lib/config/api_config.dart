import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Ganti IP ini jika backend tidak di localhost (mis. device fisik → IP PC Anda).
  static const String hostOverride = '';

  static String get baseUrl {
    if (hostOverride.isNotEmpty) {
      return hostOverride;
    }
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }
}
