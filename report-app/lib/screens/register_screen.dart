import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/system_auth_shell.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _captchaEnabled = false;
  bool _captchaLoading = true;
  String? _captchaUuid;
  Uint8List? _captchaBytes;
  final _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCaptcha();
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
      if (mounted) setState(() => _captchaEnabled = true);
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
    if (_captchaEnabled && (_captchaUuid == null || _captchaUuid!.isEmpty)) {
      showAppMessage(context, 'Kode verifikasi belum siap.');
      await _loadCaptcha();
      return;
    }
    setState(() => _loading = true);
    final username = _usernameController.text.trim();
    try {
      await widget.api.register(
        username: username,
        password: _passwordController.text,
        nickName: _nickNameController.text.trim(),
        phonenumber: _phoneController.text.trim(),
        code: _captchaEnabled ? _captchaController.text.trim() : null,
        uuid: _captchaEnabled ? _captchaUuid : null,
      );
      if (!mounted) return;
      showAppMessage(context, AppStrings.registerSuccess);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(api: widget.api, initialUsername: username),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
      if (_captchaEnabled && mounted) await _loadCaptcha();
    } catch (_) {
      if (mounted) showAppMessage(context, 'Gagal terhubung ke server.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nickNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemAuthShell(
      header: const SystemAuthHeader(
        title: AppStrings.registerTitle,
        tagline: AppStrings.registerTagline,
        description: AppStrings.registerDescription,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SystemAuthField(
              controller: _usernameController,
              hint: AppStrings.username,
              prefixIcon: Icons.alternate_email,
              validator: (value) =>
                  value == null || value.trim().length < 2 ? 'Minimal 2 karakter' : null,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _nickNameController,
              hint: 'Nama tampilan',
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _phoneController,
              hint: 'Nomor telepon (opsional)',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty) return null;
                if (phone.length > 20) return 'Maksimal 20 karakter';
                return null;
              },
            ),
            const SizedBox(height: 18),
            if (_captchaEnabled) ...[
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
                    child: InkWell(
                      onTap: _captchaLoading ? null : _loadCaptcha,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: _captchaLoading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : _captchaBytes == null
                                ? const Icon(Icons.refresh, size: 18, color: AppColors.textSecondary)
                                : Image.memory(_captchaBytes!, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
            SystemAuthField(
              controller: _passwordController,
              hint: AppStrings.password,
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
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
                  value == null || value.length < 5 ? 'Minimal 5 karakter' : null,
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(AppStrings.registerSubmit),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Sudah punya akun? Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
