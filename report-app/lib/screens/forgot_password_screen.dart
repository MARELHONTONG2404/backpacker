import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/system_auth_shell.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.api.resetPassword(
        username: _usernameController.text.trim(),
        phonenumber: _phoneController.text.trim(),
        newPassword: _passwordController.text,
      );
      if (!mounted) return;
      showAppMessage(context, 'Password berhasil diatur ulang. Silakan masuk.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(api: widget.api, initialUsername: _usernameController.text.trim()),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } catch (_) {
      if (mounted) showAppMessage(context, 'Gagal terhubung ke server.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemAuthShell(
      header: const SystemAuthHeader(
        title: 'Lupa Password',
        tagline: 'Backpacker',
        description: 'Verifikasi dengan username dan nomor telepon yang terdaftar.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SystemAuthField(
              controller: _usernameController,
              hint: AppStrings.username,
              prefixIcon: Icons.person_outline,
              validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _phoneController,
              hint: 'Nomor telepon terdaftar',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _passwordController,
              hint: 'Password baru',
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
              validator: (value) => value == null || value.length < 5 ? 'Minimal 5 karakter' : null,
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
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Atur Ulang Password'),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _loading ? null : () => Navigator.of(context).pop(),
                child: const Text('Kembali ke login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
