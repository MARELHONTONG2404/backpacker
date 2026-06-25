import 'package:flutter/material.dart';

import '../models/order.dart';
import '../services/api_service.dart';
import '../services/auth_storage.dart';
import '../navigation/auth_navigation.dart';
import '../widgets/layout/app_shell.dart';
import 'login_screen.dart';
import 'order_detail_screen.dart';
import 'profile_tab.dart';
import 'tabs/available_tab.dart';
import 'tabs/create_order_tab.dart';
import 'tabs/my_orders_tab.dart';
import '../models/backpacker_profile.dart';
import '../l10n/l10n_extension.dart';
import '../l10n/server_message_localizer.dart';
import '../widgets/common_widgets.dart';

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
        if (error.unauthorized) {
          await redirectToLoginIfUnauthorized(context, widget.api, error);
          return;
        }
        showLocalizedAppMessage(context, error.message);
      }
    } catch (error) {
      if (mounted) {
        final message = context.l10n.loadCoinsFailed(
          localizeServerMessage(context.l10n, '$error'),
        );
        setState(() {
          _coinProfile = null;
          _coinLoading = false;
          _coinError = message;
        });
        showAppMessage(context, message);
      }
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

  void _goToTab(int index) => setState(() => _tabIndex = index);

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return AvailableTab(
          api: widget.api,
          userId: _userId,
          nickName: _nickName,
          coinProfile: _coinProfile,
          coinLoading: _coinLoading,
          coinError: _coinError,
          isActive: _tabIndex == 0,
          onTapOrder: _openDetail,
          onCoinsChanged: _loadProfile,
          onCreateTask: () => _goToTab(2),
        );
      case 1:
        return MyOrdersTab(
          api: widget.api,
          userId: _userId,
          coinProfile: _coinProfile,
          coinLoading: _coinLoading,
          coinError: _coinError,
          onTapOrder: _openDetail,
          onCoinsChanged: _loadProfile,
          onCreateTask: () => _goToTab(2),
          onTakeTasks: () => _goToTab(0),
        );
      case 2:
        return CreateOrderTab(
          api: widget.api,
          coinProfile: _coinProfile,
          coinLoading: _coinLoading,
          coinError: _coinError,
          onCreated: () {
            _loadProfile();
            _goToTab(1);
          },
        );
      default:
        return ProfileTab(
          api: widget.api,
          onProfileChanged: _loadProfile,
          onLogout: _logout,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      nickName: _nickName,
      tabIndex: _tabIndex,
      onTabSelected: _goToTab,
      body: IndexedStack(
        index: _tabIndex,
        children: [
          _buildTab(0),
          _buildTab(1),
          _buildTab(2),
          _buildTab(3),
        ],
      ),
    );
  }
}
