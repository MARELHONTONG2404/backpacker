import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../navigation/post_auth_navigation.dart';
import '../widgets/common_widgets.dart';
import '../widgets/login_task_worker_animation.dart';
import '../widgets/system_auth_shell.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.api, this.initialUsername});

  final ApiService api;
  final String? initialUsername;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = AuthStorage();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _captchaEnabled = false;
  bool _captchaLoading = true;
  String? _captchaUuid;
  Uint8List? _captchaBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null) {
      _usernameController.text = widget.initialUsername!;
    } else {
      _loadRememberMe();
    }
    _loadCaptcha();
  }

  Future<void> _loadRememberMe() async {
    final saved = await _storage.loadRememberMe();
    if (!mounted || widget.initialUsername != null) return;
    setState(() {
      _rememberMe = saved.rememberMe;
      if (saved.rememberMe) {
        _usernameController.text = saved.username;
      }
    });
  }

  Future<void> _loadCaptcha() async {
    setState(() => _captchaLoading = true);
    try {
      final captcha = await widget.api.fetchCaptcha();
      if (!mounted) return;
      setState(() {
        _captchaEnabled = captcha.enabled;
        _captchaUuid = captcha.uuid;
        _captchaBytes = _decodeCaptchaImage(captcha.base64Image);
        _captchaController.clear();
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _captchaEnabled = true;
          _captchaUuid = null;
          _captchaBytes = null;
        });
        showAppMessage(context, context.l10n.captchaLoadFailed);
      }
    } finally {
      if (mounted) setState(() => _captchaLoading = false);
    }
  }

  Uint8List? _decodeCaptchaImage(String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) return null;
    try {
      return base64Decode(base64Image);
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    if (_captchaEnabled && (_captchaUuid == null || _captchaUuid!.isEmpty || _captchaBytes == null)) {
      showAppMessage(context, l10n.captchaNotReady);
      await _loadCaptcha();
      return;
    }
    setState(() => _loading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    try {
      await _storage.saveRememberMe(
        rememberMe: _rememberMe,
        username: username,
      );
      await widget.api.login(
        username: username,
        password: password,
        code: _captchaEnabled ? _captchaController.text.trim() : null,
        uuid: _captchaEnabled ? _captchaUuid : null,
      );
      if (!mounted) return;
      await PostAuthNavigation.open(context, widget.api, fromLogin: true);
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
      if (_captchaEnabled && mounted) await _loadCaptcha();
    } catch (_) {
      if (mounted) {
        showAppMessage(context, l10n.serverConnectFailed);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final fieldGap = isPhone ? 14.0 : 18.0;
    final animationHeight = isPhone ? 96.0 : 156.0;

    return SystemAuthShell(
      header: Column(
        children: [
          SystemAuthHeader(
            title: l10n.loginTitle,
            tagline: l10n.loginTagline,
            description: l10n.loginDescription,
          ),
          if (!isPhone || MediaQuery.sizeOf(context).height >= 640) ...[
            SizedBox(height: isPhone ? 8 : 12),
            LoginTaskWorkerAnimation(
              embedded: true,
              height: animationHeight,
            ),
          ],
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_captchaEnabled)
              Padding(
                padding: EdgeInsets.only(bottom: isPhone ? 10 : 14),
                child: Text(
                  l10n.captchaHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.95),
                    fontSize: isPhone ? 12 : 11,
                    height: 1.4,
                  ),
                ),
              ),
            SystemAuthField(
              controller: _usernameController,
              hint: l10n.username,
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.text,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? l10n.usernameRequired : null,
            ),
            SizedBox(height: fieldGap),
            SystemAuthField(
              controller: _passwordController,
              hint: l10n.password,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              onFieldSubmitted: (_) => _submit(),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: isPhone ? 44 : 36,
                  minHeight: isPhone ? 44 : 36,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: isPhone ? 22 : 18,
                  color: AppColors.textSecondary,
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? l10n.passwordRequired : null,
            ),
            if (_captchaEnabled) ...[
              SizedBox(height: fieldGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isPhone ? 58 : 63,
                    child: SystemAuthField(
                      controller: _captchaController,
                      hint: l10n.captcha,
                      prefixIcon: Icons.verified_outlined,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? l10n.captchaRequired : null,
                    ),
                  ),
                  SizedBox(width: isPhone ? 10 : 12),
                  Expanded(
                    flex: isPhone ? 42 : 37,
                    child: _CaptchaImage(
                      loading: _captchaLoading,
                      bytes: _captchaBytes,
                      height: isPhone ? 48 : 40,
                      onTap: _captchaLoading ? null : _loadCaptcha,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: fieldGap),
            InkWell(
              onTap: _loading ? null : () => setState(() => _rememberMe = !_rememberMe),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isPhone ? 6 : 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: isPhone ? 28 : 24,
                      height: isPhone ? 28 : 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: _loading ? null : (v) => setState(() => _rememberMe = v ?? false),
                      ),
                    ),
                    SizedBox(width: isPhone ? 10 : 8),
                    Text(
                      l10n.remember,
                      style: TextStyle(
                        color: AppColors.textRegular,
                        fontSize: isPhone ? 15 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isPhone ? 20 : 25),
            SystemAuthSubmitButton(
              onPressed: _submit,
              label: _loading ? l10n.submitting : l10n.submit,
              loading: _loading,
            ),
            SizedBox(height: isPhone ? 16 : 12),
            if (isPhone)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ForgotPasswordScreen(api: widget.api)),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: Text(l10n.forgotPasswordLink),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RegisterScreen(api: widget.api)),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    child: Text(l10n.registerLink),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ForgotPasswordScreen(api: widget.api)),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(l10n.forgotPasswordLink),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RegisterScreen(api: widget.api)),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.registerLink,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CaptchaImage extends StatelessWidget {
  const _CaptchaImage({
    required this.loading,
    required this.bytes,
    required this.onTap,
    this.height = 40,
  });

  final bool loading;
  final Uint8List? bytes;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: height * 0.45,
                height: height * 0.45,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : bytes == null
                ? Icon(Icons.refresh, size: height * 0.45, color: AppColors.textSecondary)
                : Image.memory(bytes!, fit: BoxFit.contain),
      ),
    );
  }
}
