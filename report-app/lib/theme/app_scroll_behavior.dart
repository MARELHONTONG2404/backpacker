import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Scroll mulus di web (drag mouse/trackpad) dan mobile.
class BackpackerScrollBehavior extends MaterialScrollBehavior {
  const BackpackerScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
