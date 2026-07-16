import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

@RoutePage()
class EditAdminPage extends StatefulWidget {
  const EditAdminPage({
    super.key,
   required this.adminData, required this.alldoctors,
   
  });

  final Map<String, dynamic> adminData;
  final List<Map<String, dynamic>> alldoctors;

  @override
  State<EditAdminPage> createState() => _EditAdminPageState();
}

class _EditAdminPageState extends State<EditAdminPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  
  final formkey = GlobalKey<FormState>();
 
  List<Map<String, dynamic>> selectedDoctors = [];

  String? adminid;


  @override
  void initState() {
    super.initState();
    final doc = widget.adminData;

    _nameController = TextEditingController(text: doc['name'] ?? '');
    _emailController = TextEditingController(text: doc['email'] ?? '');
    _phoneController = TextEditingController(text: doc['phone']?.toString() ?? '');
    adminid = doc['userid'];

    final List<dynamic> associated = doc['associatedDoctor'] ?? [];
    selectedDoctors = widget.alldoctors.where((hospital) {
      return associated.any((a) => a['userid'] == hospital['userid']);
    }).toList();

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
          "Edit Admin",
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
    
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
        children: [
          
          _GradientActionButton(
            icon: Icons.key,
            text: "Reset Password",
            onTap: () {
               showDialog(
                                context: context,
                                builder: (_) => ResetPasswordModel(docid: adminid??'',),
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
                  hintText: 'Enter Admin name',
                ),
              ),
              const SizedBox(height: 16),
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
              
SizedBox(height: 16,),
              Text(
                "Professional Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
             
             
              
             
              
             SizedBox(height: 16,),

              const Text("Associated Hospitals*",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownSearch<Map<String, dynamic>>.multiSelection(
                items: widget.alldoctors,
                itemAsString: (doc) => "${doc['name']} | ${doc['userid']}",
                compareFn: (item1, item2) =>
                    item1['userid'] == item2['userid'],
                selectedItems: selectedDoctors,
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
                    hintText: "Select Associated Doctors",
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
                    selectedDoctors = value;
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
                  onPressed: salesprovider.updatingadmin
                      ? null
                      : () async {
                          if (formkey.currentState!.validate()) {
                            final hospitalIds = selectedDoctors
                                .map((h) => h['userid'].toString())
                                .toList();

                            await salesprovider.editAdmin(
                              adminId: widget.adminData['userid'],
                              name: _nameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              associateddoctor: hospitalIds,
                              context: context,
                            );

                            await salesprovider.getalladmins(context);
                          }
                        },
                  child: salesprovider.updatingadmin
                      ? CircularProgressIndicator()
                      : const Text(
                          'Update Admin',
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
                                 
                                  await provider.changeadminpassword(
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