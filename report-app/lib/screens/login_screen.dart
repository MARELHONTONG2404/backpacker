import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/system_auth_shell.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
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
        _passwordController.text = saved.password;
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
        showAppMessage(context, AppStrings.captchaLoadFailed);
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
    if (!_formKey.currentState!.validate()) return;
    if (_captchaEnabled && (_captchaUuid == null || _captchaUuid!.isEmpty || _captchaBytes == null)) {
      showAppMessage(context, 'Kode verifikasi belum siap. Ketuk gambar untuk memuat ulang.');
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
        password: password,
      );
      await widget.api.login(
        username: username,
        password: password,
        code: _captchaEnabled ? _captchaController.text.trim() : null,
        uuid: _captchaEnabled ? _captchaUuid : null,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(api: widget.api)),
      );
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
      if (_captchaEnabled && mounted) await _loadCaptcha();
    } catch (_) {
      if (mounted) {
        showAppMessage(context, 'Gagal terhubung ke server. Pastikan backend berjalan.');
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
    return SystemAuthShell(
      header: const SystemAuthHeader(
        title: AppStrings.loginTitle,
        tagline: AppStrings.loginTagline,
        description: AppStrings.loginDescription,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_captchaEnabled)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  AppStrings.captchaHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.95),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            SystemAuthField(
              controller: _usernameController,
              hint: AppStrings.username,
              prefixIcon: Icons.person_outline,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? AppStrings.usernameRequired : null,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _passwordController,
              hint: AppStrings.password,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              onFieldSubmitted: (_) => _submit(),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? AppStrings.passwordRequired : null,
            ),
            if (_captchaEnabled) ...[
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 63,
                    child: SystemAuthField(
                      controller: _captchaController,
                      hint: AppStrings.captcha,
                      prefixIcon: Icons.verified_outlined,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? AppStrings.captchaRequired : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 37,
                    child: _CaptchaImage(
                      loading: _captchaLoading,
                      bytes: _captchaBytes,
                      onTap: _captchaLoading ? null : _loadCaptcha,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: _loading ? null : (v) => setState(() => _rememberMe = v ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _loading ? null : () => setState(() => _rememberMe = !_rememberMe),
                  child: const Text(AppStrings.remember, style: TextStyle(color: AppColors.textRegular, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_loading ? AppStrings.submitting : AppStrings.submit),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  child: const Text('Lupa password?'),
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
                  child: const Text(AppStrings.registerLink),
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
  const _CaptchaImage({required this.loading, required this.bytes, required this.onTap});

  final bool loading;
  final Uint8List? bytes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : bytes == null
                ? const Icon(Icons.refresh, size: 18, color: AppColors.textSecondary)
                : Image.memory(bytes!, fit: BoxFit.contain),
      ),
    );
  }
}
