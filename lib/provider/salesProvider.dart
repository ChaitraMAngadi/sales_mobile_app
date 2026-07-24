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
List<Map<String, dynamic>> allhospitalnames = [];

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

Future<void> getallhospitalsname(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getallhospitalnames";

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

        allhospitalnames = List<Map<String, dynamic>>.from(responseData["data"]);
        print("hospital names $allhospitalnames");

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

            allhospitalnames = List<Map<String, dynamic>>.from(responseData["data"]);
            print(allhospitalnames);

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
        notifyListeners();
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
        addinghospital = false;
        print(addinghospital);
        notifyListeners();
      }
    } catch (e) {
      addinghospital = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      addinghospital = false;
        print(addinghospital);
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
        addinghospital = false;
        print(addinghospital);
        notifyListeners();
      }
    } catch (e) {
      addinghospital = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      addinghospital = false;
        print(addinghospital);
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
List<Map<String, dynamic>> alldoctorsnames = [];
bool addingdoctor = false;
bool togglingdoctorstatus = false;
bool updatingdoctorprice = false;




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


Future<void> getalldoctorsname(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getalldoctorsname";

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

        alldoctorsnames = List<Map<String, dynamic>>.from(responseData["data"]);
        print("doctors names $alldoctorsnames");

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

            alldoctorsnames = List<Map<String, dynamic>>.from(responseData["data"]);
            print(alldoctorsnames);

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

Future<void> addDoctor(
String name, 
String phone,
String alternativephone,
String gender,
      String email, 
      String password, 
      String confirmpassword,
      String qualification,
      String specialization,
      String registrationnumber,
      String yearofregistration,
      String boardofregistration,
      String priceperdiagnosis,
      List<String> associatedhospital, 
       BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmpassword,
        "qualification": qualification,
        "specialization": specialization,
        "doctorRegistrationNumber": registrationnumber,
        "year_of_registration": yearofregistration,
        "board_of_registration": boardofregistration,
        "price": priceperdiagnosis,
        "hospitalIds": associatedhospital,
      };

       if(alternativephone.isNotEmpty){
      requestBody['phone2'] = alternativephone;
    }
      

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/adddoctor'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingdoctor = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Doctor Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalldoctors(context);
        Navigator.pop(context);
        notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken(context);

        try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "gender": gender,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmpassword,
        "qualification": qualification,
        "specialization": specialization,
        "doctorRegistrationNumber": registrationnumber,
        "year_of_registration": yearofregistration,
        "board_of_registration": boardofregistration,
        "price": priceperdiagnosis,
        "hospitalIds": associatedhospital,
      };
       if(alternativephone.isNotEmpty){
      requestBody['phone2'] = alternativephone;
    }
    

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/adddoctor'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingdoctor = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Doctor Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalldoctors(context);
        Navigator.pop(context);
        notifyListeners();
      } else {
        print(response.body);
        addingdoctor = false;
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
      addingdoctor = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
      }
       else {
        print(response.body);
        addingdoctor = false;
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
      addingdoctor = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
  }

  Future<bool> toggleDoctorStatus(String hospitalId, bool currentStatus, BuildContext context) async {
  togglingdoctorstatus = true;
  notifyListeners();

  // currentStatus true hai to disable karna hai, false hai to enable karna hai
  final endpoint = currentStatus ? 'disabledoctor' : 'enabledoctor';

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
            currentStatus ? 'Doctor disabled successfully' : 'Doctor enabled successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        ));
      }

      await getalldoctors(context);
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

      togglingdoctorstatus = false;
      notifyListeners();

      if (retryResponse.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              currentStatus ? 'Doctor disabled successfully' : 'Doctor enabled successfully',
              style: TextStyle(color: Colors.grey[50]),
            ),
          ));
        }
        await getalldoctors(context);
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
      togglingdoctorstatus = false;
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
    togglingdoctorstatus = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}

List<dynamic> priceHistory = [];
bool fetchingPriceHistory = false;

Future<void> getPriceHistory(String doctorId, BuildContext context) async {
  try {
    fetchingPriceHistory = true;
    notifyListeners();

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final headers = await DeviceHeaders.getDeviceHeaders();

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/getalldoctorprice/$doctorId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...headers,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      priceHistory = responseData['data'] ?? [];
      fetchingPriceHistory = false;
      notifyListeners();
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final retryResponse = await http.get(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/pricehistory/$doctorId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
      );
      if (retryResponse.statusCode == 200) {
        final responseData = jsonDecode(retryResponse.body);
        priceHistory = responseData['data'] ?? [];
      }
      fetchingPriceHistory = false;
      notifyListeners();
    } else {
      fetchingPriceHistory = false;
      priceHistory = [];
      notifyListeners();
    }
  } catch (e) {
    fetchingPriceHistory = false;
    priceHistory = [];
    notifyListeners();
    final error = SnackBar(content: Text(e.toString()));
    ScaffoldMessenger.of(context).showSnackBar(error);
  }
}

bool updatingdoctor = false;

Future<void> editDoctor({
  required String doctorId,
  required String name,
  required String phone,
  required String alternativephone,
  required String gender,
  required String email,
  required String password,
  required String confirmpassword,
  required String qualification,
  required String specialization,
  required String registrationnumber,
  required String yearofregistration,
  required String boardofregistration,
  required List<String> associatedhospital,
  required BuildContext context,
}) async {
  try {
    updatingdoctor = true;
    notifyListeners();

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final headers = await DeviceHeaders.getDeviceHeaders();

    final Map<String, dynamic> requestBody = {
      "name": name,
      "gender": gender,
      "email": email,
      "phone": phone,
      "qualification": qualification,
      "specialization": specialization,
      "doctorRegistrationNumber": registrationnumber,
      "year_of_registration": yearofregistration,
      "board_of_registration": boardofregistration,
      "hospitalIds": associatedhospital,
    };

    // Password sirf tab bhejo jab user ne naya password type kiya ho
    if (password.isNotEmpty) {
      requestBody["password"] = password;
      requestBody["confirm_password"] = confirmpassword;
    }
    if(alternativephone.isNotEmpty){
      requestBody['phone2'] = alternativephone;
    }

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/editdoctor/$doctorId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      updatingdoctor = false;
      notifyListeners();

      final successSnackbar = SnackBar(
        backgroundColor: Colors.green[400],
        content: Text(
          'Doctor updated successfully',
          style: TextStyle(color: Colors.grey[50]),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      await getalldoctors(context);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final retryResponse = await http.put(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/editdoctor/$doctorId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      updatingdoctor = false;
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        notifyListeners();
        final successSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Doctor updated successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
        await getalldoctors(context);
        updatingdoctor = false;
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(retryResponse.body);
        final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"] ?? "Something went wrong",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        updatingdoctor = false;
        notifyListeners();
      }
    } else {
      updatingdoctor = false;
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(
          responseData["msg"] ?? "Something went wrong",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      updatingdoctor = false;
      notifyListeners();
    }
  } catch (e) {
    updatingdoctor = false;
    notifyListeners();
    final error = SnackBar(content: Text(e.toString()));
    ScaffoldMessenger.of(context).showSnackBar(error);
  }
}

Future<void> changedoctorpassword(String newPassword, String confirmPassword,
 String doctid, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();
      print(doctid);

      final Map<String, dynamic> requestBody = {
        "newPassword": newPassword,
        "confirm_password": confirmPassword,
      };

      String url = "${Constants.baseUrl}/api/v1/sales/resetpassworddoctor/$doctid";
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 401) {
        await refreshtoken(context);
        Constants.token = await secureStorage.readSecureData('token') ?? '';
        final retryHeaders = await DeviceHeaders.getDeviceHeaders();
        response = await http.patch(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer ${Constants.token}',
            'Content-Type': 'application/json',
            ...retryHeaders,
          },
          body: jsonEncode(requestBody),
        );
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "New password updated successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        Navigator.pop(context);
        notifyListeners();
      } else {
        final responseData = jsonDecode(response.body);
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (e) {
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  Future<void> changeDoctorValidity({
  required String doctorId,
  required String validTill,
  required BuildContext context,
}) async {
  try {
   
final headers = await DeviceHeaders.getDeviceHeaders();
    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/changedoctorvalidity/$doctorId'),
       headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
      body: jsonEncode({'validdate': validTill}),
    );

    if (response.statusCode == 200) {
      final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Doctor Validity Updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalldoctors(context);
         notifyListeners();
    } else if(response.statusCode == 401){
    await  refreshtoken(context);

      try {
  
final headers = await DeviceHeaders.getDeviceHeaders();
    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/changedoctorvalidity/$doctorId'),
       headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
      body: jsonEncode({'validTill': validTill}),
    );

    if (response.statusCode == 200) {
      final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Doctor Validity Updated successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
       getalldoctors(context);
         notifyListeners();
    } else {
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
    print(e);
    // error handling
  } finally {
   
    notifyListeners();
  }
    }
    else {
     
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
    print(e);
    // error handling
  } finally {
  
    notifyListeners();
  }
}

Future<void> updateDoctorPrice({
  required String doctorId,
  required String price,
  required String effectiveDate,
  required BuildContext context,
}) async {
  try {
    print("button clicked");
    updatingdoctorprice = true;
    notifyListeners();
final headers = await DeviceHeaders.getDeviceHeaders();
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/updatedoctorprice/$doctorId'),
       headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
      body: jsonEncode({'price': price,
      'effectiveFrom': effectiveDate,
      }),
    );
 final responseData = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
         notifyListeners();
    } else if(response.statusCode == 401){
    await  refreshtoken(context);

      try {
    updatingdoctorprice = true;
    notifyListeners();
final headers = await DeviceHeaders.getDeviceHeaders();
    final response = await http.patch(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/updatedoctorprice/$doctorId'),
       headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
       body: jsonEncode({'price': price,
      'effectiveFrom': effectiveDate,
      }),
    );
     final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              responseData["msg"],
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
       getalldoctors(context);
         notifyListeners();
    } else {
      updatingdoctorprice = false;
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
    print(e);
    // error handling
  } finally {
    updatingdoctorprice = false;
    notifyListeners();
  }
    }
    else {
      updatingdoctorprice = false;
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
    print(e);
    // error handling
  } finally {
    updatingdoctorprice = false;
    notifyListeners();
  }
}


////////////////////////////////////////// Admins //////////////////////////////////////////////

List<Map<String, dynamic>> alladmins = [];
bool addingadmin = false;
bool togglingadminstatus = false;
bool updatingadmin = false;



Future<void> getalladmins(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getalladmins";

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

        alladmins = List<Map<String, dynamic>>.from(responseData["data"]);
        print(alladmins);

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

            alladmins = List<Map<String, dynamic>>.from(responseData["data"]);
            print(alladmins);

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

Future<void> addAdmin(String name, String phone, 
      String email, String password, String confirmpassword, List<String> associateddoctor , BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmpassword,
        "doctorIds": associateddoctor
        
      };

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addadmin'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingadmin = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Admin Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalladmins(context);
        Navigator.pop(context);
         notifyListeners();
      } else if(response.statusCode == 401){
        await refreshtoken(context);

        try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmpassword,
        "doctorIds": associateddoctor
      };
    

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addadmin'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addingadmin = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Admin Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalladmins(context);
        Navigator.pop(context);
         notifyListeners();
      } else {
        print(response.body);
        addingadmin = false;
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
      addingadmin = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
      }
       else {
        print(response.body);
        addingadmin = false;
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
      addingadmin = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
  }

Future<bool> toggleAdminStatus(String hospitalId, bool currentStatus, BuildContext context) async {
  togglingadminstatus = true;
  notifyListeners();

  // currentStatus true hai to disable karna hai, false hai to enable karna hai
  final endpoint = currentStatus ? 'disableadmin' : 'enableadmin';

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
      togglingadminstatus = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            currentStatus ? 'Admin disabled successfully' : 'Admin enabled successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        ));
      }

      await getalladmins(context);
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

      togglingadminstatus = false;
      notifyListeners();

      if (retryResponse.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              currentStatus ? 'Admin disabled successfully' : 'Admin enabled successfully',
              style: TextStyle(color: Colors.grey[50]),
            ),
          ));
        }
        await getalladmins(context);
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
      togglingadminstatus = false;
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
    togglingadminstatus = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}

Future<void> editAdmin({
  required String adminId,
  required String name,
  required String phone,
  required String email,
  required List<String> associateddoctor,
  required BuildContext context,
}) async {
  try {
    updatingadmin = true;
    notifyListeners();

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final headers = await DeviceHeaders.getDeviceHeaders();

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "phone": phone,
      "doctorIds": associateddoctor,
    };


    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/editadmin/$adminId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      updatingadmin = false;
      notifyListeners();

      final successSnackbar = SnackBar(
        backgroundColor: Colors.green[400],
        content: Text(
          'Admin updated successfully',
          style: TextStyle(color: Colors.grey[50]),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      await getalladmins(context);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final retryResponse = await http.put(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/editadmin/$adminId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      updatingadmin = false;
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        notifyListeners();
        final successSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Admin updated successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
        await getalladmins(context);
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(retryResponse.body);
        final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"] ?? "Something went wrong",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        notifyListeners();
      }
    } else {
      updatingadmin = false;
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(
          responseData["msg"] ?? "Something went wrong",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      notifyListeners();
    }
  } catch (e) {
    updatingadmin = false;
    notifyListeners();
    final error = SnackBar(content: Text(e.toString()));
    ScaffoldMessenger.of(context).showSnackBar(error);
  }
}

Future<void> changeadminpassword(String newPassword, String confirmPassword,
 String doctid, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();
      print(doctid);

      final Map<String, dynamic> requestBody = {
        "newPassword": newPassword,
        "confirm_password": confirmPassword,
      };

      String url = "${Constants.baseUrl}/api/v1/sales/resetpasswordadmin/$doctid";
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 401) {
        await refreshtoken(context);
        Constants.token = await secureStorage.readSecureData('token') ?? '';
        final retryHeaders = await DeviceHeaders.getDeviceHeaders();
        response = await http.patch(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer ${Constants.token}',
            'Content-Type': 'application/json',
            ...retryHeaders,
          },
          body: jsonEncode(requestBody),
        );
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "New password updated successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        Navigator.pop(context);
        notifyListeners();
      } else {
        final responseData = jsonDecode(response.body);
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (e) {
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }


///////////////////////////////// labtechnicians ///////////////////////////////////////

List<Map<String, dynamic>> labtechnicians = [];
bool addinglabtechnician = false;
bool togglinglabtechnicianstatus = false;





Future<void> getalllabtechnicians(BuildContext context) async {
    String url = "${Constants.baseUrl}/api/v1/sales/getalllabtechnicians";

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

        labtechnicians = List<Map<String, dynamic>>.from(responseData["data"]);
        print(labtechnicians);

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

            labtechnicians = List<Map<String, dynamic>>.from(responseData["data"]);
            print(labtechnicians);

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


Future<void> addLabtechnician(String name, String phone, 
      String email, String address, String password, String confirmpassword, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();


      final Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "password": password,
        "confirm_password": confirmpassword,
        
      };

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addlabtechnician'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addinglabtechnician = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Lab technician Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalllabtechnicians(context);
        Navigator.pop(context);
         notifyListeners();
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
        "password": password,
        "confirm_password": confirmpassword,
      };

    

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/addlabtechnician'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        addinglabtechnician = false;
        print(responseData);
        notifyListeners();

        final sucessSnackbar = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              'Lab technician Registered successfully',
              style: TextStyle(color: Colors.grey[50]),
            ));

        ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
        getalllabtechnicians(context);
        Navigator.pop(context);
         notifyListeners();
      } else {
        print(response.body);
        addinglabtechnician = false;
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
      addinglabtechnician = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
      }
       else {
        print(response.body);
        addinglabtechnician = false;
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
      addinglabtechnician = false;
      final error = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
      notifyListeners();
    }
  }

  Future<bool> toggleLabtechnicianStatus(String hospitalId, bool currentStatus, BuildContext context) async {
  togglinglabtechnicianstatus = true;
  notifyListeners();

  // currentStatus true hai to disable karna hai, false hai to enable karna hai
  final endpoint = currentStatus ? 'disablelabtechnician' : 'enablelabtechnician';

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
      togglinglabtechnicianstatus = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            currentStatus ? 'Lab Technician disabled successfully' : 'Lab Technician enabled successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        ));
      }

      await getalllabtechnicians(context);
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

      togglinglabtechnicianstatus = false;
      notifyListeners();

      if (retryResponse.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              currentStatus ? 'Lab Technician disabled successfully' : 'Lab Technician enabled successfully',
              style: TextStyle(color: Colors.grey[50]),
            ),
          ));
        }
        await getalllabtechnicians(context);
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
      togglinglabtechnicianstatus = false;
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
    togglinglabtechnicianstatus = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return false;
  }
}

bool updatingLabtechnician = false;

Future<void> editLabtechnician({
  required String adminId,
  required String name,
  required String phone,
  required String email,
  required String address,
  required BuildContext context,
}) async {
  try {
    updatingLabtechnician = true;
    notifyListeners();

    Constants.token = await secureStorage.readSecureData('token') ?? '';
    final headers = await DeviceHeaders.getDeviceHeaders();

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
    };


    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/v1/sales/editlabtechnician/$adminId'),
      headers: <String, String>{
        'Authorization': 'Bearer ${Constants.token}',
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      updatingLabtechnician = false;
      notifyListeners();

      final successSnackbar = SnackBar(
        backgroundColor: Colors.green[400],
        content: Text(
          'Lab Technician updated successfully',
          style: TextStyle(color: Colors.grey[50]),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
      await getalllabtechnicians(context);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      await refreshtoken(context);
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final retryResponse = await http.put(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/editlabtechnician/$adminId'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      updatingLabtechnician = false;
      if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
        notifyListeners();
        final successSnackbar = SnackBar(
          backgroundColor: Colors.green[400],
          content: Text(
            'Lab Technican updated successfully',
            style: TextStyle(color: Colors.grey[50]),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
        await getalllabtechnicians(context);
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(retryResponse.body);
        final snackbar = SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            responseData["msg"] ?? "Something went wrong",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        notifyListeners();
      }
    } else {
      updatingLabtechnician = false;
      final responseData = jsonDecode(response.body);
      final snackbar = SnackBar(
        backgroundColor: Colors.red[400],
        content: Text(
          responseData["msg"] ?? "Something went wrong",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      notifyListeners();
    }
  } catch (e) {
    updatingLabtechnician = false;
    notifyListeners();
    final error = SnackBar(content: Text(e.toString()));
    ScaffoldMessenger.of(context).showSnackBar(error);
  }
}

Future<void> changelabtechnicianpassword(String newPassword, String confirmPassword,
 String doctid, BuildContext context) async {
    try {
      Constants.token = await secureStorage.readSecureData('token') ?? '';
      final headers = await DeviceHeaders.getDeviceHeaders();
      print(doctid);

      final Map<String, dynamic> requestBody = {
        "newPassword": newPassword,
        "confirm_password": confirmPassword,
      };

      String url = "${Constants.baseUrl}/api/v1/sales/resetpasswordlabtechnician/$doctid";
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          ...headers,
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 401) {
        await refreshtoken(context);
        Constants.token = await secureStorage.readSecureData('token') ?? '';
        final retryHeaders = await DeviceHeaders.getDeviceHeaders();
        response = await http.patch(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer ${Constants.token}',
            'Content-Type': 'application/json',
            ...retryHeaders,
          },
          body: jsonEncode(requestBody),
        );
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        final msg = SnackBar(
            backgroundColor: Colors.green[400],
            content: Text(
              "New password updated successfully",
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
        Navigator.pop(context);
        notifyListeners();
      } else {
        final responseData = jsonDecode(response.body);
        final msg = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              responseData['msg'],
              style: TextStyle(color: Colors.grey[50]),
            ));
        ScaffoldMessenger.of(context).showSnackBar(msg);
      }
    } catch (e) {
      final error = SnackBar(
          backgroundColor: Colors.red[400], content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }


//////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> refreshtoken(BuildContext context) async {
    try {
      Constants.refreshtoken = await secureStorage.readSecureData('refreshtoken') ?? '';
            Constants.token = await secureStorage.readSecureData('token') ?? '';

      notifyListeners();

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/v1/sales/refreshtokensalesphone'),
        headers: <String, String>{
          'Authorization': 'Bearer ${Constants.token}',
          'Content-Type': 'application/json',
          // ...headers,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await secureStorage.writeSecureData('token', responseData['token']);
        await secureStorage.writeSecureData('refreshtoken', responseData['refreshToken']);
        Constants.token = responseData['token'];
        Constants.refreshtoken = responseData['refreshToken'];
        print("Constants.doctortoken ${Constants.token}");
        print("Constants.doctorrefreshtoken ${Constants.refreshtoken}");
        notifyListeners();

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

   void notify() {
    notifyListeners();
  }
}
