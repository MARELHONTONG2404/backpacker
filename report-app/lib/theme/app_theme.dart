import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

/// Warna brand Backpacker — tetap sama di mode terang & gelap.
class AppColors {
  static const primary = Color(0xFF409EFF);
  static const primaryDark = Color(0xFF337ECC);
  static const secondary = Color(0xFF67C23A);
  static const background = Color(0xFFF0F2F5);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF303133);
  static const textRegular = Color(0xFF606266);
  static const textSecondary = Color(0xFF909399);
  static const border = Color(0xFFDCDFE6);
  static const loginTitle = Color(0xFF707070);

  static const trail = Color(0xFF2D6A4F);
  static const trailLight = Color(0xFF40916C);
  static const sand = Color(0xFFE9C46A);
  static const adventureDark = Color(0xFF1B4332);
  static const skyDeep = Color(0xFF2563EB);

  static const brandGradient = LinearGradient(
    colors: [skyDeep, primary, trail, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const splashGradient = LinearGradient(
    colors: [adventureDark, Color(0xFF1D3557), primaryDark, trail],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [secondary, Color(0xFF85CE61)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppLayout {
  static const screenPadding = 16.0;
  static const sectionGap = 12.0;
  static const listBottomInset = 96.0;
  static const bottomNavHeight = 74.0;
  static const cardRadius = 18.0;
  static const heroRadius = 22.0;
  static const inputRadius = 12.0;
}

class AppDecorations {
  static List<BoxShadow> cardShadow({double elevation = 1, bool dark = false}) {
    final alpha = dark ? 0.25 + elevation * 0.05 : 0.06 + elevation * 0.02;
    return [
      BoxShadow(
        color: (dark ? Colors.black : AppColors.primary).withValues(alpha: alpha),
        blurRadius: 16 + elevation * 4,
        offset: Offset(0, 4 + elevation * 2),
      ),
      if (!dark)
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
    ];
  }

  static BoxDecoration glassCard({
    required BuildContext context,
    Color? tint,
    double radius = AppLayout.cardRadius,
  }) {
    final palette = AppPalette.of(context);
    return BoxDecoration(
      color: (tint ?? palette.surface).withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: palette.glassBorder),
      boxShadow: cardShadow(dark: palette.isDark),
    );
  }
}

class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final palette = AppPalette(brightness);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: const Color(0xFFF56C6C),
      onError: Colors.white,
      surface: palette.surface,
      onSurface: palette.textPrimary,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: palette.textPrimary,
      displayColor: palette.textPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface.withValues(alpha: 0.85),
        indicatorColor: palette.navIndicator,
        elevation: 0,
        height: AppLayout.bottomNavHeight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.primary : palette.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : palette.textSecondary,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceElevated.withValues(alpha: 0.92),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
          side: BorderSide(color: palette.border.withValues(alpha: 0.6)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? palette.surfaceElevated : AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: palette.textSecondary, fontSize: 14),
        hintStyle: TextStyle(
          color: palette.textSecondary.withValues(alpha: 0.75),
          fontSize: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(46),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.inputRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.14);
            }
            return isDark ? palette.surfaceElevated : palette.surface;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppLayout.inputRadius)),
          ),
        ),
      ),
      dividerColor: palette.border,
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.cardRadius),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: palette.textRegular,
          height: 1.45,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? palette.surfaceElevated : const Color(0xFF303133),
        contentTextStyle: TextStyle(color: isDark ? palette.textPrimary : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppLayout.inputRadius)),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

String formatCurrency(num amount) {
  final text = amount.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

Color statusColor(String status, {Brightness brightness = Brightness.light}) {
  final muted = brightness == Brightness.dark
      ? const Color(0xFF8B95A5)
      : AppColors.textSecondary;
  switch (status) {
    case 'DRAFT':
      return muted;
    case 'PUBLISHED':
      return AppColors.primary;
    case 'TAKEN':
      return const Color(0xFFE6A23C);
    case 'IN_PROGRESS':
      return const Color(0xFFE6A23C);
    case 'COMPLETED':
      return AppColors.secondary;
    case 'CANCELLED':
      return const Color(0xFFF56C6C);
    default:
      return muted;
  }
}

IconData categoryIcon(String? category) {
  switch (category) {
    case 'delivery':
      return Icons.local_shipping_outlined;
    case 'helper':
      return Icons.handshake_outlined;
    case 'tech':
      return Icons.build_outlined;
    case 'errands':
      return Icons.shopping_bag_outlined;
    default:
      return Icons.task_alt_outlined;
  }
}
