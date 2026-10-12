// lib/services/token_manager.dart  (SALES APP)
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_mobile_app/services/DeviceHeader.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';

enum RefreshResult { success, sessionExpired, failed }

/// Single-flight token refresh.
/// Kitni bhi API calls ek saath 401 khayein, refresh API sirf EK baar chalegi.
/// Baaki sab usi ka result wait karengi.
class TokenManager {
  static final SecureStorage _storage = SecureStorage();
  static Future<RefreshResult>? _inFlight;

  /// main.dart mein set karo. Session khatam hone par navigation yahin se hoga.
  static void Function()? onSessionExpired;

  /// [failedToken] = wo token jisse API call 401 hui thi.
  static Future<RefreshResult> refresh({required String failedToken}) {
    return _inFlight ??= _doRefresh(failedToken).whenComplete(() {
      _inFlight = null;
    });
  }

  static Future<RefreshResult> _doRefresh(String failedToken) async {
    try {
      // Kisi aur call ne pehle hi refresh kar diya? To dobara mat karo.
      final String current = (await _storage.readSecureData('token')) ?? '';
      if (current.isNotEmpty && current != failedToken) {
        Constants.token = current;
        return RefreshResult.success;
      }

      // Token pehle se empty = logout ho chuka hai, dobara navigation mat chalao.
      if (current.isEmpty) {
        return RefreshResult.sessionExpired;
      }

      final String refreshToken =
          (await _storage.readSecureData('refreshtoken')) ?? '';
      if (refreshToken.isEmpty) {
        await _logout();
        return RefreshResult.sessionExpired;
      }

      Map<String, String> extra = {};
      try {
        extra = Map<String, String>.from(await DeviceHeaders.getDeviceHeaders());
      } catch (_) {}

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/refreshtokensalesphone'),
        headers: <String, String>{
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
          ...extra,
        },
      );

      // DEBUG: problem solve hone ke baad ye 2 prints hata dena
      print(
          'REFRESH SENT => ${refreshToken.length > 12 ? refreshToken.substring(0, 12) : refreshToken}...');
      print('REFRESH RESP => ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.writeSecureData('token', data['token']);
        await _storage.writeSecureData('refreshtoken', data['refreshToken']);
        Constants.token = data['token'];
        Constants.refreshtoken = data['refreshToken'];
        return RefreshResult.success;
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Logout se pehle ek aakhri check: beech mein kisi ne refresh kar diya?
        final String latest = (await _storage.readSecureData('token')) ?? '';
        if (latest.isNotEmpty && latest != failedToken) {
          Constants.token = latest;
          return RefreshResult.success;
        }
        await _logout();
        return RefreshResult.sessionExpired;
      }

      // 500 / koi aur error => logout NAHI
      return RefreshResult.failed;
    } catch (e) {
      // Network error => logout NAHI
      print('Refresh error: $e');
      return RefreshResult.failed;
    }
  }

  static Future<void> _logout() async {
    await _storage.deleteSecureData('token');
    await _storage.deleteSecureData('refreshtoken');
    await _storage.deleteSecureData('isLoggedIn');
    Constants.token = '';
    Constants.refreshtoken = '';

    onSessionExpired?.call();
  }
}