import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/doctors/uploadLogoFile.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';


class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
    final TextEditingController _searchController = TextEditingController();
  late Future fetchhospitals;
  String _searchQuery = ''; 
  final SecureStorage secureStorage = SecureStorage();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
     Salesprovider salesprovider = context.read<Salesprovider>();
    fetchhospitals = salesprovider.getallhospitals(context);

    _searchController.addListener(() {   
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }


@override
  void dispose() {
    _searchController.dispose();   // 👈 naya - cleanup
    super.dispose();
  }
  List<Map<String, dynamic>> _filterHospitals(List<Map<String, dynamic>> hospitals) {
  if (_searchQuery.isEmpty) {
    return hospitals;
  }

  return hospitals.where((hospital) {
    final name = (hospital['name'] ?? '').toString().toLowerCase();
    final id = (hospital['userid'] ?? '').toString().toLowerCase();
    final phone = (hospital['phone'] ?? '').toString().toLowerCase();

    return name.contains(_searchQuery) ||
        id.contains(_searchQuery) ||
        phone.contains(_searchQuery);
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Consumer<Salesprovider>(builder:(context, salesprovider, child) {
      return Column(
        children: [
          _TopActionsBar(),
          _buildSearchBar(),
          Expanded(child: _buildMainContent(salesprovider)),
          
        ],
      );
    },);
  }

  Widget _buildLoadingState() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            Icon(Icons.favorite, color: AppColors.secondary, size: 28),
          ],
        ),
        SizedBox(height: 24),
        Text(
          'Loading hospitals...',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Future<void> _handleRefresh() async {
    Salesprovider salesprovider = context.read<Salesprovider>();

    await Future.delayed(Duration(seconds: 2));
    
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    setState(() {
      fetchhospitals = salesprovider.getallhospitals(context);
    });
  }

  Widget _buildMainContent(Salesprovider provider){
    return RefreshIndicator(
      onRefresh: () => _handleRefresh() ,
      child: FutureBuilder(future: fetchhospitals, 
      builder:(context, snapshot) 
      {
         if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: BoxDecoration(gradient: AppColors.bgGradient),
                  child: SafeArea(child: _buildLoadingState()),
                );
              }
      
              final filteredHospitals = _filterHospitals(provider.allhospitals);   // 👈 naya
            
            
                  if (filteredHospitals.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "There no hospitals Registered Please \nRegister Hospital",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
      
        return Container(
          height:  MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            itemCount:filteredHospitals.length, 
          
            itemBuilder:(context, index) {
                // final item = provider.allhospitals[index];
       final item = filteredHospitals[index];
              
            return HospitalCard(onView: ()=> showDialog(
                          context: context,
                          builder: (_) => ViewHospitalModel(
                            name: item['name']??"",
                            adminId: item['userid']??"",
                            email: item['email'] ?? "",
                            phonenumber: item['phone'] ?? "",
                            createdat: item['createdAt']??"",
                            address: item['address']??"",
                          ),
                        ), 
                         onEdit: () {
                                              context.router.push(
                                                EditHospitalRoute(
                                              hospitalId: item["userid"],
                                              name: item['name'],
                                              email: item['email'],
                                              phone: item['phone'],
                                              address: item['address'],
                                              userid: item["userid"],
                                              ));
      
                         },
            onToggleActive: () {
      _showToggleStatusConfirmation(
            context,
            item['userid'],
            item['isActive'] ?? false,
            item['name'] ?? 'this hospital',
      );
            },
            onUpload: provider.uploadinglogo 
        ? (){} 
        : () async {
        await _pickAndUploadLogo(context, item['userid']);
      }, 
      onDelete: () {
      _showDeleteConfirmation(context, item['userid'], item['name'] ?? 'this hospital');
            },
      
       hospitalname: item['name'], hospitalId: item['userid'], isactive: item['isActive'], phone: item['phone'], logoUrl: item['logo']??'');
          },),
        );
      },),
    );
  }


  // Widget _buildSearchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(color: const Color(0xFFF0DEDE)),
  //       ),
  //       child: TextField(
  //         controller: _searchController,
  //         decoration: InputDecoration(
  //           hintText: 'Search hospitals...',
  //           hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
  //           prefixIcon: const Icon(Icons.search, color: Color(0xFFE5544E)),
  //           border: InputBorder.none,
  //           contentPadding: const EdgeInsets.symmetric(vertical: 16),
  //         ),
  //       ),
  //     ),
  //   );
  // }

Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0DEDE)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search hospitals by name, ID, or phone...',   // 👈 updated hint
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFE5544E)),
          suffixIcon: _searchQuery.isNotEmpty   // 👈 naya - clear button
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ),
  );
}

// Future<void> _pickAndUploadLogo(BuildContext context, String hospitalId) async {
//   final salesprovider = context.read<Salesprovider>();
//   final ImagePicker picker = ImagePicker();

//   final XFile? pickedFile = await picker.pickImage(
//     source: ImageSource.gallery,   // sirf gallery se, camera nahi
//     imageQuality: 85,
//   );

//   if (pickedFile == null) {
//     return; // user cancelled
//   }

//   File file = File(pickedFile.path);
//   final fileSizeInBytes = await file.length();
//   const maxSizeInBytes = 500 * 1024; // 500 KB

//   if (fileSizeInBytes > maxSizeInBytes) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('File size must be 500KB or less'),
//         ),
//       );
//     }
//     return;
//   }

//   await salesprovider.uploadHospitalLogo(hospitalId, file, context);
// }

// Future<void> _pickAndUploadLogo(BuildContext context, String hospitalId) async {
//   final salesprovider = context.read<Salesprovider>();
//   final ImagePicker picker = ImagePicker();

//   final XFile? pickedFile = await picker.pickImage(
//     source: ImageSource.gallery,
//     imageQuality: 85,
//   );

//   if (pickedFile == null) {
//     return; // user cancelled
//   }

//   final Uint8List originalBytes = await pickedFile.readAsBytes();

//   if (!context.mounted) return;

//   // Crop dialog dikhaye jaise screenshot mein hai
//   final Uint8List? croppedBytes = await showDialog<Uint8List>(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => UploadLogoDialog(imageBytes: originalBytes),
//   );

//   if (croppedBytes == null) {
//     return; // user ne cancel/close kiya
//   }

//   const maxSizeInBytes = 500 * 1024; // 500 KB
//   if (croppedBytes.lengthInBytes > maxSizeInBytes) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('File size must be 500KB or less'),
//         ),
//       );
//     }
//     return;
//   }

//   // Cropped bytes ko temp file mein save karo upload ke liye
//   final tempDir = await getTemporaryDirectory();
//   final tempFile = File('${tempDir.path}/logo_${DateTime.now().millisecondsSinceEpoch}.png');
//   await tempFile.writeAsBytes(croppedBytes);

//   if (!context.mounted) return;
//   await salesprovider.uploadHospitalLogo(hospitalId, tempFile, context);
// }

Future<void> _pickAndUploadLogo(BuildContext context, String hospitalId) async {
  final salesprovider = context.read<Salesprovider>();
  final ImagePicker picker = ImagePicker();

  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  );

  if (pickedFile == null) return; // user cancelled

  const maxSizeInBytes = 500 * 1024; // 500 KB

  // Step 1: File select hote hi turant size check karo (crop se PEHLE)
  final int fileSizeInBytes = await pickedFile.length();

  if (fileSizeInBytes > maxSizeInBytes) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('File size must be 500KB or less. Please choose a smaller image.'),
        ),
      );
    }
    return; // yahin ruk jao, crop screen tak jaayega hi nahi
  }

  if (!context.mounted) return;

  final Uint8List originalBytes = await pickedFile.readAsBytes();

  if (!context.mounted) return;

  // Step 2: Crop dialog
  final Uint8List? croppedBytes = await showDialog<Uint8List>(
    context: context,
    barrierDismissible: false,
    builder: (_) => UploadLogoDialog(imageBytes: originalBytes),
  );

  if (croppedBytes == null) return; // user ne cancel/close kiya

  // Step 3: Crop ke baad bhi size check (kyunki crop se size badh bhi sakta hai edge cases mein)
  if (croppedBytes.lengthInBytes > maxSizeInBytes) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Cropped image exceeds 500KB. Please crop a smaller area.'),
        ),
      );
    }
    return;
  }

  if (!context.mounted) return;

  // Step 4: Preview dialog
  final bool? confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Preview'),
      content: SizedBox(
        height: 200,
        child: Image.memory(croppedBytes, fit: BoxFit.contain),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Upload'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/logo_${DateTime.now().millisecondsSinceEpoch}.png');
  await tempFile.writeAsBytes(croppedBytes);

  if (!context.mounted) return;
  await salesprovider.uploadHospitalLogo(hospitalId, tempFile, context);
  await salesprovider.getallhospitals(context);
  salesprovider.notify();
}

// Future<void> _showDeleteConfirmation(BuildContext context, String hospitalId, String hospitalName) async {
//   final salesprovider = context.read<Salesprovider>();

//   showDialog(
//     context: context,
//     builder: (dialogContext) {
//       return Dialog(
//         insetPadding: EdgeInsets.symmetric(horizontal: 16),
        
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.red),
//               SizedBox(width: 8),
//               Text('Confirm Delete',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),),
//             ],
//           ),
//           SizedBox(height: 8,),
//           Text(
//             'Are you sure you want to delete "$hospitalName" Logo ? This action cannot be undone.',
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 16,
            
//             ),
//           ),
//            SizedBox(height: 20,),
//           Row(
//             children: [
//               Expanded(
//                 child: 
//                 // TextButton(
//                 // onPressed: () => Navigator.pop(dialogContext),
//                 // child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
//                 //             ),
//                             Container(
//                 decoration: BoxDecoration(
//                   gradient: AppColors.secondaryGradient,
//                   borderRadius: BorderRadius.all(Radius.circular(16))
//                 ),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     foregroundColor: Colors.white,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   onPressed: () => Navigator.pop(dialogContext),
//                   child: const Text('Cancel'),
//                 ),
//               )
//               ),
//               SizedBox(width: 16,),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: AppColors.primaryGradient,
//                   borderRadius: BorderRadius.all(Radius.circular(16))
//                 ),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     foregroundColor: Colors.white,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   onPressed: () async {
//                     Navigator.pop(dialogContext); // close confirmation dialog first
//                     await salesprovider.deleteHospitalLogo(hospitalId, context);
//                     await salesprovider.getallhospitals(context);
//                      salesprovider.notify();
//                   },
//                   child: const Text('Delete'),
//                 ),
//               ),
//             ),
//             ],
//           )
//             ],
//           ),
//         ),
//         // title: const Row(
//         //   children: [
//         //     Icon(Icons.warning_amber_rounded, color: Colors.red),
//         //     SizedBox(width: 8),
//         //     Text('Confirm Delete'),
//         //   ],
//         // ),
//         // content: Text(
//         //   'Are you sure you want to delete "$hospitalName"? This action cannot be undone.',
//         //   style: const TextStyle(fontSize: 15),
//         // ),
//         // actions: [
//         //   TextButton(
//         //     onPressed: () => Navigator.pop(dialogContext),
//         //     child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
//         //   ),
//         //   ElevatedButton(
//         //     style: ElevatedButton.styleFrom(
//         //       backgroundColor: Colors.red,
//         //       foregroundColor: Colors.white,
//         //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         //     ),
//         //     onPressed: () async {
//         //       Navigator.pop(dialogContext); // close confirmation dialog first
//         //       await salesprovider.deleteHospital(hospitalId, context);
//         //     },
//         //     child: const Text('Delete'),
//         //   ),
//         // ],
//       );
//     },
//   );
// }

Future<void> _showDeleteConfirmation(BuildContext context, String hospitalId, String hospitalName) async {
  final salesprovider = context.read<Salesprovider>();
  bool isDeleting = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return PopScope(
            canPop: !isDeleting, // delete ke dauran dialog close na ho
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Confirm Delete',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Are you sure you want to delete "$hospitalName" Logo ? This action cannot be undone.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.secondaryGradient,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: isDeleting ? null : () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: isDeleting
                                  ? null
                                  : () async {
                                      setDialogState(() => isDeleting = true);
                                      await salesprovider.deleteHospitalLogo(hospitalId, context);
                                      await salesprovider.getallhospitals(context);
                                      salesprovider.notify();
                                      if (dialogContext.mounted) {
                                        Navigator.pop(dialogContext);
                                      }
                                    },
                              child: isDeleting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Delete'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
  
}


Future<void> _showToggleStatusConfirmation(
    BuildContext context, String hospitalId, bool currentStatus, String hospitalName) async {
  final salesprovider = context.read<Salesprovider>();
  final actionText = currentStatus ? 'disable' : 'enable';

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              currentStatus ? Icons.block : Icons.check_circle_outline,
              color: currentStatus ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 8),
            Text('Confirm ${actionText[0].toUpperCase()}${actionText.substring(1)}'),
          ],
        ),
        content: Text(
          'Are you sure you want to $actionText "$hospitalName"?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: currentStatus ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await salesprovider.toggleHospitalStatus(hospitalId, currentStatus, context);
            },
            child: Text(actionText[0].toUpperCase() + actionText.substring(1)),
          ),
        ],
      );
    },
  );
}

class _TopActionsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(""),
          _GradientActionButton(icon: Icons.add, text: "Add Hospital", onTap: (){
            context.router.push(RegisterNewHospitalRoute());
          }),
        ],
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


class HospitalCard extends StatelessWidget {
  final String hospitalname;
  final String hospitalId;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onUpload;
  final VoidCallback onDelete;
  final bool isactive;
  final String phone;
  final String logoUrl;
 
  const HospitalCard({
    super.key,
  
    required this.onView,
    required this.onEdit,
    required this.onToggleActive,
    required this.onUpload,
    required this.onDelete, required this.hospitalname, required this.hospitalId, required this.isactive, required this.phone, required this.logoUrl,
  });
 
  static const Color primaryRed = AppColors.primary;
  static const Color darkRed = AppColors.primaryDark;
  static const Color lightPink = AppColors.badgeBg;
  static const Color activeGreenBg = Color(0xFFD9F2E3);
  static const Color activeGreenText = Color(0xFF1E9E5A);
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top red accent bar
            Container(height: 5, color: primaryRed),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + status row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospitalname,
                              style: const TextStyle(
                                fontFamily: 'Georgia', // swap for a serif font of your choice
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: primaryRed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${hospitalId}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(isActive: isactive),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEFEFEF)),
                  const SizedBox(height: 16),
       
                  // Phone row
                  _InfoRow(label: 'PHONE', value: phone),
                  const SizedBox(height: 14),
       
                  // Logo row
                  _InfoRow(
                    label: 'LOGO',
                    value: '',
                    trailing: logoUrl != ''
                        ? 
                         GestureDetector(
          onTap: () => _showLogoPreview(context, logoUrl),   // 👈 naya
          child: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.local_hospital, color: primaryRed),
            ),
          ),
        )
                        // Container(
                        //     width: 56,
                        //     height: 56,
                        //     padding: const EdgeInsets.all(6),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.grey.shade300),
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     child: Image.network(
                        //       logoUrl,
                        //       fit: BoxFit.contain,
                        //       errorBuilder: (_, __, ___) =>
                        //           const Icon(Icons.local_hospital, color: primaryRed),
                        //     ),
                        //   )
                        : Container(
                            width: 56,
                            height: 56,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text("No Logo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey
                            ),),
                          ),
                  ),
       
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEFEFEF)),
                  const SizedBox(height: 16),
       
                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: _RoundIconButton(
                          icon: Icons.remove_red_eye_outlined,
                          background: lightPink,
                          iconColor: primaryRed,
                          onTap: onView,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _RoundIconButton(
                          icon: Icons.edit_outlined,
                          background: lightPink,
                          iconColor: primaryRed,
                          onTap: onEdit,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                          child: ElevatedButton(
                            onPressed: onToggleActive,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isactive ? 'Disable' : 'Enable',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _RoundIconButton(
                          icon: Icons.file_upload_outlined,
                          background: darkRed,
                          iconColor: Colors.white,
                          onTap: onUpload,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if(logoUrl != '')
                      Expanded(
                        child: _RoundIconButton(
                          icon: Icons.delete_outline,
                          background: primaryRed,
                          iconColor: Colors.white,
                          onTap: onDelete,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showLogoPreview(BuildContext context, String logoUrl) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  },
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.primary),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
 
class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? HospitalCard.activeGreenBg
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'DISABLED',
        style: TextStyle(
          color: isActive ? HospitalCard.activeGreenText : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
 
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
 
  const _InfoRow({required this.label, required this.value, this.trailing});
 
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (trailing != null)
          trailing!
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }
}
 
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;
 
  const _RoundIconButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}

String formatCreatedAt(String createdAt) {
  DateTime dateTime = DateTime.parse(createdAt).toLocal();
  return DateFormat("EEEE, MMMM d, yyyy 'at' h:mm a").format(dateTime);
}

class ViewHospitalModel extends StatelessWidget {
  final String name;
  final String adminId;
  final String email;
  final String phonenumber;
  final String createdat;
  final String address;

  const ViewHospitalModel({
    super.key,
    required this.name,
    required this.adminId,
    required this.email,
    required this.phonenumber,
    required this.createdat, required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top: Radius.circular(12),bottom: Radius.circular(22))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(FontAwesomeIcons.hospital,
                            color: Colors.red),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Hospital Details",
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 16),
            
                  /// NAME (HIGHLIGHT)
                  _highlightTile(
                    icon: Icons.person,
                    label: "NAME",
                    value: name,
                  ),
            
                  const SizedBox(height: 12),
            
                  /// EMAIL
                  _infoTile(
                    icon: Icons.email,
                    label: "Email Address",
                    value: email,
                    iconBg: Colors.blue.shade50,
                    iconColor: Colors.blue,
                  ),
            
                  const SizedBox(height: 12),
            
                  /// PHONE
                  _infoTile(
                    icon: Icons.phone,
                    label: "Phone Number",
                    value: phonenumber.toString(),
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                  ),

                  const SizedBox(height: 12),

                   _infoTile(
                    icon: Icons.book_outlined,
                    label: "Address",
                    value: address,
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                  ),
            
            
                  const SizedBox(height: 16),
            
                  /// CREATION DATE
                  _infoTile(
                    icon: Icons.bookmark,
                    label: "Created On",
                    value: formatCreatedAt(createdat),
                    iconBg: Colors.grey.shade100,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Highlight Tile (Red)
  Widget _highlightTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color:AppColors.accent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                       TextStyle(fontSize: 12,
                       fontWeight:FontWeight.bold , color: Colors.grey.shade700)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Normal Info Tile
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                       TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }
}