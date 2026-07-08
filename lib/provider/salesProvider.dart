import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/services/DeviceHeader.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';




class Salesprovider extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();


//////////////////////////Hospitals//////////////////////////////////////

List<Map<String, dynamic>> allhospitals = [];
Map<String, dynamic> allprofiles = {};   
//  List<Map<String, dynamic>> allprofiles = [];
bool addinghospital = false;
bool iseditinghospital = false;
bool uploadinglogo = false;

Future<void> getallhospitals(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getallhospitals";

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        allhospitals = List<Map<String, dynamic>>.from(responseData["data"]);
        print(allhospitals);

        notifyListeners();
      } else if (response.statusCode == 401) {
        await refreshtoken(context);

        Constants.token = await secureStorage.readSecureData('token') ?? '';

        try {
          final response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${Constants.token}',
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            print(responseData);

            allhospitals = List<Map<String, dynamic>>.from(responseData["data"]);
            print(allhospitals);

            notifyListeners();
          } else if (response.statusCode == 404) {
            final responseData = jsonDecode(response.body);
          }
        } catch (e) {
          print(e);
        }
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
}


  Future<void> addHospital(String name, String phone, 
      String email, String address, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addhospital'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addinghospital = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Hospital Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getallhospitals(context);
        Navigator.pop(context);
      } else if(response.statusCode == 401){
        await refreshtoken(context);

        try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };

    

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addhospital'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addinghospital = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Hospital Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getallhospitals(context);
        Navigator.pop(context);
      } else {
        print(response.body);
        addinghospital = false;
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        notifyListeners();
      }
    } catch (e) {
      addinghospital = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
      }
       else {
        print(response.body);
        addinghospital = false;
        final responseData = jsonDecode(response.body);
        final snackbar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData["msg"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        notifyListeners();
      }
    } catch (e) {
      addinghospital = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
  }


Future<void> edithospital(String id, String name, String address,
      String email, String phone, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "address": address,
        "email": email,
        "phone": phone
      };

      String url = "${Constants.baseUrl}/api/v1/sales/edithospital/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        iseditinghospital = false;
        final responseData = jsonDecode(response.body);
        await getallhospitals(context);

        notifyListeners();
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "Hospital details updated Successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      
        Navigator.pop(context);

        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken(context);

        try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();

      final Map<String, dynamic> requestBody = {
        "name": name,
        "address": address,
        "email": email,
        "phone": phone
      };
      

      String url = "${Constants.baseUrl}/api/v1/sales/edithospital/$id";
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        iseditinghospital = false;
        final responseData = jsonDecode(response.body);
        await getallhospitals(context);

        notifyListeners();
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "Patient details updated Successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      
        Navigator.pop(context);

        notifyListeners();
      } else {
        iseditinghospital = false;
        final responseData = jsonDecode(response.body);
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        notifyListeners();
      }
    } catch (e) {
      iseditinghospital = false;
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
      }
       else {
        iseditinghospital = false;
        final responseData = jsonDecode(response.body);
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        notifyListeners();
      }
    } catch (e) {
      iseditinghospital = false;
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
  }


Future<bool> uploadHospitalLogo(String hospitalId, File file, BuildContext context) async {
  uploadinglogo = true;
  notifyListeners();

  final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
  print('DETECTED MIME TYPE: $mimeType');

  try {
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${Constants.baseUrl}/api/v1/sales/uploadhospitallogo/$hospitalId'),
    );

    request.headers['Authorization'] = 'Bearer ${Constants.token}';
    request.headers.addAll(deviceHeaders);
    request.files.add(
      await http.MultipartFile.fromPath(
        'logo',
        file.path,
        contentType: MediaType.parse(mimeType),   // ✅ original request
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      uploadinglogo = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text('Logo uploaded successfully', style: TextStyle(color: Colors.grey[50])),
        ));
      }

      await getallhospitals(context);
      return true;
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';

      var retryRequest = http.MultipartRequest(
        'PUT',
        Uri.parse('${Constants.baseUrl}/api/v1/sales/uploadhospitallogo/$hospitalId'),
      );
      retryRequest.headers['Authorization'] = 'Bearer ${Constants.token}';
      retryRequest.headers.addAll(deviceHeaders);
      retryRequest.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          file.path,
          contentType: MediaType.parse(mimeType),   // ✅ retry request — ye missing tha
        ),
      );

      var retryStreamed = await retryRequest.send();
      var retryResponse = await http.Response.fromStream(retryStreamed);

      uploadinglogo = false;
      notifyListeners();

      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text('Logo uploaded successfully', style: TextStyle(color: Colors.grey[50])),
          ));
        }
        await getallhospitals(context);
        return true;
      } else {
        print('Retry failed: ${retryResponse.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(_extractErrorMessage(retryResponse)),
          ));
        }
        return false;
      }
    } else {
      print('Upload failed: ${response.statusCode} - ${response.body}');
      uploadinglogo = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(_extractErrorMessage(response)),
        ));
      }
      return false;
    }
  } catch (e) {
    print('Upload exception: $e');
    uploadinglogo = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}


//////////////////////////Delete Hospital Logo//////////////////////////////////////

bool deletinglogo = false;

Future<bool> deleteHospitalLogo(String hospitalId, BuildContext context) async {
  deletinglogo = true;
  notifyListeners();

  try {
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/deletehospitallogo/$hospitalId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...deviceHeaders,
      },
    );

    if (response.statusCode == 200) {
      deletinglogo = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text('Logo deleted successfully', style: TextStyle(color: Colors.grey[50])),
        ));
      }

      await getallhospitals(context);
      return true;
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';

      final retryResponse = await http.delete(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/deletehospitallogo/$hospitalId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...deviceHeaders,
        },
      );

      deletinglogo = false;
      notifyListeners();

      if (retryResponse.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text('Logo deleted successfully', style: TextStyle(color: Colors.grey[50])),
          ));
        }
        await getallhospitals(context);
        return true;
      } else {
        print('Delete logo retry failed: ${retryResponse.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(_extractErrorMessage(retryResponse)),
          ));
        }
        return false;
      }
    } else {
      print('Delete logo failed: ${response.statusCode} - ${response.body}');
      deletinglogo = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(_extractErrorMessage(response)),
        ));
      }
      return false;
    }
  } catch (e) {
    print('Delete logo exception: $e');
    deletinglogo = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}

String _extractErrorMessage(http.Response response) {
  try {
    final decoded = jsonDecode(response.body);
    return decoded['msg'] ?? 'Something went wrong';
  } catch (e) {
    return 'Something went wrong (status: ${response.statusCode})';
  }
}

//////////////////////////Enable/Disable Hospital//////////////////////////////////////

bool togglinghospitalstatus = false;

Future<bool> toggleHospitalStatus(String hospitalId, bool currentStatus, BuildContext context) async {
  togglinghospitalstatus = true;
  notifyListeners();

  // currentStatus true hai to disable karna hai, false hai to enable karna hai
  final endpoint = currentStatus ? 'disablehospital' : 'enablehospital';

  try {
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...deviceHeaders,
      },
    );

    if (response.statusCode == 200) {
      togglinghospitalstatus = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            currentStatus ? 'Hospital disabled successfully' : 'Hospital enabled successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        ));
      }

      await getallhospitals(context);
      return true;
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';

      final retryResponse = await http.patch(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...deviceHeaders,
        },
      );

      togglinghospitalstatus = false;
      notifyListeners();

      if (retryResponse.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              currentStatus ? 'Hospital disabled successfully' : 'Hospital enabled successfully',
              style: TextStyle(color: Colors.grey[50]),
            ),
          ));
        }
        await getallhospitals(context);
        return true;
      } else {
        print('Toggle status retry failed: ${retryResponse.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(_extractErrorMessage(retryResponse)),
          ));
        }
        return false;
      }
    } else {
      print('Toggle status failed: ${response.statusCode} - ${response.body}');
      togglinghospitalstatus = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(_extractErrorMessage(response)),
        ));
      }
      return false;
    }
  } catch (e) {
    print('Toggle status exception: $e');
    togglinghospitalstatus = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}


Future<void> getallprofiles(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/myprofile";
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    print(Constants.token);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        allprofiles = Map<String, dynamic>.from(responseData["data"]);   // ✅ Map se convert
        print(allprofiles);
        print(responseData);

        notifyListeners();
      } else if (response.statusCode == 401) {
        await refreshtoken(context);
        Constants.token = await secureStorage.readSecureData('token') ?? '';
        try {
          final response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${Constants.token}',
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            allprofiles = Map<String, dynamic>.from(responseData["data"]);   // ✅ yahan bhi

            print('profile : $allprofiles');
            notifyListeners();
          } else if (response.statusCode == 404) {
            print('No profile found.');
          } else {
            print(response.body);
          }
        } catch (e) {
          print(e);
        }
      } else if (response.statusCode == 404) {
        print('No profile found.');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
}

//////////////////////////////////// Doctors /////////////////////////////////////////////////
///

List<Map<String, dynamic>> alldoctors = [];

Future<void> getalldoctors(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getalldoctors";

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);

        alldoctors = List<Map<String, dynamic>>.from(responseData["data"]);
        print(alldoctors);

        notifyListeners();
      } else if (response.statusCode == 401) {
        await refreshtoken(context);

        Constants.token = await secureStorage.readSecureData('token') ?? '';

        try {
          final response = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${Constants.token}',
            },
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            print(responseData);

            alldoctors = List<Map<String, dynamic>>.from(responseData["data"]);
            print(alldoctors);

            notifyListeners();
          } else if (response.statusCode == 404) {
            final responseData = jsonDecode(response.body);
          }
        } catch (e) {
          print(e);
        }
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> refreshtoken(BuildContext context) async {
    try {
      Constants.refreshtoken = await secureStorage.readSecureData('refreshtoken') ?? '';

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/refreshtokensalesphone'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.refreshtoken}',
          'Content-Type': 'application/json',
          // ...headers,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await secureStorage.writeSecureData('token', responseData['token']);
        await secureStorage.writeSecureData('refreshtoken', responseData['refreshToken']);
        Constants.token = responseData['token'];
        Constants.refreshtoken = responseData['refreshToken'];
        print("Constants.doctortoken ${Constants.token}");
        print("Constants.doctorrefreshtoken ${Constants.refreshtoken}");

      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Only logout on auth errors
        await secureStorage.deleteSecureData('token');
        await secureStorage.deleteSecureData('refreshtoken');
        Constants.token = '';
        Constants.refreshtoken = '';
        if (context.mounted) context.router.popAndPush(SplashRoute());

      } else {
        // 500 or any other error — DO NOT logout, just print
        print("Refresh failed with status: ${response.statusCode} — ${response.body}");
      }


    } catch (e) {
      final error = SnackBar(content: Text(e.toString()));
    }
  }
}
