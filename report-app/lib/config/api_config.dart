import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Kosongkan untuk auto-detect. Override via --dart-define=API_BASE_URL=http://host:8080
  static const String hostOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    final override = hostOverride.trim();
    if (override.isNotEmpty) {
      return override.endsWith('/')
          ? override.substring(0, override.length - 1)
          : override;
    }
    if (kIsWeb) {
      final uri = Uri.base;
      if (uri.host.isNotEmpty) {
        final isLanGateway = uri.port == 8888 &&
            uri.host != 'localhost' &&
            uri.host != '127.0.0.1';
        final isTunnel = uri.host.endsWith('.loca.lt') ||
            uri.host.endsWith('.trycloudflare.com');
        if (isLanGateway || isTunnel) {
          final portSuffix = uri.hasPort && uri.port != 80 && uri.port != 443
              ? ':${uri.port}'
              : '';
          return '${uri.scheme}://${uri.host}$portSuffix';
        }
        return 'http://${uri.host}:8080';
      }
      return 'http://localhost:8080';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }
}
