// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:sales_mobile_app/pages/marketingPage.dart';
// // // import 'package:sales_mobile_app/provider/marketingProvider.dart';
// // // import 'package:sales_mobile_app/theme/app_colors.dart';

// // // const _bg = Color(0xFFFEF6F6);

// // // Map<String, dynamic> _m(dynamic v) =>
// // // v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
// // // List _l(dynamic v) => v is List ? v : const [];
// // // String _s(dynamic v) => v == null ? '' : v.toString();

// // // // ═══════════════════════════════════════════════════════════════════
// // // // GATE: data null  -> form (MarketingProfilePage)
// // // //       data aaya  -> read-only profile view
// // // // ═══════════════════════════════════════════════════════════════════
// // // class MarketingProfileGate extends StatefulWidget {
// // //   const MarketingProfileGate({super.key, required this.id});
// // //   final String id;

// // //   @override
// // //   State<MarketingProfileGate> createState() => _MarketingProfileGateState();
// // // }

// // // class _MarketingProfileGateState extends State<MarketingProfileGate> {
// // //   late Future<dynamic> _future;
// // //   bool _editing = false;
// // //   late dynamic _profileData; // NEW


// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     Marketingprovider marketingprovider = context.read<Marketingprovider>();
// // //     _future = context
// // //         .read<Marketingprovider>()
// // //         .getdoctoralldetails(context, widget.id);
// // //         // _profileData = marketingprovider.doctordetails;
// // //         // print("_profileData : ${_profileData}");
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     if (_editing) {
// // //       return MarketingProfilePage(id: widget.id, initialData: _profileData,
// // //     isEdit: true,);
// // //     }

// // //     return FutureBuilder<dynamic>(
// // //       future: _future,
// // //       builder: (context, snap) {
// // //         if (snap.connectionState != ConnectionState.done) {
// // //           return const Scaffold(
// // //             backgroundColor: _bg,
// // //             body: Center(child: CircularProgressIndicator()),
// // //           );
// // //         }
// // //         // snap.data = poora decoded response: {"success":true,"data":...}
// // //         final res = _m(snap.data);
// // //         final data = res['data'];

// // //         if (snap.hasError || data == null) {
// // //           // {"success":true,"data":null} -> marketing form dikhao
// // //           return MarketingProfilePage(id: widget.id, initialData: _profileData,
// // //           isEdit: false,);
// // //         }

// // //         _profileData = _m(data); // ✅ store correctly-typed Map for later "Edit"

// // //         return MarketingProfileView(
// // //           data: _profileData!,
// // //           onEdit: () => setState(() => _editing = true),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // // ═══════════════════════════════════════════════════════════════════
// // // // READ-ONLY VIEW
// // // // ═══════════════════════════════════════════════════════════════════
// // // class MarketingProfileView extends StatefulWidget {
// // //   const MarketingProfileView({super.key, required this.data, this.onEdit});
// // //   final Map<String, dynamic> data;
// // //   final VoidCallback? onEdit;

// // //   @override
// // //   State<MarketingProfileView> createState() => _MarketingProfileViewState();
// // // }

// // // class _MarketingProfileViewState extends State<MarketingProfileView> {
// // //   final _keys = List.generate(6, (_) => GlobalKey());
// // //   static const _tabs = [
// // //     ('Overview', Icons.person_outline_rounded),
// // //     ('Qualifications', Icons.school_outlined),
// // //     ('Specialisation', Icons.medical_services_outlined),
// // //     ('Clinics', Icons.apartment_outlined),
// // //     ('Fees', Icons.account_balance_wallet_outlined),
// // //     ('Availability', Icons.event_available_outlined),
// // //   ];

// // //   void _jump(int i) {
// // //     final ctx = _keys[i].currentContext;
// // //     if (ctx != null) {
// // //       Scrollable.ensureVisible(ctx,
// // //           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final d = widget.data;
// // //     final isActive = d['isActive'] == true;

// // //     return Scaffold(
// // //       backgroundColor: _bg,
// // //       appBar: AppBar(
// // //         flexibleSpace: Container(
// // //             decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //         title: const Text('Marketing Profile',
// // //             style: TextStyle(
// // //                 fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
// // //       ),
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               // Live status + Edit
// // //               Row(
// // //                 children: [
// // //                   Container(
// // //                     padding:
// // //                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// // //                     decoration: _cardDeco(10),
// // //                     child: Row(children: [
// // //                       Text(isActive ? 'Live' : 'Not live',
// // //                           style: const TextStyle(fontSize: 13)),
// // //                       const SizedBox(width: 6),
// // //                       Switch(
// // //                           value: isActive,
// // //                           onChanged: null,
// // //                           activeTrackColor: AppColors.primary,
// // //                            // read-only; API se connect karo
// // //                           activeColor: AppColors.primary),
// // //                     ]),
// // //                   ),
// // //                   const Spacer(),
// // //                   FilledButton.icon(
// // //                     onPressed: widget.onEdit,
// // //                     icon: const Icon(Icons.edit_outlined, size: 18),
// // //                     label: const Text('Edit profile'),
// // //                     style: FilledButton.styleFrom(
// // //                         backgroundColor: AppColors.primary),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 12),

// // //               // Tabs (tap karke section tak scroll)
// // //               Container(
// // //                 decoration: _cardDeco(12),
// // //                 height: 48,
// // //                 child: ListView.separated(
// // //                   scrollDirection: Axis.horizontal,
// // //                   padding: const EdgeInsets.symmetric(horizontal: 8),
// // //                   itemCount: _tabs.length,
// // //                   separatorBuilder: (_, __) => const SizedBox(width: 4),
// // //                   itemBuilder: (_, i) => TextButton.icon(
// // //                     onPressed: () => _jump(i),
// // //                     icon: Icon(_tabs[i].$2, size: 16),
// // //                     label: Text(_tabs[i].$1),
// // //                     style: TextButton.styleFrom(
// // //                         foregroundColor: Colors.black87,
// // //                         textStyle: const TextStyle(fontSize: 13)),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),

// // //               KeyedSubtree(key: _keys[0], child: _overview(d)),
// // //               const SizedBox(height: 16),
// // //               KeyedSubtree(key: _keys[1], child: _qualifications(d)),
// // //               const SizedBox(height: 16),
// // //               KeyedSubtree(key: _keys[2], child: _specialisation(d)),
// // //               const SizedBox(height: 16),
// // //               KeyedSubtree(key: _keys[3], child: _clinics(d)),
// // //               const SizedBox(height: 16),
// // //               KeyedSubtree(key: _keys[4], child: _fees(d)),
// // //               const SizedBox(height: 16),
// // //               KeyedSubtree(key: _keys[5], child: _availability(d)),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ───────── Overview ─────────
// // //   Widget _overview(Map<String, dynamic> d) {
// // //     final b = _m(d['basicInformation']);
// // //     final q = _m(d['qualifications']);
// // //     final sp = _m(d['specialisation']);
// // //     final name = _s(b['fullName']);
// // //     final experince = _m(b['yearsOfExperience']);
// // //     final exp = _s(sp['areasOfExpertise']);
// // //     final initials = name
// // //         .trim()
// // //         .split(RegExp(r'\s+'))
// // //         .where((e) => e.isNotEmpty)
// // //         .take(2)
// // //         .map((e) => e[0].toUpperCase())
// // //         .join();
// // //     final langs = _l(b['languagesSpoken']);

// // //     return _SectionCard(
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               CircleAvatar(
// // //                 radius: 36,
// // //                 backgroundColor: AppColors.badgeBg,
// // //                 child: Text(initials,
// // //                     style: TextStyle(
// // //                         fontSize: 28,
// // //                         fontWeight: FontWeight.w800,
// // //                         color: AppColors.primary)),
// // //               ),
// // //               const SizedBox(width: 16),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(name,
// // //                         style: const TextStyle(
// // //                             fontSize: 22, fontWeight: FontWeight.w800)),
// // //                     const SizedBox(height: 6),
// // //                     Wrap(spacing: 6, runSpacing: 6, children: [
// // //                       if (_s(sp['primarySpecialisation']).isNotEmpty)
// // //                         _Pill(_s(sp['primarySpecialisation']), filled: true),
// // //                       if (_s(q['highestQualification']).isNotEmpty)
// // //                         _Pill(_s(q['highestQualification'])),
// // //                         if (_s(b['yearsOfExperience']).isNotEmpty)
// // //                         _ExpPill(_s(b['yearsOfExperience'])),

// // //                         if (exp.isNotEmpty) ...[
              
// // //                 Text(exp, style: TextStyle(fontSize: 12, color: Colors.grey.shade700),),
                
// // //               ],
// // //                     ]),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
          
// // //           const SizedBox(height: 16),
// // //           Wrap(spacing: 32, runSpacing: 12, children: [
// // //             _LabeledValue('Mobile', '+91 ${_s(b['mobileNumber'])}',
// // //                 Icons.phone_outlined),
// // //             _LabeledValue('Email', _s(b['email']), Icons.mail_outline_rounded),
// // //             if (_s(b['medicalRegistrationNumber']).isNotEmpty)
// // //               _LabeledValue('Reg. No.', _s(b['medicalRegistrationNumber']),
// // //                   Icons.badge_outlined),
// // //           ]),
// // //           if (langs.isNotEmpty) ...[
// // //             const SizedBox(height: 14),
// // //             const Row(children: [
// // //               Icon(Icons.translate_rounded, size: 16, color: Colors.grey),
// // //               SizedBox(width: 6),
// // //               Text('Speaks',
// // //                   style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //             ]),
// // //             const SizedBox(height: 6),
// // //             Wrap(
// // //                 spacing: 6,
// // //                 runSpacing: 6,
// // //                 children: [for (final l in langs) _Pill(_s(l), soft: true)]),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ───────── Qualifications ─────────
// // //   Widget _qualifications(Map<String, dynamic> d) {
// // //     final list = _l(_m(d['qualifications'])['qualificationDetails']);
// // //     return _SectionCard(
// // //       title: 'Qualifications',
// // //       icon: Icons.school_outlined,
// // //       child: list.isEmpty
// // //           ? const _Empty('No qualifications added')
// // //           : Column(children: [
// // //               for (final e in list)
// // //                 _InnerBox(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           Text(_s(_m(e)['degree']),
// // //                               style: TextStyle(
// // //                                   fontWeight: FontWeight.w800,
// // //                                   color: AppColors.primary)),
// // //                                   SizedBox(width: 4,),

// // // _Pill(_s(_m(e)['year'])),
// // //                               //     Text(_s(_m(e)['year']),
// // //                               // style: TextStyle(
// // //                               //     fontWeight: FontWeight.w800,
// // //                               //     color: AppColors.primary)),

// // //                         ],
// // //                       ),
// // //                       const SizedBox(height: 6),
// // //                       Text(_s(_m(e)['specialization']),
// // //                           style: const TextStyle(
// // //                               fontWeight: FontWeight.w600, fontSize: 14)),
// // //                       const SizedBox(height: 2),
// // //                       Text(_s(_m(e)['institution']),
// // //                           style: const TextStyle(
// // //                               fontSize: 12, color: Colors.grey)),
// // //                     ],
// // //                   ),
// // //                 ),
// // //             ]),
// // //     );
// // //   }

// // //   // ───────── Specialisation ─────────
// // //   Widget _specialisation(Map<String, dynamic> d) {
// // //     final sp = _m(d['specialisation']);
// // //     final sub = _l(sp['subSpecialisation']);
// // //     final cond = _l(sp['conditionsTreated']);
// // //     final keys = _l(sp['keywords']);
// // //     final exp = _s(sp['areasOfExpertise']);
// // //     final nothing = sub.isEmpty && cond.isEmpty && keys.isEmpty && exp.isEmpty;

// // //     Widget group(String label, List items) => items.isEmpty
// // //         ? const SizedBox.shrink()
// // //         : Padding(
// // //             padding: const EdgeInsets.only(bottom: 12),
// // //             child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(label,
// // //                       style: const TextStyle(fontSize: 12, color: Colors.grey)),
// // //                   const SizedBox(height: 6),
// // //                   Wrap(spacing: 6, runSpacing: 6, children: [
// // //                     for (final i in items) _Pill(_s(i), soft: true)
// // //                   ]),
// // //                 ]),
// // //           );

// // //     return _SectionCard(
// // //       title: 'Specialisation',
// // //       icon: Icons.medical_services_outlined,
// // //       child: nothing
// // //           ? const _Empty('No specialisation details added')
// // //           : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //               group('Sub specialisation', sub),
// // //               group('Conditions treated', cond),
              
// // //               group('Keywords', keys),
// // //             ]),
// // //     );
// // //   }

// // //   // ───────── Clinics ─────────
// // //   Widget _clinics(Map<String, dynamic> d) {
// // //     final list = _l(d['clinics']);
// // //     const facilityLabels = {
// // //       'parkingAvailable': 'Parking',
// // //       'wheelchairAccessible': 'Wheelchair',
// // //       'liftAvailable': 'Lift',
// // //       'pharmacy': 'Pharmacy',
// // //       'laboratory': 'Laboratory',
// // //       'diagnosticCentre': 'Diagnostic centre',
// // //       'acWaitingArea': 'AC waiting area',
// // //       'insuranceAccepted': 'Insurance',
// // //       'cashlessFacility': 'Cashless',
// // //       'emergencyFacility': 'Emergency',
// // //       'washroomAvailable': 'Washroom',
// // //       'drinkingWater': 'Drinking water',
// // //       'waitingArea': 'Waiting area',
// // //       'childFriendly': 'Child friendly',
// // //       'elderlyFriendly': 'Elderly friendly',
// // //       'securityAvailable': 'Security',
// // //       'receptionDesk': 'Reception',
// // //       'accessibleParking': 'Accessible parking',
// // //       'cleanliness': 'Cleanliness',
// // //       'hygieneStandards': 'Hygiene',
// // //     };

// // //     return _SectionCard(
// // //       title: 'Clinics & hospitals (${list.length})',
// // //       icon: Icons.apartment_outlined,
// // //       child: list.isEmpty
// // //           ? const _Empty('No clinics added')
// // //           : Column(children: [
// // //               for (final c in list) _clinicTile(_m(c), facilityLabels),
// // //             ]),
// // //     );
// // //   }

// // //   Widget _clinicTile(Map<String, dynamic> c, Map<String, String> labels) {
// // //     final fac = _m(c['facilities']);
// // //     final on = labels.entries.where((e) => fac[e.key] == true).toList();
// // //     final fees = _m(c['fees']);
// // //     final loc = [_s(c['area']), _s(c['city']), _s(c['state']), _s(c['pinCode'])]
// // //         .where((e) => e.isNotEmpty)
// // //         .join(', ');

        
// // //     Widget fee(String label, String key) {
// // //       final f = _m(fees[key])['fee'];
// // //       return f == null ? const SizedBox.shrink() : _Pill('$label ₹$f', soft: true);
// // //     }

// // //     return _InnerBox(
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(_s(c['clinicName']),
// // //               style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          
// // //           if (_s(c['branchName']).isNotEmpty)
// // //             Text(_s(c['branchName']),
// // //                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
// // //                 SizedBox(height: 6,),
// // //               Row(
// // //                 children: [
// // //                   Icon(Icons.call, color: AppColors.primary,),
// // //                   if(_s(c['contactNumber']).isNotEmpty)
// // //                   Text(c['contactNumber'], style: TextStyle(color: AppColors.primary),)
// // //                 ],
// // //               ),
// // //           const SizedBox(height: 8),
// // //           Row(children: [
// // //             Icon(Icons.location_on_outlined,
// // //                 size: 16, color: AppColors.primary),
// // //             const SizedBox(width: 6),
// // //             Expanded(child: Text(loc, style: const TextStyle(fontSize: 13))),
// // //           ]),
// // //           SizedBox(height: 5,),
// // //           Text(c['fullAddress'],
// // //           style: TextStyle(fontSize: 12, color: Colors.grey.shade700),),
// // //           const SizedBox(height: 10),
// // //           Wrap(spacing: 6, runSpacing: 6, children: [
// // //             fee('First', 'firstConsultation'),
// // //             fee('Follow-up', 'followUp'),
// // //             fee('Emergency', 'emergency'),
// // //           ]),
// // //           if (on.isNotEmpty) ...[
// // //             const SizedBox(height: 8),
// // //             Wrap(spacing: 6, runSpacing: 6, children: [
// // //               for (final e in on) _Pill(e.value, check: true),
// // //             ]),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ───────── Fees ─────────
// // //   Widget _fees(Map<String, dynamic> d) {
// // //     final c = _m(d['consultation']);
// // //     final fees = _m(c['fees']);
// // //     final modes = <(String, IconData, bool)>[
// // //       ('In-clinic', Icons.apartment_outlined, c['inClinic'] == true),
// // //       ('Video', Icons.videocam_outlined, c['video'] == true),
// // //       ('Phone', Icons.phone_outlined, c['phone'] == true),
// // //       ('Home visit', Icons.home_outlined, c['homeVisit'] == true),
// // //       ('Hospital', Icons.local_hospital_outlined, c['hospital'] == true),
// // //     ].where((e) => e.$3).toList();

// // //     Widget tile(String label, String key, bool show) {
// // //       if (!show) return const SizedBox.shrink();
// // //       return _InnerBox(
// // //         child: Row(children: [
// // //           Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
// // //           Text('₹${_s(_m(fees[key])['fee'])}',
// // //               style:
// // //                   const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
// // //         ]),
// // //       );
// // //     }

// // //     return _SectionCard(
// // //       title: 'Consultation & fees',
// // //       icon: Icons.account_balance_wallet_outlined,
// // //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //         const Text('Available modes',
// // //             style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //         const SizedBox(height: 8),
// // //         Wrap(spacing: 8, runSpacing: 8, children: [
// // //           for (final m in modes)
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// // //               decoration: BoxDecoration(
// // //                 borderRadius: BorderRadius.circular(10),
// // //                 border: Border.all(color: AppColors.primary.withOpacity(0.6)),
// // //               ),
// // //               child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //                 Icon(m.$2, size: 16, color: AppColors.primary),
// // //                 const SizedBox(width: 6),
// // //                 Text(m.$1,
// // //                     style: TextStyle(
// // //                         fontSize: 13,
// // //                         fontWeight: FontWeight.w600,
// // //                         color: AppColors.primary)),
// // //               ]),
// // //             ),
// // //         ]),
// // //         const SizedBox(height: 16),
        
// // //         tile('Video consultation', 'video', c['video'] == true),
// // //         tile('Phone consultation', 'phone', c['phone'] == true),
// // //         tile('Home visit', 'homeVisit', c['homeVisit'] == true),
// // //         tile('Hospital visit', 'hospital', c['hospital'] == true),
// // //         tile('Average consultation fee', 'averageConsultationFee', true),
// // //         if (c['averageWaitingDuration'] != null)
// // //           Padding(
// // //             padding: const EdgeInsets.only(top: 4),
// // //             child: Text(
// // //                 'Average waiting time: ${_s(c['averageWaitingDuration'])} min',
// // //                 style: const TextStyle(fontSize: 12, color: Colors.grey)),
// // //           ),
// // //       ]),
// // //     );
// // //   }

// // //   // ───────── Availability ─────────
// // //   Widget _availability(Map<String, dynamic> d) {
// // //     final clinics = _l(d['clinics']);
// // //     const days = [
// // //       'monday', 'tuesday', 'wednesday', 'thursday',
// // //       'friday', 'saturday', 'sunday'
// // //     ];
// // //     if (clinics.isEmpty) {
// // //       return const _SectionCard(
// // //         title: 'Availability',
// // //         icon: Icons.event_available_outlined,
// // //         child: _Empty('No availability added'),
// // //       );
// // //     }
// // //     // Pehle clinic ki availability (multiple clinics ho to har clinic ka block)
// // //     return _SectionCard(
// // //       title: 'Availability',
// // //       icon: Icons.event_available_outlined,
// // //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// // //         for (final c in clinics) ...[
// // //           if (clinics.length > 1)
// // //             Padding(
// // //               padding: const EdgeInsets.only(bottom: 8),
// // //               child: Text(_s(_m(c)['clinicName']),
// // //                   style: const TextStyle(fontWeight: FontWeight.w700)),
// // //             ),
// // //           for (final day in days) _dayRow(day, _m(_m(_m(c)['availability'])[day])),
// // //           const SizedBox(height: 8),
// // //         ],
// // //       ]),
// // //     );
// // //   }

// // //   Widget _dayRow(String day, Map<String, dynamic> a) {
// // //     final enabled = a['enabled'] == true;
// // //     final label = day[0].toUpperCase() + day.substring(1);
// // //     var text = 'Closed';
// // //     if (enabled) {
// // //       text = '${_s(a['startTime'])} - ${_s(a['endTime'])}';
// // //       if (_s(a['breakStartTime']).isNotEmpty) {
// // //         text += '  (break ${_s(a['breakStartTime'])}-${_s(a['breakEndTime'])})';
// // //       }
// // //     }
// // //     return Opacity(
// // //       opacity: enabled ? 1 : 0.6,
// // //       child: _InnerBox(
// // //         child: Row(children: [
// // //           Expanded(
// // //               child: Text(label,
// // //                   style: const TextStyle(
// // //                       fontWeight: FontWeight.w600, fontSize: 14))),
// // //           Text(text,
// // //               style: TextStyle(
// // //                   fontSize: 12,
// // //                   color: enabled ? AppColors.primary : Colors.grey,
// // //                   fontWeight: enabled ? FontWeight.w700 : FontWeight.w400)),
// // //         ]),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // ═══════════════════════════════════════════════════════════════════
// // // // Shared small widgets
// // // // ═══════════════════════════════════════════════════════════════════
// // // BoxDecoration _cardDeco([double r = 12]) => BoxDecoration(
// // //       color: Colors.white,
// // //       borderRadius: BorderRadius.circular(r),
// // //       boxShadow: [
// // //         BoxShadow(
// // //             color: AppColors.primary.withOpacity(0.08),
// // //             blurRadius: 24,
// // //             offset: const Offset(0, 8)),
// // //       ],
// // //     );

// // // class _SectionCard extends StatelessWidget {
// // //   const _SectionCard({this.title, this.icon, required this.child});
// // //   final String? title;
// // //   final IconData? icon;
// // //   final Widget child;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       decoration: _cardDeco(16),
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(16),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.stretch,
// // //           children: [
// // //             Container(height: 3, color: AppColors.primary),
// // //             Padding(
// // //               padding: const EdgeInsets.all(18),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   if (title != null) ...[
// // //                     Row(children: [
// // //                       Container(
// // //                         width: 38,
// // //                         height: 38,
// // //                         decoration: BoxDecoration(
// // //                           color: AppColors.primary.withOpacity(0.10),
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                         child:
// // //                             Icon(icon, color: AppColors.primary, size: 20),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: Text(title!,
// // //                             style: const TextStyle(
// // //                                 fontSize: 16, fontWeight: FontWeight.w800)),
// // //                       ),
// // //                     ]),
// // //                     const SizedBox(height: 16),
// // //                   ],
// // //                   child,
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _InnerBox extends StatelessWidget {
// // //   const _InnerBox({required this.child});
// // //   final Widget child;

// // //   @override
// // //   Widget build(BuildContext context) => Container(
// // //         width: double.infinity,
// // //         margin: const EdgeInsets.only(bottom: 10),
// // //         padding: const EdgeInsets.all(14),
// // //         decoration: BoxDecoration(
// // //           color: const Color(0xFFFEF6F6),
// // //           borderRadius: BorderRadius.circular(10),
// // //           border: Border.all(color: AppColors.primary.withOpacity(0.08)),
// // //         ),
// // //         child: child,
// // //       );
// // // }

// // // class _Pill extends StatelessWidget {
// // //   const _Pill(this.text,
// // //       {this.filled = false, this.soft = false, this.check = false});
// // //   final String text;
// // //   final bool filled, soft, check;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final fg = filled ? Colors.white : AppColors.primary;
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: filled
// // //             ? AppColors.primary
// // //             : soft
// // //                 ? AppColors.badgeBg
// // //                 : Colors.white,
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: (filled || soft)
// // //             ? null
// // //             : Border.all(color: AppColors.primary.withOpacity(0.5)),
// // //       ),
// // //       child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //         if (check) ...[
// // //           Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
// // //           const SizedBox(width: 4),
// // //         ],
// // //         Text(text,
// // //             style: TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: check ? Colors.black87 : fg)),
// // //       ]),
// // //     );
// // //   }
// // // }
// // // class _ExpPill extends StatelessWidget {
// // //   const _ExpPill(this.text,
// // //       {this.filled = false, this.soft = false, this.check = false});
// // //   final String text;
// // //   final bool filled, soft, check;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final fg = filled ? Colors.white : Colors.grey.shade700;
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: filled
// // //             ? Colors.grey.shade700
// // //             : soft
// // //                 ? AppColors.badgeBg
// // //                 : Colors.white,
// // //         borderRadius: BorderRadius.circular(20),
// // //         border: (filled || soft)
// // //             ? null
// // //             : Border.all(color: Colors.grey.withOpacity(0.5)),
// // //       ),
// // //       child: Row(mainAxisSize: MainAxisSize.min, children: [
// // //         if (check) ...[
// // //           Icon(Icons.check_rounded, size: 12, color: Colors.grey.shade700),
// // //           const SizedBox(width: 4),
// // //         ],
// // //         Text("${text} yrs experience",
// // //             style: TextStyle(
// // //                 fontSize: 12,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: check ? Colors.black87 : fg)),
// // //       ]),
// // //     );
// // //   }
// // // }


// // // class _LabeledValue extends StatelessWidget {
// // //   const _LabeledValue(this.label, this.value, this.icon);
// // //   final String label, value;
// // //   final IconData icon;

// // //   @override
// // //   Widget build(BuildContext context) => Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
// // //           const SizedBox(height: 4),
// // //           Row(mainAxisSize: MainAxisSize.min, children: [
// // //             Icon(icon, size: 16, color: Colors.grey),
// // //             const SizedBox(width: 6),
// // //             Text(value,
// // //                 style:
// // //                     const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// // //           ]),
// // //         ],
// // //       );
// // // }

// // // class _Empty extends StatelessWidget {
// // //   const _Empty(this.text);
// // //   final String text;

// // //   @override
// // //   Widget build(BuildContext context) => Text(text,
// // //       style: const TextStyle(fontSize: 13, color: Colors.grey));
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:sales_mobile_app/pages/marketingPage.dart';
// // import 'package:sales_mobile_app/provider/marketingProvider.dart';
// // import 'package:sales_mobile_app/theme/app_colors.dart';

// // const _bg = Color(0xFFFEF6F6);

// // Map<String, dynamic> _m(dynamic v) =>
// //     v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
// // List _l(dynamic v) => v is List ? v : const [];
// // String _s(dynamic v) => v == null ? '' : v.toString();

// // /// 1115 -> ₹1,115 | 123456 -> ₹1,23,456 (Indian grouping)
// // String _inr(dynamic v) {
// //   final n = v is num ? v.round() : (int.tryParse(_s(v)) ?? 0);
// //   final s = n.abs().toString();
// //   final sign = n < 0 ? '-' : '';
// //   if (s.length <= 3) return '₹$sign$s';
// //   final last3 = s.substring(s.length - 3);
// //   var rest = s.substring(0, s.length - 3);
// //   final parts = <String>[];
// //   while (rest.length > 2) {
// //     parts.insert(0, rest.substring(rest.length - 2));
// //     rest = rest.substring(0, rest.length - 2);
// //   }
// //   if (rest.isNotEmpty) parts.insert(0, rest);
// //   return '₹$sign${parts.join(',')},$last3';
// // }

// // num _n(dynamic v) => v is num ? v : (num.tryParse(_s(v)) ?? 0);

// // // ═══════════════════════════════════════════════════════════════════
// // // GATE: data null  -> form (MarketingProfilePage)
// // //       data aaya  -> read-only profile view
// // // ═══════════════════════════════════════════════════════════════════
// // class MarketingProfileGate extends StatefulWidget {
// //   const MarketingProfileGate({super.key, required this.id});
// //   final String id;

// //   @override
// //   State<MarketingProfileGate> createState() => _MarketingProfileGateState();
// // }

// // class _MarketingProfileGateState extends State<MarketingProfileGate> {
// //   late Future<dynamic> _future;
// //   bool _editing = false;

// //   // FIX: `late` hata diya — data null wale case mein ye read hota hai
// //   // aur late variable pe LateInitializationError aata tha.
// //   dynamic _profileData;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _future = context
// //         .read<Marketingprovider>()
// //         .getdoctoralldetails(context, widget.id);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_editing) {
// //       return MarketingProfilePage(
// //         id: widget.id,
// //         initialData: _profileData,
// //         isEdit: true,
// //       );
// //     }

// //     return FutureBuilder<dynamic>(
// //       future: _future,
// //       builder: (context, snap) {
// //         if (snap.connectionState != ConnectionState.done) {
// //           return const Scaffold(
// //             backgroundColor: _bg,
// //             body: Center(child: CircularProgressIndicator()),
// //           );
// //         }
// //         final res = _m(snap.data);
// //         final data = res['data'];

// //         if (snap.hasError || data == null) {
// //           return MarketingProfilePage(
// //             id: widget.id,
// //             initialData: _profileData,
// //             isEdit: false,
// //           );
// //         }

// //         _profileData = _m(data);

// //         return MarketingProfileView(
// //           data: _profileData,
// //           onEdit: () => setState(() => _editing = true),
// //         );
// //       },
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════════════════
// // // READ-ONLY VIEW
// // // ═══════════════════════════════════════════════════════════════════
// // const Map<String, String> _kFacilityLabels = {
// //   'parkingAvailable': 'Parking',
// //   'accessibleParking': 'Accessible parking',
// //   'wheelchairAccessible': 'Wheelchair accessible',
// //   'liftAvailable': 'Lift',
// //   'pharmacy': 'Pharmacy',
// //   'laboratory': 'Laboratory',
// //   'diagnosticCentre': 'Diagnostic centre',
// //   'acWaitingArea': 'AC waiting area',
// //   'waitingArea': 'Waiting area',
// //   'washroomAvailable': 'Washroom',
// //   'drinkingWater': 'Drinking water',
// //   'insuranceAccepted': 'Insurance accepted',
// //   'cashlessFacility': 'Cashless facility',
// //   'emergencyFacility': 'Emergency facility',
// //   'cleanliness': 'Cleanliness assured',
// //   'hygieneStandards': 'Hygiene standards',
// //   'childFriendly': 'Child friendly',
// //   'elderlyFriendly': 'Elderly friendly',
// //   'securityAvailable': 'Security',
// //   'receptionDesk': 'Reception desk',
// // };

// // const _kDays = [
// //   ('monday', 'Mon'),
// //   ('tuesday', 'Tue'),
// //   ('wednesday', 'Wed'),
// //   ('thursday', 'Thu'),
// //   ('friday', 'Fri'),
// //   ('saturday', 'Sat'),
// //   ('sunday', 'Sun'),
// // ];

// // const _kBookingPrefs = {
// //   'appointmentRequired': 'Appointment required',
// //   'walkInsAccepted': 'Walk-ins accepted',
// //   'sameDayAppointment': 'Same-day appointments',
// //   'emergencyAvailability': 'Emergency availability',
// // };

// // class MarketingProfileView extends StatefulWidget {
// //   const MarketingProfileView({super.key, required this.data, this.onEdit});
// //   final Map<String, dynamic> data;
// //   final VoidCallback? onEdit;

// //   @override
// //   State<MarketingProfileView> createState() => _MarketingProfileViewState();
// // }

// // class _MarketingProfileViewState extends State<MarketingProfileView> {
// //   // Availability ab har clinic ke andar hai, isliye 5 sections
// //   final _keys = List.generate(5, (_) => GlobalKey());
// //   static const _tabs = [
// //     ('Overview', Icons.person_outline_rounded),
// //     ('Qualifications', Icons.school_outlined),
// //     ('Specialisation', Icons.medical_services_outlined),
// //     ('Clinics', Icons.apartment_outlined),
// //     ('Fees', Icons.account_balance_wallet_outlined),
// //   ];

// //   void _jump(int i) {
// //     final ctx = _keys[i].currentContext;
// //     if (ctx != null) {
// //       Scrollable.ensureVisible(ctx,
// //           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
// //     }
// //   }

// //   /// Google Maps link ko Maps app / browser mein kholta hai (navigation)
// //   Future<void> _openMap(String link) async {
// //     var ok = false;
// //     final uri = Uri.tryParse(link);
// //     if (uri != null) {
// //       try {
// //         ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
// //       } catch (_) {}
// //     }
// //     if (!ok && mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Could not open Google Maps')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final d = widget.data;
// //     final isActive = d['isActive'] == true;

// //     return Scaffold(
// //       backgroundColor: _bg,
// //       appBar: AppBar(
// //         flexibleSpace: Container(
// //             decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         title: const Text('Marketing Profile',
// //             style: TextStyle(
// //                 fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
// //       ),
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Row(
// //                 children: [
// //                   Container(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //                     decoration: _cardDeco(10),
// //                     child: Row(children: [
// //                       Text(isActive ? 'Live' : 'Not live',
// //                           style: const TextStyle(fontSize: 13)),
// //                       const SizedBox(width: 6),
// //                       Switch(
// //                         value: isActive,
// //                         onChanged: null, // read-only; API se connect karo
// //                         activeTrackColor: AppColors.primary,
// //                         activeColor: AppColors.primary,
// //                       ),
// //                     ]),
// //                   ),
// //                   const Spacer(),
// //                   FilledButton.icon(
// //                     onPressed: widget.onEdit,
// //                     icon: const Icon(Icons.edit_outlined, size: 18),
// //                     label: const Text('Edit profile'),
// //                     style: FilledButton.styleFrom(
// //                         backgroundColor: AppColors.primary),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),

// //               Container(
// //                 decoration: _cardDeco(12),
// //                 height: 48,
// //                 child: ListView.separated(
// //                   scrollDirection: Axis.horizontal,
// //                   padding: const EdgeInsets.symmetric(horizontal: 8),
// //                   itemCount: _tabs.length,
// //                   separatorBuilder: (_, __) => const SizedBox(width: 4),
// //                   itemBuilder: (_, i) => TextButton.icon(
// //                     onPressed: () => _jump(i),
// //                     icon: Icon(_tabs[i].$2, size: 16),
// //                     label: Text(_tabs[i].$1),
// //                     style: TextButton.styleFrom(
// //                         foregroundColor: Colors.black87,
// //                         textStyle: const TextStyle(fontSize: 13)),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               KeyedSubtree(key: _keys[0], child: _overview(d)),
// //               const SizedBox(height: 16),
// //               KeyedSubtree(key: _keys[1], child: _qualifications(d)),
// //               const SizedBox(height: 16),
// //               KeyedSubtree(key: _keys[2], child: _specialisation(d)),
// //               const SizedBox(height: 16),
// //               KeyedSubtree(key: _keys[3], child: _clinics(d)),
// //               const SizedBox(height: 16),
// //               KeyedSubtree(key: _keys[4], child: _fees(d)),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ───────── Overview ─────────
// //   Widget _overview(Map<String, dynamic> d) {
// //     final b = _m(d['basicInformation']);
// //     final q = _m(d['qualifications']);
// //     final sp = _m(d['specialisation']);
// //     final name = _s(b['fullName']);
// //     final years = _s(b['yearsOfExperience']);
// //     final expertise = _s(sp['areasOfExpertise']);
// //     final langs = _l(b['languagesSpoken']);
// //     final photo = _s(d['profilePhoto']); // top-level key
// //     final regNo = _s(b['medicalRegistrationNumber']);
// //     final regYear = _s(b['registrationYear']);
// //     final registration =
// //         [regNo, regYear].where((e) => e.isNotEmpty).join(' · ');

// //     return _SectionCard(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _ProfileAvatar(url: photo, radius: 38),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(name,
// //                         style: const TextStyle(
// //                             fontSize: 22, fontWeight: FontWeight.w800)),
// //                     const SizedBox(height: 6),
// //                     Wrap(spacing: 6, runSpacing: 6, children: [
// //                       if (_s(sp['primarySpecialisation']).isNotEmpty)
// //                         _Pill(_s(sp['primarySpecialisation']), filled: true),
// //                       if (_s(q['highestQualification']).isNotEmpty)
// //                         _Pill(_s(q['highestQualification'])),
// //                       if (years.isNotEmpty)
// //                         _Pill('$years yrs experience', neutral: true),
// //                     ]),
// //                     if (expertise.isNotEmpty) ...[
// //                       const SizedBox(height: 8),
// //                       Text(expertise,
// //                           style: TextStyle(
// //                               fontSize: 12, color: Colors.grey.shade700)),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           Wrap(spacing: 32, runSpacing: 12, children: [
// //             if (_s(b['mobileNumber']).isNotEmpty)
// //               _LabeledValue('Mobile', '+91 ${_s(b['mobileNumber'])}',
// //                   Icons.phone_outlined),
// //             if (_s(b['email']).isNotEmpty)
// //               _LabeledValue(
// //                   'Email', _s(b['email']), Icons.mail_outline_rounded),
// //             if (registration.isNotEmpty)
// //               _LabeledValue('Registration', registration, Icons.badge_outlined),
// //           ]),
// //           if (langs.isNotEmpty) ...[
// //             const SizedBox(height: 14),
// //             const Row(children: [
// //               Icon(Icons.translate_rounded, size: 16, color: Colors.grey),
// //               SizedBox(width: 6),
// //               Text('Speaks',
// //                   style: TextStyle(fontSize: 12, color: Colors.grey)),
// //             ]),
// //             const SizedBox(height: 6),
// //             Wrap(
// //                 spacing: 6,
// //                 runSpacing: 6,
// //                 children: [for (final l in langs) _Pill(_s(l), soft: true)]),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // ───────── Qualifications (+ fellowships) ─────────
// //   Widget _qualifications(Map<String, dynamic> d) {
// //     final q = _m(d['qualifications']);
// //     final list = _l(q['qualificationDetails']);
// //     final fellowships = _l(q['fellowshipsCertifications']);

// //     return _SectionCard(
// //       title: 'Qualifications',
// //       icon: Icons.school_outlined,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (list.isEmpty)
// //             const _Empty('No qualifications added')
// //           else
// //             for (final e in list)
// //               _InnerBox(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(children: [
// //                       Text(_s(_m(e)['degree']),
// //                           style: TextStyle(
// //                               fontWeight: FontWeight.w800,
// //                               color: AppColors.primary)),
// //                       if (_s(_m(e)['year']).isNotEmpty) ...[
// //                         const SizedBox(width: 6),
// //                         _Pill(_s(_m(e)['year']), soft: true),
// //                       ],
// //                     ]),
// //                     const SizedBox(height: 6),
// //                     Text(_s(_m(e)['specialization']),
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.w600, fontSize: 14)),
// //                     const SizedBox(height: 2),
// //                     Text(_s(_m(e)['institution']),
// //                         style:
// //                             const TextStyle(fontSize: 12, color: Colors.grey)),
// //                   ],
// //                 ),
// //               ),
// //           if (fellowships.isNotEmpty) ...[
// //             const Divider(height: 28),
// //             const _MiniLabel(
// //                 Icons.workspace_premium_outlined, 'Fellowships & certifications'),
// //             const SizedBox(height: 10),
// //             for (final f in fellowships)
// //               _InnerBox(
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 2),
// //                       child: Icon(Icons.check_rounded,
// //                           size: 16, color: AppColors.primary),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(_s(_m(f)['name']),
// //                               style: const TextStyle(
// //                                   fontWeight: FontWeight.w700, fontSize: 13)),
// //                           const SizedBox(height: 2),
// //                           Text(
// //                             [_s(_m(f)['organization']), _s(_m(f)['year'])]
// //                                 .where((e) => e.isNotEmpty)
// //                                 .join(' · '),
// //                             style: const TextStyle(
// //                                 fontSize: 12, color: Colors.grey),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // ───────── Specialisation ─────────
// //   Widget _specialisation(Map<String, dynamic> d) {
// //     final sp = _m(d['specialisation']);
// //     final sub = _l(sp['subSpecialisation']);
// //     final cond = _l(sp['conditionsTreated']);
// //     final keys = _l(sp['keywords']);
// //     final nothing = sub.isEmpty && cond.isEmpty && keys.isEmpty;

// //     Widget group(String label, List items) => items.isEmpty
// //         ? const SizedBox.shrink()
// //         : Padding(
// //             padding: const EdgeInsets.only(bottom: 12),
// //             child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(label,
// //                       style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //                   const SizedBox(height: 6),
// //                   Wrap(spacing: 6, runSpacing: 6, children: [
// //                     for (final i in items) _Pill(_s(i), soft: true)
// //                   ]),
// //                 ]),
// //           );

// //     return _SectionCard(
// //       title: 'Specialisation',
// //       icon: Icons.medical_services_outlined,
// //       child: nothing
// //           ? const _Empty('No specialisation details added')
// //           : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //               group('Sub-specialisations', sub),
// //               group('Conditions treated', cond),
// //               group('Search keywords', keys),
// //             ]),
// //     );
// //   }

// //   // ───────── Clinics ─────────
// //   Widget _clinics(Map<String, dynamic> d) {
// //     final list = _l(d['clinics']);
// //     return _SectionCard(
// //       title: 'Clinics & hospitals (${list.length})',
// //       icon: Icons.apartment_outlined,
// //       child: list.isEmpty
// //           ? const _Empty('No clinics added')
// //           : Column(children: [for (final c in list) _clinicTile(_m(c))]),
// //     );
// //   }

// //   Widget _clinicTile(Map<String, dynamic> c) {
// //     final fac = _m(c['facilities']);
// //     final on = _kFacilityLabels.entries.where((e) => fac[e.key] == true);
// //     final fees = _m(c['fees']);
// //     final av = _m(c['availability']);

// //     final phone = _s(c['contactNumber']);
// //     final mapLink = _s(c['googleLocationLink']).trim();
// //     final rating = c['averageGoogleReview'];
// //     final hasRating = rating is num && rating > 0;
// //     final branch = _s(c['branchName']);
// //     final address = _s(c['fullAddress']);
// //     final loc = [_s(c['area']), _s(c['city']), _s(c['state']), _s(c['pinCode'])]
// //         .where((e) => e.isNotEmpty)
// //         .join(', ');

// //     final feePills = <Widget>[
// //       for (final f in const [
// //         ('First consultation', 'firstConsultation'),
// //         ('Follow-up', 'followUp'),
// //         ('Emergency', 'emergency'),
// //       ])
// //         if (_n(_m(fees[f.$2])['fee']) > 0)
// //           _FeePill(f.$1, _inr(_m(fees[f.$2])['fee'])),
// //     ];

// //     final prefs = _kBookingPrefs.entries.where((e) => av[e.key] == true);

// //     return _InnerBox(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // ── Header: name/branch (left) | phone + View on map (right)
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(_s(c['clinicName']),
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.w800, fontSize: 15)),
// //                     if (branch.isNotEmpty)
// //                       Text(branch,
// //                           style: const TextStyle(
// //                               fontSize: 12, color: Colors.grey)),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   if (phone.isNotEmpty)
// //                     Row(mainAxisSize: MainAxisSize.min, children: [
// //                       Icon(Icons.call, size: 14, color: AppColors.primary),
// //                       const SizedBox(width: 4),
// //                       Text(phone,
// //                           style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w700,
// //                               color: AppColors.primary)),
// //                     ]),
// //                   if (mapLink.isNotEmpty) ...[
// //                     const SizedBox(height: 6),
// //                     OutlinedButton.icon(
// //                       onPressed: () => _openMap(mapLink),
// //                       icon: const Icon(Icons.near_me_outlined, size: 14),
// //                       label: const Text('View on map'),
// //                       style: OutlinedButton.styleFrom(
// //                         foregroundColor: AppColors.primary,
// //                         side: BorderSide(
// //                             color: AppColors.primary.withOpacity(0.5)),
// //                         visualDensity: VisualDensity.compact,
// //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 10, vertical: 6),
// //                         textStyle: const TextStyle(
// //                             fontSize: 12, fontWeight: FontWeight.w600),
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8)),
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ],
// //           ),

// //           // ── Google rating (yellow box)
// //           if (hasRating) ...[
// //             const SizedBox(height: 8),
// //             _RatingBox(rating: rating.toDouble()),
// //           ],

// //           // ── Location
// //           if (loc.isNotEmpty) ...[
// //             const SizedBox(height: 10),
// //             Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //               Icon(Icons.location_on_outlined,
// //                   size: 16, color: AppColors.primary),
// //               const SizedBox(width: 6),
// //               Expanded(child: Text(loc, style: const TextStyle(fontSize: 13))),
// //             ]),
// //           ],
// //           if (address.isNotEmpty) ...[
// //             const SizedBox(height: 4),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 22),
// //               child: Text(address,
// //                   style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
// //             ),
// //           ],

// //           // ── Facilities
// //           if (on.isNotEmpty) ...[
// //             const SizedBox(height: 10),
// //             Wrap(spacing: 6, runSpacing: 6, children: [
// //               for (final e in on) _Pill(e.value, check: true),
// //             ]),
// //           ],

// //           // ── Fees at this clinic
// //           if (feePills.isNotEmpty) ...[
// //             const Divider(height: 24),
// //             const _MiniLabel(Icons.payments_outlined, 'FEES AT THIS CLINIC'),
// //             const SizedBox(height: 8),
// //             Wrap(spacing: 6, runSpacing: 6, children: feePills),
// //           ],

// //           // ── Weekly timings
// //           const Divider(height: 24),
// //           const _MiniLabel(Icons.schedule_rounded, 'WEEKLY TIMINGS'),
// //           const SizedBox(height: 8),
// //           Wrap(spacing: 6, runSpacing: 6, children: [
// //             for (final day in _kDays) _dayChip(day.$2, _m(av[day.$1])),
// //           ]),

// //           // ── Booking preferences
// //           if (prefs.isNotEmpty) ...[
// //             const SizedBox(height: 10),
// //             Wrap(spacing: 8, runSpacing: 6, children: [
// //               for (final p in prefs)
// //                 Row(mainAxisSize: MainAxisSize.min, children: [
// //                   Icon(Icons.check_rounded,
// //                       size: 13, color: AppColors.primary),
// //                   const SizedBox(width: 4),
// //                   Text(p.value,
// //                       style: TextStyle(
// //                           fontSize: 11.5,
// //                           fontWeight: FontWeight.w600,
// //                           color: AppColors.primary)),
// //                 ]),
// //             ]),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _dayChip(String short, Map<String, dynamic> a) {
// //     final enabled = a['enabled'] == true;
// //     var times = 'Closed';
// //     if (enabled) {
// //       times = '${_s(a['startTime'])} – ${_s(a['endTime'])}';
// //       if (_s(a['breakStartTime']).isNotEmpty) {
// //         times += ' (break ${_s(a['breakStartTime'])} – ${_s(a['breakEndTime'])})';
// //       }
// //     }
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: enabled ? Colors.white : const Color(0xFFF1F5FA),
// //         borderRadius: BorderRadius.circular(6),
// //         border: Border.all(
// //           color: enabled
// //               ? AppColors.primary.withOpacity(0.6)
// //               : const Color(0xFFDDE5EF),
// //         ),
// //       ),
// //       child: Text.rich(
// //         TextSpan(children: [
// //           TextSpan(
// //             text: short,
// //             style: TextStyle(
// //               fontWeight: FontWeight.w800,
// //               fontSize: 11.5,
// //               color: enabled ? Colors.black87 : Colors.grey,
// //             ),
// //           ),
// //           TextSpan(
// //             text: '  $times',
// //             style: TextStyle(
// //               fontSize: 11,
// //               color: enabled ? Colors.grey.shade700 : Colors.grey,
// //             ),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   // ───────── Consultation & fees ─────────
// //   Widget _fees(Map<String, dynamic> d) {
// //     final c = _m(d['consultation']);
// //     final fees = _m(c['fees']);
// //     final modes = <(String, IconData)>[
// //       if (c['inClinic'] == true) ('In-clinic', Icons.apartment_outlined),
// //       if (c['video'] == true) ('Video', Icons.videocam_outlined),
// //       if (c['phone'] == true) ('Phone', Icons.phone_outlined),
// //       if (c['homeVisit'] == true) ('Home visit', Icons.home_outlined),
// //       if (c['hospital'] == true) ('Hospital', Icons.local_hospital_outlined),
// //     ];

// //     Widget tile(String label, String key, {bool requireMode = true}) {
// //       final enabled = !requireMode || c[key] == true;
// //       final fee = _m(fees[key])['fee'];
// //       if (!enabled || _n(fee) <= 0) return const SizedBox.shrink();
// //       return _InnerBox(
// //         child: Row(children: [
// //           Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
// //           Text(_inr(fee),
// //               style:
// //                   const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
// //         ]),
// //       );
// //     }

// //     final waiting = c['averageWaitingDuration'];

// //     return _SectionCard(
// //       title: 'Consultation & fees',
// //       icon: Icons.account_balance_wallet_outlined,
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         const Text('Available modes',
// //             style: TextStyle(fontSize: 12, color: Colors.grey)),
// //         const SizedBox(height: 8),
// //         Wrap(spacing: 8, runSpacing: 8, children: [
// //           for (final m in modes)
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: AppColors.primary.withOpacity(0.6)),
// //               ),
// //               child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                 Icon(m.$2, size: 16, color: AppColors.primary),
// //                 const SizedBox(width: 6),
// //                 Text(m.$1,
// //                     style: TextStyle(
// //                         fontSize: 13,
// //                         fontWeight: FontWeight.w600,
// //                         color: AppColors.primary)),
// //               ]),
// //             ),
// //         ]),
// //         const Divider(height: 28),
// //         tile('Video consultation', 'video'),
// //         tile('Phone consultation', 'phone'),
// //         tile('Home visit', 'homeVisit'),
// //         tile('Hospital consultation', 'hospital'),
// //         tile('Average consultation fee', 'averageConsultationFee',
// //             requireMode: false),
// //         if (waiting != null && _n(waiting) > 0)
// //           Padding(
// //             padding: const EdgeInsets.only(top: 2),
// //             child: Row(children: [
// //               const Icon(Icons.access_time_rounded,
// //                   size: 14, color: Colors.grey),
// //               const SizedBox(width: 6),
// //               Text.rich(TextSpan(
// //                 style: const TextStyle(fontSize: 12, color: Colors.grey),
// //                 children: [
// //                   const TextSpan(text: 'Average waiting time: '),
// //                   TextSpan(
// //                     text: '${_s(waiting)} min',
// //                     style: TextStyle(
// //                         fontWeight: FontWeight.w800,
// //                         color: AppColors.primary),
// //                   ),
// //                 ],
// //               )),
// //             ]),
// //           ),
// //       ]),
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════════════════════════════════
// // // Shared small widgets
// // // ═══════════════════════════════════════════════════════════════════
// // BoxDecoration _cardDeco([double r = 12]) => BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(r),
// //       boxShadow: [
// //         BoxShadow(
// //             color: AppColors.primary.withOpacity(0.08),
// //             blurRadius: 24,
// //             offset: const Offset(0, 8)),
// //       ],
// //     );

// // /// Profile photo — URL khaali/fail ho to person icon
// // class _ProfileAvatar extends StatelessWidget {
// //   const _ProfileAvatar({required this.url, this.radius = 36});
// //   final String url;
// //   final double radius;

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = radius * 2;
// //     final fallback = Center(
// //       child: Icon(Icons.person_rounded, size: radius * 1.2, color: AppColors.primary),
// //     );

// //     return Container(
// //       width: size,
// //       height: size,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: AppColors.badgeBg,
// //         border: Border.all(color: Colors.white, width: 3),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.12),
// //               blurRadius: 10,
// //               offset: const Offset(0, 3)),
// //         ],
// //       ),
// //       child: ClipOval(
// //         child: url.isEmpty
// //             ? fallback
// //             : Image.network(
// //                 url,
// //                 width: size,
// //                 height: size,
// //                 fit: BoxFit.cover,
// //                 loadingBuilder: (_, child, progress) => progress == null
// //                     ? child
// //                     : const Center(
// //                         child: SizedBox(
// //                           width: 18,
// //                           height: 18,
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         ),
// //                       ),
// //                 errorBuilder: (_, __, ___) => fallback,
// //               ),
// //       ),
// //     );
// //   }
// // }

// // /// Chhota yellow Google rating box
// // class _RatingBox extends StatelessWidget {
// //   const _RatingBox({required this.rating});
// //   final double rating;

// //   @override
// //   Widget build(BuildContext context) => Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFFFF8E1),
// //           borderRadius: BorderRadius.circular(6),
// //           border: Border.all(color: const Color(0xFFF5D06F)),
// //         ),
// //         child: Row(mainAxisSize: MainAxisSize.min, children: [
// //           const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF5A623)),
// //           const SizedBox(width: 4),
// //           Text(rating.toStringAsFixed(1),
// //               style:
// //                   const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
// //           const SizedBox(width: 4),
// //           Text('Google rating',
// //               style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
// //         ]),
// //       );
// // }

// // class _MiniLabel extends StatelessWidget {
// //   const _MiniLabel(this.icon, this.text);
// //   final IconData icon;
// //   final String text;

// //   @override
// //   Widget build(BuildContext context) => Row(children: [
// //         Icon(icon, size: 14, color: AppColors.primary),
// //         const SizedBox(width: 6),
// //         Text(text,
// //             style: const TextStyle(
// //                 fontSize: 11.5,
// //                 fontWeight: FontWeight.w800,
// //                 letterSpacing: 0.3)),
// //       ]);
// // }

// // /// "First consultation  ₹1,115"
// // class _FeePill extends StatelessWidget {
// //   const _FeePill(this.label, this.amount);
// //   final String label, amount;

// //   @override
// //   Widget build(BuildContext context) => Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(6),
// //           border: Border.all(color: Colors.grey.shade300),
// //         ),
// //         child: Text.rich(TextSpan(children: [
// //           TextSpan(
// //               text: '$label  ',
// //               style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
// //           TextSpan(
// //               text: amount,
// //               style: TextStyle(
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w800,
// //                   color: AppColors.primary)),
// //         ])),
// //       );
// // }

// // class _SectionCard extends StatelessWidget {
// //   const _SectionCard({this.title, this.icon, required this.child});
// //   final String? title;
// //   final IconData? icon;
// //   final Widget child;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: _cardDeco(16),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Container(height: 3, color: AppColors.primary),
// //             Padding(
// //               padding: const EdgeInsets.all(18),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   if (title != null) ...[
// //                     Row(children: [
// //                       Container(
// //                         width: 38,
// //                         height: 38,
// //                         decoration: BoxDecoration(
// //                           color: AppColors.primary.withOpacity(0.10),
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: Icon(icon, color: AppColors.primary, size: 20),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Text(title!,
// //                             style: const TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.w800)),
// //                       ),
// //                     ]),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   child,
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _InnerBox extends StatelessWidget {
// //   const _InnerBox({required this.child});
// //   final Widget child;

// //   @override
// //   Widget build(BuildContext context) => Container(
// //         width: double.infinity,
// //         margin: const EdgeInsets.only(bottom: 10),
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFFEF6F6),
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(color: AppColors.primary.withOpacity(0.08)),
// //         ),
// //         child: child,
// //       );
// // }

// // class _Pill extends StatelessWidget {
// //   const _Pill(this.text,
// //       {this.filled = false,
// //       this.soft = false,
// //       this.check = false,
// //       this.neutral = false});
// //   final String text;
// //   final bool filled, soft, check, neutral;

// //   @override
// //   Widget build(BuildContext context) {
// //     Color bg = Colors.white;
// //     Color fg = AppColors.primary;
// //     Border? border = Border.all(color: AppColors.primary.withOpacity(0.5));

// //     if (filled) {
// //       bg = AppColors.primary;
// //       fg = Colors.white;
// //       border = null;
// //     } else if (soft) {
// //       bg = AppColors.badgeBg;
// //       border = null;
// //     } else if (neutral) {
// //       fg = Colors.grey.shade700;
// //       border = Border.all(color: Colors.grey.withOpacity(0.5));
// //     } else if (check) {
// //       fg = Colors.black87;
// //       border = Border.all(color: Colors.grey.shade300);
// //     }

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: bg,
// //         borderRadius: BorderRadius.circular(20),
// //         border: border,
// //       ),
// //       child: Row(mainAxisSize: MainAxisSize.min, children: [
// //         if (check) ...[
// //           Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
// //           const SizedBox(width: 4),
// //         ],
// //         Text(text,
// //             style: TextStyle(
// //                 fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
// //       ]),
// //     );
// //   }
// // }

// // class _LabeledValue extends StatelessWidget {
// //   const _LabeledValue(this.label, this.value, this.icon);
// //   final String label, value;
// //   final IconData icon;

// //   @override
// //   Widget build(BuildContext context) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
// //           const SizedBox(height: 4),
// //           Row(mainAxisSize: MainAxisSize.min, children: [
// //             Icon(icon, size: 16, color: Colors.grey),
// //             const SizedBox(width: 6),
// //             Text(value,
// //                 style:
// //                     const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// //           ]),
// //         ],
// //       );
// // }

// // class _Empty extends StatelessWidget {
// //   const _Empty(this.text);
// //   final String text;

// //   @override
// //   Widget build(BuildContext context) =>
// //       Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey));
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:sales_mobile_app/pages/marketingPage.dart';
// import 'package:sales_mobile_app/provider/marketingProvider.dart';
// // ▼▼▼ CHANGE 1: Salesprovider ki import (apna sahi path daalo) ▼▼▼
// import 'package:sales_mobile_app/provider/salesProvider.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';

// const _bg = Color(0xFFFEF6F6);

// Map<String, dynamic> _m(dynamic v) =>
//     v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
// List _l(dynamic v) => v is List ? v : const [];
// String _s(dynamic v) => v == null ? '' : v.toString();

// /// 1115 -> ₹1,115 | 123456 -> ₹1,23,456 (Indian grouping)
// String _inr(dynamic v) {
//   final n = v is num ? v.round() : (int.tryParse(_s(v)) ?? 0);
//   final s = n.abs().toString();
//   final sign = n < 0 ? '-' : '';
//   if (s.length <= 3) return '₹$sign$s';
//   final last3 = s.substring(s.length - 3);
//   var rest = s.substring(0, s.length - 3);
//   final parts = <String>[];
//   while (rest.length > 2) {
//     parts.insert(0, rest.substring(rest.length - 2));
//     rest = rest.substring(0, rest.length - 2);
//   }
//   if (rest.isNotEmpty) parts.insert(0, rest);
//   return '₹$sign${parts.join(',')},$last3';
// }

// num _n(dynamic v) => v is num ? v : (num.tryParse(_s(v)) ?? 0);

// // ═══════════════════════════════════════════════════════════════════
// // GATE: data null  -> form (MarketingProfilePage)
// //       data aaya  -> read-only profile view
// // ═══════════════════════════════════════════════════════════════════
// class MarketingProfileGate extends StatefulWidget {
//   const MarketingProfileGate({super.key, required this.id});
//   final String id;

//   @override
//   State<MarketingProfileGate> createState() => _MarketingProfileGateState();
// }

// class _MarketingProfileGateState extends State<MarketingProfileGate> {
//   late Future<dynamic> _future;
//   bool _editing = false;
//   dynamic _profileData;

//   @override
//   void initState() {
//     super.initState();
//     _future = context
//         .read<Marketingprovider>()
//         .getdoctoralldetails(context, widget.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_editing) {
//       return MarketingProfilePage(
//         id: widget.id,
//         initialData: _profileData,
//         isEdit: true,
//       );
//     }

//     return FutureBuilder<dynamic>(
//       future: _future,
//       builder: (context, snap) {
//         if (snap.connectionState != ConnectionState.done) {
//           return const Scaffold(
//             backgroundColor: _bg,
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         final res = _m(snap.data);
//         final data = res['data'];

//         if (snap.hasError || data == null) {
//           return MarketingProfilePage(
//             id: widget.id,
//             initialData: _profileData,
//             isEdit: false,
//           );
//         }

//         _profileData = _m(data);

//         return MarketingProfileView(
//           // ▼▼▼ CHANGE 2: id pass karo ▼▼▼
//           id: widget.id,
//           data: _profileData,
//           onEdit: () => setState(() => _editing = true),
//         );
//       },
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════
// // READ-ONLY VIEW
// // ═══════════════════════════════════════════════════════════════════
// const Map<String, String> _kFacilityLabels = {
//   'parkingAvailable': 'Parking',
//   'accessibleParking': 'Accessible parking',
//   'wheelchairAccessible': 'Wheelchair accessible',
//   'liftAvailable': 'Lift',
//   'pharmacy': 'Pharmacy',
//   'laboratory': 'Laboratory',
//   'diagnosticCentre': 'Diagnostic centre',
//   'acWaitingArea': 'AC waiting area',
//   'waitingArea': 'Waiting area',
//   'washroomAvailable': 'Washroom',
//   'drinkingWater': 'Drinking water',
//   'insuranceAccepted': 'Insurance accepted',
//   'cashlessFacility': 'Cashless facility',
//   'emergencyFacility': 'Emergency facility',
//   'cleanliness': 'Cleanliness assured',
//   'hygieneStandards': 'Hygiene standards',
//   'childFriendly': 'Child friendly',
//   'elderlyFriendly': 'Elderly friendly',
//   'securityAvailable': 'Security',
//   'receptionDesk': 'Reception desk',
// };

// const _kDays = [
//   ('monday', 'Mon'),
//   ('tuesday', 'Tue'),
//   ('wednesday', 'Wed'),
//   ('thursday', 'Thu'),
//   ('friday', 'Fri'),
//   ('saturday', 'Sat'),
//   ('sunday', 'Sun'),
// ];

// const _kBookingPrefs = {
//   'appointmentRequired': 'Appointment required',
//   'walkInsAccepted': 'Walk-ins accepted',
//   'sameDayAppointment': 'Same-day appointments',
//   'emergencyAvailability': 'Emergency availability',
// };

// class MarketingProfileView extends StatefulWidget {
//   const MarketingProfileView({
//     super.key,
//     required this.id, // ▼▼▼ CHANGE 3: id field ▼▼▼
//     required this.data,
//     this.onEdit,
//   });
//   final String id;
//   final Map<String, dynamic> data;
//   final VoidCallback? onEdit;

//   @override
//   State<MarketingProfileView> createState() => _MarketingProfileViewState();
// }

// class _MarketingProfileViewState extends State<MarketingProfileView> {
//   final _keys = List.generate(5, (_) => GlobalKey());
//   static const _tabs = [
//     ('Overview', Icons.person_outline_rounded),
//     ('Qualifications', Icons.school_outlined),
//     ('Specialisation', Icons.medical_services_outlined),
//     ('Clinics', Icons.apartment_outlined),
//     ('Fees', Icons.account_balance_wallet_outlined),
//   ];

//   // ▼▼▼ CHANGE 4: toggle ka state ▼▼▼
//   late bool _isActive;
//   bool _toggling = false;
//   late String photourl;

//   @override
//   void initState() {
//     super.initState();
//     _isActive = widget.data['isActive'] == true;
//     photourl = widget.data['profilePhoto'] ??'';

//   }

//   String _cleanPhone(String raw) {
//     final t = raw.trim();
//     final plus = t.startsWith('+') ? '+' : '';
//     return plus + t.replaceAll(RegExp(r'[^0-9]'), '');
//   }
 
//   Future<void> _callNumber(String raw) async {
//     var ok = false;
//     try {
//       ok = await launchUrl(Uri(scheme: 'tel', path: _cleanPhone(raw)));
//     } catch (_) {}
//     if (!ok && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open the phone dialer')),
//       );
//     }
//   }
 
//   Future<void> _copyNumber(String raw) async {
//     await Clipboard.setData(ClipboardData(text: raw.trim()));
//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         const SnackBar(
//           content: Text('Phone number copied'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//   }
 
//   /// Bottom sheet shown when the phone button is tapped: Call / Copy.
//   void _showPhoneOptions(String phone) {
//     showModalBottomSheet<void>(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (sheetCtx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 phone,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.w800),
//               ),
//               const SizedBox(height: 14),
//               ListTile(
//                 leading: Icon(Icons.call, color: AppColors.primary),
//                 title: const Text('Call'),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 onTap: () {
//                   Navigator.pop(sheetCtx);
//                   _callNumber(phone);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.copy_rounded, color: AppColors.primary),
//                 title: const Text('Copy number'),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 onTap: () {
//                   Navigator.pop(sheetCtx);
//                   _copyNumber(phone);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
 
//   /// One style for BOTH buttons so they look identical.
//   ButtonStyle _clinicActionStyle() => OutlinedButton.styleFrom(
//         foregroundColor: AppColors.primary,
//         side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
//         visualDensity: VisualDensity.compact,
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       );

//   @override
//   void didUpdateWidget(covariant MarketingProfileView old) {
//     super.didUpdateWidget(old);
//     if (old.data != widget.data) {
//       _isActive = widget.data['isActive'] == true;
//     }
//   }

//   // ▼▼▼ CHANGE 5: Live switch — bina dialog ke seedha API call ▼▼▼
//   Future<void> _toggleLive(bool _) async {
//     if (_toggling) return;

//     final marketingprovider = context.read<Marketingprovider>();
//     final current = _isActive; // "currentStatus" = toggle se pehle wala

//     // Optimistic: switch turant badal do
//     setState(() {
//       _toggling = true;
//       _isActive = !current;
//     });

//     try {
//       // Tumhara wahi function, bas dialog ke bina
//       await marketingprovider.toggleStatus(widget.id, current, context);

//       // Server se asli status le lo, taaki fail hone par UI galat na rahe
//       final res =
//           await marketingprovider.getdoctoralldetails(context, widget.id);
//       final data = res is Map ? res['data'] : null;
//       if (mounted && data is Map) {
//         setState(() => _isActive = data['isActive'] == true);
//         widget.data['isActive'] = _isActive; // Edit se wapas aane par bhi sahi
//       }
//     } catch (_) {
//       if (mounted) setState(() => _isActive = current); // error -> purana
//     } finally {
//       if (mounted) setState(() => _toggling = false);
//     }
//   }

//   void _jump(int i) {
//     final ctx = _keys[i].currentContext;
//     if (ctx != null) {
//       Scrollable.ensureVisible(ctx,
//           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
//     }
//   }

//   Future<void> _openMap(String link) async {
//     var ok = false;
//     final uri = Uri.tryParse(link);
//     if (uri != null) {
//       try {
//         ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } catch (_) {}
//     }
//     if (!ok && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open Google Maps')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final d = widget.data;
//     // CHANGE 6: purani `final isActive = d['isActive'] == true;` line hata di
//     // (ab `_isActive` state use hota hai)

//     return Scaffold(
//       backgroundColor: _bg,
//       appBar: AppBar(
//         flexibleSpace: Container(
//             decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text('Marketing Profile',
//             style: TextStyle(
//                 fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 children: [
//                   // ▼▼▼ CHANGE 7: Live switch ▼▼▼
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: _cardDeco(10),
//                     child: Row(children: [
//                       Text(_isActive ? 'Live' : 'Not live',
//                           style: const TextStyle(fontSize: 13)),
//                       const SizedBox(width: 6),
//                       if (_toggling)
//                         const Padding(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           child: SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         )
//                       else
//                         Switch(
//                           value: _isActive,
//                           onChanged: _toggleLive, // pehle null tha
//                           activeTrackColor: AppColors.primary,
//                           activeColor: AppColors.primary,
//                         ),
//                     ]),
//                   ),
//                   const Spacer(),
//                   FilledButton.icon(
//                     onPressed: widget.onEdit,
//                     icon: const Icon(Icons.edit_outlined, size: 18),
//                     label: const Text('Edit profile'),
//                     style: FilledButton.styleFrom(
//                         backgroundColor: AppColors.primary),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               Container(
//                 decoration: _cardDeco(12),
//                 height: 48,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   itemCount: _tabs.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 4),
//                   itemBuilder: (_, i) => TextButton.icon(
//                     onPressed: () => _jump(i),
//                     icon: Icon(_tabs[i].$2, size: 16),
//                     label: Text(_tabs[i].$1),
//                     style: TextButton.styleFrom(
//                         foregroundColor: Colors.black87,
//                         textStyle: const TextStyle(fontSize: 13)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               KeyedSubtree(key: _keys[0], child: _overview(d)),
//               const SizedBox(height: 16),
//               KeyedSubtree(key: _keys[1], child: _qualifications(d)),
//               const SizedBox(height: 16),
//               KeyedSubtree(key: _keys[2], child: _specialisation(d)),
//               const SizedBox(height: 16),
//               KeyedSubtree(key: _keys[3], child: _clinics(d)),
//               const SizedBox(height: 16),
//               KeyedSubtree(key: _keys[4], child: _fees(d)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ───────── Overview ─────────
//   Widget _overview(Map<String, dynamic> d) {
//     final b = _m(d['basicInformation']);
//     final q = _m(d['qualifications']);
//     final sp = _m(d['specialisation']);
//     final name = _s(b['fullName']);
//     final years = _s(b['yearsOfExperience']);
//     final expertise = _s(sp['areasOfExpertise']);
//     final langs = _l(b['languagesSpoken']);
//     final photo = _s(d['profilePhoto']);
//     final regNo = _s(b['medicalRegistrationNumber']);
//     final regYear = _s(b['registrationYear']);
//     final registration =
//         [regNo, regYear].where((e) => e.isNotEmpty).join(' · ');

//     return _SectionCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _ProfileAvatar(url: photo, radius: 38),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(name,
//                         style: const TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.w800)),
//                     const SizedBox(height: 6),
//                     Wrap(spacing: 6, runSpacing: 6, children: [
//                       if (_s(sp['primarySpecialisation']).isNotEmpty)
//                         _Pill(_s(sp['primarySpecialisation']), filled: true),
//                       if (_s(q['highestQualification']).isNotEmpty)
//                         _Pill(_s(q['highestQualification'])),
//                       if (years.isNotEmpty)
//                         _Pill('$years yrs experience', neutral: true),
//                     ]),
//                     if (expertise.isNotEmpty) ...[
//                       const SizedBox(height: 8),
//                       Text(expertise,
//                           style: TextStyle(
//                               fontSize: 12, color: Colors.grey.shade700)),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Wrap(spacing: 32, runSpacing: 12, children: [
//             if (_s(b['mobileNumber']).isNotEmpty)
//               _LabeledValue('Mobile', '+91 ${_s(b['mobileNumber'])}',
//                   Icons.phone_outlined),
//             if (_s(b['email']).isNotEmpty)
//               _LabeledValue(
//                   'Email', _s(b['email']), Icons.mail_outline_rounded),
//             if (registration.isNotEmpty)
//               _LabeledValue('Registration', registration, Icons.badge_outlined),
//           ]),
//           if (langs.isNotEmpty) ...[
//             const SizedBox(height: 14),
//             const Row(children: [
//               Icon(Icons.translate_rounded, size: 16, color: Colors.grey),
//               SizedBox(width: 6),
//               Text('Speaks',
//                   style: TextStyle(fontSize: 12, color: Colors.grey)),
//             ]),
//             const SizedBox(height: 6),
//             Wrap(
//                 spacing: 6,
//                 runSpacing: 6,
//                 children: [for (final l in langs) _Pill(_s(l), soft: true)]),
//           ],
//         ],
//       ),
//     );
//   }

//   // ───────── Qualifications (+ fellowships) ─────────
//   Widget _qualifications(Map<String, dynamic> d) {
//     final q = _m(d['qualifications']);
//     final list = _l(q['qualificationDetails']);
//     final fellowships = _l(q['fellowshipsCertifications']);

//     return _SectionCard(
//       title: 'Qualifications',
//       icon: Icons.school_outlined,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (list.isEmpty)
//             const _Empty('No qualifications added')
//           else
//             for (final e in list)
//               _InnerBox(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(children: [
//                       Text(_s(_m(e)['degree']),
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: AppColors.primary)),
//                       if (_s(_m(e)['year']).isNotEmpty) ...[
//                         const SizedBox(width: 6),
//                         _Pill(_s(_m(e)['year']), soft: true),
//                       ],
//                     ]),
//                     const SizedBox(height: 6),
//                     Text(_s(_m(e)['specialization']),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 14)),
//                     const SizedBox(height: 2),
//                     Text(_s(_m(e)['institution']),
//                         style:
//                             const TextStyle(fontSize: 12, color: Colors.grey)),
//                   ],
//                 ),
//               ),
//           if (fellowships.isNotEmpty) ...[
//             const Divider(height: 28),
//             const _MiniLabel(
//                 Icons.workspace_premium_outlined, 'Fellowships & certifications'),
//             const SizedBox(height: 10),
//             for (final f in fellowships)
//               _InnerBox(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Icon(Icons.check_rounded,
//                           size: 16, color: AppColors.primary),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(_s(_m(f)['name']),
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w700, fontSize: 13)),
//                           const SizedBox(height: 2),
//                           Text(
//                             [_s(_m(f)['organization']), _s(_m(f)['year'])]
//                                 .where((e) => e.isNotEmpty)
//                                 .join(' · '),
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ───────── Specialisation ─────────
//   Widget _specialisation(Map<String, dynamic> d) {
//     final sp = _m(d['specialisation']);
//     final sub = _l(sp['subSpecialisation']);
//     final cond = _l(sp['conditionsTreated']);
//     final keys = _l(sp['keywords']);
//     final nothing = sub.isEmpty && cond.isEmpty && keys.isEmpty;

//     Widget group(String label, List items) => items.isEmpty
//         ? const SizedBox.shrink()
//         : Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                   const SizedBox(height: 6),
//                   Wrap(spacing: 6, runSpacing: 6, children: [
//                     for (final i in items) _Pill(_s(i), soft: true)
//                   ]),
//                 ]),
//           );

//     return _SectionCard(
//       title: 'Specialisation',
//       icon: Icons.medical_services_outlined,
//       child: nothing
//           ? const _Empty('No specialisation details added')
//           : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               group('Sub-specialisations', sub),
//               group('Conditions treated', cond),
//               group('Search keywords', keys),
//             ]),
//     );
//   }

//   // ───────── Clinics ─────────
//   Widget _clinics(Map<String, dynamic> d) {
//     final list = _l(d['clinics']);
//     return _SectionCard(
//       title: 'Clinics & hospitals (${list.length})',
//       icon: Icons.apartment_outlined,
//       child: list.isEmpty
//           ? const _Empty('No clinics added')
//           : Column(children: [for (final c in list) _clinicTile(_m(c))]),
//     );
//   }

//   Widget _clinicTile(Map<String, dynamic> c) {
//     final fac = _m(c['facilities']);
//     final on = _kFacilityLabels.entries.where((e) => fac[e.key] == true);
//     final fees = _m(c['fees']);
//     final av = _m(c['availability']);

//     final phone = _s(c['contactNumber']);
//     final mapLink = _s(c['googleLocationLink']).trim();
//     final rating = c['averageGoogleReview'];
//     final hasRating = rating is num && rating > 0;
//     final branch = _s(c['branchName']);
//     final address = _s(c['fullAddress']);
//     final loc = [_s(c['area']), _s(c['city']), _s(c['state']), _s(c['pinCode'])]
//         .where((e) => e.isNotEmpty)
//         .join(', ');

//     final feePills = <Widget>[
//       for (final f in const [
//         ('First consultation', 'firstConsultation'),
//         ('Follow-up', 'followUp'),
//         ('Emergency', 'emergency'),
//       ])
//         if (_n(_m(fees[f.$2])['fee']) > 0)
//           _FeePill(f.$1, _inr(_m(fees[f.$2])['fee'])),
//     ];

//     final prefs = _kBookingPrefs.entries.where((e) => av[e.key] == true);

//     return _InnerBox(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(_s(c['clinicName']),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w800, fontSize: 15)),
//                     if (branch.isNotEmpty)
//                       Text(branch,
//                           style: const TextStyle(
//                               fontSize: 12, color: Colors.grey)),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // if (phone.isNotEmpty)
//                   //   Row(mainAxisSize: MainAxisSize.min, children: [
//                   //     Icon(Icons.call, size: 14, color: AppColors.primary),
//                   //     const SizedBox(width: 4),
//                   //     Text(phone,
//                   //         style: TextStyle(
//                   //             fontSize: 12,
//                   //             fontWeight: FontWeight.w700,
//                   //             color: AppColors.primary)),
//                   //   ]),
//                   // if (mapLink.isNotEmpty) ...[
//                   //   const SizedBox(height: 6),
//                   //   OutlinedButton.icon(
//                   //     onPressed: () => _openMap(mapLink),
//                   //     icon: const Icon(Icons.near_me_outlined, size: 14),
//                   //     label: const Text('View on map'),
//                   //     style: OutlinedButton.styleFrom(
//                   //       foregroundColor: AppColors.primary,
//                   //       side: BorderSide(
//                   //           color: AppColors.primary.withOpacity(0.5)),
//                   //       visualDensity: VisualDensity.compact,
//                   //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   //       padding: const EdgeInsets.symmetric(
//                   //           horizontal: 10, vertical: 6),
//                   //       textStyle: const TextStyle(
//                   //           fontSize: 12, fontWeight: FontWeight.w600),
//                   //       shape: RoundedRectangleBorder(
//                   //           borderRadius: BorderRadius.circular(8)),
//                   //     ),
//                   //   ),
//                   // ],

//                   const SizedBox(width: 8),
//               if (phone.isNotEmpty || mapLink.isNotEmpty)
//                 IntrinsicWidth(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       if (phone.isNotEmpty)
//                         OutlinedButton.icon(
//                           onPressed: () => _showPhoneOptions(phone),
//                           icon: const Icon(Icons.call, size: 14),
//                           label: Text(phone),
//                           style: _clinicActionStyle(),
//                         ),
//                       if (phone.isNotEmpty && mapLink.isNotEmpty)
//                         const SizedBox(height: 8),
//                       if (mapLink.isNotEmpty)
//                         OutlinedButton.icon(
//                           onPressed: () => _openMap(mapLink),
//                           icon: const Icon(Icons.near_me_outlined, size: 14),
//                           label: const Text('View on map'),
//                           style: _clinicActionStyle(),
//                         ),
//                     ],
//                   ),
//                 ),
 
//                 ],
//               ),
//             ],
//           ),

//           if (hasRating) ...[
//             const SizedBox(height: 8),
//             _RatingBox(rating: rating.toDouble()),
//           ],

//           if (loc.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Icon(Icons.location_on_outlined,
//                   size: 16, color: AppColors.primary),
//               const SizedBox(width: 6),
//               Expanded(child: Text(loc, style: const TextStyle(fontSize: 13))),
//             ]),
//           ],
//           if (address.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.only(left: 22),
//               child: Text(address,
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
//             ),
//           ],

//           if (on.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Wrap(spacing: 6, runSpacing: 6, children: [
//               for (final e in on) _Pill(e.value, check: true),
//             ]),
//           ],

//           if (feePills.isNotEmpty) ...[
//             const Divider(height: 24),
//             const _MiniLabel(Icons.payments_outlined, 'FEES AT THIS CLINIC'),
//             const SizedBox(height: 8),
//             Wrap(spacing: 6, runSpacing: 6, children: feePills),
//           ],

//           const Divider(height: 24),
//           const _MiniLabel(Icons.schedule_rounded, 'WEEKLY TIMINGS'),
//           const SizedBox(height: 8),
//           Wrap(spacing: 6, runSpacing: 6, children: [
//             for (final day in _kDays) _dayChip(day.$2, _m(av[day.$1])),
//           ]),

//           if (prefs.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Wrap(spacing: 8, runSpacing: 6, children: [
//               for (final p in prefs)
//                 Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.check_rounded,
//                       size: 13, color: AppColors.primary),
//                   const SizedBox(width: 4),
//                   Text(p.value,
//                       style: TextStyle(
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.primary)),
//                 ]),
//             ]),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _dayChip(String short, Map<String, dynamic> a) {
//     final enabled = a['enabled'] == true;
//     var times = 'Closed';
//     if (enabled) {
//       times = '${_s(a['startTime'])} – ${_s(a['endTime'])}';
//       if (_s(a['breakStartTime']).isNotEmpty) {
//         times += ' (break ${_s(a['breakStartTime'])} – ${_s(a['breakEndTime'])})';
//       }
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: BoxDecoration(
//         color: enabled ? Colors.white : const Color(0xFFF1F5FA),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: enabled
//               ? AppColors.primary.withOpacity(0.6)
//               : const Color(0xFFDDE5EF),
//         ),
//       ),
//       child: Text.rich(
//         TextSpan(children: [
//           TextSpan(
//             text: short,
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               fontSize: 11.5,
//               color: enabled ? Colors.black87 : Colors.grey,
//             ),
//           ),
//           TextSpan(
//             text: '  $times',
//             style: TextStyle(
//               fontSize: 11,
//               color: enabled ? Colors.grey.shade700 : Colors.grey,
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   // ───────── Consultation & fees ─────────
//   Widget _fees(Map<String, dynamic> d) {
//     final c = _m(d['consultation']);
//     final fees = _m(c['fees']);
//     final modes = <(String, IconData)>[
//       if (c['inClinic'] == true) ('In-clinic', Icons.apartment_outlined),
//       if (c['video'] == true) ('Video', Icons.videocam_outlined),
//       if (c['phone'] == true) ('Phone', Icons.phone_outlined),
//       if (c['homeVisit'] == true) ('Home visit', Icons.home_outlined),
//       if (c['hospital'] == true) ('Hospital', Icons.local_hospital_outlined),
//     ];

//     Widget tile(String label, String key, {bool requireMode = true}) {
//       final enabled = !requireMode || c[key] == true;
//       final fee = _m(fees[key])['fee'];
//       if (!enabled || _n(fee) <= 0) return const SizedBox.shrink();
//       return _InnerBox(
//         child: Row(children: [
//           Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
//           Text(_inr(fee),
//               style:
//                   const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
//         ]),
//       );
//     }

//     final waiting = c['averageWaitingDuration'];

//     return _SectionCard(
//       title: 'Consultation & fees',
//       icon: Icons.account_balance_wallet_outlined,
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('Available modes',
//             style: TextStyle(fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 8),
//         Wrap(spacing: 8, runSpacing: 8, children: [
//           for (final m in modes)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: AppColors.primary.withOpacity(0.6)),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 Icon(m.$2, size: 16, color: AppColors.primary),
//                 const SizedBox(width: 6),
//                 Text(m.$1,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary)),
//               ]),
//             ),
//         ]),
//         const Divider(height: 28),
//         tile('Video consultation', 'video'),
//         tile('Phone consultation', 'phone'),
//         tile('Home visit', 'homeVisit'),
//         tile('Hospital consultation', 'hospital'),
//         tile('Average consultation fee', 'averageConsultationFee',
//             requireMode: false),
//         if (waiting != null && _n(waiting) > 0)
//           Padding(
//             padding: const EdgeInsets.only(top: 2),
//             child: Row(children: [
//               const Icon(Icons.access_time_rounded,
//                   size: 14, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text.rich(TextSpan(
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 children: [
//                   const TextSpan(text: 'Average waiting time: '),
//                   TextSpan(
//                     text: '${_s(waiting)} min',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.primary),
//                   ),
//                 ],
//               )),
//             ]),
//           ),
//       ]),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════
// // Shared small widgets
// // ═══════════════════════════════════════════════════════════════════
// BoxDecoration _cardDeco([double r = 12]) => BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(r),
//       boxShadow: [
//         BoxShadow(
//             color: AppColors.primary.withOpacity(0.08),
//             blurRadius: 24,
//             offset: const Offset(0, 8)),
//       ],
//     );

    

// // class _ProfileAvatar extends StatelessWidget {
// //   const _ProfileAvatar({required this.url, this.radius = 36});
// //   final String url;
// //   final double radius;

// //   @override
// //   Widget build(BuildContext context) {
// //     print(url);
// //     final size = radius * 2;
// //     final fallback = Center(
// //       child: Icon(Icons.person_rounded,
// //           size: radius * 1.2, color: AppColors.primary),
// //     );

// //     return Container(
// //       width: size,
// //       height: size,
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         color: AppColors.badgeBg,
// //         border: Border.all(color: Colors.white, width: 3),
// //         boxShadow: [
// //           BoxShadow(
// //               color: Colors.black.withOpacity(0.12),
// //               blurRadius: 10,
// //               offset: const Offset(0, 3)),
// //         ],
// //       ),
// //       child: ClipOval(
// //         child: url.isEmpty
// //             ? fallback
// //             : Image.network(
// //                 url,
// //                 width: size,
// //                 height: size,
// //                 fit: BoxFit.cover,
// //                 loadingBuilder: (_, child, progress) => progress == null
// //                     ? child
// //                     : const Center(
// //                         child: SizedBox(
// //                           width: 18,
// //                           height: 18,
// //                           child: CircularProgressIndicator(strokeWidth: 2),
// //                         ),
// //                       ),
// //                 errorBuilder: (_, __, ___) => fallback,
// //               ),
// //       ),
// //     );
// //   }
// // }

// class _ProfileAvatar extends StatelessWidget {
//   const _ProfileAvatar({required this.url, this.radius = 36});
//   final String url;
//   final double radius;

//   @override
//   Widget build(BuildContext context) {
//     final size = radius * 2;
//     final clean = url.trim();
//     final fallback = Center(
//       child: Icon(Icons.person_rounded,
//           size: radius * 1.2, color: AppColors.primary),
//     );

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.badgeBg,
//         border: Border.all(color: Colors.white, width: 3),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.12),
//               blurRadius: 10,
//               offset: const Offset(0, 3)),
//         ],
//       ),
//       child: ClipOval(
//         child: clean.isEmpty
//             ? fallback
//             : Image.network(
//                 clean,
//                 width: size,
//                 height: size,
//                 fit: BoxFit.cover,
//                 // Browser jaisa request bhejo (kai CDN Dart ka default UA block karte hain)
//                 headers: const {
//                   'User-Agent':
//                       'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
//                       '(KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36',
//                   'Accept': 'image/png,image/jpeg,image/webp,image/*;q=0.8',
//                 },
//                 loadingBuilder: (_, child, progress) => progress == null
//                     ? child
//                     : const Center(
//                         child: SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       ),
//                 errorBuilder: (_, error, __) {
//                   // ▼ Asli wajah console mein aayegi
//                   debugPrint('PROFILE IMAGE ERROR: $error');
//                   return fallback;
//                 },
//               ),
//       ),
//     );
//   }
// }

// class _RatingBox extends StatelessWidget {
//   const _RatingBox({required this.rating});
//   final double rating;

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFF8E1),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: const Color(0xFFF5D06F)),
//         ),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF5A623)),
//           const SizedBox(width: 4),
//           Text(rating.toStringAsFixed(1),
//               style:
//                   const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
//           const SizedBox(width: 4),
//           Text('Google rating',
//               style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
//         ]),
//       );
// }

// class _MiniLabel extends StatelessWidget {
//   const _MiniLabel(this.icon, this.text);
//   final IconData icon;
//   final String text;

//   @override
//   Widget build(BuildContext context) => Row(children: [
//         Icon(icon, size: 14, color: AppColors.primary),
//         const SizedBox(width: 6),
//         Text(text,
//             style: const TextStyle(
//                 fontSize: 11.5,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 0.3)),
//       ]);
// }

// class _FeePill extends StatelessWidget {
//   const _FeePill(this.label, this.amount);
//   final String label, amount;

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Text.rich(TextSpan(children: [
//           TextSpan(
//               text: '$label  ',
//               style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
//           TextSpan(
//               text: amount,
//               style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.primary)),
//         ])),
//       );
// }

// class _SectionCard extends StatelessWidget {
//   const _SectionCard({this.title, this.icon, required this.child});
//   final String? title;
//   final IconData? icon;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: _cardDeco(16),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(height: 3, color: AppColors.primary),
//             Padding(
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (title != null) ...[
//                     Row(children: [
//                       Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(0.10),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Icon(icon, color: AppColors.primary, size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(title!,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w800)),
//                       ),
//                     ]),
//                     const SizedBox(height: 16),
//                   ],
//                   child,
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _InnerBox extends StatelessWidget {
//   const _InnerBox({required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context) => Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFEF6F6),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: AppColors.primary.withOpacity(0.08)),
//         ),
//         child: child,
//       );
// }

// class _Pill extends StatelessWidget {
//   const _Pill(this.text,
//       {this.filled = false,
//       this.soft = false,
//       this.check = false,
//       this.neutral = false});
//   final String text;
//   final bool filled, soft, check, neutral;

//   @override
//   Widget build(BuildContext context) {
//     Color bg = Colors.white;
//     Color fg = AppColors.primary;
//     Border? border = Border.all(color: AppColors.primary.withOpacity(0.5));

//     if (filled) {
//       bg = AppColors.primary;
//       fg = Colors.white;
//       border = null;
//     } else if (soft) {
//       bg = AppColors.badgeBg;
//       border = null;
//     } else if (neutral) {
//       fg = Colors.grey.shade700;
//       border = Border.all(color: Colors.grey.withOpacity(0.5));
//     } else if (check) {
//       fg = Colors.black87;
//       border = Border.all(color: Colors.grey.shade300);
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//         border: border,
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         if (check) ...[
//           Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
//           const SizedBox(width: 4),
//         ],
//         Text(text,
//             style: TextStyle(
//                 fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
//       ]),
//     );
//   }
// }

// class _LabeledValue extends StatelessWidget {
//   const _LabeledValue(this.label, this.value, this.icon);
//   final String label, value;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//           const SizedBox(height: 4),
//           Row(mainAxisSize: MainAxisSize.min, children: [
//             Icon(icon, size: 16, color: Colors.grey),
//             const SizedBox(width: 6),
//             Text(value,
//                 style:
//                     const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//           ]),
//         ],
//       );
// }

// class _Empty extends StatelessWidget {
//   const _Empty(this.text);
//   final String text;

//   @override
//   Widget build(BuildContext context) =>
//       Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey));
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sales_mobile_app/pages/marketingPage.dart';
import 'package:sales_mobile_app/provider/marketingProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

const _bg = Color(0xFFFEF6F6);

Map<String, dynamic> _m(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
List _l(dynamic v) => v is List ? v : const [];
String _s(dynamic v) => v == null ? '' : v.toString();

/// 1115 -> ₹1,115 | 123456 -> ₹1,23,456 (Indian grouping)
String _inr(dynamic v) {
  final n = v is num ? v.round() : (int.tryParse(_s(v)) ?? 0);
  final s = n.abs().toString();
  final sign = n < 0 ? '-' : '';
  if (s.length <= 3) return '₹$sign$s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '₹$sign${parts.join(',')},$last3';
}

num _n(dynamic v) => v is num ? v : (num.tryParse(_s(v)) ?? 0);

// ═══════════════════════════════════════════════════════════════════
// GATE: data null  -> form (MarketingProfilePage)
//       data aaya  -> read-only profile view
// ═══════════════════════════════════════════════════════════════════
class MarketingProfileGate extends StatefulWidget {
  const MarketingProfileGate({super.key, required this.id});
  final String id;

  @override
  State<MarketingProfileGate> createState() => _MarketingProfileGateState();
}

class _MarketingProfileGateState extends State<MarketingProfileGate> {
  late Future<dynamic> _future;
  bool _editing = false;
  dynamic _profileData;

  @override
  void initState() {
    super.initState();
    _future = context
        .read<Marketingprovider>()
        .getdoctoralldetails(context, widget.id);
  }


  

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return MarketingProfilePage(
        id: widget.id,
        initialData: _profileData,
        isEdit: true,
      );
    }

    // return FutureBuilder<dynamic>(
    //   future: _future,
    //   builder: (context, snap) {
    //     if (snap.connectionState != ConnectionState.done) {
    //       return const Scaffold(
    //         backgroundColor: _bg,
    //         body: Center(child: CircularProgressIndicator()),
    //       );
    //     }
    //     final res = _m(snap.data);
    //     final data = res['data'];

    //     if (snap.hasError || data == null) {
    //       return MarketingProfilePage(
    //         id: widget.id,
    //         initialData: _profileData,
    //         isEdit: false,
    //       );
    //     }

    //     _profileData = _m(data);

    //     return MarketingProfileView(
    //       id: widget.id,
    //       data: _profileData,
    //       onEdit: () => setState(() => _editing = true),
    //     );
    //   },
    // );

    return FutureBuilder<dynamic>(
  future: _future,
  builder: (context, snap) {
    if (snap.connectionState != ConnectionState.done) {
      return const Scaffold(
        backgroundColor: _bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final res = _m(snap.data);
    final data = res['data'];

    // basicInformation ka fullName khaali ho to profile "bana hua" nahi mana jayega
    final hasProfile = data != null &&
        _s(_m(_m(data)['basicInformation'])['fullName']).trim().isNotEmpty;

    if (snap.hasError || !hasProfile) {
      // data null ho YA name empty ho -> form dikhao
      return MarketingProfilePage(
        id: widget.id,
        initialData: _profileData,
        isEdit: false,
      );
    }

    _profileData = _m(data);

    return MarketingProfileView(
      id: widget.id,
      data: _profileData,
      onEdit: () => setState(() => _editing = true),
    );
  },
);
  }
}

// ═══════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════
const Map<String, String> _kFacilityLabels = {
  'parkingAvailable': 'Parking',
  'accessibleParking': 'Accessible parking',
  'wheelchairAccessible': 'Wheelchair accessible',
  'liftAvailable': 'Lift',
  'pharmacy': 'Pharmacy',
  'laboratory': 'Laboratory',
  'diagnosticCentre': 'Diagnostic centre',
  'acWaitingArea': 'AC waiting area',
  'waitingArea': 'Waiting area',
  'washroomAvailable': 'Washroom',
  'drinkingWater': 'Drinking water',
  'insuranceAccepted': 'Insurance accepted',
  'cashlessFacility': 'Cashless facility',
  'emergencyFacility': 'Emergency facility',
  'cleanliness': 'Cleanliness assured',
  'hygieneStandards': 'Hygiene standards',
  'childFriendly': 'Child friendly',
  'elderlyFriendly': 'Elderly friendly',
  'securityAvailable': 'Security',
  'receptionDesk': 'Reception desk',
};

const _kDays = [
  ('monday', 'Mon'),
  ('tuesday', 'Tue'),
  ('wednesday', 'Wed'),
  ('thursday', 'Thu'),
  ('friday', 'Fri'),
  ('saturday', 'Sat'),
  ('sunday', 'Sun'),
];

const _kBookingPrefs = {
  'appointmentRequired': 'Appointment required',
  'walkInsAccepted': 'Walk-ins accepted',
  'sameDayAppointment': 'Same-day appointments',
  'emergencyAvailability': 'Emergency availability',
};

const List<(String, IconData)> _kTabs = [
  ('Overview', Icons.person_outline_rounded),
  ('Qualifications', Icons.school_outlined),
  ('Specialisation', Icons.medical_services_outlined),
  ('Clinics', Icons.apartment_outlined),
  ('Fees', Icons.account_balance_wallet_outlined),
];

// ═══════════════════════════════════════════════════════════════════
// STICKY TABS HEADER
// ═══════════════════════════════════════════════════════════════════
class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabsHeaderDelegate({required this.active, required this.onTap});

  final int active;
  final ValueChanged<int> onTap;

  static const double extent = 64;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // Solid background, taaki neeche scroll hota content tabs ke peeche na dikhe
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: _cardDeco(12),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: _kTabs.length,
          separatorBuilder: (_, __) => const SizedBox(width: 4),
          itemBuilder: (_, i) {
            final on = i == active;
            return Center(
              child: TextButton.icon(
                onPressed: () => onTap(i),
                icon: Icon(_kTabs[i].$2, size: 16),
                label: Text(_kTabs[i].$1),
                style: TextButton.styleFrom(
                  foregroundColor: on ? AppColors.primary : Colors.black87,
                  backgroundColor:
                      on ? AppColors.primary.withOpacity(0.10) : null,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: on ? FontWeight.w800 : FontWeight.w500),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabsHeaderDelegate old) =>
      old.active != active;
}

// ═══════════════════════════════════════════════════════════════════
// READ-ONLY VIEW
// ═══════════════════════════════════════════════════════════════════
class MarketingProfileView extends StatefulWidget {
  const MarketingProfileView({
    super.key,
    required this.id,
    required this.data,
    this.onEdit,
  });
  final String id;
  final Map<String, dynamic> data;
  final VoidCallback? onEdit;

  @override
  State<MarketingProfileView> createState() => _MarketingProfileViewState();
}

class _MarketingProfileViewState extends State<MarketingProfileView> {
  final _keys = List.generate(_kTabs.length, (_) => GlobalKey());
  final GlobalKey _viewportKey = GlobalKey();
  final ScrollController _scroll = ScrollController();

  int _active = 0;
  bool _jumping = false;

  late bool _isActive;
  bool _toggling = false;

  @override
  void initState() {
    super.initState();
    _isActive = widget.data['isActive'] == true;
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MarketingProfileView old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _isActive = widget.data['isActive'] == true;
    }
  }

  // ───────── sticky tabs: jump + scroll-spy ─────────

  /// Section ka top (scroll area ke top se, pixels mein)
  double? _sectionTop(int i) {
    final ctx = _keys[i].currentContext;
    final viewport = _viewportKey.currentContext?.findRenderObject();
    final box = ctx?.findRenderObject();
    if (box is! RenderBox || viewport is! RenderBox) return null;
    return box.localToGlobal(Offset.zero, ancestor: viewport).dy;
  }

  void _onScroll() {
    if (_jumping || !_scroll.hasClients) return;

    var idx = 0;
    for (var i = 0; i < _keys.length; i++) {
      final top = _sectionTop(i);
      if (top != null && top <= _TabsHeaderDelegate.extent + 24) idx = i;
    }
    // Sabse neeche pahunch gaye to aakhri tab highlight
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 4) {
      idx = _keys.length - 1;
    }
    if (idx != _active) setState(() => _active = idx);
  }

  Future<void> _jump(int i) async {
    final top = _sectionTop(i);
    if (top == null || !_scroll.hasClients) return;

    // Sticky bar ke neeche se section shuru ho, usके peeche chhup na jaye
    final target = (_scroll.offset + top - _TabsHeaderDelegate.extent - 8)
        .clamp(0.0, _scroll.position.maxScrollExtent)
        .toDouble();

    setState(() {
      _active = i;
      _jumping = true;
    });
    try {
      await _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } finally {
      if (mounted) setState(() => _jumping = false);
    }
  }

  // ───────── phone / map ─────────

  String _cleanPhone(String raw) {
    final t = raw.trim();
    final plus = t.startsWith('+') ? '+' : '';
    return plus + t.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> _callNumber(String raw) async {
    var ok = false;
    try {
      ok = await launchUrl(Uri(scheme: 'tel', path: _cleanPhone(raw)));
    } catch (_) {}
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the phone dialer')),
      );
    }
  }

  Future<void> _copyNumber(String raw) async {
    await Clipboard.setData(ClipboardData(text: raw.trim()));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Phone number copied'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _showPhoneOptions(String phone) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                phone,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: Icon(Icons.call, color: AppColors.primary),
                title: const Text('Call'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _callNumber(phone);
                },
              ),
              ListTile(
                leading: Icon(Icons.copy_rounded, color: AppColors.primary),
                title: const Text('Copy number'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _copyNumber(phone);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _clinicActionStyle() => OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );

  Future<void> _openMap(String link) async {
    var ok = false;
    final uri = Uri.tryParse(link);
    if (uri != null) {
      try {
        ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  // ───────── Pull to refresh ─────────
Future<void> _onRefresh() async {
  final provider = context.read<Marketingprovider>();
  try {
    final res = await provider.getdoctoralldetails(context, widget.id);
    final fresh = res is Map ? res['data'] : null;
    if (!mounted) return;

    if (fresh is Map) {
      setState(() {
        // Wahi map update kar rahe hain (naya nahi bana rahe), taaki Gate ke paas
        // bhi latest data rahe aur "Edit profile" dabane par purana data na khule.
        widget.data
          ..clear()
          ..addAll(Map<String, dynamic>.from(fresh));
        _isActive = widget.data['isActive'] == true;
      });
    } else {
      _showRefreshError();
    }
  } catch (_) {
    if (mounted) _showRefreshError();
  }
}

void _showRefreshError() {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Couldn't refresh. Pull down to try again.")),
  );
}

  // ───────── Live switch ─────────
  Future<void> _toggleLive(bool _) async {
    if (_toggling) return;

    final marketingprovider = context.read<Marketingprovider>();
    final current = _isActive;

    setState(() {
      _toggling = true;
      _isActive = !current;
    });

    try {
      await marketingprovider.toggleStatus(widget.id, current, context);

      // Server se asli status le lo, taaki fail hone par UI galat na rahe
      final res =
          await marketingprovider.getdoctoralldetails(context, widget.id);
      final data = res is Map ? res['data'] : null;
      if (mounted && data is Map) {
        setState(() => _isActive = data['isActive'] == true);
        widget.data['isActive'] = _isActive;
      }
    } catch (_) {
      if (mounted) setState(() => _isActive = current);
    } finally {
      if (mounted) setState(() => _toggling = false);
    }
  }

  // ═══════════════════════════ build ═══════════════════════════
  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Marketing Profile',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(),
          child: CustomScrollView(
            key: _viewportKey,
            controller: _scroll,
            slivers: [
              // Live switch + Edit (ye normal scroll hota hai)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: _cardDeco(10),
                        child: Row(children: [
                          Text(_isActive ? 'Live' : 'Not live',
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 6),
                          if (_toggling)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          else
                            Switch(
                              value: _isActive,
                              onChanged: _toggleLive,
                              activeTrackColor: AppColors.primary,
                              activeColor: AppColors.primary,
                            ),
                        ]),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit profile'),
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
          
              // ✅ STICKY tabs: scroll karne par upar chipak jaate hain
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabsHeaderDelegate(active: _active, onTap: _jump),
              ),
          
              // Saare sections (ek hi Column mein, taaki sabke keys hamesha built rahein)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyedSubtree(key: _keys[0], child: _overview(d)),
                      const SizedBox(height: 16),
                      KeyedSubtree(key: _keys[1], child: _qualifications(d)),
                      const SizedBox(height: 16),
                      KeyedSubtree(key: _keys[2], child: _specialisation(d)),
                      const SizedBox(height: 16),
                      KeyedSubtree(key: _keys[3], child: _clinics(d)),
                      const SizedBox(height: 16),
                      KeyedSubtree(key: _keys[4], child: _fees(d)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── Overview ─────────
  Widget _overview(Map<String, dynamic> d) {
    final b = _m(d['basicInformation']);
    final q = _m(d['qualifications']);
    final sp = _m(d['specialisation']);
    final name = _s(b['fullName']);
    final years = _s(b['yearsOfExperience']);
    final expertise = _s(sp['areasOfExpertise']);
    final langs = _l(b['languagesSpoken']);
    final photo = _s(d['profilePhoto']);
    final regNo = _s(b['medicalRegistrationNumber']);
    final regYear = _s(b['registrationYear']);
    final registration =
        [regNo, regYear].where((e) => e.isNotEmpty).join(' · ');

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileAvatar(url: photo, radius: 38),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      if (_s(sp['primarySpecialisation']).isNotEmpty)
                        _Pill(_s(sp['primarySpecialisation']), filled: true),
                      if (_s(q['highestQualification']).isNotEmpty)
                        _Pill(_s(q['highestQualification'])),
                      if (years.isNotEmpty)
                        _Pill('$years yrs experience', neutral: true),
                    ]),
                    if (expertise.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(expertise,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 32, runSpacing: 12, children: [
            if (_s(b['mobileNumber']).isNotEmpty)
              _LabeledValue('Mobile', '+91 ${_s(b['mobileNumber'])}',
                  Icons.phone_outlined),
            if (_s(b['email']).isNotEmpty)
              _LabeledValue(
                  'Email', _s(b['email']), Icons.mail_outline_rounded),
            if (registration.isNotEmpty)
              _LabeledValue('Registration', registration, Icons.badge_outlined),
          ]),
          if (langs.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Row(children: [
              Icon(Icons.translate_rounded, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text('Speaks',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            const SizedBox(height: 6),
            Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final l in langs) _Pill(_s(l), soft: true)]),
          ],
        ],
      ),
    );
  }

  // ───────── Qualifications (+ fellowships) ─────────
  Widget _qualifications(Map<String, dynamic> d) {
    final q = _m(d['qualifications']);
    final list = _l(q['qualificationDetails']);
    final fellowships = _l(q['fellowshipsCertifications']);

    return _SectionCard(
      title: 'Qualifications',
      icon: Icons.school_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (list.isEmpty)
            const _Empty('No qualifications added')
          else
            for (final e in list)
              _InnerBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(_s(_m(e)['degree']),
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary)),
                      if (_s(_m(e)['year']).isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _Pill(_s(_m(e)['year']), soft: true),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(_s(_m(e)['specialization']),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(_s(_m(e)['institution']),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
          if (fellowships.isNotEmpty) ...[
            const Divider(height: 28),
            const _MiniLabel(
                Icons.workspace_premium_outlined, 'Fellowships & certifications'),
            const SizedBox(height: 10),
            for (final f in fellowships)
              _InnerBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_rounded,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_s(_m(f)['name']),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(
                            [_s(_m(f)['organization']), _s(_m(f)['year'])]
                                .where((e) => e.isNotEmpty)
                                .join(' · '),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ───────── Specialisation (primary + sub-specialisations) ─────────
  Widget _specialisation(Map<String, dynamic> d) {
    final sp = _m(d['specialisation']);
    final primary = _s(sp['primarySpecialisation']).trim();
    final sub = _l(sp['subSpecialisation'])
        .map(_s)
        .where((e) => e.trim().isNotEmpty)
        .toList();
    final cond = _l(sp['conditionsTreated']);
    final keys = _l(sp['keywords']);
    final nothing =
        primary.isEmpty && sub.isEmpty && cond.isEmpty && keys.isEmpty;

    Widget group(String label, List items, {bool filled = false}) =>
        items.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        for (final i in items)
                          _Pill(_s(i), filled: filled, soft: !filled)
                      ]),
                    ]),
              );

    return _SectionCard(
      title: 'Specialisation',
      icon: Icons.medical_services_outlined,
      child: nothing
          ? const _Empty('No specialisation details added')
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // group('Primary specialisation',
              //     primary.isEmpty ? const [] : [primary],
              //     filled: true),
              group('Sub-specialisations', sub),
              group('Conditions treated', cond),
              group('Search keywords', keys),
            ]),
    );
  }

  // ───────── Clinics ─────────
  Widget _clinics(Map<String, dynamic> d) {
    final list = _l(d['clinics']);
    return _SectionCard(
      title: 'Clinics & hospitals (${list.length})',
      icon: Icons.apartment_outlined,
      child: list.isEmpty
          ? const _Empty('No clinics added')
          : Column(children: [for (final c in list) _clinicTile(_m(c))]),
    );
  }

  Widget _clinicTile(Map<String, dynamic> c) {
    final fac = _m(c['facilities']);
    final on = _kFacilityLabels.entries.where((e) => fac[e.key] == true);
    final fees = _m(c['fees']);
    final av = _m(c['availability']);

    final phone = _s(c['contactNumber']);
    final mapLink = _s(c['googleLocationLink']).trim();
    // averageGoogleReview number ho ya string, dono chalega; 0/missing => box nahi dikhega
    final rating = _n(c['averageGoogleReview']).toDouble();
    final hasRating = rating > 0;
    final branch = _s(c['branchName']);
    final address = _s(c['fullAddress']);
    final loc = [_s(c['area']), _s(c['city']), _s(c['state']), _s(c['pinCode'])]
        .where((e) => e.isNotEmpty)
        .join(', ');

    final feePills = <Widget>[
      for (final f in const [
        ('First consultation', 'firstConsultation'),
        ('Follow-up', 'followUp'),
        ('Emergency', 'emergency'),
      ])
        if (_n(_m(fees[f.$2])['fee']) > 0)
          _FeePill(f.$1, _inr(_m(fees[f.$2])['fee'])),
    ];

    final prefs = _kBookingPrefs.entries.where((e) => av[e.key] == true);

    return _InnerBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_s(c['clinicName']),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15)),
                    if (branch.isNotEmpty)
                      Text(branch,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (phone.isNotEmpty || mapLink.isNotEmpty)
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (phone.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => _showPhoneOptions(phone),
                          icon: const Icon(Icons.call, size: 14),
                          label: Text(phone),
                          style: _clinicActionStyle(),
                        ),
                      if (phone.isNotEmpty && mapLink.isNotEmpty)
                        const SizedBox(height: 8),
                      if (mapLink.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => _openMap(mapLink),
                          icon: const Icon(Icons.near_me_outlined, size: 14),
                          label: const Text('View on map'),
                          style: _clinicActionStyle(),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          // ⭐ Google rating (sirf jab averageGoogleReview ho)
          if (hasRating) ...[
            const SizedBox(height: 8),
            _RatingBox(rating: rating),
          ],

          if (loc.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(loc, style: const TextStyle(fontSize: 13))),
            ]),
          ],
          if (address.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(address,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            ),
          ],

          if (on.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final e in on) _Pill(e.value, check: true),
            ]),
          ],

          if (feePills.isNotEmpty) ...[
            const Divider(height: 24),
            const _MiniLabel(Icons.payments_outlined, 'FEES AT THIS CLINIC'),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: feePills),
          ],

          const Divider(height: 24),
          const _MiniLabel(Icons.schedule_rounded, 'WEEKLY TIMINGS'),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final day in _kDays) _dayChip(day.$2, _m(av[day.$1])),
          ]),

          if (prefs.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 6, children: [
              for (final p in prefs)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_rounded,
                      size: 13, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(p.value,
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ]),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _dayChip(String short, Map<String, dynamic> a) {
    final enabled = a['enabled'] == true;
    var times = 'Closed';
    if (enabled) {
      times = '${_s(a['startTime'])} – ${_s(a['endTime'])}';
      if (_s(a['breakStartTime']).isNotEmpty) {
        times +=
            ' (break ${_s(a['breakStartTime'])} – ${_s(a['breakEndTime'])})';
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF1F5FA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: enabled
              ? AppColors.primary.withOpacity(0.6)
              : const Color(0xFFDDE5EF),
        ),
      ),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: short,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
              color: enabled ? Colors.black87 : Colors.grey,
            ),
          ),
          TextSpan(
            text: '  $times',
            style: TextStyle(
              fontSize: 11,
              color: enabled ? Colors.grey.shade700 : Colors.grey,
            ),
          ),
        ]),
      ),
    );
  }

  // ───────── Consultation & fees ─────────
  Widget _fees(Map<String, dynamic> d) {
    final c = _m(d['consultation']);
    final fees = _m(c['fees']);
    final modes = <(String, IconData)>[
      if (c['inClinic'] == true) ('In-clinic', Icons.apartment_outlined),
      if (c['video'] == true) ('Video', Icons.videocam_outlined),
      if (c['phone'] == true) ('Phone', Icons.phone_outlined),
      if (c['homeVisit'] == true) ('Home visit', Icons.home_outlined),
      if (c['hospital'] == true) ('Hospital', Icons.local_hospital_outlined),
    ];

    Widget tile(String label, String key, {bool requireMode = true}) {
      final enabled = !requireMode || c[key] == true;
      final fee = _m(fees[key])['fee'];
      if (!enabled || _n(fee) <= 0) return const SizedBox.shrink();
      return _InnerBox(
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(_inr(fee),
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ]),
      );
    }

    final waiting = c['averageWaitingDuration'];

    return _SectionCard(
      title: 'Consultation & fees',
      icon: Icons.account_balance_wallet_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Available modes',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final m in modes)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withOpacity(0.6)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(m.$2, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(m.$1,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ]),
            ),
        ]),
        const Divider(height: 28),
        tile('Video consultation', 'video'),
        tile('Phone consultation', 'phone'),
        tile('Home visit', 'homeVisit'),
        tile('Hospital consultation', 'hospital'),
        tile('Average consultation fee', 'averageConsultationFee',
            requireMode: false),
        if (waiting != null && _n(waiting) > 0)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text.rich(TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  const TextSpan(text: 'Average waiting time: '),
                  TextSpan(
                    text: '${_s(waiting)} min',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary),
                  ),
                ],
              )),
            ]),
          ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Shared small widgets
// ═══════════════════════════════════════════════════════════════════
BoxDecoration _cardDeco([double r = 12]) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
      boxShadow: [
        BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8)),
      ],
    );

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.url, this.radius = 36});
  final String url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final clean = url.trim();
    final fallback = Center(
      child: Icon(Icons.person_rounded,
          size: radius * 1.2, color: AppColors.primary),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.badgeBg,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ClipOval(
        child: clean.isEmpty
            ? fallback
            : Image.network(
                clean,
                width: size,
                height: size,
                fit: BoxFit.cover,
                headers: const {
                  'User-Agent':
                      'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
                          '(KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36',
                  'Accept': 'image/png,image/jpeg,image/webp,image/*;q=0.8',
                },
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                errorBuilder: (_, error, __) {
                  debugPrint('PROFILE IMAGE ERROR: $error');
                  return fallback;
                },
              ),
      ),
    );
  }
}

/// Chhota yellow Google rating box
class _RatingBox extends StatelessWidget {
  const _RatingBox({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFF5D06F)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF5A623)),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1),
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(width: 4),
          Text('Google rating',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
        ]),
      );
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3)),
      ]);
}

class _FeePill extends StatelessWidget {
  const _FeePill(this.label, this.amount);
  final String label, amount;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: '$label  ',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700)),
          TextSpan(
              text: amount,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary)),
        ])),
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({this.title, this.icon, required this.child});
  final String? title;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 3, color: AppColors.primary),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Row(children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(title!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                  ],
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InnerBox extends StatelessWidget {
  const _InnerBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF6F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withOpacity(0.08)),
        ),
        child: child,
      );
}

class _Pill extends StatelessWidget {
  const _Pill(this.text,
      {this.filled = false,
      this.soft = false,
      this.check = false,
      this.neutral = false});
  final String text;
  final bool filled, soft, check, neutral;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color fg = AppColors.primary;
    Border? border = Border.all(color: AppColors.primary.withOpacity(0.5));

    if (filled) {
      bg = AppColors.primary;
      fg = Colors.white;
      border = null;
    } else if (soft) {
      bg = AppColors.badgeBg;
      border = null;
    } else if (neutral) {
      fg = Colors.grey.shade700;
      border = Border.all(color: Colors.grey.withOpacity(0.5));
    } else if (check) {
      fg = Colors.black87;
      border = Border.all(color: Colors.grey.shade300);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (check) ...[
          Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
        ],
        Text(text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
      ]),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue(this.label, this.value, this.icon);
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ],
      );
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey));
}