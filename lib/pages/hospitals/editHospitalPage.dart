import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

@RoutePage()
class EditHospitalPage extends StatefulWidget {
  const EditHospitalPage({super.key, required this.hospitalId, required this.name, required this.userid, required this.email, required this.phone, required this.address,});

  final String hospitalId;
  final String name;
  final String userid;
  final String email;
  final String phone;
  final String address;

  @override
  State<EditHospitalPage> createState() => _EditHospitalPageState();
}

class _EditHospitalPageState extends State<EditHospitalPage> {
  late Future fetchhospital;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final formkey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
        _nameController.text = widget.name??"";
        _emailController.text = widget.email ?? "";
        _phoneController.text = widget.phone ?? "";
        _addressController.text = widget.address?? "";

  }

  // Shimmer skeleton widget
  Widget _buildShimmerSkeleton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Email field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Phone field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // DOB field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Gender field shimmer
            _buildShimmerField(),
            const SizedBox(height: 16),
            
            // Age field shimmer
            _buildShimmerField(),
            const SizedBox(height: 32),
            
            // Button shimmer
            _buildShimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label shimmer
        Container(
          height: 16,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        // Field shimmer
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[200]!),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.badgeBg,
        appBar: AppBar(
           flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
          title: const Text(
            "Edit Hospital",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<Salesprovider>(
          builder: (context, salesprovider, child) {
            return Container(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Name of the Hospital*',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _nameController,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9 ]'),
                                )
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter hospital name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter full name',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Email of the Hospital',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9.@]')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Hospital Email";
                                }

                                const emailRegex =
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                if (!RegExp(emailRegex).hasMatch(value!)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter email',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Phone number of the Hospital*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _phoneController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              validator: (value) {
                                if (value!.length != 10) {
                                  return 'Phone number must be exactly 10 digits';
                                }
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter phone',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Address of the Hospital*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _addressController,
                              decoration: InputDecoration(
                                
                                border: OutlineInputBorder(),
                                hintText: 'Enter Address',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            
                            
                            
                            
                            
                            
                            
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16),),
                                gradient:salesprovider.iseditinghospital?LinearGradient(colors: [
                                  Colors.grey, Colors.grey
                                ]) :AppColors.primaryGradient,
                              ),
                              child: ElevatedButton(
                                style:  ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(vertical: 16)),
                                      shadowColor: WidgetStatePropertyAll(Colors.transparent),
                                  backgroundColor: salesprovider.iseditinghospital? WidgetStatePropertyAll(Colors.transparent):
                                      WidgetStatePropertyAll(Colors.transparent),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(14)),
                                    ),
                                  ),
                                ),
                                onPressed:salesprovider.iseditinghospital? null: () async {
                                  if (formkey.currentState!.validate()) {
                                     setState(() {
                                  salesprovider.iseditinghospital = true;
                                });
                                    await salesprovider.edithospital(
                                      widget.hospitalId,
                                      _nameController.text,
                                      _addressController.text,
                                      _emailController.text,
                                      _phoneController.text,
                                      context,
                                    );

                                    // await patientpageprovider.getPatientsByPage(1, context);

                                    // patientpageprovider.notify();
                                  }
                                },
                                child:salesprovider.iseditinghospital?CircularProgressIndicator(): const Text(
                                  'Edit Hospital',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ));
  }
}

// class _EditPatientPageState extends State<EditPatientPage> {
//   late Future fetchpatient;

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final formkey = GlobalKey<FormState>();

//   String formatedJoiDate = '';
//   String formatedJoiPreviousDate = '';

//   Map<String, dynamic>? _patientData;

//   String formatDate(String date) {
//     final parsedDate = DateTime.parse(date);
//     final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
//     return formattedDate;
//   }

//   String? newSelectedGender;

//   final List<String> _genderOptions = [
//     'male',
//     'female',
//     'transgender',
//     'other'
//   ];
//   String? _selectedGender;

//   String calculateAge(DateTime birthDate) {
//     DateTime today = DateTime.now();

//     int years = today.year - birthDate.year;
//     int months = today.month - birthDate.month;
//     int days = today.day - birthDate.day;

//     if (days < 0) {
//       final previousMonth = DateTime(today.year, today.month, 0);
//       days += previousMonth.day;
//       months--;
//     }

//     if (months < 0) {
//       months += 12;
//       years--;
//     }

//     return '$years year, $months month, $days day';
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   Patientpageprovider patientpageprovider =
//   //       context.read<Patientpageprovider>();
//   //   fetchpatient = patientpageprovider.getpatient(widget.patientId);
//   // }

//   @override
//   void initState() {
//     super.initState();
//     Patientpageprovider patientpageprovider =
//         context.read<Patientpageprovider>();
//     fetchpatient = patientpageprovider.getpatient(widget.patientId).then((_) {
//       if (patientpageprovider.patientdetails.isNotEmpty) {
//         final data = patientpageprovider.patientdetails.first;
//         _patientData = data;

//         _nameController.text = data["name"] ?? "";
//         formatedJoiPreviousDate = data["DOB"] ?? "";
//         _dobController.text = formatDate(data["DOB"] ?? "");
//         formatedJoiDate = data["DOB"] ?? "";
//         _selectedGender = data["gender"];
//         _emailController.text = data["email"] ?? "";
//         _ageController.text = data["age"] ?? "";
//         _phoneController.text = (data["phone"] ?? "").toString();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Edit Patient",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: Consumer<Patientpageprovider>(
//           builder: (context, patientpageprovider, child) {
//             return FutureBuilder(
//               future: fetchpatient,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else {
//                   // if (patientpageprovider.patientdetails.isNotEmpty) {
//                   //   _nameController.text =
//                   //       patientpageprovider.patientdetails.first["name"] ?? "";
//                   //   formatedJoiPreviousDate =
//                   //       patientpageprovider.patientdetails.first["DOB"] ?? "";
//                   //   _dobController.text = formatDate(
//                   //       patientpageprovider.patientdetails.first["DOB"] ?? "");
//                   //   formatedJoiDate =
//                   //       patientpageprovider.patientdetails.first["DOB"] ?? "";
//                   //   _selectedGender =
//                   //       patientpageprovider.patientdetails.first["gender"];
//                   //   _emailController.text =
//                   //       patientpageprovider.patientdetails.first["email"] ?? "";
//                   //   _ageController.text =
//                   //       patientpageprovider.patientdetails.first["age"] ?? "";
//                   //   _phoneController.text =
//                   //       (patientpageprovider.patientdetails.first["phone"] ??
//                   //               "")
//                   //           .toString();
//                   // } else {
//                   //   print("member details list is empty.");
//                   // }
//                   return Container(
//                     padding: EdgeInsets.all(16),
//                     child: SingleChildScrollView(
//                       child: Form(
//                         key: formkey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text('Name of the Patient*',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 8),
//                             TextFormField(
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               controller: _nameController,
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(20),
//                                 FilteringTextInputFormatter.allow(
//                                   RegExp(r'[a-zA-Z0-9 ]'),
//                                 )
//                               ],
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter name';
//                                 }
//                                 return null; // Return null if validation is successful
//                               },
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Enter full name',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Email of the Patient',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextFormField(
//                               controller: _emailController,
//                               // autovalidateMode: AutovalidateMode.onUserInteraction,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[a-zA-Z0-9.@]')),
//                               ],
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return null; // No error for empty value
//                                 }

//                                 const emailRegex =
//                                     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
//                                 if (!RegExp(emailRegex).hasMatch(value!)) {
//                                   return 'Enter a valid email address';
//                                 }
//                                 return null; // Return null if the input is valid
//                               },
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Enter email',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Phone number of the patient',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextFormField(
//                               controller: _phoneController,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               inputFormatters: <TextInputFormatter>[
//                                 LengthLimitingTextInputFormatter(10),
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[0-9]')),
//                               ],
//                               validator: (value) {
//                                 if (value!.length != 10) {
//                                   return 'Phone number must be exactly 10 digits';
//                                 }
//                                 if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//                                   return 'Enter a valid phone number';
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Enter phone',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Date of Birth of the patient*',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextFormField(
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               controller: _dobController,
//                               readOnly: true,
//                               decoration: InputDecoration(
//                                 suffixIcon: Padding(
//                                   padding: const EdgeInsets.only(right: 16),
//                                   child: GestureDetector(
//                                       onTap: () async {
//                                         DateTime? pickedDate = await showDatePicker(
//                                             context: context,
//                                             initialDate: DateTime.now(),
//                                             firstDate: DateTime(1950),
//                                             //DateTime.now() - not to allow to choose before today.
//                                             lastDate: DateTime.now());

//                                         if (pickedDate != null) {
//                                           print(pickedDate);
//                                           String formattedDate =
//                                               DateFormat('dd/MM/yyyy')
//                                                   .format(pickedDate);
//                                           print(formattedDate);
//                                           _dobController.text = formattedDate;
//                                           formatedJoiDate =
//                                               DateFormat('yyyy-MM-dd')
//                                                   .format(pickedDate);

//                                           String age = calculateAge(pickedDate);
//                                           _ageController.text = age;
//                                           // setState(() {
//                                           //   dob.text = formattedDate;
//                                           // });
//                                         } else {}
//                                       },
//                                       child:
//                                           Icon(Icons.calendar_month_outlined)),
//                                 ),
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Enter DOB',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter DOB';
//                                 }
//                                 return null; // Return null if validation is successful
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Gender of the patient*',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             DropdownButtonFormField<String>(
//                               value: _selectedGender,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               decoration: InputDecoration(
//                                 hintText: 'Select gender of the patient',
//                                 border: OutlineInputBorder(),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 15),
//                               ),
//                               validator: (value) => value == null
//                                   ? 'Please select gender of the patient'
//                                   : null,
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   _selectedGender = newValue;
//                                   newSelectedGender = newValue;
//                                   print(_selectedGender);
//                                 });
//                               },
//                               items: _genderOptions.map((String gender) {
//                                 return DropdownMenuItem<String>(
//                                   value: gender,
//                                   child: Text(gender),
//                                 );
//                               }).toList(),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Age of the patient*',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextFormField(
//                               readOnly: true,
//                               controller: _ageController,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Enter Age',
//                               ),
//                             ),
//                             const SizedBox(height: 32),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: const ButtonStyle(
//                                   padding: WidgetStatePropertyAll(
//                                       EdgeInsets.symmetric(vertical: 14)),
//                                   backgroundColor:
//                                       WidgetStatePropertyAll(Color(0XFF0857C0)),
//                                   shape: WidgetStatePropertyAll(
//                                     RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(14)),
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (formkey.currentState!.validate()) {
//                                     await patientpageprovider.editpatient(
//                                       widget.patientId,
//                                       _nameController.text,
//                                       formatedJoiDate,
//                                       newSelectedGender ?? _selectedGender!,
//                                       _emailController.text,
//                                       _phoneController.text,
//                                       context,
//                                     );

//                                     await patientpageprovider.getPatientsByPage(1);

//                                     patientpageprovider.notify();
//                                   }
//                                 },
//                                 child: const Text(
//                                   'Edit Patient',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               },
//             );
//           },
//         ));
//   }
// }
