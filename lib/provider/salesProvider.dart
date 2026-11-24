// import 'dart:convert';
// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:sales_mobile_app/routes/app_router.dart';
// import 'package:sales_mobile_app/services/DeviceHeader.dart';
// import 'package:sales_mobile_app/services/constants.dart';
// import 'package:sales_mobile_app/services/secureStorage.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';




// class Salesprovider extends ChangeNotifier {
//   final SecureStorage secureStorage = SecureStorage();


// //////////////////////////Hospitals//////////////////////////////////////

// List<Map<String, dynamic>> allhospitals = [];
// List<Map<String, dynamic>> allhospitalnames = [];

// Map<String, dynamic> allprofiles = {};   
// //  List<Map<String, dynamic>> allprofiles = [];
// bool addinghospital = false;
// bool iseditinghospital = false;
// bool uploadinglogo = false;

// Future<void> getallhospitals(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getallhospitals";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         allhospitals = List<Map<String, dynamic>>.from(responseData["data"]);
//         print(allhospitals);

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             allhospitals = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(allhospitals);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }

// Future<void> getallhospitalsname(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getallhospitalnames";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         allhospitalnames = List<Map<String, dynamic>>.from(responseData["data"]);
//         print("hospital names $allhospitalnames");

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             allhospitalnames = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(allhospitalnames);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }


//   Future<void> addHospital(String name, String phone, 
//       String email, String address, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "address": address,
//       };

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addhospital'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addinghospital = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Hospital Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getallhospitals(context);
//         Navigator.pop(context);
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);

//         try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "address": address,
//       };

    

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addhospital'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addinghospital = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Hospital Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getallhospitals(context);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         print(response.body);
//         addinghospital = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addinghospital = false;
//         print(addinghospital);
//         notifyListeners();
//       }
//     } catch (e) {
//       addinghospital = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addinghospital = false;
//         print(addinghospital);
//       notifyListeners();
//     }
//       }
//        else {
//         print(response.body);
//         addinghospital = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         addinghospital = false;
//         print(addinghospital);
//         notifyListeners();
//       }
//     } catch (e) {
//       addinghospital = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       addinghospital = false;
//         print(addinghospital);
//       notifyListeners();
//     }
//   }


// Future<void> edithospital(String id, String name, String address,
//       String email, String phone, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "address": address,
//         "email": email,
//         "phone": phone
//       };

//       String url = "${Constants.baseUrl}/api/v1/sales/edithospital/$id";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         iseditinghospital = false;
//         final responseData = jsonDecode(response.body);
//         await getallhospitals(context);

//         notifyListeners();
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Hospital details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
      
//         Navigator.pop(context);

//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);

//         try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();

//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "address": address,
//         "email": email,
//         "phone": phone
//       };
      

//       String url = "${Constants.baseUrl}/api/v1/sales/edithospital/$id";
//       final response = await http.put(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         iseditinghospital = false;
//         final responseData = jsonDecode(response.body);
//         await getallhospitals(context);

//         notifyListeners();
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "Patient details updated Successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
      
//         Navigator.pop(context);

//         notifyListeners();
//       } else {
//         iseditinghospital = false;
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         notifyListeners();
//       }
//     } catch (e) {
//       iseditinghospital = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//       }
//        else {
//         iseditinghospital = false;
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         notifyListeners();
//       }
//     } catch (e) {
//       iseditinghospital = false;
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//   }


// Future<bool> uploadHospitalLogo(String hospitalId, File file, BuildContext context) async {
//   uploadinglogo = true;
//   notifyListeners();

//   final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//   print('DETECTED MIME TYPE: $mimeType');

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     var request = http.MultipartRequest(
//       'PUT',
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/uploadhospitallogo/$hospitalId'),
//     );

//     request.headers['Authorization'] = 'Bearer ${Constants.token}';
//     request.headers.addAll(deviceHeaders);
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'logo',
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

//       await getallhospitals(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       var retryRequest = http.MultipartRequest(
//         'PUT',
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/uploadhospitallogo/$hospitalId'),
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
//         await getallhospitals(context);
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


// //////////////////////////Delete Hospital Logo//////////////////////////////////////

// bool deletinglogo = false;

// Future<bool> deleteHospitalLogo(String hospitalId, BuildContext context) async {
//   deletinglogo = true;
//   notifyListeners();

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.delete(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/deletehospitallogo/$hospitalId'),
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

//       await getallhospitals(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.delete(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/deletehospitallogo/$hospitalId'),
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
//         await getallhospitals(context);
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

// String _extractErrorMessage(http.Response response) {
//   try {
//     final decoded = jsonDecode(response.body);
//     return decoded['msg'] ?? 'Something went wrong';
//   } catch (e) {
//     return 'Something went wrong (status: ${response.statusCode})';
//   }
// }

// //////////////////////////Enable/Disable Hospital//////////////////////////////////////

// bool togglinghospitalstatus = false;

// Future<bool> toggleHospitalStatus(String hospitalId, bool currentStatus, BuildContext context) async {
//   togglinghospitalstatus = true;
//   notifyListeners();

//   // currentStatus true hai to disable karna hai, false hai to enable karna hai
//   final endpoint = currentStatus ? 'disablehospital' : 'enablehospital';

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       togglinghospitalstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             currentStatus ? 'Hospital disabled successfully' : 'Hospital enabled successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         ));
//       }

//       await getallhospitals(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.patch(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       togglinghospitalstatus = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               currentStatus ? 'Hospital disabled successfully' : 'Hospital enabled successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ),
//           ));
//         }
//         await getallhospitals(context);
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
//       togglinghospitalstatus = false;
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
//     togglinghospitalstatus = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }


// Future<void> getallprofiles(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/myprofile";
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     print(Constants.token);
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         allprofiles = Map<String, dynamic>.from(responseData["data"]);   // ✅ Map se convert
//         print(allprofiles);
//         print(responseData);

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);
//         Constants.token = await secureStorage.readSecureData('token') ?? '';
//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             allprofiles = Map<String, dynamic>.from(responseData["data"]);   // ✅ yahan bhi

//             print('profile : $allprofiles');
//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             print('No profile found.');
//           } else {
//             print(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         print('No profile found.');
//       } else {
//         print(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }

// //////////////////////////////////// Doctors /////////////////////////////////////////////////
// ///

// List<Map<String, dynamic>> alldoctors = [];
// List<Map<String, dynamic>> alldoctorsnames = [];
// bool addingdoctor = false;
// bool togglingdoctorstatus = false;
// bool updatingdoctorprice = false;




// Future<void> getalldoctors(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getalldoctors";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         alldoctors = List<Map<String, dynamic>>.from(responseData["data"]);
//         print(alldoctors);

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             alldoctors = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(alldoctors);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }


// Future<void> getalldoctorsname(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getalldoctorsname";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         alldoctorsnames = List<Map<String, dynamic>>.from(responseData["data"]);
//         print("doctors names $alldoctorsnames");

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             alldoctorsnames = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(alldoctorsnames);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }

// Future<void> addDoctor(
// String name, 
// String phone,
// String alternativephone,
// String gender,
//       String email, 
//       String password, 
//       String confirmpassword,
//       String qualification,
//       String specialization,
//       String registrationnumber,
//       String yearofregistration,
//       String boardofregistration,
//       String priceperdiagnosis,
//       List<String> associatedhospital, 
//        BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "email": email,
//         "phone": phone,
//         "password": password,
//         "confirm_password": confirmpassword,
//         "qualification": qualification,
//         "specialization": specialization,
//         "doctorRegistrationNumber": registrationnumber,
//         "year_of_registration": yearofregistration,
//         "board_of_registration": boardofregistration,
//         "price": priceperdiagnosis,
//         "hospitalIds": associatedhospital,
//       };

//        if(alternativephone.isNotEmpty){
//       requestBody['phone2'] = alternativephone;
//     }
      

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/adddoctor'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingdoctor = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Doctor Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalldoctors(context);
//         Navigator.pop(context);
//         notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);

//         try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "gender": gender,
//         "email": email,
//         "phone": phone,
//         "password": password,
//         "confirm_password": confirmpassword,
//         "qualification": qualification,
//         "specialization": specialization,
//         "doctorRegistrationNumber": registrationnumber,
//         "year_of_registration": yearofregistration,
//         "board_of_registration": boardofregistration,
//         "price": priceperdiagnosis,
//         "hospitalIds": associatedhospital,
//       };
//        if(alternativephone.isNotEmpty){
//       requestBody['phone2'] = alternativephone;
//     }
    

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/adddoctor'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingdoctor = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Doctor Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalldoctors(context);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         print(response.body);
//         addingdoctor = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addingdoctor = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//       }
//        else {
//         print(response.body);
//         addingdoctor = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addingdoctor = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//   }

//   Future<bool> toggleDoctorStatus(String hospitalId, bool currentStatus, BuildContext context) async {
//   togglingdoctorstatus = true;
//   notifyListeners();

//   // currentStatus true hai to disable karna hai, false hai to enable karna hai
//   final endpoint = currentStatus ? 'disabledoctor' : 'enabledoctor';

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       togglinghospitalstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             currentStatus ? 'Doctor disabled successfully' : 'Doctor enabled successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         ));
//       }

//       await getalldoctors(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.patch(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       togglingdoctorstatus = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               currentStatus ? 'Doctor disabled successfully' : 'Doctor enabled successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ),
//           ));
//         }
//         await getalldoctors(context);
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
//       togglingdoctorstatus = false;
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
//     togglingdoctorstatus = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

// List<dynamic> priceHistory = [];
// bool fetchingPriceHistory = false;

// Future<void> getPriceHistory(String doctorId, BuildContext context) async {
//   try {
//     fetchingPriceHistory = true;
//     notifyListeners();

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.get(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/getalldoctorprice/$doctorId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...headers,
//       },
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       priceHistory = responseData['data'] ?? [];
//       fetchingPriceHistory = false;
//       notifyListeners();
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final retryResponse = await http.get(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/pricehistory/$doctorId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//       );
//       if (retryResponse.statusCode == 200) {
//         final responseData = jsonDecode(retryResponse.body);
//         priceHistory = responseData['data'] ?? [];
//       }
//       fetchingPriceHistory = false;
//       notifyListeners();
//     } else {
//       fetchingPriceHistory = false;
//       priceHistory = [];
//       notifyListeners();
//     }
//   } catch (e) {
//     fetchingPriceHistory = false;
//     priceHistory = [];
//     notifyListeners();
//     final error = SnackBar(content: Text(e.toString()));
//     ScaffoldMessenger.of(context).showSnackBar(error);
//   }
// }

// bool updatingdoctor = false;

// Future<void> editDoctor({
//   required String doctorId,
//   required String name,
//   required String phone,
//   required String alternativephone,
//   required String gender,
//   required String email,
//   required String password,
//   required String confirmpassword,
//   required String qualification,
//   required String specialization,
//   required String registrationnumber,
//   required String yearofregistration,
//   required String boardofregistration,
//   required List<String> associatedhospital,
//   required BuildContext context,
// }) async {
//   try {
//     updatingdoctor = true;
//     notifyListeners();

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     final Map<String, dynamic> requestBody = {
//       "name": name,
//       "gender": gender,
//       "email": email,
//       "phone": phone,
//       "qualification": qualification,
//       "specialization": specialization,
//       "doctorRegistrationNumber": registrationnumber,
//       "year_of_registration": yearofregistration,
//       "board_of_registration": boardofregistration,
//       "hospitalIds": associatedhospital,
//     };

//     // Password sirf tab bhejo jab user ne naya password type kiya ho
//     if (password.isNotEmpty) {
//       requestBody["password"] = password;
//       requestBody["confirm_password"] = confirmpassword;
//     }
//     if(alternativephone.isNotEmpty){
//       requestBody['phone2'] = alternativephone;
//     }

//     final response = await http.put(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/editdoctor/$doctorId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...headers,
//       },
//       body: jsonEncode(requestBody),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       updatingdoctor = false;
//       notifyListeners();

//       final successSnackbar = SnackBar(
//         backgroundColor: Colors.green[400],
//         content: Text(
//           'Doctor updated successfully',
//           style: TextStyle(color: Colors.grey[50]),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//       await getalldoctors(context);
//       Navigator.pop(context);
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final retryResponse = await http.put(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/editdoctor/$doctorId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       updatingdoctor = false;
//       if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
//         notifyListeners();
//         final successSnackbar = SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             'Doctor updated successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//         await getalldoctors(context);
//         updatingdoctor = false;
//         Navigator.pop(context);
//       } else {
//         final responseData = jsonDecode(retryResponse.body);
//         final snackbar = SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(
//             responseData["msg"] ?? "Something went wrong",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         updatingdoctor = false;
//         notifyListeners();
//       }
//     } else {
//       updatingdoctor = false;
//       final responseData = jsonDecode(response.body);
//       final snackbar = SnackBar(
//         backgroundColor: Colors.red[400],
//         content: Text(
//           responseData["msg"] ?? "Something went wrong",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       updatingdoctor = false;
//       notifyListeners();
//     }
//   } catch (e) {
//     updatingdoctor = false;
//     notifyListeners();
//     final error = SnackBar(content: Text(e.toString()));
//     ScaffoldMessenger.of(context).showSnackBar(error);
//   }
// }

// Future<void> changedoctorpassword(String newPassword, String confirmPassword,
//  String doctid, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();
//       print(doctid);

//       final Map<String, dynamic> requestBody = {
//         "newPassword": newPassword,
//         "confirm_password": confirmPassword,
//       };

//       String url = "${Constants.baseUrl}/api/v1/sales/resetpassworddoctor/$doctid";
//       var response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 401) {
//         await refreshtoken(context);
//         Constants.token = await secureStorage.readSecureData('token') ?? '';
//         final retryHeaders = await DeviceHeaders.getDeviceHeaders();
//         response = await http.patch(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Authorization': 'Bearer ${Constants.token}',
//             'Content-Type': 'application/json',
//             ...retryHeaders,
//           },
//           body: jsonEncode(requestBody),
//         );
//       }

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "New password updated successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }

//   Future<void> changeDoctorValidity({
//   required String doctorId,
//   required String validTill,
//   required BuildContext context,
// }) async {
//   try {
   
// final headers = await DeviceHeaders.getDeviceHeaders();
//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/changedoctorvalidity/$doctorId'),
//        headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//       body: jsonEncode({'validdate': validTill}),
//     );

//     if (response.statusCode == 200) {
//       final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Doctor Validity Updated successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalldoctors(context);
//          notifyListeners();
//     } else if(response.statusCode == 401){
//     await  refreshtoken(context);

//       try {
  
// final headers = await DeviceHeaders.getDeviceHeaders();
//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/changedoctorvalidity/$doctorId'),
//        headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//       body: jsonEncode({'validTill': validTill}),
//     );

//     if (response.statusCode == 200) {
//       final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Doctor Validity Updated successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//        getalldoctors(context);
//          notifyListeners();
//     } else {
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//     }
//   } catch (e) {
//     print(e);
//     // error handling
//   } finally {
   
//     notifyListeners();
//   }
//     }
//     else {
     
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//     }
//   } catch (e) {
//     print(e);
//     // error handling
//   } finally {
  
//     notifyListeners();
//   }
// }

// Future<void> updateDoctorPrice({
//   required String doctorId,
//   required String price,
//   required String effectiveDate,
//   required BuildContext context,
// }) async {
//   try {
//     print("button clicked");
//     updatingdoctorprice = true;
//     notifyListeners();
// final headers = await DeviceHeaders.getDeviceHeaders();
//     final response = await http.put(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/updatedoctorprice/$doctorId'),
//        headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//       body: jsonEncode({'price': price,
//       'effectiveFrom': effectiveDate,
//       }),
//     );
//  final responseData = jsonDecode(response.body);
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//          notifyListeners();
//     } else if(response.statusCode == 401){
//     await  refreshtoken(context);

//       try {
//     updatingdoctorprice = true;
//     notifyListeners();
// final headers = await DeviceHeaders.getDeviceHeaders();
//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/updatedoctorprice/$doctorId'),
//        headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//        body: jsonEncode({'price': price,
//       'effectiveFrom': effectiveDate,
//       }),
//     );
//      final responseData = jsonDecode(response.body);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               responseData["msg"],
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//        getalldoctors(context);
//          notifyListeners();
//     } else {
//       updatingdoctorprice = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//     }
//   } catch (e) {
//     print(e);
//     // error handling
//   } finally {
//     updatingdoctorprice = false;
//     notifyListeners();
//   }
//     }
//     else {
//       updatingdoctorprice = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//     }
//   } catch (e) {
//     print(e);
//     // error handling
//   } finally {
//     updatingdoctorprice = false;
//     notifyListeners();
//   }
// }


// ////////////////////////////////////////// Admins //////////////////////////////////////////////

// List<Map<String, dynamic>> alladmins = [];
// bool addingadmin = false;
// bool togglingadminstatus = false;
// bool updatingadmin = false;



// Future<void> getalladmins(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getalladmins";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         alladmins = List<Map<String, dynamic>>.from(responseData["data"]);
//         print(alladmins);

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             alladmins = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(alladmins);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }

// Future<void> addAdmin(String name, String phone, 
//       String email, String password, String confirmpassword, List<String> associateddoctor , BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "password": password,
//         "confirm_password": confirmpassword,
//         "doctorIds": associateddoctor
        
//       };

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addadmin'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingadmin = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Admin Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalladmins(context);
//         Navigator.pop(context);
//          notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);

//         try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "password": password,
//         "confirm_password": confirmpassword,
//         "doctorIds": associateddoctor
//       };
    

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addadmin'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addingadmin = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Admin Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalladmins(context);
//         Navigator.pop(context);
//          notifyListeners();
//       } else {
//         print(response.body);
//         addingadmin = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addingadmin = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//       }
//        else {
//         print(response.body);
//         addingadmin = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addingadmin = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//   }

// Future<bool> toggleAdminStatus(String hospitalId, bool currentStatus, BuildContext context) async {
//   togglingadminstatus = true;
//   notifyListeners();

//   // currentStatus true hai to disable karna hai, false hai to enable karna hai
//   final endpoint = currentStatus ? 'disableadmin' : 'enableadmin';

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       togglingadminstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             currentStatus ? 'Admin disabled successfully' : 'Admin enabled successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         ));
//       }

//       await getalladmins(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.patch(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       togglingadminstatus = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               currentStatus ? 'Admin disabled successfully' : 'Admin enabled successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ),
//           ));
//         }
//         await getalladmins(context);
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
//       togglingadminstatus = false;
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
//     togglingadminstatus = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

// Future<void> editAdmin({
//   required String adminId,
//   required String name,
//   required String phone,
//   required String email,
//   required List<String> associateddoctor,
//   required BuildContext context,
// }) async {
//   try {
//     updatingadmin = true;
//     notifyListeners();

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     final Map<String, dynamic> requestBody = {
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "doctorIds": associateddoctor,
//     };


//     final response = await http.put(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/editadmin/$adminId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...headers,
//       },
//       body: jsonEncode(requestBody),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       updatingadmin = false;
//       notifyListeners();

//       final successSnackbar = SnackBar(
//         backgroundColor: Colors.green[400],
//         content: Text(
//           'Admin updated successfully',
//           style: TextStyle(color: Colors.grey[50]),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//       await getalladmins(context);
//       Navigator.pop(context);
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final retryResponse = await http.put(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/editadmin/$adminId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       updatingadmin = false;
//       if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
//         notifyListeners();
//         final successSnackbar = SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             'Admin updated successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//         await getalladmins(context);
//         Navigator.pop(context);
//       } else {
//         final responseData = jsonDecode(retryResponse.body);
//         final snackbar = SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(
//             responseData["msg"] ?? "Something went wrong",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } else {
//       updatingadmin = false;
//       final responseData = jsonDecode(response.body);
//       final snackbar = SnackBar(
//         backgroundColor: Colors.red[400],
//         content: Text(
//           responseData["msg"] ?? "Something went wrong",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       notifyListeners();
//     }
//   } catch (e) {
//     updatingadmin = false;
//     notifyListeners();
//     final error = SnackBar(content: Text(e.toString()));
//     ScaffoldMessenger.of(context).showSnackBar(error);
//   }
// }

// Future<void> changeadminpassword(String newPassword, String confirmPassword,
//  String doctid, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();
//       print(doctid);

//       final Map<String, dynamic> requestBody = {
//         "newPassword": newPassword,
//         "confirm_password": confirmPassword,
//       };

//       String url = "${Constants.baseUrl}/api/v1/sales/resetpasswordadmin/$doctid";
//       var response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 401) {
//         await refreshtoken(context);
//         Constants.token = await secureStorage.readSecureData('token') ?? '';
//         final retryHeaders = await DeviceHeaders.getDeviceHeaders();
//         response = await http.patch(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Authorization': 'Bearer ${Constants.token}',
//             'Content-Type': 'application/json',
//             ...retryHeaders,
//           },
//           body: jsonEncode(requestBody),
//         );
//       }

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "New password updated successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }


// ///////////////////////////////// labtechnicians ///////////////////////////////////////

// List<Map<String, dynamic>> labtechnicians = [];
// bool addinglabtechnician = false;
// bool togglinglabtechnicianstatus = false;





// Future<void> getalllabtechnicians(BuildContext context) async {
//     String url = "${Constants.baseUrl}/api/v1/sales/getalllabtechnicians";

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${Constants.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);

//         labtechnicians = List<Map<String, dynamic>>.from(responseData["data"]);
//         print(labtechnicians);

//         notifyListeners();
//       } else if (response.statusCode == 401) {
//         await refreshtoken(context);

//         Constants.token = await secureStorage.readSecureData('token') ?? '';

//         try {
//           final response = await http.get(
//             Uri.parse(url),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer ${Constants.token}',
//             },
//           );

//           if (response.statusCode == 200) {
//             final responseData = jsonDecode(response.body);
//             print(responseData);

//             labtechnicians = List<Map<String, dynamic>>.from(responseData["data"]);
//             print(labtechnicians);

//             notifyListeners();
//           } else if (response.statusCode == 404) {
//             final responseData = jsonDecode(response.body);
//           }
//         } catch (e) {
//           print(e);
//         }
//       } else if (response.statusCode == 404) {
//         final responseData = jsonDecode(response.body);
//       }
//     } catch (e) {
//       print(e);
//     }
// }


// Future<void> addLabtechnician(String name, String phone, 
//       String email, String address, String password, String confirmpassword, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "address": address,
//         "password": password,
//         "confirm_password": confirmpassword,
        
//       };

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addlabtechnician'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addinglabtechnician = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Lab technician Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalllabtechnicians(context);
//         Navigator.pop(context);
//          notifyListeners();
//       } else if(response.statusCode == 401){
//         await refreshtoken(context);

//         try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();


//       final Map<String, dynamic> requestBody = {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "address": address,
//         "password": password,
//         "confirm_password": confirmpassword,
//       };

    

//       final response = await http.post(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/addlabtechnician'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         addinglabtechnician = false;
//         print(responseData);
//         notifyListeners();

//         final sucessSnackbar = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               'Lab technician Registered successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ));

//         ScaffoldMessenger.of(context).showSnackBar(sucessSnackbar);
//         getalllabtechnicians(context);
//         Navigator.pop(context);
//          notifyListeners();
//       } else {
//         print(response.body);
//         addinglabtechnician = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addinglabtechnician = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//       }
//        else {
//         print(response.body);
//         addinglabtechnician = false;
//         final responseData = jsonDecode(response.body);
//         final snackbar = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData["msg"],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } catch (e) {
//       addinglabtechnician = false;
//       final error = SnackBar(content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//       notifyListeners();
//     }
//   }

//   Future<bool> toggleLabtechnicianStatus(String hospitalId, bool currentStatus, BuildContext context) async {
//   togglinglabtechnicianstatus = true;
//   notifyListeners();

//   // currentStatus true hai to disable karna hai, false hai to enable karna hai
//   final endpoint = currentStatus ? 'disablelabtechnician' : 'enablelabtechnician';

//   try {
//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final deviceHeaders = await DeviceHeaders.getDeviceHeaders();

//     final response = await http.patch(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...deviceHeaders,
//       },
//     );

//     if (response.statusCode == 200) {
//       togglinglabtechnicianstatus = false;
//       notifyListeners();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             currentStatus ? 'Lab Technician disabled successfully' : 'Lab Technician enabled successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         ));
//       }

//       await getalllabtechnicians(context);
//       return true;
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';

//       final retryResponse = await http.patch(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/$endpoint/$hospitalId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...deviceHeaders,
//         },
//       );

//       togglinglabtechnicianstatus = false;
//       notifyListeners();

//       if (retryResponse.statusCode == 200) {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               currentStatus ? 'Lab Technician disabled successfully' : 'Lab Technician enabled successfully',
//               style: TextStyle(color: Colors.grey[50]),
//             ),
//           ));
//         }
//         await getalllabtechnicians(context);
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
//       togglinglabtechnicianstatus = false;
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
//     togglinglabtechnicianstatus = false;
//     notifyListeners();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     return false;
//   }
// }

// bool updatingLabtechnician = false;

// Future<void> editLabtechnician({
//   required String adminId,
//   required String name,
//   required String phone,
//   required String email,
//   required String address,
//   required BuildContext context,
// }) async {
//   try {
//     updatingLabtechnician = true;
//     notifyListeners();

//     Constants.token = await secureStorage.readSecureData('token') ?? '';
//     final headers = await DeviceHeaders.getDeviceHeaders();

//     final Map<String, dynamic> requestBody = {
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "address": address,
//     };


//     final response = await http.put(
//       Uri.parse('${Constants.baseUrl}/api/v1/sales/editlabtechnician/$adminId'),
//       headers: <String, String>{
//         'Authorization': 'Bearer ${Constants.token}',
//         'Content-Type': 'application/json',
//         ...headers,
//       },
//       body: jsonEncode(requestBody),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       updatingLabtechnician = false;
//       notifyListeners();

//       final successSnackbar = SnackBar(
//         backgroundColor: Colors.green[400],
//         content: Text(
//           'Lab Technician updated successfully',
//           style: TextStyle(color: Colors.grey[50]),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//       await getalllabtechnicians(context);
//       Navigator.pop(context);
//     } else if (response.statusCode == 401) {
//       await refreshtoken(context);
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final retryResponse = await http.put(
//         Uri.parse('${Constants.baseUrl}/api/v1/sales/editlabtechnician/$adminId'),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       updatingLabtechnician = false;
//       if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
//         notifyListeners();
//         final successSnackbar = SnackBar(
//           backgroundColor: Colors.green[400],
//           content: Text(
//             'Lab Technican updated successfully',
//             style: TextStyle(color: Colors.grey[50]),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
//         await getalllabtechnicians(context);
//         Navigator.pop(context);
//       } else {
//         final responseData = jsonDecode(retryResponse.body);
//         final snackbar = SnackBar(
//           backgroundColor: Colors.red[400],
//           content: Text(
//             responseData["msg"] ?? "Something went wrong",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//         notifyListeners();
//       }
//     } else {
//       updatingLabtechnician = false;
//       final responseData = jsonDecode(response.body);
//       final snackbar = SnackBar(
//         backgroundColor: Colors.red[400],
//         content: Text(
//           responseData["msg"] ?? "Something went wrong",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       notifyListeners();
//     }
//   } catch (e) {
//     updatingLabtechnician = false;
//     notifyListeners();
//     final error = SnackBar(content: Text(e.toString()));
//     ScaffoldMessenger.of(context).showSnackBar(error);
//   }
// }

// Future<void> changelabtechnicianpassword(String newPassword, String confirmPassword,
//  String doctid, BuildContext context) async {
//     try {
//       Constants.token = await secureStorage.readSecureData('token') ?? '';
//       final headers = await DeviceHeaders.getDeviceHeaders();
//       print(doctid);

//       final Map<String, dynamic> requestBody = {
//         "newPassword": newPassword,
//         "confirm_password": confirmPassword,
//       };

//       String url = "${Constants.baseUrl}/api/v1/sales/resetpasswordlabtechnician/$doctid";
//       var response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Authorization': 'Bearer ${Constants.token}',
//           'Content-Type': 'application/json',
//           ...headers,
//         },
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 401) {
//         await refreshtoken(context);
//         Constants.token = await secureStorage.readSecureData('token') ?? '';
//         final retryHeaders = await DeviceHeaders.getDeviceHeaders();
//         response = await http.patch(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Authorization': 'Bearer ${Constants.token}',
//             'Content-Type': 'application/json',
//             ...retryHeaders,
//           },
//           body: jsonEncode(requestBody),
//         );
//       }

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//         final msg = SnackBar(
//             backgroundColor: Colors.green[400],
//             content: Text(
//               "New password updated successfully",
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//         Navigator.pop(context);
//         notifyListeners();
//       } else {
//         final responseData = jsonDecode(response.body);
//         final msg = SnackBar(
//             backgroundColor: Colors.red[400],
//             content: Text(
//               responseData['msg'],
//               style: TextStyle(color: Colors.grey[50]),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(msg);
//       }
//     } catch (e) {
//       final error = SnackBar(
//           backgroundColor: Colors.red[400], content: Text(e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(error);
//     }
//   }


// //////////////////////////////////////////////////////////////////////////////////////////////

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

//    void notify() {
//     notifyListeners();
//   }
// }


// lib/provider/salesProvider.dart
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

class Salesprovider extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();

  String get _api => '${Constants.baseUrl}/api/v1/sales';

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

  String _okMessage(http.Response res, String fallback) {
    try {
      return jsonDecode(res.body)['msg']?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  /// GET list: success par data list, warna null (provider ka data change nahi hota).
  Future<List<Map<String, dynamic>>?> _fetchList(String path) async {
    try {
      final res = await authGet('$_api/$path');
      if (res == null) return null;
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body)['data']);
      }
      if (res.statusCode != 404) print(res.body);
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// Mutating call (device headers ke saath, jaise pehle the).
  Future<http.Response?> _mutate(String method, String path,
      {Map<String, dynamic>? body}) {
    final url = '$_api/$path';
    final b = body == null ? null : jsonEncode(body);
    switch (method) {
      case 'PUT':
        return authPut(url, body: b, withDeviceHeaders: true);
      case 'PATCH':
        return authPatch(url, body: b, withDeviceHeaders: true);
      case 'DELETE':
        return authDelete(url, body: b, withDeviceHeaders: true);
      default:
        return authPost(url, body: b, withDeviceHeaders: true);
    }
  }

  /// Enable/disable toggle (hospital / doctor / admin / lab technician sab ke liye).
  Future<bool> _toggle({
    required String enableEp,
    required String disableEp,
    required String label,
    required String id,
    required bool currentStatus,
    required void Function(bool) setBusy,
    required Future<void> Function() reload,
    required BuildContext context,
  }) async {
    setBusy(true);
    notifyListeners();
    // currentStatus true hai to disable karna hai, false hai to enable
    final ep = currentStatus ? disableEp : enableEp;
    try {
      final res = await authPatch('$_api/$ep/$id', withDeviceHeaders: true);
      setBusy(false);
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200) {
        _snack(context,
            '$label ${currentStatus ? 'disabled' : 'enabled'} successfully');
        await reload();
        return true;
      }
      print('Toggle status failed: ${res.statusCode} - ${res.body}');
      _snack(context, _extractErrorMessage(res), error: true);
      return false;
    } catch (e) {
      print('Toggle status exception: $e');
      setBusy(false);
      notifyListeners();
      _snack(context, e.toString(), error: true);
      return false;
    }
  }

  Future<void> _changePassword(String path, String newPassword,
      String confirmPassword, BuildContext context) async {
    try {
      final res = await _mutate('POST', path, body: {
        "newPassword": newPassword,
        "confirm_password": confirmPassword,
      });
      if (res == null) return;

      if (res.statusCode == 200) {
        _snack(context, "New password updated successfully");
        if (context.mounted) Navigator.pop(context);
        notifyListeners();
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
      }
    } catch (e) {
      _snack(context, e.toString(), error: true);
    }
  }

  // ═══════════════════════════ Hospitals ═══════════════════════════

  List<Map<String, dynamic>> allhospitals = [];
  List<Map<String, dynamic>> allhospitalnames = [];
  Map<String, dynamic> allprofiles = {};
  bool addinghospital = false;
  bool iseditinghospital = false;
  bool uploadinglogo = false;
  bool deletinglogo = false;
  bool togglinghospitalstatus = false;

  Future<void> getallhospitals(BuildContext context) async {
    final l = await _fetchList('getallhospitals');
    if (l != null) {
      allhospitals = l;
      notifyListeners();
    }
  }

  Future<void> getallhospitalsname(BuildContext context) async {
    final l = await _fetchList('getallhospitalnames');
    if (l != null) {
      allhospitalnames = l;
      notifyListeners();
    }
  }

  Future<void> addHospital(String name, String phone, String email,
      String address, BuildContext context) async {
    try {
      final res = await _mutate('POST', 'addhospital', body: {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      });
      addinghospital = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Hospital Registered successfully');
        getallhospitals(context);
        if (context.mounted) Navigator.pop(context);
      } else {
        print(res.body);
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      addinghospital = false;
      _snack(context, e.toString(), error: true);
      notifyListeners();
    }
  }

  Future<void> edithospital(String id, String name, String address,
      String email, String phone, BuildContext context) async {
    try {
      final res = await _mutate('PUT', 'edithospital/$id', body: {
        "name": name,
        "address": address,
        "email": email,
        "phone": phone,
      });
      iseditinghospital = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 200) {
        await getallhospitals(context);
        notifyListeners();
        _snack(context, "Hospital details updated Successfully");
        if (context.mounted) Navigator.pop(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      iseditinghospital = false;
      _snack(context, e.toString(), error: true);
      notifyListeners();
    }
  }

  Future<bool> uploadHospitalLogo(
      String hospitalId, File file, BuildContext context) async {
    uploadinglogo = true;
    notifyListeners();

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    try {
      final res = await authMultipart(
        '$_api/uploadhospitallogo/$hospitalId',
        field: 'logo',
        filePaths: [file.path],
        method: 'PUT',
        contentType: MediaType.parse(mimeType),
      );
      uploadinglogo = false;
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200 || res.statusCode == 201) {
        _snack(context, 'Logo uploaded successfully');
        await getallhospitals(context);
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
      final res = await _mutate('DELETE', 'deletehospitallogo/$hospitalId');
      deletinglogo = false;
      notifyListeners();
      if (res == null) return false;

      if (res.statusCode == 200) {
        _snack(context, 'Logo deleted successfully');
        await getallhospitals(context);
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

  Future<bool> toggleHospitalStatus(
      String hospitalId, bool currentStatus, BuildContext context) {
    return _toggle(
      enableEp: 'enablehospital',
      disableEp: 'disablehospital',
      label: 'Hospital',
      id: hospitalId,
      currentStatus: currentStatus,
      setBusy: (v) => togglinghospitalstatus = v,
      reload: () => getallhospitals(context),
      context: context,
    );
  }

  Future<void> getallprofiles(BuildContext context) async {
    try {
      final res = await authGet('$_api/myprofile');
      if (res == null) return;

      if (res.statusCode == 200) {
        allprofiles =
            Map<String, dynamic>.from(jsonDecode(res.body)["data"]);
        notifyListeners();
      } else if (res.statusCode == 404) {
        print('No profile found.');
      } else {
        print(res.body);
      }
    } catch (e) {
      print(e);
    }
  }

  // ═══════════════════════════ Doctors ═══════════════════════════

  List<Map<String, dynamic>> alldoctors = [];
  List<Map<String, dynamic>> alldoctorsnames = [];
  bool addingdoctor = false;
  bool togglingdoctorstatus = false;
  bool updatingdoctorprice = false;
  bool updatingdoctor = false;

  Future<void> getalldoctors(BuildContext context) async {
    final l = await _fetchList('getalldoctors');
    if (l != null) {
      alldoctors = l;
      notifyListeners();
    }
  }

  Future<void> getalldoctorsname(BuildContext context) async {
    final l = await _fetchList('getalldoctorsname');
    if (l != null) {
      alldoctorsnames = l;
      notifyListeners();
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
      final Map<String, dynamic> body = {
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
      if (alternativephone.isNotEmpty) body['phone2'] = alternativephone;

      final res = await _mutate('POST', 'adddoctor', body: body);
      addingdoctor = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Doctor Registered successfully');
        getalldoctors(context);
        if (context.mounted) Navigator.pop(context);
        notifyListeners();
      } else {
        print(res.body);
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      addingdoctor = false;
      _snack(context, e.toString(), error: true);
      notifyListeners();
    }
  }

  Future<bool> toggleDoctorStatus(
      String doctorId, bool currentStatus, BuildContext context) {
    return _toggle(
      enableEp: 'enabledoctor',
      disableEp: 'disabledoctor',
      label: 'Doctor',
      id: doctorId,
      currentStatus: currentStatus,
      setBusy: (v) => togglingdoctorstatus = v,
      reload: () => getalldoctors(context),
      context: context,
    );
  }

  List<dynamic> priceHistory = [];
  bool fetchingPriceHistory = false;

  Future<void> getPriceHistory(String doctorId, BuildContext context) async {
    try {
      fetchingPriceHistory = true;
      notifyListeners();

      final res = await authGet('$_api/getalldoctorprice/$doctorId',
          withDeviceHeaders: true);
      fetchingPriceHistory = false;

      if (res != null && res.statusCode == 200) {
        priceHistory = jsonDecode(res.body)['data'] ?? [];
      } else {
        priceHistory = [];
      }
      notifyListeners();
    } catch (e) {
      fetchingPriceHistory = false;
      priceHistory = [];
      notifyListeners();
      _snack(context, e.toString(), error: true);
    }
  }

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

      final Map<String, dynamic> body = {
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
        body["password"] = password;
        body["confirm_password"] = confirmpassword;
      }
      if (alternativephone.isNotEmpty) body['phone2'] = alternativephone;

      final res = await _mutate('PUT', 'editdoctor/$doctorId', body: body);
      updatingdoctor = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 200 || res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Doctor updated successfully');
        await getalldoctors(context);
        if (context.mounted) Navigator.pop(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      updatingdoctor = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
    }
  }

  Future<void> changedoctorpassword(String newPassword, String confirmPassword,
      String doctid, BuildContext context) {
    return _changePassword(
        'resetpassworddoctor/$doctid', newPassword, confirmPassword, context);
  }

  Future<void> changeDoctorValidity({
    required String doctorId,
    required String validTill,
    required BuildContext context,
  }) async {
    try {
      final res = await _mutate('PATCH', 'changedoctorvalidity/$doctorId',
          body: {'validdate': validTill});
      if (res == null) return;

      if (res.statusCode == 200) {
        _snack(context, 'Doctor Validity Updated successfully');
        getalldoctors(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
      }
    } catch (e) {
      print(e);
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
      updatingdoctorprice = true;
      notifyListeners();

      final res = await _mutate('PUT', 'updatedoctorprice/$doctorId', body: {
        'price': price,
        'effectiveFrom': effectiveDate,
      });
      if (res == null) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        _snack(context, _okMessage(res, 'Price updated successfully'));
        getalldoctors(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
      }
    } catch (e) {
      print(e);
    } finally {
      updatingdoctorprice = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════ Admins ═══════════════════════════

  List<Map<String, dynamic>> alladmins = [];
  bool addingadmin = false;
  bool togglingadminstatus = false;
  bool updatingadmin = false;

  Future<void> getalladmins(BuildContext context) async {
    final l = await _fetchList('getalladmins');
    if (l != null) {
      alladmins = l;
      notifyListeners();
    }
  }

  Future<void> addAdmin(String name, String phone, String email,
      String password, String confirmpassword, List<String> associateddoctor,
      BuildContext context) async {
    try {
      final res = await _mutate('POST', 'addadmin', body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirm_password": confirmpassword,
        "doctorIds": associateddoctor,
      });
      addingadmin = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Admin Registered successfully');
        getalladmins(context);
        if (context.mounted) Navigator.pop(context);
        notifyListeners();
      } else {
        print(res.body);
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      addingadmin = false;
      _snack(context, e.toString(), error: true);
      notifyListeners();
    }
  }

  Future<bool> toggleAdminStatus(
      String adminId, bool currentStatus, BuildContext context) {
    return _toggle(
      enableEp: 'enableadmin',
      disableEp: 'disableadmin',
      label: 'Admin',
      id: adminId,
      currentStatus: currentStatus,
      setBusy: (v) => togglingadminstatus = v,
      reload: () => getalladmins(context),
      context: context,
    );
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

      final res = await _mutate('PUT', 'editadmin/$adminId', body: {
        "name": name,
        "email": email,
        "phone": phone,
        "doctorIds": associateddoctor,
      });
      updatingadmin = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 200 || res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Admin updated successfully');
        await getalladmins(context);
        if (context.mounted) Navigator.pop(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      updatingadmin = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
    }
  }

  Future<void> changeadminpassword(String newPassword, String confirmPassword,
      String adminId, BuildContext context) {
    return _changePassword(
        'resetpasswordadmin/$adminId', newPassword, confirmPassword, context);
  }

  // ═══════════════════════════ Lab technicians ═══════════════════════════

  List<Map<String, dynamic>> labtechnicians = [];
  bool addinglabtechnician = false;
  bool togglinglabtechnicianstatus = false;
  bool updatingLabtechnician = false;

  Future<void> getalllabtechnicians(BuildContext context) async {
    final l = await _fetchList('getalllabtechnicians');
    if (l != null) {
      labtechnicians = l;
      notifyListeners();
    }
  }

  Future<void> addLabtechnician(String name, String phone, String email,
      String address, String password, String confirmpassword,
      BuildContext context) async {
    try {
      final res = await _mutate('POST', 'addlabtechnician', body: {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "password": password,
        "confirm_password": confirmpassword,
      });
      addinglabtechnician = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Lab technician Registered successfully');
        getalllabtechnicians(context);
        if (context.mounted) Navigator.pop(context);
        notifyListeners();
      } else {
        print(res.body);
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      addinglabtechnician = false;
      _snack(context, e.toString(), error: true);
      notifyListeners();
    }
  }

  Future<bool> toggleLabtechnicianStatus(
      String id, bool currentStatus, BuildContext context) {
    return _toggle(
      enableEp: 'enablelabtechnician',
      disableEp: 'disablelabtechnician',
      label: 'Lab Technician',
      id: id,
      currentStatus: currentStatus,
      setBusy: (v) => togglinglabtechnicianstatus = v,
      reload: () => getalllabtechnicians(context),
      context: context,
    );
  }

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

      final res = await _mutate('PUT', 'editlabtechnician/$adminId', body: {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      });
      updatingLabtechnician = false;
      if (res == null) {
        notifyListeners();
        return;
      }

      if (res.statusCode == 200 || res.statusCode == 201) {
        notifyListeners();
        _snack(context, 'Lab Technician updated successfully');
        await getalllabtechnicians(context);
        if (context.mounted) Navigator.pop(context);
      } else {
        _snack(context, _extractErrorMessage(res), error: true);
        notifyListeners();
      }
    } catch (e) {
      updatingLabtechnician = false;
      notifyListeners();
      _snack(context, e.toString(), error: true);
    }
  }

  

  Future<void> changelabtechnicianpassword(String newPassword,
      String confirmPassword, String id, BuildContext context) {
    return _changePassword('resetpasswordlabtechnician/$id', newPassword,
        confirmPassword, context);
  }

  // ── Advance payment state ──
bool isPurseLoading = false;
double? purseAmount;

Future<void> fetchDoctorPurse(String doctorUserid) async {
  isPurseLoading = true;
  notifyListeners();
  try {
    // TODO: use your real wallet/purse endpoint + auth helper
    // final data = await authGet('/api/v1/sales/purse/$doctorUserid');
    // if (data['success'] == true) {
    //   purseAmount = double.tryParse(
    //           data['data']?['purseAmount']?.toString() ?? '') ??
    //       0;
    // }

     final res = await authPost('${Constants.baseUrl}/api/v1/sales/getpurseamount/$doctorUserid');
     debugPrint('PURSE status: ${res?.statusCode}');
debugPrint('PURSE body: ${res?.body}');
    // final data = res?.data;
    final data = jsonDecode(res!.body);
    print(data);
    if (data is Map && data['success'] == true) {
      purseAmount =
          double.tryParse(data['data']?['purseAmount']?.toString() ?? '') ?? 0;
    }
  } catch (e) {
    debugPrint('Error fetching purse: $e');
  } finally {
    isPurseLoading = false;
    notifyListeners();
  }
}

/// Returns null on success, or an error message on failure.
Future<String?> addAdvancePayment({
  required String doctorUserid,
  required String paymentMode,
  required double totalAmount,
  DateTime? paymentDate,
  String transactionReference = '',
  String utrNumber = '',
  String bankName = '',
  String chequeNumber = '',
  String receivedBy = '',
  String receiptNumber = '',
  String paymentProof = '',
}) async {
  final body = <String, dynamic>{
    'paymentMode': paymentMode,
    'totalAmountReceived': totalAmount,
    'transactionReference': transactionReference,
    'utrNumber': utrNumber,
    'bankName': bankName,
    'chequeNumber': chequeNumber,
    'receivedBy': receivedBy,
    'receiptNumber': receiptNumber,
    'paymentProof': paymentProof,
  };
  if (paymentDate != null) {
    body['paymentDate'] = DateTime.utc(
            paymentDate.year, paymentDate.month, paymentDate.day)
        .toIso8601String();
  }

  // try {
  //   final data = await authPost(
  //     '/api/v1/sales/advancedpayment/$doctorUserid',
  //     body: body,
  //   );
  //   if (data['success'] == true) {
  //     await fetchDoctorPurse(doctorUserid); // refresh balance
  //     return null;
  //   }
  //   final errs = data['errors'];
  //   return (errs is List && errs.isNotEmpty)
  //       ? errs.first.toString()
  //       : (data['message']?.toString() ??
  //           'Advance payment could not be added');
  // } catch (e) {
  //   debugPrint('Error adding advance payment: $e');
  //   return 'Something went wrong. Please try again.';
  // }
  try {
  final res = await authPost(
    '${Constants.baseUrl}/api/v1/sales/advancedpayment/$doctorUserid',
    // body: body,
    body: jsonEncode(body),
  );
  if (res == null) return 'No response from server. Please try again.';

  // final data = res.data;

  final data = jsonDecode(res.body); // instead of res.data

  print(data);
  if (data is Map) {
    if (data['success'] == true) {
      await fetchDoctorPurse(doctorUserid);
      return null;
    }
    final errs = data['errors'];
    return (errs is List && errs.isNotEmpty)
        ? errs.first.toString()
        : (data['message']?.toString() ?? 'Advance payment could not be added');
  }
  return 'Unexpected response from server.';
} catch (e) {
  debugPrint('Error adding advance payment: $e');
  return 'Something went wrong. Please try again.';
}
}

  // ═══════════════════════════ misc ═══════════════════════════

  /// Compatibility: purani files agar provider.refreshtoken(context) call karein
  /// to bhi ab single-flight TokenManager hi chalega.
  Future<void> refreshtoken(BuildContext context) async {
    final String failed = (await secureStorage.readSecureData('token')) ?? '';
    await TokenManager.refresh(failedToken: failed);
  }



  /// Logout par purana data na dikhe.
  void reset() {
    allhospitals = [];
    allhospitalnames = [];
    allprofiles = {};
    alldoctors = [];
    alldoctorsnames = [];
    alladmins = [];
    labtechnicians = [];
    priceHistory = [];
    notifyListeners();
  }

  

  void notify() {
    notifyListeners();
  }
}