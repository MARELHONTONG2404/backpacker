import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';
import 'app_animations.dart';
import 'auth_background.dart';
import 'backpacker_brand.dart';
import 'glass_surface.dart';
import 'language_selector.dart';
import 'login_task_worker_animation.dart';
import 'theme_selector.dart';

/// Layout auth selaras konsep sistem Backpacker.
class SystemAuthShell extends StatefulWidget {
  const SystemAuthShell({
    super.key,
    required this.header,
    required this.child,
    this.showFooter = true,
    this.showTaskWorkerAnimation = false,
  });

  final Widget header;
  final Widget child;
  final bool showFooter;
  final bool showTaskWorkerAnimation;

  @override
  State<SystemAuthShell> createState() => _SystemAuthShellState();
}

class _SystemAuthShellState extends State<SystemAuthShell> {
  static bool _isPhone(BuildContext context) => MediaQuery.sizeOf(context).width <= 480;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPhone = _isPhone(context);
    final cardWidth = isPhone
        ? size.width - 32
        : (size.width > 448 ? 400.0 : size.width - 48);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: isPhone ? 4 : 8, right: isPhone ? 4 : 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ThemeMenuButton(iconColor: Colors.white),
                    LanguageMenuButton(iconColor: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showTaskWorkerAnimation)
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.showFooter ? 40 : 0,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.92,
                  child: LoginTaskWorkerAnimation(
                    height: size.height < 640 ? 150 : 190,
                  ),
                ),
              ),
            ),
          Align(
            alignment: isPhone ? Alignment.topCenter : Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isPhone ? 16 : 24,
                isPhone ? 52 : 32,
                isPhone ? 16 : 24,
                isPhone ? 24 : 32,
              ),
              child: EntranceFadeSlide(
                duration: const Duration(milliseconds: 520),
                offsetY: 24,
                child: GlassSurface(
                  blur: true,
                  opacity: 0.92,
                  borderRadius: isPhone ? 16 : 20,
                  elevation: 2,
                  padding: EdgeInsets.fromLTRB(
                    isPhone ? 20 : 25,
                    isPhone ? 22 : 28,
                    isPhone ? 20 : 25,
                    isPhone ? 16 : 8,
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        widget.header,
                        SizedBox(height: isPhone ? 18 : 24),
                        widget.child,
                        if (isPhone && widget.showFooter) ...[
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.footer,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary.withValues(alpha: 0.85),
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.showFooter && !isPhone)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  context.l10n.footer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
    this.compact = false,
  });

  final String title;
  final String tagline;
  final String? description;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final useCompact = compact || isPhone;

    return Column(
      children: [
        BackpackerBrandTitle(
          compact: useCompact,
          showLogo: true,
          showSubtitle: !useCompact,
          logoSize: useCompact ? 44 : null,
        ),
        if (description != null) ...[
          SizedBox(height: useCompact ? 8 : 10),
          Text(
            description!,
            textAlign: TextAlign.center,
            maxLines: useCompact ? 2 : null,
            overflow: useCompact ? TextOverflow.ellipsis : null,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: useCompact ? 13 : 12,
              height: 1.45,
            ),
          ),
        ],
        SizedBox(height: useCompact ? 6 : 8),
        Container(
          height: 3,
          width: useCompact ? 40 : 48,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
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
    final palette = context.palette;
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final fieldHeight = isPhone ? 48.0 : 40.0;
    final fontSize = isPhone ? 16.0 : 14.0;
    final iconSize = isPhone ? 20.0 : 16.0;

    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: onFieldSubmitted != null ? TextInputAction.done : TextInputAction.next,
        style: TextStyle(fontSize: fontSize, color: palette.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize, color: palette.textSecondary),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isPhone ? 14 : 12,
            vertical: isPhone ? 14 : 10,
          ),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, size: iconSize, color: palette.textSecondary),
          suffixIcon: suffixIcon,
          isDense: !isPhone,
        ),
      ),
    );
  }
}

/// Tombol submit standar halaman auth — ukuran sentuh nyaman di smartphone.
class SystemAuthSubmitButton extends StatelessWidget {
  const SystemAuthSubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final height = isPhone ? 48.0 : 40.0;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isPhone ? 8 : 4),
          ),
          textStyle: TextStyle(
            fontSize: isPhone ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: loading
            ? SizedBox(
                width: isPhone ? 22 : 18,
                height: isPhone ? 22 : 18,
                child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}
