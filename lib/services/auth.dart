// // lib/services/authorized_http.dart  (SALES APP)
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:sales_mobile_app/services/DeviceHeader.dart';
// import 'package:sales_mobile_app/services/constants.dart';
// import 'package:sales_mobile_app/services/secureStorage.dart';
// import 'package:sales_mobile_app/services/tokenManager.dart';

// final SecureStorage _storage = SecureStorage();

// /// Authorized requests. Auth fail par single-flight refresh karke ek baar retry.
// /// Return null => session expire ho gaya ya refresh fail hua (caller kuch na kare;
// /// navigation TokenManager sambhal leta hai).

// Future<http.Response?> authGet(String url, {bool withDeviceHeaders = false}) =>
//     _authRequest(
//       (token, extra) => http.get(Uri.parse(url), headers: _json(token, extra)),
//       withDeviceHeaders: withDeviceHeaders,
//     );

// Future<http.Response?> authPost(String url,
//         {Object? body, bool withDeviceHeaders = false}) =>
//     _authRequest(
//       (token, extra) =>
//           http.post(Uri.parse(url), headers: _json(token, extra), body: body),
//       withDeviceHeaders: withDeviceHeaders,
//     );

// Future<http.Response?> authPut(String url,
//         {Object? body, bool withDeviceHeaders = false}) =>
//     _authRequest(
//       (token, extra) =>
//           http.put(Uri.parse(url), headers: _json(token, extra), body: body),
//       withDeviceHeaders: withDeviceHeaders,
//     );

// Future<http.Response?> authPatch(String url,
//         {Object? body, bool withDeviceHeaders = false}) =>
//     _authRequest(
//       (token, extra) =>
//           http.patch(Uri.parse(url), headers: _json(token, extra), body: body),
//       withDeviceHeaders: withDeviceHeaders,
//     );

// Future<http.Response?> authDelete(String url,
//         {Object? body, bool withDeviceHeaders = false}) =>
//     _authRequest(
//       (token, extra) =>
//           http.delete(Uri.parse(url), headers: _json(token, extra), body: body),
//       withDeviceHeaders: withDeviceHeaders,
//     );

// /// Multipart upload (har attempt par naya request banta hai).
// Future<http.Response?> authMultipart(
//   String url, {
//   required String field,
//   required List<String> filePaths,
//   String method = 'POST',
//   MediaType? contentType,
//   bool withDeviceHeaders = true,
// }) =>
//     _authRequest(
//       (token, extra) async {
//         final req = http.MultipartRequest(method, Uri.parse(url));
//         req.headers['Authorization'] = 'Bearer $token';
//         req.headers.addAll(extra);
//         for (final p in filePaths) {
//           req.files.add(
//             await http.MultipartFile.fromPath(field, p, contentType: contentType),
//           );
//         }
//         return http.Response.fromStream(await req.send());
//       },
//       withDeviceHeaders: withDeviceHeaders,
//     );

// Map<String, String> _json(String token, Map<String, String> extra) => {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//       ...extra,
//     };

// /// 401, ya non-200 jisme body bole "token galat/expired".
// bool _isAuthFailure(http.Response r) {
//   if (r.statusCode == 401) return true;
//   if (r.statusCode == 200 || r.statusCode == 201) return false;
//   final b = r.body.toLowerCase();
//   return b.contains('token is not correct') ||
//       b.contains('invalid token') ||
//       b.contains('token expired') ||
//       b.contains('jwt expired');
// }

// Future<http.Response?> _authRequest(
//   Future<http.Response> Function(String token, Map<String, String> extra) send, {
//   required bool withDeviceHeaders,
// }) async {
//   final Map<String, String> extra = withDeviceHeaders
//       ? Map<String, String>.from(await DeviceHeaders.getDeviceHeaders())
//       : <String, String>{};

//   String token = (await _storage.readSecureData('token')) ?? '';
//   Constants.token = token;

//   // Token hai hi nahi => logged out, request mat bhejo
//   if (token.isEmpty) return null;

//   var res = await send(token, extra);

//   if (_isAuthFailure(res)) {
//     final result = await TokenManager.refresh(failedToken: token);
//     if (result != RefreshResult.success) return null;

//     token = (await _storage.readSecureData('token')) ?? '';
//     Constants.token = token;
//     res = await send(token, extra);
//   }
//   return res;
// }

// lib/services/authorized_http.dart  (SALES APP)
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sales_mobile_app/services/DeviceHeader.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:sales_mobile_app/services/tokenManager.dart';

final SecureStorage _storage = SecureStorage();

/// Authorized requests.
/// Token expire ho to refresh token se naya token leke WAHI API dobara chalata hai.
/// Return null => sirf tab jab sach mein logout ho chuka ho
/// (navigation TokenManager sambhal leta hai, caller kuch na kare).

Future<http.Response?> authGet(String url, {bool withDeviceHeaders = false}) =>
    _authRequest(
      url,
      (token, extra) => http.get(Uri.parse(url), headers: _json(token, extra)),
      withDeviceHeaders: withDeviceHeaders,
    );

Future<http.Response?> authPost(String url,
        {Object? body, bool withDeviceHeaders = false}) =>
    _authRequest(
      url,
      (token, extra) =>
          http.post(Uri.parse(url), headers: _json(token, extra), body: body),
      withDeviceHeaders: withDeviceHeaders,
    );

Future<http.Response?> authPut(String url,
        {Object? body, bool withDeviceHeaders = false}) =>
    _authRequest(
      url,
      (token, extra) =>
          http.put(Uri.parse(url), headers: _json(token, extra), body: body),
      withDeviceHeaders: withDeviceHeaders,
    );

Future<http.Response?> authPatch(String url,
        {Object? body, bool withDeviceHeaders = false}) =>
    _authRequest(
      url,
      (token, extra) =>
          http.patch(Uri.parse(url), headers: _json(token, extra), body: body),
      withDeviceHeaders: withDeviceHeaders,
    );

Future<http.Response?> authDelete(String url,
        {Object? body, bool withDeviceHeaders = false}) =>
    _authRequest(
      url,
      (token, extra) =>
          http.delete(Uri.parse(url), headers: _json(token, extra), body: body),
      withDeviceHeaders: withDeviceHeaders,
    );

/// Multipart upload (har attempt par naya request banta hai).
Future<http.Response?> authMultipart(
  String url, {
  required String field,
  required List<String> filePaths,
  String method = 'POST',
  MediaType? contentType,
  bool withDeviceHeaders = true,
}) =>
    _authRequest(
      url,
      (token, extra) async {
        final req = http.MultipartRequest(method, Uri.parse(url));
        req.headers['Authorization'] = 'Bearer $token';
        req.headers.addAll(extra);
        for (final p in filePaths) {
          req.files.add(
            await http.MultipartFile.fromPath(field, p, contentType: contentType),
          );
        }
        return http.Response.fromStream(await req.send());
      },
      withDeviceHeaders: withDeviceHeaders,
    );

Map<String, String> _json(String token, Map<String, String> extra) => {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...extra,
    };

void _log(String url, String msg) {
  // Console mein "[authHttp]" search karo. Sab theek hone ke baad hata sakte ho.
  final path = Uri.tryParse(url)?.path ?? url;
  debugPrint('[authHttp] $path -> $msg');
}

/// Storage se token padhta hai. Khaali mile to 300ms baad ek baar aur padhta hai
/// (Android secure storage kabhi write ke beech mein khaali de deta hai).
Future<String> _readToken() async {
  var t = (await _storage.readSecureData('token')) ?? '';
  if (t.isEmpty) {
    await Future.delayed(const Duration(milliseconds: 300));
    t = (await _storage.readSecureData('token')) ?? '';
  }
  return t;
}

/// 401, ya "token galat/expired" wali body.
/// 200/201 par sirf tab maanta hai jab body chhoti ho (asli data ko galti se na pakde).
bool _isAuthFailure(http.Response r) {
  if (r.statusCode == 401) return true;

  final b = r.body.toLowerCase();
  final looksLikeTokenError = b.contains('token is not correct') ||
      b.contains('invalid token') ||
      b.contains('token expired') ||
      b.contains('jwt expired');

  if (r.statusCode == 200 || r.statusCode == 201) {
    return looksLikeTokenError && b.length < 300;
  }
  return looksLikeTokenError;
}

Future<http.Response?> _authRequest(
  String url,
  Future<http.Response> Function(String token, Map<String, String> extra) send, {
  required bool withDeviceHeaders,
}) async {
  final Map<String, String> extra = withDeviceHeaders
      ? Map<String, String>.from(await DeviceHeaders.getDeviceHeaders())
      : <String, String>{};

  String token = await _readToken();
  Constants.token = token;

  // Token hai hi nahi => logged out, request mat bhejo
  if (token.isEmpty) {
    _log(url, 'NULL: no token in storage (logged out)');
    return null;
  }

  var res = await send(token, extra);
  if (!_isAuthFailure(res)) return res;

  _log(url, 'auth failed (${res.statusCode}) ${_short(res.body)}');

  // Maximum 2 koshish: refresh -> wahi API dobara
  for (var attempt = 1; attempt <= 2; attempt++) {
    final latest = await _readToken();

    if (latest.isNotEmpty && latest != token) {
      // Kisi aur call ne pehle hi refresh kar diya, uska naya token use karo
      _log(url, 'attempt $attempt: using token already refreshed by another call');
      token = latest;
    } else {
      final result = await TokenManager.refresh(failedToken: token);

      if (result == RefreshResult.sessionExpired) {
        // Asli logout: TokenManager navigation kar chuka hai
        _log(url, 'NULL: session expired (refresh token rejected)');
        return null;
      }

      if (result == RefreshResult.failed) {
        // Network / 500: thoda ruk ke dobara
        _log(url, 'attempt $attempt: refresh failed (network/server), retrying');
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      token = await _readToken();
      if (token.isEmpty) {
        _log(url, 'NULL: token empty after refresh');
        return null;
      }
    }

    Constants.token = token;
    res = await send(token, extra);

    if (!_isAuthFailure(res)) {
      _log(url, 'OK after refresh (${res.statusCode})');
      return res;
    }
    _log(url, 'attempt $attempt: still auth failure (${res.statusCode})');
  }

  // Yahan tak aaye => user logout nahi hua, bas API ne sahi jawab nahi diya.
  // null nahi dete, taaki "Session expired" na dikhe; caller apna normal error handle karega.
  return res;
}

String _short(String s) => s.length > 120 ? '${s.substring(0, 120)}...' : s;