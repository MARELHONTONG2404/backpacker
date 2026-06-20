import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../models/backpacker_profile.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/backpacker_rules_card.dart';
import '../widgets/gamification_banner.dart';
import '../widgets/order_action_handler.dart';
import '../widgets/order_card.dart';
import 'login_screen.dart';
import 'order_detail_screen.dart';
import 'profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = AuthStorage();
  int _tabIndex = 0;
  String? _nickName;
  int? _userId;
  BackpackerProfile? _coinProfile;
  bool _coinLoading = true;
  bool _checkinLoading = false;
  String? _coinError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final nickName = await _storage.getNickName();
    final userId = await _storage.getUserId();
    if (mounted) {
      setState(() {
        _nickName = nickName;
        _userId = userId;
        _coinLoading = true;
        _coinError = null;
      });
    }
    try {
      final coins = await widget.api.fetchCoinProfile();
      if (mounted) {
        setState(() {
          _coinProfile = coins;
          _coinLoading = false;
          _coinError = null;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _coinProfile = null;
          _coinLoading = false;
          _coinError = error.message;
        });
        showAppMessage(context, error.message);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _coinProfile = null;
          _coinLoading = false;
          _coinError = 'Gagal memuat data koin: $error';
        });
        showAppMessage(context, _coinError!);
      }
    }
  }

  Future<void> _checkin() async {
    if (_coinProfile != null && !_coinProfile!.canCheckinToday) return;
    setState(() => _checkinLoading = true);
    try {
      await widget.api.dailyCheckin();
      await _loadProfile();
      if (mounted) {
        showAppMessage(context, 'Check-in berhasil! +${_coinProfile?.dailyCheckinReward ?? 2} koin');
      }
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _checkinLoading = false);
    }
  }

  Future<void> _logout() async {
    await widget.api.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen(api: widget.api)),
    );
  }

  void _openDetail(OrderItem order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(
          api: widget.api,
          orderId: order.orderId,
          initialOrder: order,
        ),
      ),
    );
  }

  String get _tabTitle {
    switch (_tabIndex) {
      case 0:
        return AppStrings.tabAvailable;
      case 1:
        return AppStrings.tabMine;
      case 2:
        return AppStrings.tabCreate;
      default:
        return AppStrings.tabProfile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitle),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
          ),
        ],
        bottom: _nickName == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      AppStrings.welcomeHello.replaceFirst('{name}', _nickName!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
      ),
      body: Column(
        children: [
          GamificationBanner(
            profile: _coinProfile,
            loading: _coinLoading,
            checkinLoading: _checkinLoading,
            errorMessage: _coinError,
            onCheckin: _checkin,
            onRetry: _loadProfile,
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _AvailableTab(
                  api: widget.api,
                  userId: _userId,
                  coinProfile: _coinProfile,
                  onTapOrder: _openDetail,
                  onCoinsChanged: _loadProfile,
                ),
                _MyOrdersTab(
                  api: widget.api,
                  userId: _userId,
                  coinProfile: _coinProfile,
                  onTapOrder: _openDetail,
                  onCoinsChanged: _loadProfile,
                ),
                _CreateOrderTab(
                  api: widget.api,
                  coinProfile: _coinProfile,
                  onCreated: () {
                    _loadProfile();
                    setState(() => _tabIndex = 1);
                  },
                ),
                ProfileTab(
                  api: widget.api,
                  onProfileChanged: _loadProfile,
                  onLogout: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        height: 68,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: AppStrings.tabAvailable,
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: AppStrings.tabMine,
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: AppStrings.tabCreate,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}

class _AvailableTab extends StatefulWidget {
  const _AvailableTab({
    required this.api,
    required this.userId,
    required this.onTapOrder,
    required this.onCoinsChanged,
    this.coinProfile,
  });

  final ApiService api;
  final int? userId;
  final ValueChanged<OrderItem> onTapOrder;
  final VoidCallback onCoinsChanged;
  final BackpackerProfile? coinProfile;

  @override
  State<_AvailableTab> createState() => _AvailableTabState();
}

class _AvailableTabState extends State<_AvailableTab> {
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

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders = await widget.api.fetchAvailableOrders(
        title: _titleController.text.trim(),
        category: _category,
      );
      if (mounted) setState(() => _orders = orders);
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } catch (_) {
      if (mounted) showAppMessage(context, 'Gagal memuat tugas tersedia');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingView(message: 'Memuat tugas tersedia...');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Cari judul tugas...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _category,
                  hint: const Text('Kategori'),
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Semua')),
                    DropdownMenuItem(value: 'general', child: Text('Umum')),
                    DropdownMenuItem(value: 'delivery', child: Text('Antar')),
                    DropdownMenuItem(value: 'helper', child: Text('Bantuan')),
                    DropdownMenuItem(value: 'tech', child: Text('Teknisi')),
                    DropdownMenuItem(value: 'errands', child: Text('Errands')),
                  ],
                  onChanged: (value) {
                    setState(() => _category = value);
                    _load();
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.coinProfile != null && !widget.coinProfile!.canTakeTask)
          MaterialBanner(
            content: Text(widget.coinProfile!.reputationBlockedMessage),
            leading: Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
            actions: [TextButton(onPressed: _load, child: const Text('Refresh'))],
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: _orders.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      BackpackerRulesCard(profile: widget.coinProfile),
                      const SizedBox(height: 80),
                      const EmptyState(
                        icon: Icons.search_off_outlined,
                        title: 'Belum ada tugas tersedia',
                        subtitle: 'Tugas dari backpacker lain akan muncul di sini.',
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: _orders.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return BackpackerRulesCard(profile: widget.coinProfile);
                      }
                      final order = _orders[index - 1];
                      return OrderCard(
                        order: order,
                        onTap: () => widget.onTapOrder(order),
                        userId: widget.userId,
                        trailing: OrderActionButtons(
                          order: order,
                          api: widget.api,
                          userId: widget.userId,
                          profile: widget.coinProfile,
                          marketplace: true,
                          compact: true,
                          onChanged: widget.onCoinsChanged,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _MyOrdersTab extends StatefulWidget {
  const _MyOrdersTab({
    required this.api,
    required this.userId,
    required this.onTapOrder,
    required this.onCoinsChanged,
    this.coinProfile,
  });

  final ApiService api;
  final int? userId;
  final ValueChanged<OrderItem> onTapOrder;
  final VoidCallback onCoinsChanged;
  final BackpackerProfile? coinProfile;

  @override
  State<_MyOrdersTab> createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<_MyOrdersTab> {
  bool _loading = true;
  List<OrderItem> _orders = [];
  String _scope = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders = await widget.api.fetchMyOrders(scope: _scope);
      if (mounted) setState(() => _orders = orders);
    } on ApiException catch (error) {
      if (mounted) showAppMessage(context, error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final needsRatingCount =
        _orders.where((order) => order.canRate(widget.userId)).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'all', label: Text('Semua')),
              ButtonSegment(value: 'created', label: Text('Saya buat')),
              ButtonSegment(value: 'executing', label: Text('Saya kerjakan')),
            ],
            selected: {_scope},
            onSelectionChanged: (value) {
              setState(() => _scope = value.first);
              _load();
            },
          ),
        ),
        if (needsRatingCount > 0)
          MaterialBanner(
            content: Text(
              '$needsRatingCount tugas selesai perlu dinilai. '
              'Penilaian buruk menurunkan reputasi pelaksana.',
            ),
            leading: const Icon(Icons.rate_review_outlined, color: AppColors.secondary),
            actions: [TextButton(onPressed: _load, child: const Text('Refresh'))],
          ),
        Expanded(
          child: _loading
              ? const LoadingView(message: 'Memuat pesanan...')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _orders.isEmpty
                      ? const EmptyState(
                          icon: Icons.inbox_outlined,
                          title: 'Belum ada pesanan',
                          subtitle: 'Tugas yang Anda buat atau kerjakan akan muncul di sini.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _orders.length,
                          itemBuilder: (context, index) {
                            final order = _orders[index];
                            return OrderCard(
                              order: order,
                              roleLabel: order.roleLabel(widget.userId),
                              userId: widget.userId,
                              onTap: () => widget.onTapOrder(order),
                              trailing: OrderActionButtons(
                                order: order,
                                api: widget.api,
                                userId: widget.userId,
                                profile: widget.coinProfile,
                                onChanged: () {
                                  _load();
                                  widget.onCoinsChanged();
                                },
                              ),
                            );
                          },
                        ),
                ),
        ),
      ],
    );
  }
}

class _CreateOrderTab extends StatefulWidget {
  const _CreateOrderTab({
    required this.api,
    required this.onCreated,
    this.coinProfile,
  });

  final ApiService api;
  final VoidCallback onCreated;
  final BackpackerProfile? coinProfile;

  @override
  State<_CreateOrderTab> createState() => _CreateOrderTabState();
}

class _CreateOrderTabState extends State<_CreateOrderTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();
  final _locationController = TextEditingController();
  String _category = 'general';
  bool _loading = false;
  bool _publishNow = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_publishNow && widget.coinProfile != null && !widget.coinProfile!.canAffordPublish) {
      showAppMessage(context, AppStrings.publishInsufficient);
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
        publish: _publishNow,
      );
      _titleController.clear();
      _descriptionController.clear();
      _rewardController.clear();
      _locationController.clear();
      if (!mounted) return;
      showAppMessage(
        context,
        _publishNow ? 'Tugas berhasil dibuat dan dipublikasikan' : 'Draft tugas berhasil disimpan',
      );
      widget.onCreated();
    } on ApiException catch (error) {
      showAppMessage(context, error.message);
    } catch (_) {
      showAppMessage(context, 'Gagal membuat tugas');
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            BackpackerRulesCard(profile: widget.coinProfile),
            const SizedBox(height: 8),
            SectionCard(
              title: 'Informasi Tugas',
              child: Column(
                children: [
                  AppTextField(
                    controller: _titleController,
                    label: 'Judul tugas',
                    prefixIcon: Icons.title,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Deskripsi',
                    prefixIcon: Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_category),
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'general', child: Text('Umum')),
                      DropdownMenuItem(value: 'delivery', child: Text('Antar Barang')),
                      DropdownMenuItem(value: 'helper', child: Text('Bantuan')),
                      DropdownMenuItem(value: 'tech', child: Text('Teknisi')),
                      DropdownMenuItem(value: 'errands', child: Text('Belanja / Errands')),
                    ],
                    onChanged: (value) => setState(() => _category = value ?? 'general'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Detail Layanan',
              child: Column(
                children: [
                  AppTextField(
                    controller: _rewardController,
                    label: 'Imbalan (Rp)',
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || num.tryParse(value) == null ? 'Angka tidak valid' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _locationController,
                    label: 'Lokasi',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Publikasi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.coinProfile != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        AppStrings.publishFeeHint.replaceFirst('{fee}', '${widget.coinProfile!.publishFee}'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.coinProfile!.canAffordPublish
                                  ? AppColors.textRegular
                                  : Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  if (widget.coinProfile != null && !widget.coinProfile!.canAffordPublish)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.coinProfile!.publishBlockedMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Langsung publikasikan'),
                    subtitle: const Text('Nonaktifkan untuk simpan sebagai draft dulu'),
                    value: _publishNow,
                    activeThumbColor: AppColors.primary,
                    onChanged: _loading ? null : (value) => setState(() => _publishNow = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_publishNow ? 'Buat & Publish' : 'Simpan Draft'),
            ),
          ],
        ),
      ),
    );
  }
}
