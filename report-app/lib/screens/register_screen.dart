import 'package:flutter/material.dart';

import '../l10n/l10n_extension.dart';
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

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final username = _usernameController.text.trim();
    try {
      await widget.api.register(
        username: username,
        password: _passwordController.text,
        nickName: _nickNameController.text.trim(),
        phonenumber: _phoneController.text.trim(),
      );
      if (!mounted) return;
      showAppMessage(context, l10n.registerSuccess);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(api: widget.api, initialUsername: username),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } catch (_) {
      if (mounted) showAppMessage(context, l10n.serverConnectFailed);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SystemAuthShell(
      header: SystemAuthHeader(
        title: l10n.registerTitle,
        tagline: l10n.registerTagline,
        description: l10n.registerDescription,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SystemAuthField(
              controller: _usernameController,
              hint: l10n.username,
              prefixIcon: Icons.alternate_email,
              validator: (value) =>
                  value == null || value.trim().length < 2 ? l10n.minChars2 : null,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _nickNameController,
              hint: l10n.displayName,
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _phoneController,
              hint: l10n.phoneOptional,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty) return null;
                if (phone.length > 20) return l10n.maxChars20;
                return null;
              },
            ),
            const SizedBox(height: 18),
            SystemAuthField(
              controller: _passwordController,
              hint: l10n.password,
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
                  value == null || value.length < 5 ? l10n.minChars5 : null,
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
                    : Text(l10n.registerSubmit),
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
                child: Text(l10n.alreadyHaveAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
