import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/app_notification.dart';
import '../models/backpacker_profile.dart';
import '../models/captcha.dart';
import '../models/coin_transaction.dart';
import '../models/chat_message.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import 'auth_storage.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.unauthorized = false});
  final String message;
  final bool unauthorized;

  @override
  String toString() => message;
}

class ApiService {
  ApiService(this._storage);

  static const _requestTimeout = Duration(seconds: 20);

  final AuthStorage _storage;

  Future<http.Response> _timed(Future<http.Response> request) async {
    try {
      return await request.timeout(_requestTimeout);
    } on TimeoutException {
      throw ApiException('Server tidak merespons. Periksa koneksi dan coba lagi.');
    }
  }

  Future<http.Response> _get(Uri uri, {Map<String, String>? headers}) =>
      _timed(http.get(uri, headers: headers));

  Future<http.Response> _post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _timed(http.post(uri, headers: headers, body: body));

  Future<http.Response> _put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) =>
      _timed(http.put(uri, headers: headers, body: body));

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Sesi login habis, silakan masuk kembali', unauthorized: true);
      }
      headers['access_token'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw ApiException('Respons server tidak valid');
    }
    return data;
  }

  List<Map<String, dynamic>> _readRows(Map<String, dynamic> data) {
    final rows = data['rows'];
    if (rows is List) {
      return rows
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> _readDataMap(Map<String, dynamic> data, {String label = 'Data'}) {
    final raw = data['data'];
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    throw ApiException('$label respons tidak valid');
  }

  int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool _readBool(dynamic value, {bool defaultValue = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return defaultValue;
  }

  bool _isUnauthorized(Map<String, dynamic> data) {
    final code = data['code'] as int? ?? 500;
    if (code == 401) return true;
    final msg = data['msg'] as String? ?? '';
    return msg.contains('认证失败') || msg.contains('autentikasi gagal');
  }

  Future<void> _ensureSuccess(Map<String, dynamic> data) async {
    if (_isUnauthorized(data)) {
      await _storage.clear();
      throw ApiException('Sesi login habis, silakan masuk kembali', unauthorized: true);
    }
    final code = data['code'] as int? ?? 500;
    if (code != 200) {
      throw ApiException(data['msg'] as String? ?? 'Permintaan gagal');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    String? nickName,
    String? phonenumber,
  }) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/register'),
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickName': nickName ?? username,
        'phonenumber': phonenumber ?? '',
      }),
    );
    await _ensureSuccess(_decodeBody(response));
  }

  Future<void> resetPassword({
    required String username,
    required String phonenumber,
    required String newPassword,
  }) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/reset-password'),
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'phonenumber': phonenumber,
        'newPassword': newPassword,
      }),
    );
    await _ensureSuccess(_decodeBody(response));
  }

  Future<UserProfile> fetchUserProfile() async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/me'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return UserProfile.fromJson(data);
  }

  Future<UserProfile> updateProfile({
    required String nickName,
    String? phonenumber,
  }) async {
    final response = await _put(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/profile'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        'nickName': nickName,
        'phonenumber': phonenumber ?? '',
      }),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return UserProfile(
      userId: _readInt(data['userId']) ?? 0,
      username: data['username'] as String? ?? '',
      nickName: data['nickName'] as String? ?? nickName,
      phonenumber: data['phonenumber'] as String?,
    );
  }

  Future<CaptchaInfo> fetchCaptcha() async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/captchaImage'),
      headers: await _headers(),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final enabled = _readBool(data['captchaEnabled'], defaultValue: true);
    return CaptchaInfo(
      enabled: enabled,
      uuid: data['uuid'] as String?,
      base64Image: data['img'] as String?,
    );
  }

  Future<void> login({
    required String username,
    required String password,
    String? code,
    String? uuid,
  }) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/login'),
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'code': code ?? '',
        'uuid': uuid ?? '',
      }),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw ApiException('Token login tidak ditemukan');
    }
    final userId = _readInt(data['userId']);
    if (userId == null) {
      throw ApiException('Data user tidak ditemukan');
    }
    await _storage.saveSession(
      token: token,
      userId: userId,
      username: data['username'] as String? ?? username,
      nickName: data['nickName'] as String? ?? username,
    );
  }

  Future<void> logout() => _storage.clear();

  Future<BackpackerProfile> fetchCoinProfile() async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/coins/profile'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return BackpackerProfile.fromJson(data);
  }

  Future<BackpackerProfile> dailyCheckin() async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/coins/checkin'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return fetchCoinProfile();
  }

  Future<List<CoinTransaction>> fetchCoinTransactions({int limit = 20}) async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/coins/transactions?limit=$limit'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final rows = data['data'];
    if (rows is List) {
      return rows
          .whereType<Map>()
          .map((row) => CoinTransaction.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    }
    return [];
  }

  Future<List<OrderItem>> fetchAvailableOrders({String? title, String? category}) async {
    final params = <String, String>{
      'pageNum': '1',
      'pageSize': '50',
    };
    if (title != null && title.isNotEmpty) params['title'] = title;
    if (category != null && category.isNotEmpty) params['category'] = category;
    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/available?$query'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final rows = _readRows(data);
    return rows.map(OrderItem.fromJson).toList();
  }

  Future<List<OrderItem>> fetchMyOrders({String scope = 'all'}) async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/mine?scope=$scope&pageNum=1&pageSize=50'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final rows = _readRows(data);
    return rows.map(OrderItem.fromJson).toList();
  }

  Future<OrderItem> createOrder({
    required String title,
    required num rewardAmount,
    String? description,
    String? category,
    String? locationText,
    bool publish = true,
  }) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        'title': title,
        'description': description ?? '',
        'category': category ?? 'general',
        'rewardAmount': rewardAmount,
        'locationText': locationText ?? '',
      }),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final created = OrderItem.fromJson(_readDataMap(data, label: 'Pesanan'));
    if (publish) {
      return takeOrderAction(created.orderId, 'publish');
    }
    return created;
  }

  Future<OrderItem> fetchOrderDetail(int orderId) async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return OrderItem.fromJson(_readDataMap(data, label: 'Pesanan'));
  }

  Future<OrderItem> takeOrderAction(int orderId, String action, {String? cancelReason}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/$action');
    final response = await _post(
      uri,
      headers: await _headers(auth: true),
      body: (action == 'cancel' || action == 'abandon')
          ? jsonEncode({'cancelReason': cancelReason ?? ''})
          : null,
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return OrderItem.fromJson(_readDataMap(data, label: 'Pesanan'));
  }

  Future<OrderItem> rateOrder(int orderId, {required int score, String? comment}) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/rate'),
      headers: await _headers(auth: true),
      body: jsonEncode({'score': score, 'comment': comment ?? ''}),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return OrderItem.fromJson(_readDataMap(data, label: 'Pesanan'));
  }

  Future<List<AppNotification>> fetchNotifications({int limit = 20}) async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/notifications?limit=$limit'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final rows = data['data'];
    if (rows is List) {
      return rows
          .whereType<Map>()
          .map((row) => AppNotification.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    }
    return [];
  }

  Future<int> fetchUnreadNotificationCount() async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/notifications/unread-count'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return _readInt(data['unreadCount']) ?? 0;
  }

  Future<void> markNotificationRead(int notificationId) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/notifications/$notificationId/read'),
      headers: await _headers(auth: true),
    );
    await _ensureSuccess(_decodeBody(response));
  }

  Future<void> markAllNotificationsRead() async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/notifications/read-all'),
      headers: await _headers(auth: true),
    );
    await _ensureSuccess(_decodeBody(response));
  }

  Future<List<ChatMessage>> fetchOrderChatMessages(
    int orderId, {
    int? sinceId,
    int limit = 50,
  }) async {
    final params = <String, String>{'limit': '$limit'};
    if (sinceId != null) params['sinceId'] = '$sinceId';
    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/messages?$query'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    final rows = data['data'];
    if (rows is List) {
      return rows
          .whereType<Map>()
          .map((row) => ChatMessage.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    }
    return [];
  }

  Future<ChatMessage> sendOrderChatMessage(
    int orderId, {
    String? content,
    String? imageUrl,
  }) async {
    final payload = <String, String>{};
    if (content != null && content.isNotEmpty) payload['content'] = content;
    if (imageUrl != null && imageUrl.isNotEmpty) payload['imageUrl'] = imageUrl;
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/messages'),
      headers: await _headers(auth: true),
      body: jsonEncode(payload),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return ChatMessage.fromJson(_readDataMap(data, label: 'Pesan'));
  }

  Future<int> fetchOrderChatUnreadCount(int orderId) async {
    final response = await _get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/messages/unread-count'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    await _ensureSuccess(data);
    return _readInt(data['unreadCount']) ?? 0;
  }

  Future<void> markOrderChatRead(int orderId, int lastMessageId) async {
    final response = await _post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/messages/read'),
      headers: await _headers(auth: true),
      body: jsonEncode({'lastMessageId': lastMessageId}),
    );
    await _ensureSuccess(_decodeBody(response));
  }

  Future<String> uploadChatImage(List<int> bytes, String filename) async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Sesi login habis, silakan masuk kembali', unauthorized: true);
    }
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/common/upload'),
    );
    request.headers['access_token'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    try {
      final streamed = await request.send().timeout(_requestTimeout);
      final response = await http.Response.fromStream(streamed);
      final data = _decodeBody(response);
      await _ensureSuccess(data);
      final url = data['url'];
      if (url is String && url.isNotEmpty) return url;
      throw ApiException('Upload gambar gagal');
    } on TimeoutException {
      throw ApiException('Server tidak merespons. Periksa koneksi dan coba lagi.');
    }
  }
}
