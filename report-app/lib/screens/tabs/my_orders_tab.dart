import 'package:flutter/material.dart';

import '../../l10n/l10n_extension.dart';
import '../../models/backpacker_profile.dart';
import '../../models/order.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/gamification_banner.dart';
import '../../widgets/layout/tab_context_header.dart';
import '../../widgets/order_action_handler.dart';
import '../../widgets/order_card.dart';
import '../../widgets/rate_order_sheet.dart';
import '../../widgets/role_overview_card.dart';

class MyOrdersTab extends StatefulWidget {
  const MyOrdersTab({
    super.key,
    required this.api,
    required this.userId,
    required this.onTapOrder,
    required this.onCoinsChanged,
    this.coinProfile,
    this.coinLoading = false,
    this.coinError,
    this.onCreateTask,
    this.onTakeTasks,
  });

  final ApiService api;
  final int? userId;
  final ValueChanged<OrderItem> onTapOrder;
  final VoidCallback onCoinsChanged;
  final BackpackerProfile? coinProfile;
  final bool coinLoading;
  final String? coinError;
  final VoidCallback? onCreateTask;
  final VoidCallback? onTakeTasks;

  @override
  State<MyOrdersTab> createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<MyOrdersTab> {
  static const _scrollPhysics = AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  );

  bool _loading = true;
  List<OrderItem> _allOrders = [];
  String _scope = 'all';
  String _statusFilter = 'all';

  List<OrderItem> get _visibleOrders {
    switch (_statusFilter) {
      case 'active':
        return _allOrders
            .where((order) => const {'DRAFT', 'PUBLISHED', 'TAKEN', 'IN_PROGRESS'}.contains(order.status))
            .toList();
      case 'draft':
        return _allOrders.where((order) => order.status == 'DRAFT').toList();
      case 'completed':
        return _allOrders.where((order) => order.status == 'COMPLETED').toList();
      case 'needs_rating':
        return _allOrders.where((order) => order.canRate(widget.userId)).toList();
      default:
        return _allOrders;
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders = await widget.api.fetchMyOrders(scope: _scope);
      if (mounted) setState(() => _allOrders = orders);
    } on ApiException catch (error) {
      if (mounted) showLocalizedAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _rateOrder(OrderItem order) async {
    final updated = await showRateOrderSheet(context, api: widget.api, order: order);
    if (updated != null) {
      await _load();
      widget.onCoinsChanged();
    }
  }

  void _rateFirstPending() {
    final pending = _visibleOrders.where((order) => order.canRate(widget.userId)).toList();
    if (pending.isEmpty) return;
    _rateOrder(pending.first);
  }

  List<Widget> _headerSlivers(BuildContext context) {
    final l10n = context.l10n;
    final isPhone = MediaQuery.sizeOf(context).width <= 480;
    final needsRatingCount =
        _visibleOrders.where((order) => order.canRate(widget.userId)).length;

    return [
      SliverToBoxAdapter(
        child: TabContextHeader(
          title: l10n.myTasksHeader,
          subtitle: l10n.myTasksSubtitle,
          icon: Icons.assignment_outlined,
          color: AppColors.primary,
        ),
      ),
      SliverToBoxAdapter(
        child: GamificationBanner(
          profile: widget.coinProfile,
          style: GamificationBannerStyle.compact,
          loading: widget.coinLoading,
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
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'all', label: Text(l10n.scopeAll)),
              ButtonSegment(
                value: 'created',
                label: Text(isPhone ? l10n.tabCreate : l10n.scopeCreated),
              ),
              ButtonSegment(
                value: 'executing',
                label: Text(isPhone ? l10n.roleExecutor : l10n.scopeExecuting),
              ),
            ],
            selected: {_scope},
            onSelectionChanged: (value) {
              setState(() => _scope = value.first);
              _load();
            },
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: AppLayout.sectionGap),
          child: CategoryFilterChips(
            selected: _statusFilter,
            onSelected: (value) => setState(() => _statusFilter = value ?? 'all'),
            options: [
              (value: 'all', label: l10n.filterAllStatus),
              (value: 'active', label: l10n.filterActive),
              (value: 'draft', label: l10n.filterDraft),
              (value: 'completed', label: l10n.filterCompleted),
              (value: 'needs_rating', label: l10n.filterNeedsRating),
            ],
          ),
        ),
      ),
      if (needsRatingCount > 0)
        SliverToBoxAdapter(
          child: InlineNotice(
            message: l10n.needsRatingBanner(needsRatingCount),
            icon: Icons.rate_review_outlined,
            color: AppColors.secondary,
            actionLabel: l10n.rateNow,
            onAction: _rateFirstPending,
            secondaryActionLabel: l10n.refresh,
            onSecondaryAction: _load,
          ),
        ),
    ];
  }

  Widget _bodySliver(BuildContext context) {
    final l10n = context.l10n;
    final orders = _visibleOrders;

    if (_loading && _allOrders.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: LoadingView(message: l10n.loadingOrders),
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

    if (orders.isEmpty) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppLayout.screenPadding,
                AppLayout.sectionGap,
                AppLayout.screenPadding,
                0,
              ),
              child: RoleOverviewCard(
                onCreateTask: widget.onCreateTask,
                onTakeTasks: widget.onTakeTasks,
              ),
            ),
            EmptyState(
              icon: Icons.inbox_outlined,
              title: l10n.noOrders,
              subtitle: l10n.noOrdersSubtitle,
            ),
          ],
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppLayout.screenPadding,
        AppLayout.sectionGap,
        AppLayout.screenPadding,
        0,
      ),
      sliver: SliverList.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            animationIndex: index,
            roleLabel: order.roleLabel(l10n, widget.userId),
            userId: widget.userId,
            onTap: () => widget.onTapOrder(order),
            onRate: order.canRate(widget.userId) ? () => _rateOrder(order) : null,
            trailing: OrderActionButtons(
              order: order,
              api: widget.api,
              userId: widget.userId,
              profile: widget.coinProfile,
              myOrders: true,
              fullWidth: true,
              onChanged: () {
                _load();
                widget.onCoinsChanged();
              },
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
