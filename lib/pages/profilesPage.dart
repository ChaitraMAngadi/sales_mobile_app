
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future fetchProfiles;

  @override
  void initState() {
    super.initState();
    Salesprovider salesprovider = context.read<Salesprovider>();
    fetchProfiles = salesprovider.getallprofiles(context);
  }

  
  Future<void> _handleRefresh() async {
    Salesprovider salesprovider = context.read<Salesprovider>();
    // profileprovider.invalidateCache(key: profileprovider.kProfile);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      fetchProfiles = salesprovider.getallprofiles(context);
    });
  }

 
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Consumer<Salesprovider>(
        builder: (context, profileprovider, child) {
          return FutureBuilder(
            future: fetchProfiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: BoxDecoration(gradient: AppColors.bgGradient),
                  child: SafeArea(child: _buildLoadingState()),
                );
              }

              if (profileprovider.allprofiles.isEmpty) {
                return Container(
                  decoration: BoxDecoration(gradient: AppColors.bgGradient),
                  child: SafeArea(
                    child: ListView(   // ListView taaki pull-to-refresh empty state pe bhi kaam kare
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "Profile not found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final item = profileprovider.allprofiles;

              return Container(
                decoration: BoxDecoration(gradient: AppColors.bgGradient),
                child: SafeArea(
                  child: ListView(   // ListView (single item) taaki RefreshIndicator ke liye scrollable rahe
                    children: [
                      ProfileCard(
                        name: item['name'] ?? '',
                        phone: item['phone']?.toString() ?? '',
                        email: item['email'] ?? '',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileCard  (now StatefulWidget for _isAnalyzing)
// ─────────────────────────────────────────────────────────────────────────────

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    //  required this.userid, 
  });

  final String name;
  final String phone;
  final String email;
  // final String userid;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top gradient bar ──────────────────────────────────────
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.person_2_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "MY PROFILE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                // Text(
                //   "ID: ${widget.userid}",
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.grey.shade600,
                //   ),
                // ),
                // const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 14),
                if (widget.phone.isNotEmpty && widget.phone != "null")
                  ProfileInfoTile(
                    icon: LucideIcons.phone,
                    label: "Phone Number",
                    value: widget.phone,
                  ),
                if (widget.email.isNotEmpty)
                  ProfileInfoTile(
                    icon: LucideIcons.mail,
                    label: "Email",
                    value: widget.email,
                  ),
   
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileInfoTile
// ─────────────────────────────────────────────────────────────────────────────

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state helper
// ─────────────────────────────────────────────────────────────────────────────

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