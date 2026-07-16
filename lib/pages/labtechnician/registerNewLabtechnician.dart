import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';



@RoutePage()
class RegisterNewLabtechnicianPage extends StatefulWidget {
  const RegisterNewLabtechnicianPage({super.key, });
  


  @override
  State<RegisterNewLabtechnicianPage> createState() => _RegisterNewLabtechnicianPageState();
}

class _RegisterNewLabtechnicianPageState extends State<RegisterNewLabtechnicianPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool _obscureText = true;


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
            "Register New Labtechnician",
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
                        return 'Please enter name';
                      }
                      return null; // Return null if validation is successful
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name',
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
                      hintText: 'Enter phone number',
                    ),
                  ),
                  const SizedBox(height: 16),

                 
                  const Text(
                    'Address*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _addressController,
                    // inputFormatters: [
                    //   // LengthLimitingTextInputFormatter(50),
                    //   FilteringTextInputFormatter.allow(
                    //     RegExp(r'[a-zA-Z0-9 ]'),
                    //   )
                    // ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null; // Return null if validation is successful
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Address',
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
                        backgroundColor: salesprovider.addinglabtechnician? const WidgetStatePropertyAll( Colors.grey):
                            const WidgetStatePropertyAll(Colors.transparent),
                            shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                      ),
                      onPressed: salesprovider.addinglabtechnician? null: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            salesprovider.addinglabtechnician = true;
                          });
                         
                          await salesprovider.addLabtechnician(
                              _nameController.text,
                              _phoneController.text,
                              _emailController.text,
                              _addressController.text,
                              _passwordController.text,
                              _confirmpasswordController.text,
                              context);

                          await salesprovider.getalllabtechnicians(context);

                          // patientpageprovider.notify();
                        }
                      },
                      child:salesprovider.addinglabtechnician? CircularProgressIndicator(): const Text(
                        'Register Lab Technician',
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
