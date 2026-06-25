import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:report_app/main.dart';
import 'package:report_app/services/locale_service.dart';

void main() {
  testWidgets('App shows splash loading indicator', (WidgetTester tester) async {
    final localeService = LocaleService(const Locale('id'));
    await tester.pumpWidget(BackpackerApp(localeService: localeService));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
