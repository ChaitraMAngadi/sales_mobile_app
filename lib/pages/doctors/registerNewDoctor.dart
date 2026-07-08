import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

@RoutePage()
class RegisterNewDoctorPage extends StatefulWidget {
  const RegisterNewDoctorPage({super.key});

  @override
  State<RegisterNewDoctorPage> createState() => _RegisterNewDoctorPageState();
}

class _RegisterNewDoctorPageState extends State<RegisterNewDoctorPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final formkey = GlobalKey<FormState>();


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
            "Register New Hospital",
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
                  const Text('Hospital Name*',
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
                      hintText: 'Enter Hospital name',
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
                    'Hospital Address*',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospital address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter address',
                    ),
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
                      onPressed: salesprovider.addinghospital? null: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            salesprovider.addinghospital = true;
                          });
                          await salesprovider.addHospital(
                              _nameController.text,
                              _phoneController.text,
                              _emailController.text,
                              _addressController.text,
                              context);

                          await salesprovider.getallhospitals(context);

                          // patientpageprovider.notify();
                        }
                      },
                      child:salesprovider.addinghospital? CircularProgressIndicator(): const Text(
                        'Register Hospital',
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
