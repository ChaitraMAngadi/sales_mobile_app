// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:sales_mobile_app/pages/doctors/uploadLogoFile.dart';
// // import 'package:sales_mobile_app/pages/formFeilds.dart';
// // import 'package:sales_mobile_app/provider/salesProvider.dart';
// // import 'package:sales_mobile_app/theme/app_colors.dart';


// // class BasicInfoStep extends StatefulWidget {
// //   const BasicInfoStep({super.key, required this.formKey});

// //   final GlobalKey<FormState> formKey;

// //   @override
// //   State<BasicInfoStep> createState() => _BasicInfoStepState();
// // }

// // class _BasicInfoStepState extends State<BasicInfoStep> {
// //   // Sample values from the design – replace with data from your API.
// //   final _name = TextEditingController();
// //   final _mobile = TextEditingController();
// //   final _email = TextEditingController();
// //   final _experience = TextEditingController();
// //   final _bio = TextEditingController();
// //   final _dobText = TextEditingController();

// //   final _dateFmt = DateFormat('dd-MM-yyyy');
// //   // DateTime _dob = DateTime(1996, 6, 14);
// //   // String _gender = 'Male';
// //     DateTime? _dob;
// //   String? _gender;


// //   @override
// //   void initState() {
// //     super.initState();
// //     // _dobText.text = _dateFmt.format(_dob);
// //     _name.addListener(() => setState(() {})); // live-update the avatar initials
// //   }

// //   @override
// //   void dispose() {
// //     _name.dispose();
// //     _mobile.dispose();
// //     _email.dispose();
// //     _experience.dispose();
// //     _bio.dispose();
// //     _dobText.dispose();
// //     super.dispose();
// //   }

// //   /// First letter of the first + last word ("Dr. Rohan Banerjee" -> "DB"),
// //   /// matching the design. Strip a leading "Dr." here if you'd rather get "RB".
// //   String get _initials {
// //     final parts = _name.text.trim().split(RegExp(r'\s+'))
// //       ..removeWhere((p) => p.isEmpty);
// //     if (parts.isEmpty) return '?';
// //     if (parts.length == 1) return parts.first[0].toUpperCase();
// //     return (parts.first[0] + parts.last[0]).toUpperCase();
// //   }

// //   Future<void> _pickDob() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       // initialDate: _dob,
// //       initialDate: _dob ?? DateTime.now(),
// //       firstDate: DateTime(1940),
// //       lastDate: DateTime.now(),
// //     );
// //     if (picked != null) {
// //       setState(() {
// //         _dob = picked;
// //         _dobText.text = _dateFmt.format(picked);
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final fields = Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         TwoColumn(
// //           left: LabeledField(
// //             label: 'Full name',
// //             isRequired: true,
// //             child: AppTextField(
// //               hint: "Enter Full name",
// //               controller: _name,
// //               validator: (v) =>
// //                   (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
// //             ),
// //           ),
// //           right: LabeledField(
// //             label: 'Gender',
            
// //             child: AppDropdown(
// //               hint: 'Select gender of the patient',
// //               value: _gender,
// //               items: const ['Male', 'Female', 'Other'],
// //               onChanged: (v) => setState(() => _gender = v ?? _gender),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         TwoColumn(
// //           left: LabeledField(
// //             label: 'Mobile number',
// //             child: AffixField(
// //               controller: _mobile,
// //               prefixText: '+91',
// //               hint: 'Enter Mobile number',
// //               keyboardType: TextInputType.phone,
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.digitsOnly,
// //                 LengthLimitingTextInputFormatter(10),
// //               ],
// //               validator: (v) =>
// //                   (v ?? '').length == 10 ? null : 'Enter a 10-digit number',
// //             ),
// //           ),
// //           right: LabeledField(
// //             label: 'Email',
// //             child: AppTextField(
// //               controller: _email,
// //               hint: "Enter email",
// //               prefixIcon: Icons.mail_outline_rounded,
// //               keyboardType: TextInputType.emailAddress,
// //               validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return null; // No error for empty value
// //                       }

// //                        const emailRegex =
// //                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|in|io|co|me|info|biz|xyz)$';

// //                       // const emailRegex =
// //                       //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
// //                       if (!RegExp(emailRegex).hasMatch(value!)) {
// //                         return 'Enter a valid email address';
// //                       }
// //                       return null; // Return null if the input is valid
// //                     }
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         TwoColumn(
// //           left: LabeledField(
// //             label: 'Date of birth',
// //             child: AppTextField(
// //               controller: _dobText,
// //               readOnly: true,
// //                hint: 'Select date of birth',
// //               onTap: _pickDob,
// //               suffixIcon: IconButton(
// //                 onPressed: _pickDob,
// //                 icon: const Icon(Icons.calendar_today_outlined, size: 20),
// //               ),
// //             ),
// //           ),
// //           right: LabeledField(
// //             label: 'Years of experience',
// //             child: AffixField(
// //               controller: _experience,
// //               suffixText: 'years',
// //               hint: "Enter year of experience",
// //               keyboardType: TextInputType.number,
// //               inputFormatters: [
// //                 FilteringTextInputFormatter.digitsOnly,
// //                 LengthLimitingTextInputFormatter(2),
// //               ],
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         LabeledField(
// //           label: 'Short bio',
// //           child: AppTextField(
// //             controller: _bio,
// //             maxLines: 4,
// //             maxLength: 400,
// //             hint: 'Tell patients about your approach and experience',
// //           ),
// //         ),
// //       ],
// //     );

// //     return Form(
// //       key: widget.formKey,
// //       child: LayoutBuilder(builder: (context, box) {
// //         final photo = _PhotoPicker(initials: _initials);
// //         if (box.maxWidth >= 820) {
// //           return Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               SizedBox(width: 260, child: photo),
// //               const SizedBox(width: 40),
// //               Expanded(child: fields),
// //             ],
// //           );
// //         }
// //         return Column(children: [photo, const SizedBox(height: 32), fields]);
// //       }),
// //     );
// //   }
// // }

// // class _PhotoPicker extends StatelessWidget {
// //   const _PhotoPicker({required this.initials});
// //   final String initials;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Container(
// //           width: 130,
// //           height: 130,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: AppColors.accent,
// //             border: Border.all(color: Colors.white, width: 6),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: AppColors.primary.withValues(alpha: 0.18),
// //                 blurRadius: 24,
// //                 offset: const Offset(0, 8),
// //               ),
// //             ],
// //           ),
// //           child: Text(
// //             initials,
// //             style: const TextStyle(
// //               fontSize: 64,
// //               fontWeight: FontWeight.w800,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         OutlinedButton.icon(
// //           onPressed: () async{
// //             await _pickAndUploadLogo(context);
// //           },
// //           icon: const Icon(Icons.upload_outlined, size: 20),
// //           label: const Text('Upload photo'),
// //           style: OutlinedButton.styleFrom(
// //             minimumSize: const Size(0, 46),
// //             foregroundColor: AppColors.primary,
// //             side: const BorderSide(color: AppColors.primary),
// //           ),
// //         ),
// //         const SizedBox(height: 14),
// //         const Text(
// //           'A clear, professional headshot helps patients trust your profile.',
// //           textAlign: TextAlign.center,
// //           style: TextStyle(fontSize: 13, color: AppColors.secondary, height: 1.4),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // Future<void> _pickAndUploadLogo(BuildContext context) async {
// //   final salesprovider = context.read<Salesprovider>();
// //   final ImagePicker picker = ImagePicker();

// //   final XFile? pickedFile = await picker.pickImage(
// //     source: ImageSource.gallery,
// //     imageQuality: 85,
// //   );

// //   if (pickedFile == null) return; // user cancelled

// //   const maxSizeInBytes = 500 * 1024; // 500 KB

// //   // Step 1: File select hote hi turant size check karo (crop se PEHLE)
// //   final int fileSizeInBytes = await pickedFile.length();

// //   if (fileSizeInBytes > maxSizeInBytes) {
// //     if (context.mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           backgroundColor: Colors.red,
// //           content: Text('File size must be 500KB or less. Please choose a smaller image.'),
// //         ),
// //       );
// //     }
// //     return; // yahin ruk jao, crop screen tak jaayega hi nahi
// //   }

// //   if (!context.mounted) return;

// //   final Uint8List originalBytes = await pickedFile.readAsBytes();

// //   if (!context.mounted) return;

// //   // Step 2: Crop dialog
// //   final Uint8List? croppedBytes = await showDialog<Uint8List>(
// //     context: context,
// //     barrierDismissible: false,
// //     builder: (_) => UploadLogoDialog(imageBytes: originalBytes),
// //   );

// //   if (croppedBytes == null) return; // user ne cancel/close kiya

// //   // Step 3: Crop ke baad bhi size check (kyunki crop se size badh bhi sakta hai edge cases mein)
// //   if (croppedBytes.lengthInBytes > maxSizeInBytes) {
// //     if (context.mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           backgroundColor: Colors.red,
// //           content: Text('Cropped image exceeds 500KB. Please crop a smaller area.'),
// //         ),
// //       );
// //     }
// //     return;
// //   }

// //   if (!context.mounted) return;

// //   // Step 4: Preview dialog
// //   // final bool? confirmed = await showDialog<bool>(
// //   //   context: context,
// //   //   barrierDismissible: false,
// //   //   builder: (dialogContext) => AlertDialog(
// //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //   //     title: const Text('Preview'),
// //   //     content: SizedBox(
// //   //       height: 200,
// //   //       child: Image.memory(croppedBytes, fit: BoxFit.contain),
// //   //     ),
// //   //     actions: [
// //   //       TextButton(
// //   //         onPressed: () => Navigator.pop(dialogContext, false),
// //   //         child: const Text('Cancel'),
// //   //       ),
// //   //       ElevatedButton(
// //   //         onPressed: () => Navigator.pop(dialogContext, true),
// //   //         child: const Text('Upload'),
// //   //       ),
// //   //     ],
// //   //   ),
// //   // );

// //   // if (confirmed != true) return;

// //   final tempDir = await getTemporaryDirectory();
// //   final tempFile = File('${tempDir.path}/logo_${DateTime.now().millisecondsSinceEpoch}.png');
// //   await tempFile.writeAsBytes(croppedBytes);

// //   if (!context.mounted) return;
// //   // await salesprovider.uploadHospitalLogo(hospitalId, tempFile, context);
// //   // await salesprovider.getallhospitals(context);
// //   salesprovider.notify();
// // }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_mobile_app/pages/doctors/uploadLogoFile.dart';
// import 'package:sales_mobile_app/pages/formFeilds.dart';
// import 'package:sales_mobile_app/provider/marketingProvider.dart';
// import 'package:sales_mobile_app/provider/salesProvider.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';

// class BasicInfoStep extends StatefulWidget {
//   const BasicInfoStep({super.key, required this.formKey, this.initialData, required this.doctorId});

//   final GlobalKey<FormState> formKey;
//   final Map<String, dynamic>? initialData;
//     final String doctorId;      // 👈 new


//   @override
//   State<BasicInfoStep> createState() => BasicInfoStepState();
// }

// class BasicInfoStepState extends State<BasicInfoStep> {
//   // Sample values from the design – replace with data from your API.
//   final _name = TextEditingController();
//   final _mobile = TextEditingController();
//   final _email = TextEditingController();
//   final _experience = TextEditingController();
//   final _bio = TextEditingController();
//   final _dobText = TextEditingController();

//   // New: medical registration.
//   final _regNo = TextEditingController();
//   final _regYear = TextEditingController();

//   final _dateFmt = DateFormat('dd-MM-yyyy');
//   DateTime? _dob;
//   String? _gender;

//   // New: languages spoken. Pre-ticked to match the design; wire this to
//   // real profile data when you load it from your API.
//   static const _allLanguages = [
//     'English',
//     'Hindi',
//     'Bengali',
//     'Tamil',
//     'Telugu',
//     'Marathi',
//     'Gujarati',
//     'Kannada',
//     'Malayalam',
//     'Punjabi',
//     'Odia',
//     'Urdu',
//   ];
//   final Set<String> _selectedLanguages = {'English', 'Hindi', 'Bengali'};

//   void _toggleLanguage(String language) {
//     setState(() {
//       if (_selectedLanguages.contains(language)) {
//         _selectedLanguages.remove(language);
//       } else {
//         _selectedLanguages.add(language);
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _name.addListener(() => setState(() {})); // live-update the avatar initials
//   _prefillFromInitialData();
  
//   }


//   void _prefillFromInitialData() {
//   final data = widget.initialData;
//   if (data == null) return;

//   _name.text = (data['fullName'] ?? '').toString();
//   _gender = data['gender'] as String?;

//   // Mobile comes as "+91 8595756172" — strip the country code + space
//   // so it fits the AffixField's prefixText: '+91'.
//   final mobileRaw = (data['mobileNumber'] ?? '').toString();
//   _mobile.text = mobileRaw.replaceFirst(RegExp(r'^\+91\s*'), '');

//   _email.text = (data['email'] ?? '').toString();
//   _experience.text = data['yearsOfExperience']?.toString() ?? '';

//   _regNo.text = (data['medicalRegistrationNumber'] ?? '').toString();
//   _regYear.text = data['registrationYear']?.toString() ?? '';

//   final dobRaw = data['dateOfBirth'] as String?;
//   if (dobRaw != null && dobRaw.isNotEmpty) {
//     final parsed = DateTime.tryParse(dobRaw);
//     if (parsed != null) {
//       _dob = parsed;
//       _dobText.text = _dateFmt.format(parsed);
//     }
//   }

//   final langs = data['languagesSpoken'];
//   if (langs is List && langs.isNotEmpty) {
//     _selectedLanguages
//       ..clear()
//       ..addAll(langs.map((e) => e.toString()));
//   }
//     _bio.text = (data['shortBio'] ?? '').toString();

//   // _bio has no matching field in the API response — leave as-is.
// }

//   @override
//   void dispose() {
//     _name.dispose();
//     _mobile.dispose();
//     _email.dispose();
//     _experience.dispose();
//     _bio.dispose();
//     _dobText.dispose();
//     _regNo.dispose();
//     _regYear.dispose();
//     super.dispose();
//   }

//   /// First letter of the first + last word ("Dr. Rohan Banerjee" -> "DB"),
//   /// matching the design. Strip a leading "Dr." here if you'd rather get "RB".
//   String get _initials {
//     final parts = _name.text.trim().split(RegExp(r'\s+'))
//       ..removeWhere((p) => p.isEmpty);
//     if (parts.isEmpty) return '?';
//     if (parts.length == 1) return parts.first[0].toUpperCase();
//     return (parts.first[0] + parts.last[0]).toUpperCase();
//   }

//   Future<void> _pickDob() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _dob ?? DateTime.now(),
//       firstDate: DateTime(1940),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _dob = picked;
//         _dobText.text = _dateFmt.format(picked);
//       });
//     }
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // NEW: is step ke saare fields se latest (edited) data nikaalo.
//   // Parent ye method Save/Update dabne par call karega.
//   // Keys bilkul "basicInformation" ke API shape se match karte hain.
//   // ═══════════════════════════════════════════════════════════════
//   Map<String, dynamic> getData() {
//     return {
//       'fullName': _name.text.trim(),
//       'gender': _gender ?? '',
//       'mobileNumber': _mobile.text.trim(),
//       'email': _email.text.trim(),
//       'dateOfBirth': _dob?.toIso8601String() ?? '',
//       'yearsOfExperience': _experience.text.trim().isEmpty
//           ? null
//           : int.tryParse(_experience.text.trim()),
//       'medicalRegistrationNumber': _regNo.text.trim(),
//       'registrationYear': _regYear.text.trim().isEmpty
//           ? null
//           : int.tryParse(_regYear.text.trim()),
//       'languagesSpoken': _selectedLanguages.toList(),
//       'shortBio': _bio.text.trim(),
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fields = Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TwoColumn(
//           left: LabeledField(
//             label: 'Full name',
//             isRequired: true,
//             child: AppTextField(
//               hint: "Enter Full name",
//               controller: _name,
//               validator: (v) => (v == null || v.trim().isEmpty)
//                   ? 'Enter your full name'
//                   : null,
//             ),
//           ),
//           right: LabeledField(
//             label: 'Gender',
//             child: AppDropdown(
//               hint: 'Select gender of the patient',
//               value: _gender,
//               items: const ['Male', 'Female', 'Other'],
//               onChanged: (v) => setState(() => _gender = v ?? _gender),
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         TwoColumn(
//           left: LabeledField(
//             label: 'Mobile number',
//             child: AffixField(
//               controller: _mobile,
//               prefixText: '+91',
//               hint: 'Enter Mobile number',
//               keyboardType: TextInputType.phone,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(10),
//               ],
//               validator: (v) =>
//                   (v ?? '').length == 10 ? null : 'Enter a 10-digit number',
//             ),
//           ),
//           right: LabeledField(
//             label: 'Email',
//             child: AppTextField(
//               controller: _email,
//               hint: "Enter email",
//               prefixIcon: Icons.mail_outline_rounded,
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return null; // No error for empty value
//                 }
//                 const emailRegex =
//                     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|in|io|co|me|info|biz|xyz)$';
//                 if (!RegExp(emailRegex).hasMatch(value)) {
//                   return 'Enter a valid email address';
//                 }
//                 return null; // Return null if the input is valid
//               },
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         TwoColumn(
//           left: LabeledField(
//             label: 'Date of birth',
//             child: AppTextField(
//               controller: _dobText,
//               readOnly: true,
//               hint: 'Select date of birth',
//               onTap: _pickDob,
//               suffixIcon: IconButton(
//                 onPressed: _pickDob,
//                 icon: const Icon(Icons.calendar_today_outlined, size: 20),
//               ),
//             ),
//           ),
//           right: LabeledField(
//             label: 'Years of experience',
//             child: AffixField(
//               controller: _experience,
//               suffixText: 'years',
//               hint: "Enter year of experience",
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(2),
//               ],
//             ),
//           ),
//         ),
//         // const SizedBox(height: 6),
//         // _HelperCaption('Not shown publicly'),
//         const SizedBox(height: 24),

//         // ── New: medical registration ──────────────────────────────
//         TwoColumn(
//           left: LabeledField(
//             label: 'Medical registration number',
//             child: AppTextField(
//               controller: _regNo,
//               hint: 'e.g. WBMC 78321',
//             ),
//           ),
//           right: LabeledField(
//             label: 'Registration year',
//             child: AppTextField(
//               controller: _regYear,
//               hint: 'e.g. 2017',
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(4),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         _HelperCaption('As issued by your State Medical Council or NMC'),
//         const SizedBox(height: 24),

//         // ── New: languages spoken ───────────────────────────────────
//         const Text(
//           'Languages spoken',
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: [
//             for (final language in _allLanguages)
//               _LanguageChip(
//                 label: language,
//                 selected: _selectedLanguages.contains(language),
//                 onTap: () => _toggleLanguage(language),
//               ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         _HelperCaption('Tap to select the languages you speak'),
//         const SizedBox(height: 24),

//         LabeledField(
//           label: 'Short bio',
//           child: AppTextField(
//             controller: _bio,
//             maxLines: 4,
//             maxLength: 400,
//             hint: 'Tell patients about your approach and experience',
//           ),
//         ),
//       ],
//     );

//     return Form(
//       key: widget.formKey,
//       child: LayoutBuilder(builder: (context, box) {
//         final photo = _PhotoPicker(initials: _initials , id: widget.doctorId,);
//         if (box.maxWidth >= 820) {
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(width: 260, child: photo),
//               const SizedBox(width: 40),
//               Expanded(child: fields),
//             ],
//           );
//         }
//         return Column(children: [photo, const SizedBox(height: 32), fields]);
//       }),
//     );
//   }
// }

// /// Small muted helper line under a field or group of fields
// /// (e.g. "Not shown publicly", "Tap to select the languages you speak").
// class _HelperCaption extends StatelessWidget {
//   const _HelperCaption(this.text);
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: const TextStyle(fontSize: 13, color: AppColors.secondary),
//     );
//   }
// }

// /// A tappable pill for one language. Tapping toggles selection: selected
// /// chips show a check mark and a tinted primary colour, unselected chips
// /// are plain white/grey — same select/deselect behaviour as the design.
// class _LanguageChip extends StatelessWidget {
//   const _LanguageChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: selected
//               ? AppColors.primary.withValues(alpha: 0.08)
//               : Colors.white,
//           border: Border.all(
//             color: selected ? AppColors.primary : Colors.grey.shade300,
//             width: 1.2,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (selected) ...[
//               Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
//               const SizedBox(width: 6),
//             ],
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: selected ? AppColors.primary : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class _PhotoPicker extends StatelessWidget {
// //   const _PhotoPicker({required this.initials, required this.id});
// //   final String initials;
// //   final String id;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Container(
// //           width: 130,
// //           height: 130,
// //           alignment: Alignment.center,
// //           decoration: BoxDecoration(
// //             shape: BoxShape.circle,
// //             color: AppColors.accent,
// //             border: Border.all(color: Colors.white, width: 6),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: AppColors.primary.withValues(alpha: 0.18),
// //                 blurRadius: 24,
// //                 offset: const Offset(0, 8),
// //               ),
// //             ],
// //           ),
// //           child: Text(
// //             initials,
// //             style: const TextStyle(
// //               fontSize: 64,
// //               fontWeight: FontWeight.w800,
// //               color: AppColors.primary,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 20),
// //         OutlinedButton.icon(
// //           onPressed: () async {
// //             await _pickAndUploadLogo(context, id);
// //           },
// //           icon: const Icon(Icons.upload_outlined, size: 20),
// //           label: const Text('Upload photo'),
// //           style: OutlinedButton.styleFrom(
// //             minimumSize: const Size(0, 46),
// //             foregroundColor: AppColors.primary,
// //             side: const BorderSide(color: AppColors.primary),
// //           ),
// //         ),
// //         const SizedBox(height: 14),
// //         const Text(
// //           'A clear, professional headshot helps patients trust your profile.',
// //           textAlign: TextAlign.center,
// //           style:
// //               TextStyle(fontSize: 13, color: AppColors.secondary, height: 1.4),
// //         ),
// //       ],
// //     );
// //   }
// // }

// class _PhotoPicker extends StatefulWidget {
//   const _PhotoPicker({required this.initials, required this.id});
//   final String initials;
//   final String id;

//   @override
//   State<_PhotoPicker> createState() => _PhotoPickerState();
// }

// class _PhotoPickerState extends State<_PhotoPicker> {
//   @override
//   Widget build(BuildContext context) {
//     // 👇 Listen to the provider so the circle refreshes after upload
//     final provider = context.watch<Marketingprovider>();
//     final details = provider.doctordetails;
//     bool isDeleting = false;


//     // Backend saves it as `profilePhoto` on the marketing document.
//     // Also checks inside basicInformation, just in case.
//     final String? photoUrl = (details?['profilePhoto'] ??
//             details?['basicInformation']?['profilePhoto'])
//         ?.toString();

//     final bool hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

//     final initialsWidget = Center(
//       child: Text(
//         widget.initials,
//         style: const TextStyle(
//           fontSize: 64,
//           fontWeight: FontWeight.w800,
//           color: AppColors.primary,
//         ),
//       ),
//     );

//     return Column(
//       children: [
//         Container(
//           width: 130,
//           height: 130,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: AppColors.accent,
//             border: Border.all(color: Colors.white, width: 6),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.primary.withValues(alpha: 0.18),
//                 blurRadius: 24,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: ClipOval(
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 if (hasPhoto)
//                   Image.network(
//                     photoUrl,
//                     key: ValueKey(photoUrl), // new URL → reload image
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, progress) {
//                       if (progress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       );
//                     },
//                     // If the URL is broken, show initials instead
//                     errorBuilder: (_, __, ___) => initialsWidget,
//                   )
//                 else
//                   initialsWidget,

//                 // Spinner overlay while uploading
//                 if (provider.uploadinglogo)
//                   Container(
//                     color: Colors.black.withValues(alpha: 0.35),
//                     child: const Center(
//                       child: CircularProgressIndicator(color: Colors.white),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         OutlinedButton.icon(
//           onPressed: provider.uploadinglogo
//               ? null // disable while uploading
//               : () async {
//                   await _pickAndUploadLogo(context, widget.id);
//                 },
//           icon: const Icon(Icons.upload_outlined, size: 20),
//           label: Text(hasPhoto ? 'Change photo' : 'Upload photo'),
//           style: OutlinedButton.styleFrom(
//             minimumSize: const Size(0, 46),
//             foregroundColor: AppColors.primary,
//             side: const BorderSide(color: AppColors.primary),
//           ),
//         ),
//         // const SizedBox(height: 14),
//         hasPhoto ? TextButton(
//           onPressed: isDeleting
//                                   ? null
//                                   : () async {
//                                       setState(() => isDeleting = true);
//                                       await provider.deleteHospitalLogo(widget.id, context);
//                                       await provider.getdoctoralldetails(context, widget.id);
                              
//                                     },
//                                     child: Text("Remove photo",
//         style: TextStyle(color: Colors.grey,
//         ),)): Text(""),
//         // hasPhoto?const SizedBox(height: 14):const SizedBox(height: 0),

//         const Text(
//           'A clear, professional headshot helps patients trust your profile.',
//           textAlign: TextAlign.center,
//           style:
//               TextStyle(fontSize: 13, color: AppColors.secondary, height: 1.4),
//         ),
//       ],
//     );
//   }
// }

// Future<void> _pickAndUploadLogo(BuildContext context, String id) async {
//   final marketingprovider = context.read<Marketingprovider>();
//   final ImagePicker picker = ImagePicker();

//   final XFile? pickedFile = await picker.pickImage(
//     source: ImageSource.gallery,
//     imageQuality: 85,
//   );

//   if (pickedFile == null) return; // user cancelled

//   const maxSizeInBytes = 500 * 1024; // 500 KB

//   // Step 1: File select hote hi turant size check karo (crop se PEHLE)
//   final int fileSizeInBytes = await pickedFile.length();

//   if (fileSizeInBytes > maxSizeInBytes) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content:
//               Text('File size must be 500KB or less. Please choose a smaller image.'),
//         ),
//       );
//     }
//     return; // yahin ruk jao, crop screen tak jaayega hi nahi
//   }

//   if (!context.mounted) return;

//   final Uint8List originalBytes = await pickedFile.readAsBytes();

//   if (!context.mounted) return;

//   // Step 2: Crop dialog
//   final Uint8List? croppedBytes = await showDialog<Uint8List>(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => UploadLogoDialog(imageBytes: originalBytes),
//   );

//   if (croppedBytes == null) return; // user ne cancel/close kiya

//   // Step 3: Crop ke baad bhi size check (kyunki crop se size badh bhi sakta hai edge cases mein)
//   if (croppedBytes.lengthInBytes > maxSizeInBytes) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Cropped image exceeds 500KB. Please crop a smaller area.'),
//         ),
//       );
//     }
//     return;
//   }

//   if (!context.mounted) return;

//   final tempDir = await getTemporaryDirectory();
//   final tempFile =
//       File('${tempDir.path}/logo_${DateTime.now().millisecondsSinceEpoch}.png');
//   await tempFile.writeAsBytes(croppedBytes);

//   if (!context.mounted) return;
//   await marketingprovider.uploadHospitalLogo(id, tempFile, context);
//   await marketingprovider.getdoctoralldetails(context,id);
  
// }

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/provider/marketingProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

/// Profile photo ki max size. Isse badi photo select karte hi reject ho jati hai.
const int _kMaxPhotoBytes = 500 * 1024; // 500 KB

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({
    super.key,
    required this.formKey,
    this.initialData,
    required this.doctorId,
  });

  final GlobalKey<FormState> formKey;
  final Map<String, dynamic>? initialData;
  final String doctorId;

  @override
  State<BasicInfoStep> createState() => BasicInfoStepState();
}

class BasicInfoStepState extends State<BasicInfoStep> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _experience = TextEditingController();
  final _bio = TextEditingController();
  final _dobText = TextEditingController();

  // Medical registration.
  final _regNo = TextEditingController();
  final _regYear = TextEditingController();

  final _dateFmt = DateFormat('dd-MM-yyyy');
  DateTime? _dob;
  String? _gender;

  static const _allLanguages = [
    'English',
    'Hindi',
    'Bengali',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
    'Odia',
    'Urdu',
  ];
  final Set<String> _selectedLanguages = {};

  void _toggleLanguage(String language) {
    setState(() {
      if (_selectedLanguages.contains(language)) {
        _selectedLanguages.remove(language);
      } else {
        _selectedLanguages.add(language);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {})); // live-update the avatar initials
    _prefillFromInitialData();
  }

  void _prefillFromInitialData() {
    final data = widget.initialData;
    if (data == null) return;

    _name.text = (data['fullName'] ?? '').toString();
    _gender = data['gender'] as String?;

    // Mobile "+91 8595756172" aaye to country code hata do
    final mobileRaw = (data['mobileNumber'] ?? '').toString();
    _mobile.text = mobileRaw.replaceFirst(RegExp(r'^\+91\s*'), '');

    _email.text = (data['email'] ?? '').toString();
    _experience.text = data['yearsOfExperience']?.toString() ?? '';

    _regNo.text = (data['medicalRegistrationNumber'] ?? '').toString();
    _regYear.text = data['registrationYear']?.toString() ?? '';

    final dobRaw = data['dateOfBirth'] as String?;
    if (dobRaw != null && dobRaw.isNotEmpty) {
      final parsed = DateTime.tryParse(dobRaw);
      if (parsed != null) {
        _dob = parsed;
        _dobText.text = _dateFmt.format(parsed);
      }
    }

    final langs = data['languagesSpoken'];
    if (langs is List && langs.isNotEmpty) {
      _selectedLanguages
        ..clear()
        ..addAll(langs.map((e) => e.toString()));
    }
    _bio.text = (data['shortBio'] ?? '').toString();
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _email.dispose();
    _experience.dispose();
    _bio.dispose();
    _dobText.dispose();
    _regNo.dispose();
    _regYear.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _name.text.trim().split(RegExp(r'\s+'))
      ..removeWhere((p) => p.isEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobText.text = _dateFmt.format(picked);
      });
    }
  }

  // /// Parent Save/Update par ye call karta hai.
  // Map<String, dynamic> getData() {
  //   return {
  //     'fullName': _name.text.trim(),
  //     'gender': _gender ?? '',
  //     'mobileNumber': _mobile.text.trim(),
  //     'email': _email.text.trim(),
  //     'dateOfBirth': _dob?.toIso8601String() ?? '',
  //     'yearsOfExperience': _experience.text.trim().isEmpty
  //         ? null
  //         : int.tryParse(_experience.text.trim()),
  //     'medicalRegistrationNumber': _regNo.text.trim(),
  //     'registrationYear': _regYear.text.trim().isEmpty
  //         ? null
  //         : int.tryParse(_regYear.text.trim()),
  //     'languagesSpoken': _selectedLanguages.toList(),
  //     'shortBio': _bio.text.trim(),
  //   };
  // }

  /// Parent Save/Update par ye call karta hai.
/// Required fields hamesha jaate hain; optional fields sirf tab
/// jab user ne unme kuch bhara ho.
Map<String, dynamic> getData() {
  final mobile = _mobile.text.trim();
  final email = _email.text.trim();
  final experience = _experience.text.trim();
  final regNo = _regNo.text.trim();
  final regYear = _regYear.text.trim();
  final bio = _bio.text.trim();

  return {
    // ── required ──
    'fullName': _name.text.trim(),
    'gender': _gender ?? '',

    // ── optional (empty ho to body me nahi jayenge) ──
    if (mobile.isNotEmpty) 'mobileNumber': mobile,
    if (email.isNotEmpty) 'email': email,
    if (_dob != null) 'dateOfBirth': _dob!.toIso8601String(),
    if (experience.isNotEmpty)
      'yearsOfExperience': int.tryParse(experience) ?? experience,
    if (regNo.isNotEmpty) 'medicalRegistrationNumber': regNo,
    if (regYear.isNotEmpty)
      'registrationYear': int.tryParse(regYear) ?? regYear,
    if (_selectedLanguages.isNotEmpty)
      'languagesSpoken': _selectedLanguages.toList(),
    if (bio.isNotEmpty) 'shortBio': bio,
  };
}

  @override
  Widget build(BuildContext context) {
    final fields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TwoColumn(
          left: LabeledField(
            label: 'Full name',
            isRequired: true,
            child: 
             AppTextField(
  hint: "Enter Full name",
  controller: _name,
  inputFormatters: [LengthLimitingTextInputFormatter(60)],
  validator: (v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Enter your full name';
    if (t.length > 60) return 'Name can be at most 60 characters';
    return null;
  },
),
            // AppTextField(
            //   hint: "Enter Full name",
            //   controller: _name,
            //   validator: (v) => (v == null || v.trim().isEmpty)
            //       ? 'Enter your full name'
            //       : null,
            // ),
          ),
          right: LabeledField(
            label: 'Gender',
            isRequired: true,
            child: AppDropdown(
  hint: 'Select gender',
  valiadtiontext: 'Please select gender',
  value: _gender,
  items: const ['Male', 'Female', 'Other'],
  onChanged: (v) => setState(() => _gender = v ?? _gender),
),
            // child: AppDropdown(
            //   hint: 'Select gender of the patient',
            //   value: _gender,
            //   items: const ['Male', 'Female', 'Other'],
            //   onChanged: (v) => setState(() => _gender = v ?? _gender),
            //   // allowEmpty: true,
            // ),
          ),
        ),
        const SizedBox(height: 24),
        TwoColumn(
          left: LabeledField(
            label: 'Mobile number',
            child: AffixField(
              controller: _mobile,
              prefixText: '+91',
              hint: 'Enter Mobile number',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
  if (value == null || value.isEmpty) return null;
  if (!RegExp(r'^[1-9]\d{9}$').hasMatch(value)) {
    return 'Mobile number should be 10 digits (cannot start with 0)';
  }
  return null;
},
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return null; // No error for empty value
              //   }
              //   if(value.length< 10){
              //     return 'Enter a 10-digit number';
              //   }
              //   return null;
              // }
              // validator: (v) =>
              //     (v ?? '').length == 10 ? null : 'Enter a 10-digit number',
            ),
          ),
          right: LabeledField(
            label: 'Email',
            child: AppTextField(
              controller: _email,
              hint: "Enter email",
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // No error for empty value
                }
                const emailRegex =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|in|io|co|me|info|biz|xyz)$';
                if (!RegExp(emailRegex).hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        TwoColumn(
          left: LabeledField(
            label: 'Date of birth',
            child: AppTextField(
              controller: _dobText,
              readOnly: true,
              hint: 'Select date of birth',
              onTap: _pickDob,
              suffixIcon: IconButton(
                onPressed: _pickDob,
                icon: const Icon(Icons.calendar_today_outlined, size: 20),
              ),
            ),
          ),
          right: LabeledField(
            label: 'Years of experience',
            child: AffixField(
              controller: _experience,
              suffixText: 'years',
              hint: "Enter year of experience",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
               validator: (v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final n = int.tryParse(t);
    if (n == null || n < 0 || n > 70) {
      return 'Enter experience between 0 and 70 years';
    }
    return null;
  },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── medical registration ──
        TwoColumn(
          left: LabeledField(
            label: 'Medical registration number',
            child: AppTextField(
              controller: _regNo,
              hint: 'e.g. WBMC 78321',
            ),
          ),
          right: LabeledField(
            label: 'Registration year',
            child: AppTextField(
              controller: _regYear,
              hint: 'e.g. 2017',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: validateYear,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const _HelperCaption('As issued by your State Medical Council or NMC'),
        const SizedBox(height: 24),

        // ── languages spoken ──
        const Text(
          'Languages spoken',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final language in _allLanguages)
              _LanguageChip(
                label: language,
                selected: _selectedLanguages.contains(language),
                onTap: () => _toggleLanguage(language),
              ),
          ],
        ),
        const SizedBox(height: 6),
        const _HelperCaption('Tap to select the languages you speak'),
        const SizedBox(height: 24),

        LabeledField(
          label: 'Short bio',
          child: AppTextField(
            controller: _bio,
            maxLines: 4,
            maxLength: 400,
            hint: 'Tell patients about your approach and experience',
          ),
        ),
      ],
    );

    return Form(
      key: widget.formKey,
      child: LayoutBuilder(builder: (context, box) {
        final photo = _PhotoPicker(initials: _initials, id: widget.doctorId);
        if (box.maxWidth >= 820) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 260, child: photo),
              const SizedBox(width: 40),
              Expanded(child: fields),
            ],
          );
        }
        return Column(children: [photo, const SizedBox(height: 32), fields]);
      }),
    );
  }
}

class _HelperCaption extends StatelessWidget {
  const _HelperCaption(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, color: AppColors.secondary),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Profile photo
// ═══════════════════════════════════════════════════════════════════
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.initials, required this.id});
  final String initials;
  final String id;

  @override
  Widget build(BuildContext context) {
    // Provider sun rahe hain taaki upload/delete ke baad circle refresh ho
    final provider = context.watch<Marketingprovider>();
    final details = provider.doctordetails;

    final String? photoUrl = (details?['profilePhoto'] ??
            details?['basicInformation']?['profilePhoto'])
        ?.toString();
    final bool hasPhoto = photoUrl != null && photoUrl.isNotEmpty;
    final bool busy = provider.uploadinglogo || provider.deletinglogo;

    final initialsWidget = Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );

    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent,
            border: Border.all(color: Colors.white, width: 6),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasPhoto)
                  Image.network(
                    photoUrl,
                    key: ValueKey(photoUrl), // naya URL -> image reload
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (_, __, ___) => initialsWidget,
                  )
                else
                  initialsWidget,
                if (busy)
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: busy ? null : () => _pickAndUploadPhoto(context, id),
          icon: const Icon(Icons.upload_outlined, size: 20),
          label: Text(hasPhoto ? 'Change photo' : 'Upload photo'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 46),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
          ),
        ),
        if (hasPhoto)
          TextButton(
            // deleteHospitalLogo khud details dobara fetch kar leta hai
            onPressed:
                busy ? null : () => provider.deleteHospitalLogo(id, context),
            child: const Text(
              'Remove photo',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          const SizedBox(height: 14),
        const Text(
          'A clear, professional headshot helps patients trust your profile.',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontSize: 13, color: AppColors.secondary, height: 1.4),
        ),
        const SizedBox(height: 6),
        Text(
          'Max size ${_formatSize(_kMaxPhotoBytes)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

String _formatSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / 1024).round()} KB';
}

/// 1) Gallery se photo chuno
/// 2) Select karte hi size check (500 KB se zyada ho to yahin ruk jao)
/// 3) Round crop dialog
/// 4) Upload
Future<void> _pickAndUploadPhoto(BuildContext context, String id) async {
  final marketingprovider = context.read<Marketingprovider>();

  // imageQuality NAHI diya: taaki asli file ki size check ho
  // (quality dene se photo re-compress ho jati hai aur check galat ho jata).
  final XFile? pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return; // user ne cancel kiya

  // ✅ Selection par hi size restriction (crop se pehle)
  final int fileSize = await pickedFile.length();
  if (fileSize > _kMaxPhotoBytes) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Selected photo is ${_formatSize(fileSize)}. '
            'Maximum allowed size is ${_formatSize(_kMaxPhotoBytes)} — '
            'please choose a smaller photo.',
          ),
        ),
      );
    }
    return;
  }

  if (!context.mounted) return;

  final Uint8List originalBytes = await pickedFile.readAsBytes();
  if (!context.mounted) return;

  // ✅ Round (circle) crop
  final Uint8List? croppedBytes = await showDialog<Uint8List>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CircleCropDialog(
      imageBytes: originalBytes,
      maxBytes: _kMaxPhotoBytes,
    ),
  );
  if (croppedBytes == null) return; // user ne cancel kiya

  // Crop ke baad bhi limit check (dialog size chhota karta hai, phir bhi safety)
  if (croppedBytes.lengthInBytes > _kMaxPhotoBytes) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'Cropped photo exceeds ${_formatSize(_kMaxPhotoBytes)}. Please choose a smaller photo.'),
        ),
      );
    }
    return;
  }

  final tempDir = await getTemporaryDirectory();
  final tempFile = File(
      '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png');
  await tempFile.writeAsBytes(croppedBytes);

  if (!context.mounted) return;
  // uploadHospitalLogo khud details dobara fetch karta hai
  await marketingprovider.uploadHospitalLogo(id, tempFile, context);
}


/// Profile photo ke liye round (circle) crop dialog.
///
/// - Photo ko ungli se khiskao (move) aur pinch karke zoom karo
/// - Circle ke andar jo dikh raha hai wahi photo banega
/// - Done dabane par square PNG bytes return hote hain (UI mein ClipOval se gol dikhta hai)
/// - Output size automatically chhota kiya jata hai taaki [maxBytes] se upar na jaye
/// - Cancel / back par null return hota hai
class CircleCropDialog extends StatefulWidget {
  const CircleCropDialog({
    super.key,
    required this.imageBytes,
    this.maxBytes = 500 * 1024,
  });

  final Uint8List imageBytes;
  final int maxBytes;

  @override
  State<CircleCropDialog> createState() => _CircleCropDialogState();
}

class _CircleCropDialogState extends State<CircleCropDialog> {
  static const double _viewport = 280;

  final TransformationController _tc = TransformationController();

  ui.Image? _image;
  double _dispW = 0;
  double _dispH = 0;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  @override
  void dispose() {
    _tc.dispose();
    _image?.dispose();
    super.dispose();
  }

  Future<void> _decode() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.imageBytes);
      final frame = await codec.getNextFrame();
      final img = frame.image;

      // "Cover" fit: chhoti side viewport ke barabar
      final shortSide = img.width < img.height ? img.width : img.height;
      final scale = _viewport / shortSide;
      final w = img.width * scale;
      final h = img.height * scale;

      // Shuruaat mein image beech mein
      _tc.value =
          Matrix4.translationValues(-(w - _viewport) / 2, -(h - _viewport) / 2, 0);

      if (!mounted) return;
      setState(() {
        _image = img;
        _dispW = w;
        _dispH = h;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not open this image. Please choose another one.';
      });
    }
  }

  Future<void> _done() async {
    final img = _image;
    if (img == null || _saving) return;
    setState(() => _saving = true);

    try {
      final m = _tc.value;
      final s = m.getMaxScaleOnAxis();
      final tx = m.storage[12];
      final ty = m.storage[13];

      // display px -> source image px
      final k = img.width / _dispW;
      final src = Rect.fromLTWH(
        (-tx / s) * k,
        (-ty / s) * k,
        (_viewport / s) * k,
        (_viewport / s) * k,
      );

      Uint8List? out;
      // Bade se chhote size tak try, jo pehle limit ke andar aaye wahi lo
      for (final size in const [512, 400, 300, 256]) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawImageRect(
          img,
          src,
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          Paint()..filterQuality = FilterQuality.high,
        );
        final picture = recorder.endRecording();
        final outImg = await picture.toImage(size, size);
        final data = await outImg.toByteData(format: ui.ImageByteFormat.png);
        outImg.dispose();
        picture.dispose();
        if (data == null) continue;

        out = data.buffer.asUint8List();
        if (out.lengthInBytes <= widget.maxBytes) break;
      }

      if (!mounted) return;
      Navigator.of(context).pop(out);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not crop the image. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Crop your photo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Center(child: _buildCropper()),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 12.5),
                ),
              )
            else
              Text(
                'Drag to move · Pinch to zoom',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _saving ? null : () => Navigator.of(context).pop(null),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: (_image == null || _saving) ? null : _done,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropper() {
    if (_loading) {
      return const SizedBox(
        width: _viewport,
        height: _viewport,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_image == null) {
      return const SizedBox(
        width: _viewport,
        height: _viewport,
        child: Center(
          child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      width: _viewport,
      height: _viewport,
      child: ClipRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black),
            ),
            InteractiveViewer(
              transformationController: _tc,
              constrained: false,
              minScale: 1,
              maxScale: 5,
              boundaryMargin: EdgeInsets.zero,
              child: SizedBox(
                width: _dispW,
                height: _dispH,
                child: Image.memory(
                  widget.imageBytes,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                ),
              ),
            ),
            // Gol overlay: bahar ka hissa dim, andar saaf. Touch neeche jaane do.
            const Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _CircleMask())),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleMask extends CustomPainter {
  const _CircleMask();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;

    final dim = Path()
      ..addRect(rect)
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(dim, Paint()..color = Colors.black.withOpacity(0.55));

    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}