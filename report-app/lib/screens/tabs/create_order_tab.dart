import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../models/backpacker_profile.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/gamification_banner.dart';
import '../../widgets/layout/tab_context_header.dart';

class CreateOrderTab extends StatefulWidget {
  const CreateOrderTab({
    super.key,
    required this.api,
    required this.onCreated,
    this.coinProfile,
    this.coinLoading = false,
    this.coinError,
  });

  final ApiService api;
  final VoidCallback onCreated;
  final BackpackerProfile? coinProfile;
  final bool coinLoading;
  final String? coinError;

  @override
  State<CreateOrderTab> createState() => _CreateOrderTabState();
}

class _CreateOrderTabState extends State<CreateOrderTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();
  final _locationController = TextEditingController();
  String _category = 'general';
  bool _loading = false;

  Future<void> _submit({required bool publish}) async {
    if (!_formKey.currentState!.validate()) return;
    if (publish && widget.coinProfile != null && !widget.coinProfile!.canAffordPublish) {
      showAppMessage(context, context.l10n.publishInsufficient);
      return;
    }
    setState(() => _loading = true);
    try {
      await widget.api.createOrder(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        rewardAmount: num.parse(_rewardController.text.trim()),
        category: _category,
        locationText: _locationController.text.trim(),
        publish: publish,
      );
      _titleController.clear();
      _descriptionController.clear();
      _rewardController.clear();
      _locationController.clear();
      if (!mounted) return;
      showAppMessage(
        context,
        publish ? context.l10n.taskCreatedPublished : context.l10n.taskDraftSaved,
      );
      widget.onCreated();
    } on ApiException catch (error) {
      showLocalizedAppMessage(context, error.message);
    } catch (_) {
      showAppMessage(context, context.l10n.createTaskFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final navClearance = AppLayout.bottomNavHeight + bottomSafe + 12;
    final buttonHeight = isPhone ? 48.0 : 50.0;
    final canPublish = widget.coinProfile?.canAffordPublish ?? true;

    Widget actionButton({
      required VoidCallback? onPressed,
      required String label,
      required IconData icon,
      required bool primary,
    }) {
      final child = _loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primary ? Colors.white : AppColors.primary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: isPhone ? 20 : 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isPhone ? 15 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );

      if (primary) {
        return SizedBox(
          height: buttonHeight,
          width: double.infinity,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: isPhone ? 12 : 16),
            ),
            child: child,
          ),
        );
      }

      return SizedBox(
        height: buttonHeight,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: isPhone ? 12 : 16),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
          child: child,
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        AppLayout.screenPadding,
        AppLayout.sectionGap,
        AppLayout.screenPadding,
        navClearance,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabContextHeader(
              title: l10n.createTabHeader,
              subtitle: l10n.createTabSubtitle,
              icon: Icons.edit_note_outlined,
              color: AppColors.primary,
              embedded: true,
            ),
            const SizedBox(height: AppLayout.sectionGap),
            GamificationBanner(
              profile: widget.coinProfile,
              style: GamificationBannerStyle.publish,
              loading: widget.coinLoading,
              errorMessage: widget.coinError,
            ),
            const SizedBox(height: AppLayout.sectionGap),
            SectionCard(
              title: l10n.taskInfo,
              child: Column(
                children: [
                  AppTextField(
                    controller: _titleController,
                    label: l10n.taskTitle,
                    prefixIcon: Icons.title,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _descriptionController,
                    label: l10n.description,
                    prefixIcon: Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_category),
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: l10n.category,
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: [
                      DropdownMenuItem(value: 'general', child: Text(l10n.categoryGeneral)),
                      DropdownMenuItem(value: 'delivery', child: Text(l10n.categoryDelivery)),
                      DropdownMenuItem(value: 'helper', child: Text(l10n.categoryHelper)),
                      DropdownMenuItem(value: 'tech', child: Text(l10n.categoryTech)),
                      DropdownMenuItem(value: 'errands', child: Text(l10n.categoryErrands)),
                    ],
                    onChanged: (value) => setState(() => _category = value ?? 'general'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppLayout.sectionGap),
            SectionCard(
              title: l10n.serviceDetails,
              child: Column(
                children: [
                  AppTextField(
                    controller: _rewardController,
                    label: l10n.rewardLabel,
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || num.tryParse(value) == null ? l10n.invalidNumber : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _locationController,
                    label: l10n.location,
                    prefixIcon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppLayout.sectionGap),
            if (widget.coinProfile != null && !canPublish)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.coinProfile!.publishBlockedMessage(l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: isPhone ? 13 : 12,
                    height: 1.35,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: actionButton(
                    onPressed: _loading ? null : () => _submit(publish: false),
                    label: l10n.tabCreate,
                    icon: Icons.edit_note_outlined,
                    primary: false,
                  ),
                ),
                SizedBox(width: isPhone ? 10 : 12),
                Expanded(
                  child: actionButton(
                    onPressed: _loading || !canPublish ? null : () => _submit(publish: true),
                    label: l10n.actionPublish,
                    icon: Icons.public_rounded,
                    primary: true,
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
