import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../widgets/order_action_handler.dart';
import 'login_screen.dart';
import 'order_detail_screen.dart';

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
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backpacker${_nickName == null ? '' : ' · $_nickName'}'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout), tooltip: 'Keluar'),
        ],
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          _AvailableTab(api: widget.api, userId: _userId, onTapOrder: _openDetail),
          _MyOrdersTab(api: widget.api, userId: _userId, onTapOrder: _openDetail),
          _CreateOrderTab(api: widget.api, onCreated: () => setState(() => _tabIndex = 1)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Tersedia'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Pesanan Saya'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Buat Tugas'),
        ],
      ),
    );
  }
}

class _AvailableTab extends StatefulWidget {
  const _AvailableTab({required this.api, required this.userId, required this.onTapOrder});

  final ApiService api;
  final int? userId;
  final ValueChanged<OrderItem> onTapOrder;

  @override
  State<_AvailableTab> createState() => _AvailableTabState();
}

class _AvailableTabState extends State<_AvailableTab> {
  bool _loading = true;
  List<OrderItem> _orders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders = await widget.api.fetchAvailableOrders();
      if (mounted) setState(() => _orders = orders);
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Gagal memuat tugas tersedia');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: _orders.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Belum ada tugas tersedia')),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return _OrderCard(
                  order: order,
                  onTap: () => widget.onTapOrder(order),
                  trailing: OrderActionButtons(
                    order: order,
                    api: widget.api,
                    userId: widget.userId,
                    marketplace: true,
                    compact: true,
                    onChanged: _load,
                  ),
                );
              },
            ),
    );
  }
}

class _MyOrdersTab extends StatefulWidget {
  const _MyOrdersTab({required this.api, required this.userId, required this.onTapOrder});

  final ApiService api;
  final int? userId;
  final ValueChanged<OrderItem> onTapOrder;

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
      _showError(error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _orders.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('Belum ada pesanan')),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _orders.length,
                          itemBuilder: (context, index) {
                            final order = _orders[index];
                            return _OrderCard(
                              order: order,
                              roleLabel: order.roleLabel(widget.userId),
                              onTap: () => widget.onTapOrder(order),
                              trailing: OrderActionButtons(
                                order: order,
                                api: widget.api,
                                userId: widget.userId,
                                onChanged: _load,
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
  const _CreateOrderTab({required this.api, required this.onCreated});

  final ApiService api;
  final VoidCallback onCreated;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_publishNow ? 'Tugas berhasil dibuat dan dipublikasikan' : 'Draft tugas berhasil disimpan'),
        ),
      );
      widget.onCreated();
    } on ApiException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Gagal membuat tugas');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul tugas', border: OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(_category),
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('Umum')),
                DropdownMenuItem(value: 'delivery', child: Text('Antar Barang')),
                DropdownMenuItem(value: 'helper', child: Text('Bantuan')),
                DropdownMenuItem(value: 'tech', child: Text('Teknisi')),
                DropdownMenuItem(value: 'errands', child: Text('Belanja / Errands')),
              ],
              onChanged: (value) => setState(() => _category = value ?? 'general'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _rewardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Imbalan (Rp)', border: OutlineInputBorder()),
              validator: (value) => value == null || num.tryParse(value) == null ? 'Angka tidak valid' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Langsung publikasikan'),
              subtitle: const Text('Nonaktifkan untuk simpan sebagai draft dulu'),
              value: _publishNow,
              onChanged: _loading ? null : (value) => setState(() => _publishNow = value),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_publishNow ? 'Buat & Publish' : 'Simpan Draft'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
    this.trailing,
    this.roleLabel,
  });

  final OrderItem order;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? roleLabel;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(order.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(order.title, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Chip(
                    label: Text(order.statusLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: color,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${order.categoryLabel} · Rp ${order.rewardAmount}'),
              if (order.locationText != null && order.locationText!.isNotEmpty)
                Text(order.locationText!, style: Theme.of(context).textTheme.bodySmall),
              if (order.description != null && order.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(order.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              if (order.creatorName != null)
                Text('Pembuat: ${order.creatorName}', style: Theme.of(context).textTheme.bodySmall),
              if (order.executorName != null)
                Text('Pelaksana: ${order.executorName}', style: Theme.of(context).textTheme.bodySmall),
              if (roleLabel != null && roleLabel!.isNotEmpty)
                Text(roleLabel!, style: Theme.of(context).textTheme.labelMedium),
              if (trailing != null) ...[
                const SizedBox(height: 12),
                trailing!,
              ],
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text('Ketuk untuk detail', style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
