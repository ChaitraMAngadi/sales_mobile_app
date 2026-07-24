import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';



@RoutePage()
class RegisterNewAdminPage extends StatefulWidget {
  const RegisterNewAdminPage({super.key, required this.alldoctors,});
  final List<Map<String, dynamic>> alldoctors;
  


  @override
  State<RegisterNewAdminPage> createState() => _RegisterNewAdminPageState();
}

class _RegisterNewAdminPageState extends State<RegisterNewAdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _autoValidate = false;
  // Map<String, dynamic>? selectedConsultingDoctor;
List<Map<String, dynamic>> selectedConsultingDoctor = [];

  @override
  Widget build(BuildContext context) {
    Salesprovider salesprovider =
        context.watch<Salesprovider>();
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
            "Register New Admin",
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
              autovalidateMode: _autoValidate
        ? AutovalidateMode.always
        : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Admin Name*',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _nameController,
                    inputFormatters: [
                      // LengthLimitingTextInputFormatter(50),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ]'),
                      )
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null; // Return null if validation is successful
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Admin name',
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    'Phone Number*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      hintText: 'Enter phone number',
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
                                if (value == null || value.isEmpty) return "Please enter password";
        if (value.length < 5) return "Minimum 5 characters required"; // ✅ min check
                                return null;

                               
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
                  
                  SizedBox(height: 8,), 
                const Text("Consulting Doctor*",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
  //               DropdownSearch<Map<String, dynamic>>(
  //                 items: widget.alldoctors,
  //                 itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
  //                 selectedItem: selectedConsultingDoctor,
  //                  autoValidateMode:
  //                                 AutovalidateMode.onUserInteraction,
  //                  popupProps: PopupProps.menu(
  //   showSearchBox: true,
  //   constraints: BoxConstraints(
  //     maxHeight: 150, // caps it, but won't add empty space
  //   ),
  //   menuProps: MenuProps(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  // ),
  //                 // popupProps: const PopupProps.menu(showSearchBox: true),
  //                 dropdownDecoratorProps: DropDownDecoratorProps(
                  
  //                   dropdownSearchDecoration: InputDecoration(
  //                     hintText: "Select Consulting Doctor",
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
                      
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                       borderSide: const BorderSide(color: Color(0xFF0857C0)),
  //                     ),
  //                   ),
  //                 ),
  //                          validator: (value) {
  //                   if (value == null) {
  //                     return "Please select a Consulting Doctor";
  //                   }
  //                   return null;
  //                 },
  //                 onChanged: (value) {
  //                   setState(() {
  //                     selectedConsultingDoctor = value;
  //                   });
  //                   debugPrint("Consulting Doctor ID: ${value?['userid']}");
  //                 },
  //               ),

                DropdownSearch<Map<String, dynamic>>.multiSelection(
  items: widget.alldoctors,
  itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
  compareFn: (item1, item2) => item1['userid'] == item2['userid'],  // 👈 ye add karo
  selectedItems: selectedConsultingDoctor,
  // autoValidateMode: AutovalidateMode.onUserInteraction,
  popupProps: PopupPropsMultiSelection.menu(
    showSearchBox: true,
    showSelectedItems: true,
    constraints: BoxConstraints(
      maxHeight: 300,
    ),
    menuProps: MenuProps(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  dropdownDecoratorProps: DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      hintText: "Select Associated Doctor",
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
      return "Please select at least one Associated Doctor";
    }
    return null;
  },
  onChanged: (value) {
    setState(() {
      selectedConsultingDoctor = value;
    });
    debugPrint(
        "Consulting Doctor IDs: ${value.map((h) => h['userid']).toList()}");
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
                        backgroundColor: salesprovider.addingadmin? const WidgetStatePropertyAll( Colors.grey):
                            const WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                      ),
                      onPressed: salesprovider.addingadmin? null: () async {
                        setState(() {
    _autoValidate = true;   // 👈 ab se onUserInteraction mode ON ho jayega
  });
                        if (formkey.currentState!.validate()) {
                           
                          setState(() {
                            salesprovider.addingadmin = true;
                          });
                          final doctorIds =
        selectedConsultingDoctor.map((h) => h['userid'].toString()).toList();
                          await salesprovider.addAdmin(
                              _nameController.text,
                              _phoneController.text,
                              _emailController.text,
                              _passwordController.text,
                              _confirmpasswordController.text,
                              doctorIds,
                              context);

                          await salesprovider.getalladmins(context);

                          // patientpageprovider.notify();
                        }
                      },
                      child:salesprovider.addingadmin? CircularProgressIndicator(): const Text(
                        'Register Admin',
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
