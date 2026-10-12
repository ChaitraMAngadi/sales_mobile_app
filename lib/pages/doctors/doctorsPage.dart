import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/marketingPage.dart';
import 'package:sales_mobile_app/pages/marketingPageGate.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';


class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
    final TextEditingController _searchController = TextEditingController();
  late Future fetchhospitalsname;
  late Future fetchdoctors;
    final SecureStorage secureStorage = SecureStorage();
      String _searchQuery = ''; 



@override
  void initState() {
    // TODO: implement initState
    super.initState();
     Salesprovider salesprovider = context.read<Salesprovider>();
    fetchhospitalsname = salesprovider.getallhospitalsname(context);
    fetchdoctors = salesprovider.getalldoctors(context);

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


Future<void> _handleRefresh() async {
    Salesprovider salesprovider = context.read<Salesprovider>();

    await Future.delayed(Duration(seconds: 2));
    
    Constants.token = await secureStorage.readSecureData('token') ?? '';
    setState(() {
      fetchdoctors = salesprovider.getalldoctors(context);
    });
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
          'Loading patient profile...',
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


  Widget _buildMainContent(Salesprovider provider){
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(),
      child: FutureBuilder(future: fetchdoctors, 
      builder:(context, snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: BoxDecoration(gradient: AppColors.bgGradient),
                  child: SafeArea(child: _buildLoadingState()),
                );
              }
                            final filtereddoctors = _filterHospitals(provider.alldoctors);   // 👈 naya

      
                  if (filtereddoctors.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "There no Doctors Register Please \nRegister Doctor",
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
            itemCount:filtereddoctors.length ,
          
            itemBuilder:(context, index) {
                final item = filtereddoctors[index];
      
              
            return DoctorCard(
              marketingonTap: () {
                Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketingProfileGate(
                                  id: item['userid'],
                                )),
                          );
              },
              onView: ()=> showDialog(
                          context: context,
                          builder: (_) => ViewDoctorModel(
                            name: item['name']??"",
                            gender: item['gender'],
                            email: item['email'] ?? "",
                            phonenumber: item['phone'] ?? 0,
                            registrationnumber: item['doctorRegistrationNumber'],
                            registrationdetails:" ${item['year_of_registration']}, ${item['board_of_registration']}",
                            qualification: item['qualification'],
                            specialization: item['specialization'],
                            phone2:item['phone2']?? 0,
                           associatedhospital: item['associatedHospital'] ?? [],
      
                            createdat: item['createdAt']??"",
                            
                          ),
                        ), 
                         onEdit: () {
        context.router.push(
          EditDoctorRoute(
      doctorData: item,
      allhospitals: provider.allhospitalnames,
          ),
        );
      },
            onToggleActive: () {
        _showToggleStatusConfirmation(
          context,
          item['userid'],
          item['isActive'] ?? false,
          item['name'] ?? 'this Doctor',
        );
      },
            onPriceTap: () async {
        await provider.getPriceHistory(item['userid'], context);
        if (context.mounted) {
          showDialog(
      context: context,
      builder: (_) => PriceHistoryModal(
        priceHistory: provider.priceHistory,
      ),
          );
        }
      },
      
       name: item['name'], id: item['userid'], isactive: item['isActive'], phone: item['phone'], createdat: item['createdAt']??'',
       validtill:item['validity']??'' ,
       phone2: item['phone2']??0,
       );
          },),
        );
      },),
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0DEDE)),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
          hintText: 'Search doctors by name, ID, or phone...',   // 👈 updated hint
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
              await salesprovider.toggleDoctorStatus(hospitalId, currentStatus, context);
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
    Salesprovider salesprovider = context.read<Salesprovider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(""),
          _GradientActionButton(icon: Icons.add, text: "Add Doctor", onTap: (){
            context.router.push(RegisterNewDoctorRoute(allhospitals:salesprovider.allhospitalnames));
          }),
        ],
      ),
    );
  }
}

class PriceHistoryModal extends StatelessWidget {
  final List<dynamic> priceHistory;

  const PriceHistoryModal({super.key, required this.priceHistory});

  String _formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      final twoDigits = (int n) => n.toString().padLeft(2, '0');
      return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)}';
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort latest first (optional, based on screenshot order)
    final sortedHistory = List<dynamic>.from(priceHistory)
      ..sort((a, b) => DateTime.parse(b['effectiveFrom'])
          .compareTo(DateTime.parse(a['effectiveFrom'])));

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
              decoration: BoxDecoration(
                color: AppColors.badgeBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.currency_rupee_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price History",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Doctor consultation pricing timeline",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Table
            Padding(
              padding: const EdgeInsets.all(24),
              child: sortedHistory.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "No price history available",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF0DEDE)),
                      ),
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBg,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "PRICE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 0.8,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "EFFECTIVE FROM",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 0.8,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Rows
                          ...List.generate(sortedHistory.length, (index) {
                            final item = sortedHistory[index];
                            final isLast = index == sortedHistory.length - 1;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : const Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFF0DEDE)),
                                      ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${item['price']}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _formatDate(item['effectiveFrom']),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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


class DoctorCard extends StatelessWidget {
  final String name;
  final String id;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onPriceTap;
  final VoidCallback marketingonTap;
  
  final bool isactive;
  final int phone;
  final int phone2;
  final String validtill;
  final String createdat;
 
  const DoctorCard({
    super.key,
  
    required this.onView,
    required this.onEdit,
    required this.onToggleActive,
   required this.isactive, required this.phone, required this.name, required this.id, required this.onPriceTap, required this.validtill, required this.createdat, required this.phone2, required this.marketingonTap,
  });
 
  static const Color primaryRed = AppColors.primary;
  static const Color darkRed = AppColors.primaryDark;
  static const Color lightPink = AppColors.badgeBg;
  static const Color activeGreenBg = Color(0xFFD9F2E3);
  static const Color activeGreenText = Color(0xFF1E9E5A);
 
String formatDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();

  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour;
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return '${dateTime.month}/${dateTime.day}/${dateTime.year}, '
      '$hour:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)} $period';
}

String formatValidDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();

  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour;
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
}

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
                              name,
                              style: const TextStyle(
                                fontFamily: 'Georgia', // swap for a serif font of your choice
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: primaryRed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${id}',
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
                  _InfoRow(label: 'PHONE', value: phone.toString()),
                  const SizedBox(height: 14),

                  
       
                  // Phone row
                  if(phone2 != 0)
                  _InfoRow(label: 'SECONDARY PHONE', value: phone2.toString()),
                  if(phone2 != 0)
                  const SizedBox(height: 14),
       
                  // Logo row
                  if(validtill != '')
                  _InfoRow(label: 'Valid Till', value:formatValidDate(validtill)),
                  const SizedBox(height: 14),
                  _InfoRow(label: 'Created', value: formatDate(createdat)),
       
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
                         child: _RoundIconButton(
                          icon: FontAwesomeIcons.indianRupeeSign,
                          background: lightPink,
                          iconColor: primaryRed,
                          onTap: onPriceTap,
                        ),
                                               
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                        child: _RoundIconButton(
                          icon: Icons.campaign_outlined,
                          background: lightPink,
                          iconColor: primaryRed,
                          onTap: marketingonTap,
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
            ? DoctorCard.activeGreenBg
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'DISABLED',
        style: TextStyle(
          color: isActive ? DoctorCard.activeGreenText : Colors.grey.shade600,
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

class ViewDoctorModel extends StatelessWidget {
  final String name;
  final String email;
  final String gender;
  final int phonenumber;
  final int phone2;
final String qualification;
  final String createdat;
  final String specialization;
  final String registrationnumber;
  final String registrationdetails;
  final List<dynamic> associatedhospital;

  const ViewDoctorModel({
    super.key, required this.name, required this.email, required this.gender, required this.phonenumber, required this.phone2, required this.qualification, required this.createdat, required this.specialization, required this.registrationnumber, required this.registrationdetails, required this.associatedhospital,
    
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
                          "Doctor Details",
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
                  _infoTile(
                    icon: Icons.person,
                    label: "Gender",
                    value: gender,
                    iconBg: Colors.grey.shade100,
                    iconColor: Colors.red,
                  ),

                  const SizedBox(height: 12),
                  Text("Contact Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
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

                   if(phone2 != 0)
                   const SizedBox(height: 12),

                  if(phone2 != 0)
                  _infoTile(
                    icon: Icons.phone,
                    label: "Alternative Phone Number",
                    value: phone2.toString(),
                    iconBg: Colors.green.shade50,
                    iconColor: Colors.green,
                  ),

                  const SizedBox(height: 12),

                  


                   _infoTile(
                    icon: FontAwesomeIcons.stethoscope,
                    label: "Qualification",
                    value: qualification,
                    iconBg: Colors.grey.shade100,
                    iconColor: AppColors.primary,
                  ),

                  const SizedBox(height: 12),

                  


                   _infoTile(
                    icon: FontAwesomeIcons.stethoscope,
                    label: "Specialization",
                    value: specialization,
                    iconBg: Colors.grey.shade100,
                    iconColor: AppColors.primary,
                  ),
            
            const SizedBox(height: 12),

                  


                   _infoTile(
                    icon: FontAwesomeIcons.stethoscope,
                    label: "Registration Number",
                    value: registrationnumber,
                    iconBg: Colors.grey.shade100,
                    iconColor: AppColors.primary,
                  ),
            

            const SizedBox(height: 12),

                  


                   _infoTile(
                    icon: FontAwesomeIcons.stethoscope,
                    label: "Registration Details",
                    value: registrationdetails,
                    iconBg: Colors.grey.shade100,
                    iconColor: AppColors.primary,
                  ),
            

            const SizedBox(height: 12),

                  
_associatedHospitalsTile(),

                  //  _infoTile(
                  //   icon: Icons.book_outlined,
                  //   label: "Associated Hospitals",
                  //   value: associatedhospital,
                  //   iconBg: Colors.green.shade50,
                  //   iconColor: Colors.green,
                  // ),
            
            
            
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

  Widget _associatedHospitalsTile() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_hospital_outlined, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Text(
              "Associated Hospitals",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (associatedhospital.isEmpty)
          const Text(
            "No hospitals associated",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: associatedhospital.map((hospital) {
              final String hospitalName = hospital['name'] ?? 'Unknown';
              final bool isActive = hospital['isActive'] ?? false;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.shade50 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? Colors.green.shade200 : Colors.grey.shade400,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      hospitalName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
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