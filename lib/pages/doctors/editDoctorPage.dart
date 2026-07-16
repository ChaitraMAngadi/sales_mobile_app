import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

@RoutePage()
class EditDoctorPage extends StatefulWidget {
  const EditDoctorPage({
    super.key,
    required this.doctorData,
    required this.allhospitals,
  });

  final Map<String, dynamic> doctorData;
  final List<Map<String, dynamic>> allhospitals;

  @override
  State<EditDoctorPage> createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _alternativephoneController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  late final TextEditingController _qualificationController;
  late final TextEditingController _specializationController;
  late final TextEditingController _registrationnumberController;
  late final TextEditingController _yearofregistrationController;
  late final TextEditingController _boardofregistrationController;
  late final TextEditingController _priceperdiagnosisController;

  final formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  List<Map<String, dynamic>> selectedHospitals = [];

  final List<String> _genderOptions = ['male', 'female', 'other'];
  String? _selectedGender;
  DateTime? _validTillDate;
  String? docid;


  @override
  void initState() {
    super.initState();
    final doc = widget.doctorData;

    _nameController = TextEditingController(text: doc['name'] ?? '');
    _emailController = TextEditingController(text: doc['email'] ?? '');
    _phoneController = TextEditingController(text: doc['phone']?.toString() ?? '');
    _alternativephoneController =
        TextEditingController(text: doc['phone2']?.toString() ?? '');
    _qualificationController = TextEditingController(text: doc['qualification'] ?? '');
    _specializationController = TextEditingController(text: doc['specialization'] ?? '');
    _registrationnumberController =
        TextEditingController(text: doc['doctorRegistrationNumber'] ?? '');
    _yearofregistrationController =
        TextEditingController(text: doc['year_of_registration']?.toString() ?? '');
    _boardofregistrationController =
        TextEditingController(text: doc['board_of_registration'] ?? '');
    _priceperdiagnosisController =
        TextEditingController(text: doc['price']?.toString() ?? '');

    _selectedGender = doc['gender'];
    docid = doc['userid'];

    // Pre-select associated hospitals from doctorData against allhospitals list
    final List<dynamic> associated = doc['associatedHospital'] ?? [];
    selectedHospitals = widget.allhospitals.where((hospital) {
      return associated.any((a) => a['userid'] == hospital['userid']);
    }).toList();

final validTillRaw = doc['validity']; // ⚠️ apne backend field ka actual naam check kar lena
if (validTillRaw != null) {
  _validTillDate = DateTime.tryParse(validTillRaw.toString());
}

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternativephoneController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _qualificationController.dispose();
    _specializationController.dispose();
    _registrationnumberController.dispose();
    _yearofregistrationController.dispose();
    _boardofregistrationController.dispose();
    _priceperdiagnosisController.dispose();
    super.dispose();
  }


Future<void> _pickValidTillDate() async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: (_validTillDate != null && _validTillDate!.isAfter(now))
        ? _validTillDate!
        : now,
    firstDate: now, // aaj se pehle ki date select nahi hogi
    lastDate: DateTime(now.year + 5),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF0857C0),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked == null) return; // user ne cancel kiya

  setState(() {
    _validTillDate = picked;
  });

  final salesprovider = context.read<Salesprovider>();
  await salesprovider.changeDoctorValidity(
    doctorId: widget.doctorData['userid'],
    validTill: picked.toIso8601String(),
    context: context,
  );
}

String get _formattedValidTill {
  if (_validTillDate == null) return 'Not set';
  return "${_validTillDate!.year}-${_validTillDate!.month.toString().padLeft(2, '0')}-${_validTillDate!.day.toString().padLeft(2, '0')}";
}


  @override
  Widget build(BuildContext context) {
    Salesprovider salesprovider = context.read<Salesprovider>();
    return Scaffold(
      backgroundColor: AppColors.badgeBg,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: Text(
          "Edit Doctor",
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
              // _TopActionsBar(),
//               Row(
//                 children: [

//                 _GradientActionButton(icon: Icons.calendar_today_outlined, text: "Change", onTap: (){}),
      
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//  _GradientActionButton(icon: Icons.key, text: "Reset Password", onTap: (){}),
//         _GradientActionButton(icon: FontAwesomeIcons.dollarSign, text: "Change Price", onTap: (){
//         }),
//                 ],
//               ),

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        blurRadius: 12,
        offset: Offset(0, 4),
        color: Colors.black12,
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Valid till box
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE9EA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: Color(0xFFE0475C), size: 18),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                children: [
                  const TextSpan(text: "Valid till: "),
                  TextSpan(
                    text: _formattedValidTill,
                    style: const TextStyle(
                        color: Color(0xFFE0475C), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      // Action buttons
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _GradientActionButton(
            icon: Icons.calendar_today_outlined,
            text: "Change",
            onTap: _pickValidTillDate,
          ),
          _GradientActionButton(
            icon: Icons.key,
            text: "Reset Password",
            onTap: () {
               showDialog(
                                context: context,
                                builder: (_) => ResetPasswordModel(docid: docid??'',),
                              );
            },
          ),
          _GradientActionButton(
            icon: FontAwesomeIcons.dollarSign,
            text: "Change Price",
            onTap: () {
               showDialog(
      context: context,
      builder: (_) => ChangePriceDialog(
        doctorId: widget.doctorData['userid'],
        currentPrice: widget.doctorData['price']?.toString() ?? '',
      ),
    );
            },
          ),
        ],
      ),
    ],
  ),
),
SizedBox(height: 16,),
              Text(
                "Personal Information",
                
                style: TextStyle(fontSize: 18, 
                
                fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              const Text('Name*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _nameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Doctor name',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gender*',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'Select gender',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
                value: _selectedGender,
                validator: (value) =>
                    value == null ? 'Please select gender' : null,
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
              SizedBox(height: 16),
              const Text(
                'Email Address*',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.@]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  const emailRegex =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|in|io|co|me|info|biz|xyz)$';
                  if (!RegExp(emailRegex).hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Mobile Number*',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  if (value == null || value.isEmpty) return null;
                  if (value.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter alternative mobile number',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Professional Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              const Text(
                'Qualification*',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              SizedBox(height: 16),
              const Text("Associated Hospitals*",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownSearch<Map<String, dynamic>>.multiSelection(
                items: widget.allhospitals,
                itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                compareFn: (item1, item2) =>
                    item1['userid'] == item2['userid'],
                selectedItems: selectedHospitals,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                popupProps: PopupPropsMultiSelection.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  constraints: BoxConstraints(maxHeight: 200),
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
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 14)),
                    backgroundColor: salesprovider.updatingdoctor
                        ? const WidgetStatePropertyAll(Colors.grey)
                        : const WidgetStatePropertyAll(Colors.transparent),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                    shape: const WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                    ),
                  ),
                  onPressed: salesprovider.updatingdoctor
                      ? null
                      : () async {
                          if (formkey.currentState!.validate()) {
                            final hospitalIds = selectedHospitals
                                .map((h) => h['userid'].toString())
                                .toList();

                            await salesprovider.editDoctor(
                              doctorId: widget.doctorData['userid'],
                              name: _nameController.text,
                              phone: _phoneController.text,
                              alternativephone:
                                  _alternativephoneController.text,
                              gender: _selectedGender!,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confirmpassword:
                                  _confirmpasswordController.text,
                              qualification: _qualificationController.text,
                              specialization: _specializationController.text,
                              registrationnumber:
                                  _registrationnumberController.text,
                              yearofregistration:
                                  _yearofregistrationController.text,
                              boardofregistration:
                                  _boardofregistrationController.text,
                              priceperdiagnosis:
                                  _priceperdiagnosisController.text,
                              associatedhospital: hospitalIds,
                              context: context,
                            );

                            await salesprovider.getalldoctors(context);
                          }
                        },
                  child: salesprovider.updatingdoctor
                      ? CircularProgressIndicator()
                      : const Text(
                          'Update Doctor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _GradientActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResetPasswordModel extends StatefulWidget {
  const ResetPasswordModel({super.key, required this.docid});
  final String docid; 

  @override
  State<ResetPasswordModel> createState() => _ResetPasswordModelState();
}

class _ResetPasswordModelState extends State<ResetPasswordModel> {
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false; // ✅ track loading state

  @override
  void dispose() {
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<Salesprovider>();

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                gradient: AppColors.primaryGradient,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Reset Password",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context), // ✅ block close while loading
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _NewPasswordField("New Password", passCtrl),
                    _PasswordField(
                      "Confirm Password",
                      confirmCtrl,
                      validator: (v) =>
                          v != passCtrl.text ? "Passwords do not match" : null,
                    ),
                    const SizedBox(height: 16),

                    // ✅ Show loader or button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : _GradientButton(
                            text: "Submit",
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() => _isLoading = true); // ✅ block further taps
                                try {
                                 
                                  await provider.changedoctorpassword(
                                    passCtrl.text,
                                      confirmCtrl.text,
                                      widget.docid, 
                                       context);
                                } finally {
                                  if (mounted) {
                                    setState(() => _isLoading = false); // ✅ re-enable on error
                                  }
                                }
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewPasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _NewPasswordField(this.label, this.controller, {this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(5),
        // ],
      validator: validator ??
      (v) {
        if (v == null || v.isEmpty) return "Required field";
        if (v.length < 5) return "Minimum 5 characters required"; // ✅ min check
        return null;
      },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}


class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _PasswordField(this.label, this.controller, {this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // inputFormatters: [
        //   LengthLimitingTextInputFormatter(5),
        // ],
      validator: validator ??
      (v) {
        if (v == null || v.isEmpty) return "Required field";
        if (v.length < 5) return "Minimum 5 characters required"; // ✅ min check
        return null;
      },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
class _GradientButton extends StatelessWidget {
  final String text;
  final bool green;
  final VoidCallback onTap;

  const _GradientButton({
    required this.text,
    this.green = false, required this.onTap,
    
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
    
          gradient: LinearGradient(
            colors: green
                ? const [Color.fromARGB(255, 170, 244, 196),Color.fromARGB(255, 185, 250, 205)]
                : const [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(16,),
          border: Border.all(
            color:green?Colors.green: AppColors.primary 
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            green?Icon(Icons.lock_reset,
            color: Colors.green,):Icon(Icons.check_circle,
            color: Colors.white,),
            SizedBox(width: 6,),
            Text(
              text,
              style: TextStyle(
                color: green
                    ? const Color(0xFF16A34A)
                    : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePriceDialog extends StatefulWidget {
  const ChangePriceDialog({
    super.key,
    required this.doctorId,
    required this.currentPrice,
  });

  final String doctorId;
  final String currentPrice;

  @override
  State<ChangePriceDialog> createState() => _ChangePriceDialogState();
}

class _ChangePriceDialogState extends State<ChangePriceDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  DateTime? _effectiveDate;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    if (_effectiveDate == null) return '';
    return "${_effectiveDate!.day.toString().padLeft(2, '0')}-${_effectiveDate!.month.toString().padLeft(2, '0')}-${_effectiveDate!.year}";
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // aaj se pehle ki date select nahi hogi
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE0475C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _effectiveDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesprovider = context.watch<Salesprovider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE9EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FontAwesomeIcons.rupeeSign,
                        color: Color(0xFFE0475C), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Schedule Doctor Price",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Set a future price for the doctor",
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Price
              const Text('Price *',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Effective Date
              const Text('Effective Date *',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: _formattedDate),
                    validator: (value) {
                      if (_effectiveDate == null) {
                        return 'Please select effective date';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'dd-mm-yyyy',
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0475C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: salesprovider.updatingdoctorprice
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await salesprovider.updateDoctorPrice(
                              doctorId: widget.doctorId,
                              price: _priceController.text,
                              effectiveDate:
                                  _effectiveDate!.toIso8601String(),
                              context: context,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                  child: salesprovider.updatingdoctorprice
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}