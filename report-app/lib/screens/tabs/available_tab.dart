import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../models/backpacker_profile.dart';
import '../../models/order.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/gamification_banner.dart';
import '../../widgets/layout/dashboard_hero.dart';
import '../../widgets/order_action_handler.dart';
import '../../widgets/order_card.dart';
import '../../widgets/role_overview_card.dart';
import '../order_detail_screen.dart';

class AvailableTab extends StatefulWidget {
  const AvailableTab({
    super.key,
    required this.api,
    required this.userId,
    required this.nickName,
    required this.onTapOrder,
    required this.onCoinsChanged,
    this.isActive = true,
    this.coinProfile,
    this.coinLoading = false,
    this.coinError,
    this.onCreateTask,
  });

  final ApiService api;
  final int? userId;
  final String? nickName;
  final ValueChanged<OrderItem> onTapOrder;
  final VoidCallback onCoinsChanged;
  final bool isActive;
  final BackpackerProfile? coinProfile;
  final bool coinLoading;
  final String? coinError;
  final VoidCallback? onCreateTask;

  @override
  State<AvailableTab> createState() => _AvailableTabState();
}

class _AvailableTabState extends State<AvailableTab> {
  static const _scrollPhysics = AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  );

  bool _loading = true;
  List<OrderItem> _orders = [];
  final _titleController = TextEditingController();
  String? _category;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AvailableTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders = await widget.api.fetchAvailableOrders(
        title: _titleController.text.trim(),
        category: _category,
      );
      if (mounted) {
        setState(() {
          _orders = orders
              .where((order) => order.status == 'PUBLISHED')
              .toList();
        });
      }
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } catch (_) {
      if (mounted) showAppMessage(context, context.l10n.loadAvailableTasksFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleOrderChanged() {
    widget.onCoinsChanged();
    _load();
  }

  Future<void> _openOrder(OrderItem order) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailScreen(
          api: widget.api,
          orderId: order.orderId,
          initialOrder: order,
        ),
      ),
    );
    if (mounted) await _load();
  }

  List<Widget> _headerSlivers(BuildContext context) {
    final l10n = context.l10n;
    return [
      SliverToBoxAdapter(
        child: DashboardHero(
          nickName: widget.nickName,
          profile: widget.coinProfile,
          loading: widget.coinLoading,
          onTakeTasks: _load,
          onCreateTask: widget.onCreateTask,
        ),
      ),
      if (widget.coinError != null)
        SliverToBoxAdapter(
          child: GamificationBanner(
            profile: widget.coinProfile,
            style: GamificationBannerStyle.compact,
            loading: false,
            errorMessage: widget.coinError,
            onRetry: widget.onCoinsChanged,
          ),
        ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayout.screenPadding,
            AppLayout.sectionGap,
            AppLayout.screenPadding,
            0,
          ),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: l10n.searchTaskHint,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
            ),
            onSubmitted: (_) => _load(),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppLayout.sectionGap)),
      SliverToBoxAdapter(
        child: CategoryFilterChips(
          selected: _category,
          onSelected: (value) {
            setState(() => _category = value);
            _load();
          },
          options: [
            (value: null, label: l10n.all),
            (value: 'general', label: l10n.categoryGeneral),
            (value: 'delivery', label: l10n.categoryDeliveryShort),
            (value: 'helper', label: l10n.categoryHelper),
            (value: 'tech', label: l10n.categoryTech),
            (value: 'errands', label: l10n.categoryErrands),
          ],
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: AppLayout.sectionGap)),
      if (widget.coinProfile != null && !widget.coinProfile!.canTakeTask)
        SliverToBoxAdapter(
          child: InlineNotice(
            message: widget.coinProfile!.reputationBlockedMessage(l10n),
            icon: Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.error,
            actionLabel: l10n.refresh,
            onAction: _load,
          ),
        ),
    ];
  }

  Widget _bodySliver(BuildContext context) {
    final l10n = context.l10n;

    if (_loading && _orders.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: LoadingView(message: l10n.loadingAvailableTasks),
        ),
      );
    }

    if (_loading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppLayout.sectionGap),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_orders.isEmpty) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppLayout.screenPadding,
                0,
                AppLayout.screenPadding,
                0,
              ),
              child: RoleOverviewCard(
                onTakeTasks: _load,
                onCreateTask: widget.onCreateTask,
              ),
            ),
            EmptyState(
              icon: Icons.search_off_outlined,
              title: l10n.noAvailableTasks,
              subtitle: l10n.noAvailableTasksSubtitle,
            ),
          ],
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppLayout.screenPadding,
        0,
        AppLayout.screenPadding,
        0,
      ),
      sliver: SliverList.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return OrderCard(
            order: order,
            animationIndex: index,
            onTap: () => _openOrder(order),
            userId: widget.userId,
            trailing: OrderActionButtons(
              order: order,
              api: widget.api,
              userId: widget.userId,
              profile: widget.coinProfile,
              marketplace: true,
              fullWidth: true,
              onChanged: () => _handleOrderChanged(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      edgeOffset: 8,
      child: CustomScrollView(
        physics: _scrollPhysics,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          ..._headerSlivers(context),
          _bodySliver(context),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppLayout.listBottomInset),
          ),
        ],
      ),
    );
  }
}
