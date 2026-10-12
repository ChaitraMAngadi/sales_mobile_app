// import 'dart:convert';
// import 'dart:io';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:mime/mime.dart';
// import 'package:sales_mobile_app/services/DeviceHeader.dart';
// import 'package:sales_mobile_app/services/constants.dart';
// import 'package:sales_mobile_app/services/secureStorage.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';

// import '../routes/app_router.dart';

// class Marketingprovider extends ChangeNotifier {
//   final SecureStorage secureStorage = SecureStorage();

//   // List<Map<String, dynamic>> doctordetails = [];
//   Map<String, dynamic>? doctordetails;
//   bool uploadinglogo = false;
//   bool togglingmarketingstatus = false;



//   // Map<String, dynamic> getData();

//   /// Optional: agar step ke andar apna validation ho (jaise Basic Info)
//   bool validate() => true;

// Future<dynamic> getdoctoralldetails(BuildContext context, String id) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/marketingprofile/$id";
//     Constants.token = await secureStorage.readSecureData('token') ?? '';

//     try {
//       var response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 401) {
//         await refreshtoken(context);
//         Constants.token = await secureStorage.readSecureData('token') ?? '';
//         response = await http.get(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${Constants.token}',
//           },
//         );
//       }

//       // if (response.statusCode == 200) {
//       //   var data = json.decode(response.body)['data'];
//       //   print(data);
//       //   if (data is List) {
//       //     doctordetails = List<Map<String, dynamic>>.from(data);
//       //     notifyListeners();
//       //   } else if (data is Map) {
//       //     doctordetails = [Map<String, dynamic>.from(data)];
//       //     print(doctordetails);
//       //   }
//       //   notifyListeners();
//       //   return jsonDecode(response.body);
        
//       // } else {
//       //   print('${response.body}');
//       // }

//       if (response.statusCode == 200) {
//   var body = jsonDecode(response.body);
//   var data = body['data'];

//   if (data is Map) {
//     doctordetails = Map<String, dynamic>.from(data);
//   } else {
//     doctordetails = null;
//   }
//   notifyListeners();
//   return body;
// } else {
//   print('${response.body}');
// }
      
//     } catch (e) {
//       print(e);
//     }
//   }

 
//   /// Common helper: token lagata hai, 401 aane par refresh karke retry karta hai
//   Future<http.Response> _sendWithAuth(
//     BuildContext context,
//     Future<http.Response> Function(Map<String, String> headers) request,
//   ) async {
//     Map<String, String> buildHeaders() => <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         };

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     var response = await request(buildHeaders());

//     if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       response = await request(buildHeaders());
//     }
//     return response;
//   }

//   Future<bool> createMarketingProfile(
//     BuildContext context,
//     String id,
//     Map<String, dynamic> payload,
//   ) async {
//     // NOTE: apna sahi endpoint yahan set karein (backend ke hisaab se)
//     final String url = "${Constants.baseUrl}/api/v1/sales/marketingprofile/$id";

//     try {
//       final response = await _sendWithAuth(
//         context,
//         (headers) => http.post(
//           Uri.parse(url),
//           headers: headers,
//           body: jsonEncode(payload),
//         ),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true) {
//           // Naya data dobara fetch karke local state refresh
//           if (context.mounted) await getdoctoralldetails(context, id);
//           notifyListeners();
//           return true;
//         }
//       } else {
//         print('createMarketingProfile failed: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }

//   Future<bool> updateMarketingProfile(
//     BuildContext context,
//     String id,
//     Map<String, dynamic> payload,
//   ) async {
//     // NOTE: apna sahi endpoint yahan set karein (backend ke hisaab se)
//     final String url = "${Constants.baseUrl}/api/v1/sales/marketingprofile/$id";

//     try {
//       print(payload);
//       final response = await _sendWithAuth(
//         context,
//         (headers) => http.post(
//           Uri.parse(url),
//           headers: headers,
//           body: jsonEncode(payload),
//         ),
//       );

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         if (body['success'] == true) {
//           // Updated data dobara fetch karke local state refresh
//           if (context.mounted) await getdoctoralldetails(context, id);
//           notifyListeners();
//           return true;
//         }
//       } else {
//         print('updateMarketingProfile failed: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }


// String _extractErrorMessage(http.Response response) {
//   try {
//     final decoded = jsonDecode(response.body);
//     return decoded['msg'] ?? 'Something went wrong';
//   } catch (e) {
//     return 'Something went wrong (status: ${response.statusCode})';
//   }
// }


//   Future<bool> uploadHospitalLogo(String id, File file, BuildContext context) async {
//   uploadinglogo = true;
//   notifyListeners();

//   final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//   print('DETECTED MIME TYPE: $mimeType');

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingphoto/$id'),
//     );

//     request.headers['Authorization'] = 'Bearer ${Constants.token}';
//     request.headers.addAll(deviceHeaders);
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'profilePhoto',
//         file.path,
//         contentType: MediaType.parse(mimeType),   // ✅ original request
//       ),
//     );

//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       uploadinglogo = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Logo uploaded successfully', style: TextStyle(color: Colors.grey[50])),
//         ));
//       }

//      getdoctoralldetails(context, id);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       var retryRequest = http.MultipartRequest(
//         'POST',
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingphoto/$id'),
//       );
//       retryRequest.headers['Authorization'] = 'Bearer ${Constants.token}';
//       retryRequest.headers.addAll(deviceHeaders);
//       retryRequest.files.add(
//         await http.MultipartFile.fromPath(
//           'logo',
//           file.path,
//           contentType: MediaType.parse(mimeType),   // ✅ retry request — ye missing tha
//         ),
//       );

//       var retryStreamed = await retryRequest.send();
//       var retryResponse = await http.Response.fromStream(retryStreamed);

//       uploadinglogo = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text('Logo uploaded successfully', style: TextStyle(color: Colors.grey[50])),
//           ));
//         }
//         await getdoctoralldetails(context, id);
//         return true;
//       } else {
//         print('Retry failed: ${retryResponse.body}');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(_extractErrorMessage(retryResponse)),
//           ));
//         }
//         return false;
//       }
//     } else {
//       print('Upload failed: ${response.statusCode} - ${response.body}');
//       uploadinglogo = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(_extractErrorMessage(response)),
//         ));
//       }
//       return false;
//     }
//   } catch (e) {
//     print('Upload exception: $e');
//     uploadinglogo = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

// Future<bool> toggleStatus(String hospitalId, bool currentStatus, BuildContext context) async {
//   togglingmarketingstatus = true;
//   notifyListeners();

//   // currentStatus true hai to disable karna hai, false hai to enable karna hai
//   final endpoint = currentStatus ? 'disable' : 'enable';

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingprofile/$hospitalId/$endpoint'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       togglingmarketingstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             currentStatus ? 'Marketing disabled successfully' : 'Marketing enabled successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         ));
//       }

//       await getdoctoralldetails(context, hospitalId);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.patch(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingprofile/$hospitalId/$endpoint'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       togglingmarketingstatus = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               currentStatus ? 'Marketing disabled successfully' : 'Marketing enabled successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ),
//           ));
//         }
//         await getdoctoralldetails(context, hospitalId);
//         return true;
//       } else {
//         print('Toggle status retry failed: ${retryResponse.body}');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(_extractErrorMessage(retryResponse)),
//           ));
//         }
//         return false;
//       }
//     } else {
//       print('Toggle status failed: ${response.statusCode} - ${response.body}');
//       togglingmarketingstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(_extractErrorMessage(response)),
//         ));
//       }
//       return false;
//     }
//   } catch (e) {
//     print('Toggle status exception: $e');
//     togglingmarketingstatus = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

// bool deletinglogo = false;

// Future<bool> deleteHospitalLogo(String hospitalId, BuildContext context) async {
//   deletinglogo = true;
//   notifyListeners();

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.delete(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingphoto/$hospitalId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       deletinglogo = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text('Logo deleted successfully', style: TextStyle(color: Colors.grey[50])),
//         ));
//       }

//       await getdoctoralldetails(context, hospitalId);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.delete(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/marketingphoto/$hospitalId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       deletinglogo = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text('Logo deleted successfully', style: TextStyle(color: Colors.grey[50])),
//           ));
//         }
//         await getdoctoralldetails(context,hospitalId);
//         return true;
//       } else {
//         print('Delete logo retry failed: ${retryResponse.body}');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(_extractErrorMessage(retryResponse)),
//           ));
//         }
//         return false;
//       }
//     } else {
//       print('Delete logo failed: ${response.statusCode} - ${response.body}');
//       deletinglogo = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(_extractErrorMessage(response)),
//         ));
//       }
//       return false;
//     }
//   } catch (e) {
//     print('Delete logo exception: $e');
//     deletinglogo = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

//   //////////////////////////////////////////////////////////////////////////////////////////////

//   Future<void> refreshtoken(BuildContext context) async {
//     Constants.refreshtoken = await secureStorage.readSecureData('refreshtoken') ?? '';
//             Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       Constants.refreshtoken = await secureStorage.readSecureData('refreshtoken') ?? '';
//             Constants.token = await secureStorage.readSecureData('token') ?? '';

      

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/refreshtokensalesphone'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.refreshtoken}',
//           'Content-Type': 'application/json',
//           // ...headers,
//         },
//       );

//       print(response.body);

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         await secureStorage.writeSecureData('token', responseData['token']);
//         await secureStorage.writeSecureData('refreshtoken', responseData['refreshToken']);
//         Constants.token = responseData['token'];
//         Constants.refreshtoken = responseData['refreshToken'];
//         print("Constants.doctortoken ${Constants.token}");
//         print("Constants.doctorrefreshtoken ${Constants.refreshtoken}");
//         notifyListeners();

//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         // Only logout on auth errors
//         await secureStorage.deleteSecureData('token');
//         await secureStorage.deleteSecureData('refreshtoken');
//         Constants.token = '';
//         Constants.refreshtoken = '';
//         if (context.mounted) context.router.popAndPush(SplashRoute());

//       } else {
//         // 500 or any other error — DO NOT logout, just print
//         print("Refresh failed with status: ${response.statusCode} — ${response.body}");
//       }


//     } catch (e) {
//       final error = SnackBar(content: Text(e.toString()));
//     }
//   }
  
// }


// lib/provider/marketingProvider.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sales_mobile_app/services/auth.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:sales_mobile_app/services/tokenManager.dart';

class Marketingprovider extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();

  Map<String, dynamic>? doctordetails;
  bool uploadinglogo = false;
  bool togglingmarketingstatus = false;
  bool deletinglogo = false;

  String get _api => '${Constants.baseUrl}/api/v1/sales';

  /// Optional: agar step ke andar apna validation ho (jaise Basic Info)
  bool validate() => true;

  // ───────────────────────────── helpers ─────────────────────────────

  void _snack(BuildContext context, String msg, {bool error = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error ? Colors.red[400] : Colors.green[400],
      content: Text(msg, style: TextStyle(color: Colors.grey[50])),
    ));
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return decoded['msg'] ?? 'Something went wrong';
    } catch (e) {
      return 'Something went wrong (status: ${response.statusCode})';
    }
  }

  // ───────────────────────────── profile ─────────────────────────────

  Future<dynamic> getdoctoralldetails(BuildContext context, String id) async {
    try {
      final res = await authGet('$_api/marketingprofile/$id');
      if (res == null) return null;

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final data = body['data'];
        print(data);
        doctordetails =
            data is Map ? Map<String, dynamic>.from(data) : null;
        notifyListeners();
        return body;
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> _saveProfile(
      BuildContext context, String id, Map<String, dynamic> payload,
      {required String label, required bool allow201}) async {
    try {
      final res = await authPost(
        '$_api/marketingprofile/$id',
        body: jsonEncode(payload),
      );
      if (res == null) return false;

      final ok = res.statusCode == 200 || (allow201 && res.statusCode == 201);
      if (ok) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          // Naya data dobara fetch karke local state refresh
          if (context.mounted) await getdoctoralldetails(context, id);
          notifyListeners();
          return true;
        }
      } else {
        print('$label failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> createMarketingProfile(
          BuildContext context, String id, Map<String, dynamic> payload) =>
      _saveProfile(context, id, payload,
          label: 'createMarketingProfile', allow201: true);

  Future<bool> updateMarketingProfile(
      BuildContext context, String id, Map<String, dynamic> payload) {
    print(payload);
    return _saveProfile(context, id, payload,
        label: 'updateMarketingProfile', allow201: false);
  }

  // ───────────────────────────── photo ─────────────────────────────

  Future<bool> uploadHospitalLogo(
      String id, File file, BuildContext context) async {
    uploadinglogo = true;
    notifyListeners();

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    try {
      final res = await authMultipart(
        '$_api/marketingphoto/$id',
        field: 'profilePhoto',
        filePaths: [file.path],
        method: 'POST',
        contentType: MediaType.parse(mimeType),
      );
      uploadinglogo = false;
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200 || res.statusCode == 201) {
        _snack(context, 'Logo uploaded successfully');
        await getdoctoralldetails(context, id);
        return true;
      }
      print('Upload failed: ${res.statusCode} - ${res.body}');
      _snack(context, _extractErrorMessage(res), error: true);
      return false;
    } catch (e) {
      print('Upload exception: $e');
      uploadinglogo = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
      return false;
    }
  }

  Future<bool> deleteHospitalLogo(String hospitalId, BuildContext context) async {
    deletinglogo = true;
    notifyListeners();

    try {
      final res = await authDelete('$_api/marketingphoto/$hospitalId',
          withDeviceHeaders: true);
      deletinglogo = false;
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200) {
        _snack(context, 'Logo deleted successfully');
        await getdoctoralldetails(context, hospitalId);
        return true;
      }
      print('Delete logo failed: ${res.statusCode} - ${res.body}');
      _snack(context, _extractErrorMessage(res), error: true);
      return false;
    } catch (e) {
      print('Delete logo exception: $e');
      deletinglogo = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
      return false;
    }
  }

  // ───────────────────────────── enable / disable ─────────────────────────────

  Future<bool> toggleStatus(
      String hospitalId, bool currentStatus, BuildContext context) async {
    togglingmarketingstatus = true;
    notifyListeners();

    // currentStatus true hai to disable karna hai, false hai to enable
    final endpoint = currentStatus ? 'disable' : 'enable';

    try {
      final res = await authPatch(
          '$_api/marketingprofile/$hospitalId/$endpoint',
          withDeviceHeaders: true);
      togglingmarketingstatus = false;
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200) {
        _snack(
            context,
            currentStatus
                ? 'Marketing disabled successfully'
                : 'Marketing enabled successfully');
        await getdoctoralldetails(context, hospitalId);
        return true;
      }
      print('Toggle status failed: ${res.statusCode} - ${res.body}');
      _snack(context, _extractErrorMessage(res), error: true);
      return false;
    } catch (e) {
      print('Toggle status exception: $e');
      togglingmarketingstatus = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
      return false;
    }
  }

  // ───────────────────────────── misc ─────────────────────────────

  /// Compatibility: purani files agar provider.refreshtoken(context) call karein
  /// to bhi ab single-flight TokenManager hi chalega.
  Future<void> refreshtoken(BuildContext context) async {
    final String failed = (await secureStorage.readSecureData('token')) ?? '';
    await TokenManager.refresh(failedToken: failed);
  }

  /// Logout par purana data na dikhe.
  void reset() {
    doctordetails = null;
    notifyListeners();
  }
}