import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/api_service.dart';

Future<void> redirectToLoginIfUnauthorized(
  BuildContext context,
  ApiService api,
  ApiException error,
) async {
  if (!error.unauthorized || !context.mounted) return;
  await api.logout();
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => LoginScreen(api: api)),
    (_) => false,
  );
}
