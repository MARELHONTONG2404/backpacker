import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../navigation/post_auth_navigation.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/app_animations.dart';
import '../widgets/auth_background.dart';
import '../widgets/backpacker_brand.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _progress;
  late final AnimationController _reveal;
  late final Animation<double> _fadeUp;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeUp = CurvedAnimation(parent: _reveal, curve: Curves.easeOutCubic);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final storage = AuthStorage();
    final api = ApiService(storage);
    final token = await storage.getToken();
    await Future<void>.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    if (token == null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (_, animation, __) => LoginScreen(api: api),
          transitionsBuilder: (_, animation, secondary, child) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
        ),
      );
      return;
    }
    await PostAuthNavigation.open(context, api, fromLogin: false);
  }

  @override
  void dispose() {
    _progress.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBackground(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.adventureDark.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          const Positioned.fill(
            child: FloatingTrailDecoration(opacity: 0.18),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _fadeUp,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(_fadeUp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BackpackerBrandTitle(
                            light: true,
                            showLogo: true,
                            showSubtitle: true,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.appConcept,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  EntranceFadeSlide(
                    index: 1,
                    child: Column(
                      children: [
                        const JourneyTrailBar(height: 3, width: double.infinity, light: true),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _progress,
                          builder: (context, _) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: _progress.value,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.18),
                                color: AppColors.sand,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.appSubtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const BrandedLoadingIndicator(size: 24, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
