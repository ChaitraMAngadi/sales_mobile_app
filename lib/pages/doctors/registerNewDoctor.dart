import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

@RoutePage()
class RegisterNewDoctorPage extends StatefulWidget {
  const RegisterNewDoctorPage({super.key, required this.allhospitals});
    final List<Map<String, dynamic>> allhospitals;


  @override
  State<RegisterNewDoctorPage> createState() => _RegisterNewDoctorPageState();
}

class _RegisterNewDoctorPageState extends State<RegisterNewDoctorPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternativephoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
    final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _registrationnumberController = TextEditingController();
  final TextEditingController _yearofregistrationController = TextEditingController();
  final TextEditingController _boardofregistrationController = TextEditingController();
  final TextEditingController _priceperdiagnosisController = TextEditingController();

  final formkey = GlobalKey<FormState>();
    bool _obscureText = true;
  List<Map<String, dynamic>> selectedHospitals = [];



 final List<String> _genderOptions = [
    'male',
    'female',
    'other'
  ];
  String? _selectedGender;


  @override
  Widget build(BuildContext context) {
    Salesprovider salesprovider =
        context.read<Salesprovider>();
    return Scaffold(
      backgroundColor: AppColors.badgeBg,
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,
          color: Colors.white,)),
           flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
          title: Text(
            "Register New Doctor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 16,),
                  const Text('Name*',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _nameController,
                    inputFormatters: [
                      // LengthLimitingTextInputFormatter(50),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ]'),
                      )
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospitalname';
                      }
                      return null; // Return null if validation is successful
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Doctor name',
                    ),
                  ),
                  const SizedBox(height: 16),
                   const Text(
                    'Gender*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Select gender of the patient',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    ),
                    value: _selectedGender,
                    validator: (value) => value == null
                        ? 'Please select gender of the patient'
                        : null,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    items: _genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16,),

                  const Text(
                    'Email Address*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9.@]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email address'; 
                      }

                       const emailRegex =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|in|io|co|me|info|biz|xyz)$';

                      // const emailRegex =
                      //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      if (!RegExp(emailRegex).hasMatch(value!)) {
                        return 'Enter a valid email address';
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter email address',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mobile Number*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                      hintText: 'Enter mobile number',
                    ),
                  ),
                  const SizedBox(height: 16),
                   const Text(
                    'Alternative Mobile Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _alternativephoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if(value.isNotEmpty){
                        if (value!.length != 10) {
                        return 'Phone number must be exactly 10 digits';
                      }
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      }
                      
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter alternative mobile number',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                              'Password*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              // obscureText: _obscureText,
                              controller: _passwordController,
                              cursorColor: const Color(0Xff2556B9),
                             
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }

                                return null; // Return null if validation is successful
                              },
                              decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // suffixIcon: IconButton(
                                  //   icon: Icon(
                                  //     _obscureText
                                  //         ? Icons.visibility_off
                                  //         : Icons.visibility,
                                  //   ),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       _obscureText = !_obscureText;
                                  //     });
                                  //   },
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, top: 14, bottom: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  hintText: 'Enter password',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff333333)
                                          .withOpacity(0.5))),
                            ),
                            SizedBox(height: 16,),
                            const Text(
                              'Confirm Password*',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: _obscureText,
                              controller: _confirmpasswordController,
                              cursorColor: const Color(0Xff2556B9),
                             
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please confirm password';
                                }
                                if(value != _passwordController.text){
                                  return 'confirm password should match password';
                                }

                                return null; // Return null if validation is successful
                              },
                              decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 16, top: 14, bottom: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  hintText: 'Confirm password',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff333333)
                                          .withOpacity(0.5))),
                            ),
                  const SizedBox(height: 16),
                  Text("Professional Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 16,),
                  const Text(
                    'Qualification*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _qualificationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter qualification';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Qualification',
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  const Text(
                    'Specialization*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _specializationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Specialization';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Specialization',
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  const Text(
                    'Registration Number*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _registrationnumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Registration Number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Registration Number',
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  const Text(
                    'Year of Registration*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _yearofregistrationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: <TextInputFormatter>[
                      
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                   keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Year of Registration';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Year of Registration',
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  const Text(
                    'Board of Registration*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _boardofregistrationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Board of Registration';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Board of Registration',
                    ),
                  ),
                
                  const SizedBox(height: 16),
                  const Text(
                    'Price per Diagnosis*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceperdiagnosisController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
keyboardType: TextInputType.number,
                   inputFormatters: <TextInputFormatter>[
                      
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Price per Diagnosis';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Price per Diagnosis',
                    ),
                  ),
                
                SizedBox(height: 16,),
                  const Text("Associated Hospitals*",
    style: TextStyle(fontWeight: FontWeight.bold)),
const SizedBox(height: 6),
DropdownSearch<Map<String, dynamic>>.multiSelection(
  items: widget.allhospitals,
  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
  compareFn: (item1, item2) => item1['userid'] == item2['userid'],  // 👈 ye add karo
  selectedItems: selectedHospitals,
  autoValidateMode: AutovalidateMode.onUserInteraction,
  popupProps: PopupPropsMultiSelection.menu(
    showSearchBox: true,
    showSelectedItems: true,
    constraints: BoxConstraints(
      maxHeight: 200,
    ),
    menuProps: MenuProps(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  dropdownDecoratorProps: DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      hintText: "Select Associated Hospitals",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0857C0)),
      ),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Please select at least one Associated Hospital";
    }
    return null;
  },
  onChanged: (value) {
    setState(() {
      selectedHospitals = value;
    });
    debugPrint(
        "Consulting hospital IDs: ${value.map((h) => h['userid']).toList()}");
  },
),
                  
  
                  SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: ElevatedButton(
                      style:  ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 14)),
                        backgroundColor: salesprovider.addinghospital? const WidgetStatePropertyAll( Colors.grey):
                            const WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                      ),
                      onPressed: salesprovider.addingdoctor? null: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            salesprovider.addingdoctor = true;
                          });

                          final hospitalIds =
        selectedHospitals.map((h) => h['userid'].toString()).toList();

                          await salesprovider.addDoctor(_nameController.text,
                           _phoneController.text,
                            _alternativephoneController.text,
                            _selectedGender!, _emailController.text, 
                            _passwordController.text, 
                            _confirmpasswordController.text, 
                            _qualificationController.text, 
                            _specializationController.text, 
                            _registrationnumberController.text, 
                            _yearofregistrationController.text, 
                            _boardofregistrationController.text, 
                            _priceperdiagnosisController.text,
                            hospitalIds,
                            context);

                          // await salesprovider.addHospital(
                          //     _nameController.text,
                          //     _phoneController.text,
                          //     _emailController.text,
                          //     _addressController.text,
                          //     context);

                          await salesprovider.getalldoctors(context);

                          // patientpageprovider.notify();
                        }
                      },
                      child:salesprovider.addinghospital? CircularProgressIndicator(): const Text(
                        'Register Doctor',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
