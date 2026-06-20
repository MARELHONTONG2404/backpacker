import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/backpacker_profile.dart';
import '../models/captcha.dart';
import '../models/order.dart';
import 'auth_storage.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService(this._storage);

  final AuthStorage _storage;

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Sesi login habis, silakan masuk kembali');
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

  void _ensureSuccess(Map<String, dynamic> data) {
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
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/auth/register'),
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickName': nickName ?? username,
        'phonenumber': phonenumber ?? '',
      }),
    );
    _ensureSuccess(_decodeBody(response));
  }

  Future<CaptchaInfo> fetchCaptcha() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/captchaImage'),
      headers: await _headers(),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    final enabled = data['captchaEnabled'] as bool? ?? true;
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
    final response = await http.post(
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
    _ensureSuccess(data);
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw ApiException('Token login tidak ditemukan');
    }
    final userId = data['userId'] as int?;
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
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/coins/profile'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    return BackpackerProfile.fromJson(data);
  }

  Future<BackpackerProfile> dailyCheckin() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/coins/checkin'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    return fetchCoinProfile();
  }

  Future<List<OrderItem>> fetchAvailableOrders() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/available?pageNum=1&pageSize=50'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    final rows = data['rows'] as List<dynamic>? ?? [];
    return rows.map((row) => OrderItem.fromJson(row as Map<String, dynamic>)).toList();
  }

  Future<List<OrderItem>> fetchMyOrders({String scope = 'all'}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/mine?scope=$scope&pageNum=1&pageSize=50'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    final rows = data['rows'] as List<dynamic>? ?? [];
    return rows.map((row) => OrderItem.fromJson(row as Map<String, dynamic>)).toList();
  }

  Future<OrderItem> createOrder({
    required String title,
    required num rewardAmount,
    String? description,
    String? category,
    String? locationText,
    bool publish = true,
  }) async {
    final response = await http.post(
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
    _ensureSuccess(data);
    final created = OrderItem.fromJson(data['data'] as Map<String, dynamic>);
    if (publish) {
      return takeOrderAction(created.orderId, 'publish');
    }
    return created;
  }

  Future<OrderItem> fetchOrderDetail(int orderId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId'),
      headers: await _headers(auth: true),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    return OrderItem.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<OrderItem> takeOrderAction(int orderId, String action, {String? cancelReason}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/$action');
    final response = await http.post(
      uri,
      headers: await _headers(auth: true),
      body: (action == 'cancel' || action == 'abandon')
          ? jsonEncode({'cancelReason': cancelReason ?? ''})
          : null,
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    return OrderItem.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<OrderItem> rateOrder(int orderId, {required int score, String? comment}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/backpacker/orders/$orderId/rate'),
      headers: await _headers(auth: true),
      body: jsonEncode({'score': score, 'comment': comment ?? ''}),
    );
    final data = _decodeBody(response);
    _ensureSuccess(data);
    return OrderItem.fromJson(data['data'] as Map<String, dynamic>);
  }
}
