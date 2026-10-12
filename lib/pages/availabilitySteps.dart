// // // import 'package:flutter/material.dart';
// // // import 'package:sales_mobile_app/pages/formFeilds.dart';
// // // import 'package:sales_mobile_app/theme/app_colors.dart';

// // // class _DaySlot {
// // //   _DaySlot(this.day, this.enabled)
// // //       : opensAt = const TimeOfDay(hour: 10, minute: 0),
// // //         closesAt = const TimeOfDay(hour: 19, minute: 0),
// // //         breakFrom = null,
// // //         breakUntil = null;

// // //   final String day;
// // //   bool enabled;
// // //   TimeOfDay opensAt;
// // //   TimeOfDay closesAt;
// // //   TimeOfDay? breakFrom;
// // //   TimeOfDay? breakUntil;
// // // }

// // // class AvailabilityStep extends StatefulWidget {
// // //   const AvailabilityStep({super.key, this.initialData});
// // //   final List? initialData;   // was Map<String, dynamic>? — clinics is a List

// // //   @override
// // //   State<AvailabilityStep> createState() => AvailabilityStepState();
// // // }

// // // class AvailabilityStepState extends State<AvailabilityStep> {

// // //   @override
// // // void initState() {
// // //   super.initState();
// // //   final clinics = widget.initialData;
// // //   if (clinics == null || clinics.isEmpty) return;

// // //   final availability = Map<String, dynamic>.from(
// // //       Map<String, dynamic>.from(clinics.first)['availability'] ?? {});
// // //   const keys = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday'];

// // //   for (var i = 0; i < _days.length; i++) {
// // //     final day = Map<String, dynamic>.from(availability[keys[i]] ?? {});
// // //     if (day.isEmpty) continue;
// // //     _days[i].enabled = day['enabled'] == true;
// // //     _days[i].opensAt = _parseTime(day['startTime']) ?? _days[i].opensAt;
// // //     _days[i].closesAt = _parseTime(day['endTime']) ?? _days[i].closesAt;
// // //     _days[i].breakFrom = _parseTime(day['breakStartTime']);
// // //     _days[i].breakUntil = _parseTime(day['breakEndTime']);
// // //   }

// // //   _appointmentRequired = availability['appointmentRequired'] ?? _appointmentRequired;
// // //   _walkInsAccepted = availability['walkInsAccepted'] ?? _walkInsAccepted;
// // //   _sameDayAppointments = availability['sameDayAppointment'] ?? _sameDayAppointments;
// // //   _emergencyAvailability = availability['emergencyAvailability'] ?? _emergencyAvailability;
// // // }

// // // TimeOfDay? _parseTime(dynamic v) {
// // //   if (v == null) return null;
// // //   final p = v.toString().split(':');
// // //   if (p.length != 2) return null;
// // //   final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
// // //   return (h == null || m == null) ? null : TimeOfDay(hour: h, minute: m);
// // // }

// // //   final List<_DaySlot> _days = [
// // //     _DaySlot('Monday', true),
// // //     _DaySlot('Tuesday', true),
// // //     _DaySlot('Wednesday', true),
// // //     _DaySlot('Thursday', true),
// // //     _DaySlot('Friday', true),
// // //     _DaySlot('Saturday', true),
// // //     _DaySlot('Sunday', false),
// // //   ];

// // //   bool _appointmentRequired = true;
// // //   bool _walkInsAccepted = true;
// // //   bool _sameDayAppointments = false;
// // //   bool _emergencyAvailability = false;

// // //   _DaySlot get _monday => _days.first;
// // //   _DaySlot get _sunday => _days.last;
// // //   List<_DaySlot> get _tuesdayToSaturday => _days.sublist(1, 6);

// // //   void _copyMondayToRest() {
// // //     setState(() {
// // //       for (final slot in _tuesdayToSaturday) {
// // //         slot.enabled = _monday.enabled;
// // //         slot.opensAt = _monday.opensAt;
// // //         slot.closesAt = _monday.closesAt;
// // //         slot.breakFrom = _monday.breakFrom;
// // //         slot.breakUntil = _monday.breakUntil;
// // //       }
// // //     });
// // //   }

// // //   Future<void> _pickTime(_DaySlot slot, {
// // //     required TimeOfDay? current,
// // //     required void Function(TimeOfDay) onPicked,
// // //   }) async {
// // //     final t = await showTimePicker(
// // //       context: context,
// // //       initialTime: current ?? const TimeOfDay(hour: 9, minute: 0),
// // //     );
// // //     if (t == null) return;
// // //     setState(() => onPicked(t));
// // //   }

// // //   String _fmt(TimeOfDay? t) {
// // //     if (t == null) return '--:--';
// // //     final h = t.hour.toString().padLeft(2, '0');
// // //     final m = t.minute.toString().padLeft(2, '0');
// // //     return '$h:$m';
// // //   }

// // //    /// "HH:mm" string for the API, or '' when there's no time (e.g. day is
// // //   /// disabled, or no break was set) — matches the JSON sample where a
// // //   /// disabled day / missing break sends an empty string, not null.
// // //   String _apiTime(TimeOfDay? t) {
// // //     if (t == null) return '';
// // //     final h = t.hour.toString().padLeft(2, '0');
// // //     final m = t.minute.toString().padLeft(2, '0');
// // //     return '$h:$m';
// // //   }

// // //     // ═══════════════════════════════════════════════════════════════
// // //   // NEW: is step ka latest data. Ye availability har clinic ke andar
// // //   // jaati hai (API shape ke mutaabik), isliye parent isko ClinicsStep
// // //   // se aayi har clinic mein merge karega.
// // //   // ═══════════════════════════════════════════════════════════════
// // //   Map<String, dynamic> getData() {
// // //     const keys = [
// // //       'monday', 'tuesday', 'wednesday', 'thursday',
// // //       'friday', 'saturday', 'sunday',
// // //     ];
 
// // //     final daysMap = <String, dynamic>{};
// // //     for (var i = 0; i < _days.length; i++) {
// // //       final slot = _days[i];
// // //       daysMap[keys[i]] = {
// // //         'enabled': slot.enabled,
// // //         'startTime': slot.enabled ? _apiTime(slot.opensAt) : '',
// // //         'endTime': slot.enabled ? _apiTime(slot.closesAt) : '',
// // //         'breakStartTime': slot.enabled ? _apiTime(slot.breakFrom) : '',
// // //         'breakEndTime': slot.enabled ? _apiTime(slot.breakUntil) : '',
// // //       };
// // //     }
 
// // //     return {
// // //       ...daysMap,
// // //       'appointmentRequired': _appointmentRequired,
// // //       'walkInsAccepted': _walkInsAccepted,
// // //       'sameDayAppointment': _sameDayAppointments,
// // //       'emergencyAvailability': _emergencyAvailability,
// // //     };
// // //   }

// // //   Widget _timeField({
// // //     required String label,
// // //     required TimeOfDay? value,
// // //     required bool enabled,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return Expanded(
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             label,
// // //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
// // //           ),
// // //           const SizedBox(height: 6),
// // //           InkWell(
// // //             onTap: enabled ? onTap : null,
// // //             borderRadius: BorderRadius.circular(8),
// // //             child: Container(
// // //               height: 40,
// // //               padding: const EdgeInsets.symmetric(horizontal: 10),
// // //               decoration: BoxDecoration(
// // //                 border: Border.all(color: Colors.grey.shade300),
// // //                 borderRadius: BorderRadius.circular(8),
// // //                 color: enabled ? Colors.white : Colors.grey.shade100,
// // //               ),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Text(
// // //                     _fmt(value),
// // //                     style: TextStyle(
// // //                       fontSize: 14,
// // //                       color: value == null ? Colors.grey.shade400 : Colors.black87,
// // //                     ),
// // //                   ),
// // //                   Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _dayCard(_DaySlot slot) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 14),
// // //       padding: const EdgeInsets.all(14),
// // //       decoration: BoxDecoration(
// // //         border: Border.all(color: AppColors.primary.withOpacity(0.35)),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Switch(
// // //                 value: slot.enabled,
// // //                 activeColor: AppColors.primary,
// // //                 onChanged: (v) => setState(() => slot.enabled = v),
// // //               ),
// // //               const SizedBox(width: 4),
// // //               Text(
// // //                 slot.day,
// // //                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 10),
// // //           Row(
// // //             children: [
// // //               _timeField(
// // //                 label: 'Opens at',
// // //                 value: slot.opensAt,
// // //                 enabled: slot.enabled,
// // //                 onTap: () => _pickTime(slot,
// // //                     current: slot.opensAt, onPicked: (t) => slot.opensAt = t),
// // //               ),
// // //               const SizedBox(width: 10),
// // //               _timeField(
// // //                 label: 'Closes at',
// // //                 value: slot.closesAt,
// // //                 enabled: slot.enabled,
// // //                 onTap: () => _pickTime(slot,
// // //                     current: slot.closesAt, onPicked: (t) => slot.closesAt = t),
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 6),
// // //           Row(
// // //             children: [
// // //               _timeField(
// // //                 label: 'Break from',
// // //                 value: slot.breakFrom,
// // //                 enabled: slot.enabled,
// // //                 onTap: () => _pickTime(slot,
// // //                     current: slot.breakFrom, onPicked: (t) => slot.breakFrom = t),
// // //               ),
// // //               const SizedBox(width: 10),
// // //               _timeField(
// // //                 label: 'Break until',
// // //                 value: slot.breakUntil,
// // //                 enabled: slot.enabled,
// // //                 onTap: () => _pickTime(slot,
// // //                     current: slot.breakUntil, onPicked: (t) => slot.breakUntil = t),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _sundayRow() {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 20),
// // //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// // //       decoration: BoxDecoration(
// // //         color: _sunday.enabled ? Colors.white : Colors.grey.shade100,
// // //         border: _sunday.enabled
// // //             ? Border.all(color: AppColors.primary.withOpacity(0.35))
// // //             : null,
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Switch(
// // //                 value: _sunday.enabled,
// // //                 activeColor: AppColors.primary,
// // //                 onChanged: (v) => setState(() => _sunday.enabled = v),
// // //               ),
// // //               const SizedBox(width: 4),
// // //               Text(_sunday.day,
// // //                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
// // //               const SizedBox(width: 10),
// // //               if (!_sunday.enabled) ...[
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.primary.withOpacity(0.1),
// // //                     borderRadius: BorderRadius.circular(6),
// // //                   ),
// // //                   child: Text(
// // //                     'OPTIONAL',
// // //                     style: TextStyle(
// // //                       fontSize: 10,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: AppColors.primary,
// // //                     ),
// // //                   ),
// // //                 ),
                
// // //               ],
// // //             ],
// // //           ),
          
// // //                 Text('Closed on Sunday',
// // //                     style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
// // //                     const SizedBox(height: 10),
// // //           if (_sunday.enabled) ...[
// // //             const SizedBox(height: 10),
// // //             Row(
// // //               children: [
// // //                 _timeField(
// // //                   label: 'Opens at',
// // //                   value: _sunday.opensAt,
// // //                   enabled: _sunday.enabled,
// // //                   onTap: () => _pickTime(_sunday,
// // //                       current: _sunday.opensAt, onPicked: (t) => _sunday.opensAt = t),
// // //                 ),
// // //                 const SizedBox(width: 10),
// // //                 _timeField(
// // //                   label: 'Closes at',
// // //                   value: _sunday.closesAt,
// // //                   enabled: _sunday.enabled,
// // //                   onTap: () => _pickTime(_sunday,
// // //                       current: _sunday.closesAt, onPicked: (t) => _sunday.closesAt = t),
// // //                 ),
// // //               ],
// // //             ),
// // //             SizedBox(height: 10,),
// // //             Row(
// // //             children: [
// // //               _timeField(
// // //                 label: 'Break from',
// // //                 value: _sunday.breakFrom,
// // //                 enabled: _sunday.enabled,
// // //                 onTap: () => _pickTime(_sunday,
// // //                     current: _sunday.breakFrom, onPicked: (t) => _sunday.breakFrom = t),
// // //               ),
// // //               const SizedBox(width: 10),
// // //               _timeField(
// // //                 label: 'Break until',
// // //                 value: _sunday.breakUntil,
// // //                 enabled: _sunday.enabled,
// // //                 onTap: () => _pickTime(_sunday,
// // //                     current: _sunday.breakUntil, onPicked: (t) => _sunday.breakUntil = t),
// // //               ),
// // //             ],
// // //           )
            
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _preferenceCard({
// // //     required String title,
// // //     required String subtitle,
// // //     required bool value,
// // //     required ValueChanged<bool> onChanged,
// // //   }) {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
// // //       padding: const EdgeInsets.all(14),
// // //       decoration: BoxDecoration(
// // //         color: value ? AppColors.primary.withOpacity(0.06) : Colors.white,
// // //         border: Border.all(
// // //           color: value ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade300,
// // //         ),
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(title,
// // //                     style: const TextStyle(
// // //                         fontSize: 14, fontWeight: FontWeight.w600)),
// // //                 const SizedBox(height: 4),
// // //                 Text(subtitle,
// // //                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// // //               ],
// // //             ),
// // //           ),
// // //           Switch(
// // //             value: value,
// // //             activeColor: AppColors.primary,
// // //             onChanged: onChanged,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.stretch,
// // //       children: [
// // //         Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             const SubHeading('Weekly schedule'),
// // //             TextButton.icon(
// // //               onPressed: _copyMondayToRest,
// // //               icon: const Icon(Icons.copy_all, size: 16),
// // //               label: const Text('Copy Monday to Tue – Sat'),
// // //               style: TextButton.styleFrom(foregroundColor: AppColors.primary),
// // //             ),
// // //           ],
// // //         ),
// // //         const SizedBox(height: 8),
// // //         for (final slot in [_monday, ..._tuesdayToSaturday]) _dayCard(slot),
// // //         _sundayRow(),
// // //         const Divider(height: 32),
// // //         const SubHeading('Booking preferences'),
// // //         const SizedBox(height: 8),
// // //         _preferenceCard(
// // //           title: 'Appointment required',
// // //           subtitle: 'Patients must book before visiting',
// // //           value: _appointmentRequired,
// // //           onChanged: (v) => setState(() => _appointmentRequired = v),
// // //         ),
// // //         _preferenceCard(
// // //           title: 'Walk-ins accepted',
// // //           subtitle: 'Patients can visit without booking',
// // //           value: _walkInsAccepted,
// // //           onChanged: (v) => setState(() => _walkInsAccepted = v),
// // //         ),
// // //         _preferenceCard(
// // //           title: 'Same-day appointments',
// // //           subtitle: 'Patients can book for today',
// // //           value: _sameDayAppointments,
// // //           onChanged: (v) => setState(() => _sameDayAppointments = v),
// // //         ),
// // //         _preferenceCard(
// // //           title: 'Emergency availability',
// // //           subtitle: 'Available for urgent cases',
// // //           value: _emergencyAvailability,
// // //           onChanged: (v) => setState(() => _emergencyAvailability = v),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:sales_mobile_app/pages/formFeilds.dart';
// // import 'package:sales_mobile_app/theme/app_colors.dart';

// // const _dayKeys = [
// //   'monday',
// //   'tuesday',
// //   'wednesday',
// //   'thursday',
// //   'friday',
// //   'saturday',
// //   'sunday',
// // ];

// // const _dayNames = [
// //   'Monday',
// //   'Tuesday',
// //   'Wednesday',
// //   'Thursday',
// //   'Friday',
// //   'Saturday',
// //   'Sunday',
// // ];

// // TimeOfDay? _parseTime(dynamic v) {
// //   if (v == null) return null;
// //   final p = v.toString().split(':');
// //   if (p.length != 2) return null;
// //   final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
// //   return (h == null || m == null) ? null : TimeOfDay(hour: h, minute: m);
// // }

// // bool _bool(dynamic v, bool fallback) => v is bool ? v : fallback;

// // class _DaySlot {
// //   _DaySlot(this.day, this.enabled)
// //       : opensAt = const TimeOfDay(hour: 10, minute: 0),
// //         closesAt = const TimeOfDay(hour: 19, minute: 0),
// //         breakFrom = null,
// //         breakUntil = null;

// //   final String day;
// //   bool enabled;
// //   TimeOfDay opensAt;
// //   TimeOfDay closesAt;
// //   TimeOfDay? breakFrom;
// //   TimeOfDay? breakUntil;

// //   void copyFrom(_DaySlot o) {
// //     enabled = o.enabled;
// //     opensAt = o.opensAt;
// //     closesAt = o.closesAt;
// //     breakFrom = o.breakFrom;
// //     breakUntil = o.breakUntil;
// //   }
// // }

// // /// Ek clinic ki poori availability (7 din + booking preferences).
// // class _ClinicAvailability {
// //   _ClinicAvailability({required this.name, required this.city})
// //       : days = [
// //           for (var i = 0; i < _dayNames.length; i++)
// //             _DaySlot(_dayNames[i], i != 6), // Sunday default band
// //         ];

// //   int? id; // ClinicsStep ke _Clinic.uid se match hota hai (pehli sync tak null)
// //   String name;
// //   String city;
// //   final List<_DaySlot> days;

// //   bool appointmentRequired = true;
// //   bool walkInsAccepted = true;
// //   bool sameDayAppointments = false;
// //   bool emergencyAvailability = false;

// //   _DaySlot get monday => days.first;
// //   _DaySlot get sunday => days.last;
// //   List<_DaySlot> get tuesdayToSaturday => days.sublist(1, 6);

// //   void copyFrom(_ClinicAvailability o) {
// //     for (var i = 0; i < days.length; i++) {
// //       days[i].copyFrom(o.days[i]);
// //     }
// //     appointmentRequired = o.appointmentRequired;
// //     walkInsAccepted = o.walkInsAccepted;
// //     sameDayAppointments = o.sameDayAppointments;
// //     emergencyAvailability = o.emergencyAvailability;
// //   }
// // }

// // class AvailabilityStep extends StatefulWidget {
// //   const AvailabilityStep({super.key, this.initialData});

// //   /// API "clinics" list — har clinic ke andar apni `availability` hoti hai.
// //   final List? initialData;

// //   @override
// //   State<AvailabilityStep> createState() => AvailabilityStepState();
// // }

// // class AvailabilityStepState extends State<AvailabilityStep> {
// //   final List<_ClinicAvailability> _clinics = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     final list = widget.initialData;
// //     if (list == null) return;

// //     for (final raw in list) {
// //       if (raw is! Map) continue;
// //       final clinic = Map<String, dynamic>.from(raw);
// //       final entry = _ClinicAvailability(
// //         name: (clinic['clinicName'] ?? clinic['name'] ?? 'Clinic').toString(),
// //         city: (clinic['city'] ?? '').toString(),
// //       );
// //       _applyAvailability(entry, clinic['availability']);
// //       _clinics.add(entry);
// //     }
// //   }

// //   void _applyAvailability(_ClinicAvailability e, dynamic raw) {
// //     if (raw is! Map) return;
// //     final a = Map<String, dynamic>.from(raw);

// //     for (var i = 0; i < e.days.length; i++) {
// //       final d = a[_dayKeys[i]];
// //       if (d is! Map || d.isEmpty) continue;
// //       final day = Map<String, dynamic>.from(d);
// //       final slot = e.days[i];
// //       slot.enabled = day['enabled'] == true;
// //       slot.opensAt = _parseTime(day['startTime']) ?? slot.opensAt;
// //       slot.closesAt = _parseTime(day['endTime']) ?? slot.closesAt;
// //       slot.breakFrom = _parseTime(day['breakStartTime']);
// //       slot.breakUntil = _parseTime(day['breakEndTime']);
// //     }

// //     e.appointmentRequired =
// //         _bool(a['appointmentRequired'], e.appointmentRequired);
// //     e.walkInsAccepted = _bool(a['walkInsAccepted'], e.walkInsAccepted);
// //     e.sameDayAppointments =
// //         _bool(a['sameDayAppointment'], e.sameDayAppointments);
// //     e.emergencyAvailability =
// //         _bool(a['emergencyAvailability'], e.emergencyAvailability);
// //   }

// //   /// Parent isse tab call karta hai jab Availability step khulta hai
// //   /// (aur save se pehle).
// //   /// - jo clinics pehle se hain unka schedule safe rehta hai
// //   /// - nayi add hui clinic ka card ban jata hai
// //   /// - delete hui clinic ka card hat jata hai
// //   /// - naam/city update hote hain, aur order ClinicsStep jaisa hi rehta hai
// //   void syncClinics(List<Map<String, dynamic>> summaries) {
// //     final old = List<_ClinicAvailability>.from(_clinics);
// //     final next = <_ClinicAvailability>[];

// //     for (var i = 0; i < summaries.length; i++) {
// //       final s = summaries[i];
// //       final id = s['id'] as int;

// //       _ClinicAvailability? e;
// //       for (final o in old) {
// //         if (o.id == id) {
// //           e = o;
// //           break;
// //         }
// //       }
// //       // Pehli sync: API se prefill hui entries ka id null hota hai -> position se match.
// //       if (e == null && i < old.length && old[i].id == null) e = old[i];

// //       e ??= _ClinicAvailability(
// //         name: s['name'] as String,
// //         city: s['city'] as String,
// //       );
// //       e.id = id;
// //       e.name = s['name'] as String;
// //       e.city = s['city'] as String;
// //       next.add(e);
// //     }

// //     setState(() {
// //       _clinics
// //         ..clear()
// //         ..addAll(next);
// //     });
// //   }

// //   String _fmt(TimeOfDay? t) {
// //     if (t == null) return '--:--';
// //     final h = t.hour.toString().padLeft(2, '0');
// //     final m = t.minute.toString().padLeft(2, '0');
// //     return '$h:$m';
// //   }

// //   /// "HH:mm" string for the API, ya '' agar time nahi hai.
// //   String _apiTime(TimeOfDay? t) => t == null ? '' : _fmt(t);

// //   Map<String, dynamic> _availabilityMap(_ClinicAvailability c) {
// //     final daysMap = <String, dynamic>{};
// //     for (var i = 0; i < c.days.length; i++) {
// //       final slot = c.days[i];
// //       daysMap[_dayKeys[i]] = {
// //         'enabled': slot.enabled,
// //         'startTime': slot.enabled ? _apiTime(slot.opensAt) : '',
// //         'endTime': slot.enabled ? _apiTime(slot.closesAt) : '',
// //         'breakStartTime': slot.enabled ? _apiTime(slot.breakFrom) : '',
// //         'breakEndTime': slot.enabled ? _apiTime(slot.breakUntil) : '',
// //       };
// //     }
// //     return {
// //       ...daysMap,
// //       'appointmentRequired': c.appointmentRequired,
// //       'walkInsAccepted': c.walkInsAccepted,
// //       'sameDayAppointment': c.sameDayAppointments,
// //       'emergencyAvailability': c.emergencyAvailability,
// //     };
// //   }

// //   /// Har clinic ki availability, ClinicsStep ke order mein.
// //   /// Parent `availability` ko i-th clinic mein merge karta hai.
// //   List<Map<String, dynamic>> getData() =>
// //       [for (final c in _clinics) _availabilityMap(c)];

// //   // ─────────────────────────── actions ───────────────────────────

// //   void _copyMondayToRest(_ClinicAvailability c) {
// //     setState(() {
// //       for (final slot in c.tuesdayToSaturday) {
// //         slot.copyFrom(c.monday);
// //       }
// //     });
// //   }

// //   void _copyToAllClinics(_ClinicAvailability source) {
// //     setState(() {
// //       for (final other in _clinics) {
// //         if (!identical(other, source)) other.copyFrom(source);
// //       }
// //     });
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Schedule of "${source.name}" copied to all clinics'),
// //       ),
// //     );
// //   }

// //   Future<void> _pickTime({
// //     required TimeOfDay? current,
// //     required void Function(TimeOfDay) onPicked,
// //   }) async {
// //     final t = await showTimePicker(
// //       context: context,
// //       initialTime: current ?? const TimeOfDay(hour: 9, minute: 0),
// //     );
// //     if (t == null) return;
// //     setState(() => onPicked(t));
// //   }

// //   // ─────────────────────────── UI ───────────────────────────

// //   @override
// //   Widget build(BuildContext context) {
// //     if (_clinics.isEmpty) {
// //       return Text(
// //         'Add a clinic first to set its availability',
// //         style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
// //       );
// //     }

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         for (final c in _clinics) ...[
// //           KeyedSubtree(key: ObjectKey(c), child: _clinicCard(c)),
// //           const SizedBox(height: 14),
// //         ],
// //       ],
// //     );
// //   }

// //   Widget _clinicCard(_ClinicAvailability c) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: AppColors.primary.withOpacity(0.04),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: AppColors.primary.withOpacity(0.18)),
// //       ),
// //       child: Theme(
// //         // ExpansionTile ke upar-neeche ki default divider lines hata do
// //         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
// //         child: ExpansionTile(
// //           initiallyExpanded: true,
// //           shape: const Border(),
// //           collapsedShape: const Border(),
// //           tilePadding: const EdgeInsets.symmetric(horizontal: 14),
// //           childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
// //           expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
// //           title: Row(
// //             children: [
// //               Icon(Icons.storefront_outlined,
// //                   size: 18, color: AppColors.primary),
// //               const SizedBox(width: 8),
// //               Flexible(
// //                 child: Text(
// //                   c.name,
// //                   overflow: TextOverflow.ellipsis,
// //                   style: const TextStyle(
// //                       fontSize: 15, fontWeight: FontWeight.w700),
// //                 ),
// //               ),
// //               if (c.city.isNotEmpty) ...[
// //                 const SizedBox(width: 8),
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(4),
// //                   ),
// //                   child: Text(c.city,
// //                       style: const TextStyle(
// //                           fontSize: 10, color: Colors.blueGrey)),
// //                 ),
// //               ],
// //             ],
// //           ),
// //           children: [
// //             const SubHeading('Weekly schedule'),
// //             Wrap(
// //               spacing: 4,
// //               children: [
// //                 TextButton.icon(
// //                   onPressed: () => _copyMondayToRest(c),
// //                   icon: const Icon(Icons.copy_all, size: 16),
// //                   label: const Text('Copy Monday to Tue – Sat'),
// //                   style:
// //                       TextButton.styleFrom(foregroundColor: AppColors.primary),
// //                 ),
// //                 if (_clinics.length > 1)
// //                   TextButton.icon(
// //                     onPressed: () => _copyToAllClinics(c),
// //                     icon: const Icon(Icons.apartment_outlined, size: 16),
// //                     label: const Text('Copy to all clinics'),
// //                     style: TextButton.styleFrom(
// //                         foregroundColor: AppColors.primary),
// //                   ),
// //               ],
// //             ),
// //             const SizedBox(height: 8),
// //             for (final slot in [c.monday, ...c.tuesdayToSaturday])
// //               _dayCard(slot),
// //             _sundayRow(c.sunday),
// //             const Divider(height: 32),
// //             const SubHeading('Booking preferences'),
// //             const SizedBox(height: 8),
// //             _preferenceCard(
// //               title: 'Appointment required',
// //               subtitle: 'Patients must book before visiting',
// //               value: c.appointmentRequired,
// //               onChanged: (v) => setState(() => c.appointmentRequired = v),
// //             ),
// //             _preferenceCard(
// //               title: 'Walk-ins accepted',
// //               subtitle: 'Patients can visit without booking',
// //               value: c.walkInsAccepted,
// //               onChanged: (v) => setState(() => c.walkInsAccepted = v),
// //             ),
// //             _preferenceCard(
// //               title: 'Same-day appointments',
// //               subtitle: 'Patients can book for today',
// //               value: c.sameDayAppointments,
// //               onChanged: (v) => setState(() => c.sameDayAppointments = v),
// //             ),
// //             _preferenceCard(
// //               title: 'Emergency availability',
// //               subtitle: 'Available for urgent cases',
// //               value: c.emergencyAvailability,
// //               onChanged: (v) => setState(() => c.emergencyAvailability = v),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _timeField({
// //     required String label,
// //     required TimeOfDay? value,
// //     required bool enabled,
// //     required VoidCallback onTap,
// //   }) {
// //     return Expanded(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
// //           ),
// //           const SizedBox(height: 6),
// //           InkWell(
// //             onTap: enabled ? onTap : null,
// //             borderRadius: BorderRadius.circular(8),
// //             child: Container(
// //               height: 40,
// //               padding: const EdgeInsets.symmetric(horizontal: 10),
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.grey.shade300),
// //                 borderRadius: BorderRadius.circular(8),
// //                 color: enabled ? Colors.white : Colors.grey.shade100,
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     _fmt(value),
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color:
// //                           value == null ? Colors.grey.shade400 : Colors.black87,
// //                     ),
// //                   ),
// //                   Icon(Icons.access_time,
// //                       size: 16, color: Colors.grey.shade500),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _timeRows(_DaySlot slot) {
// //     return Column(
// //       children: [
// //         Row(
// //           children: [
// //             _timeField(
// //               label: 'Opens at',
// //               value: slot.opensAt,
// //               enabled: slot.enabled,
// //               onTap: () => _pickTime(
// //                   current: slot.opensAt, onPicked: (t) => slot.opensAt = t),
// //             ),
// //             const SizedBox(width: 10),
// //             _timeField(
// //               label: 'Closes at',
// //               value: slot.closesAt,
// //               enabled: slot.enabled,
// //               onTap: () => _pickTime(
// //                   current: slot.closesAt, onPicked: (t) => slot.closesAt = t),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 10),
// //         Row(
// //           children: [
// //             _timeField(
// //               label: 'Break from',
// //               value: slot.breakFrom,
// //               enabled: slot.enabled,
// //               onTap: () => _pickTime(
// //                   current: slot.breakFrom, onPicked: (t) => slot.breakFrom = t),
// //             ),
// //             const SizedBox(width: 10),
// //             _timeField(
// //               label: 'Break until',
// //               value: slot.breakUntil,
// //               enabled: slot.enabled,
// //               onTap: () => _pickTime(
// //                   current: slot.breakUntil,
// //                   onPicked: (t) => slot.breakUntil = t),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _dayCard(_DaySlot slot) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 14),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border.all(color: AppColors.primary.withOpacity(0.35)),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Switch(
// //                 value: slot.enabled,
// //                 activeColor: AppColors.primary,
// //                 onChanged: (v) => setState(() => slot.enabled = v),
// //               ),
// //               const SizedBox(width: 4),
// //               Text(
// //                 slot.day,
// //                 style:
// //                     const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           _timeRows(slot),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _sundayRow(_DaySlot sunday) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 20),
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //       decoration: BoxDecoration(
// //         color: sunday.enabled ? Colors.white : Colors.grey.shade100,
// //         border: sunday.enabled
// //             ? Border.all(color: AppColors.primary.withOpacity(0.35))
// //             : null,
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Switch(
// //                 value: sunday.enabled,
// //                 activeColor: AppColors.primary,
// //                 onChanged: (v) => setState(() => sunday.enabled = v),
// //               ),
// //               const SizedBox(width: 4),
// //               Text(sunday.day,
// //                   style: const TextStyle(
// //                       fontSize: 15, fontWeight: FontWeight.w600)),
// //               const SizedBox(width: 10),
// //               if (!sunday.enabled)
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.primary.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(6),
// //                   ),
// //                   child: Text(
// //                     'OPTIONAL',
// //                     style: TextStyle(
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.bold,
// //                       color: AppColors.primary,
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           if (!sunday.enabled) ...[
// //             Text('Closed on Sunday',
// //                 style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
// //             const SizedBox(height: 10),
// //           ] else ...[
// //             const SizedBox(height: 10),
// //             _timeRows(sunday),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _preferenceCard({
// //     required String title,
// //     required String subtitle,
// //     required bool value,
// //     required ValueChanged<bool> onChanged,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 6),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: value ? AppColors.primary.withOpacity(0.06) : Colors.white,
// //         border: Border.all(
// //           color:
// //               value ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade300,
// //         ),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(title,
// //                     style: const TextStyle(
// //                         fontSize: 14, fontWeight: FontWeight.w600)),
// //                 const SizedBox(height: 4),
// //                 Text(subtitle,
// //                     style:
// //                         TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// //               ],
// //             ),
// //           ),
// //           Switch(
// //             value: value,
// //             activeColor: AppColors.primary,
// //             onChanged: onChanged,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:sales_mobile_app/pages/formFeilds.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';

// const _dayKeys = [
//   'monday',
//   'tuesday',
//   'wednesday',
//   'thursday',
//   'friday',
//   'saturday',
//   'sunday',
// ];

// const _dayNames = [
//   'Monday',
//   'Tuesday',
//   'Wednesday',
//   'Thursday',
//   'Friday',
//   'Saturday',
//   'Sunday',
// ];

// const _kBreakOutsideMsg = 'Break must fall within working hours';
// const _kBreakOrderMsg = 'Break end time must be after break start time';
// const _kBreakBothMsg = 'Select both break start and break end time';

// TimeOfDay? _parseTime(dynamic v) {
//   if (v == null) return null;
//   final p = v.toString().split(':');
//   if (p.length != 2) return null;
//   final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
//   return (h == null || m == null) ? null : TimeOfDay(hour: h, minute: m);
// }

// bool _bool(dynamic v, bool fallback) => v is bool ? v : fallback;

// int _mins(TimeOfDay t) => t.hour * 60 + t.minute;

// /// Break ka error message (null = sab theek).
// /// Sirf tab check hota hai jab din enabled ho aur break set kiya gaya ho.
// String? _breakError(_DaySlot s) {
//   if (!s.enabled) return null;

//   final from = s.breakFrom;
//   final until = s.breakUntil;
//   if (from == null && until == null) return null; // break optional hai

//   if (from == null || until == null) return _kBreakBothMsg;

//   final open = _mins(s.opensAt);
//   final close = _mins(s.closesAt);
//   final f = _mins(from);
//   final u = _mins(until);

//   // Break working hours ke andar hona chahiye (boundary allowed)
//   if (f < open || u > close || f > close || u < open) {
//     return _kBreakOutsideMsg;
//   }
//   if (u <= f) return _kBreakOrderMsg;

//   return null;
// }



// class _DaySlot {
//   _DaySlot(this.day, this.enabled)
//       : opensAt = const TimeOfDay(hour: 10, minute: 0),
//         closesAt = const TimeOfDay(hour: 19, minute: 0),
//         breakFrom = null,
//         breakUntil = null;

//   final String day;
//   bool enabled;
//   TimeOfDay opensAt;
//   TimeOfDay closesAt;
//   TimeOfDay? breakFrom;
//   TimeOfDay? breakUntil;

//   void copyFrom(_DaySlot o) {
//     enabled = o.enabled;
//     opensAt = o.opensAt;
//     closesAt = o.closesAt;
//     breakFrom = o.breakFrom;
//     breakUntil = o.breakUntil;
//   }
// }

// /// Ek clinic ki poori availability (7 din + booking preferences).
// class _ClinicAvailability {
//   _ClinicAvailability({required this.name, required this.city})
//       : days = [
//           for (var i = 0; i < _dayNames.length; i++)
//             _DaySlot(_dayNames[i], i != 6), // Sunday default band
//         ];

//   int? id; // ClinicsStep ke _Clinic.uid se match hota hai (pehli sync tak null)
//   String name;
//   String city;
//   final List<_DaySlot> days;

//   bool appointmentRequired = true;
//   bool walkInsAccepted = true;
//   bool sameDayAppointments = false;
//   bool emergencyAvailability = false;

//   _DaySlot get monday => days.first;
//   _DaySlot get sunday => days.last;
//   List<_DaySlot> get tuesdayToSaturday => days.sublist(1, 6);

//   void copyFrom(_ClinicAvailability o) {
//     for (var i = 0; i < days.length; i++) {
//       days[i].copyFrom(o.days[i]);
//     }
//     appointmentRequired = o.appointmentRequired;
//     walkInsAccepted = o.walkInsAccepted;
//     sameDayAppointments = o.sameDayAppointments;
//     emergencyAvailability = o.emergencyAvailability;
//   }
// }

// class AvailabilityStep extends StatefulWidget {
//   const AvailabilityStep({super.key, this.initialData});

//   /// API "clinics" list — har clinic ke andar apni `availability` hoti hai.
//   final List? initialData;

//   @override
//   State<AvailabilityStep> createState() => AvailabilityStepState();
// }

// class AvailabilityStepState extends State<AvailabilityStep> {
//   final List<_ClinicAvailability> _clinics = [];

//   @override
//   void initState() {
//     super.initState();
//     final list = widget.initialData;
//     if (list == null) return;

//     for (final raw in list) {
//       if (raw is! Map) continue;
//       final clinic = Map<String, dynamic>.from(raw);
//       final entry = _ClinicAvailability(
//         name: (clinic['clinicName'] ?? clinic['name'] ?? 'Clinic').toString(),
//         city: (clinic['city'] ?? '').toString(),
//       );
//       _applyAvailability(entry, clinic['availability']);
//       _clinics.add(entry);
//     }
//   }

//   void _applyAvailability(_ClinicAvailability e, dynamic raw) {
//     if (raw is! Map) return;
//     final a = Map<String, dynamic>.from(raw);

//     for (var i = 0; i < e.days.length; i++) {
//       final d = a[_dayKeys[i]];
//       if (d is! Map || d.isEmpty) continue;
//       final day = Map<String, dynamic>.from(d);
//       final slot = e.days[i];
//       slot.enabled = day['enabled'] == true;
//       slot.opensAt = _parseTime(day['startTime']) ?? slot.opensAt;
//       slot.closesAt = _parseTime(day['endTime']) ?? slot.closesAt;
//       slot.breakFrom = _parseTime(day['breakStartTime']);
//       slot.breakUntil = _parseTime(day['breakEndTime']);
//     }

//     e.appointmentRequired =
//         _bool(a['appointmentRequired'], e.appointmentRequired);
//     e.walkInsAccepted = _bool(a['walkInsAccepted'], e.walkInsAccepted);
//     e.sameDayAppointments =
//         _bool(a['sameDayAppointment'], e.sameDayAppointments);
//     e.emergencyAvailability =
//         _bool(a['emergencyAvailability'], e.emergencyAvailability);
//   }

//   /// Parent isse tab call karta hai jab Availability step khulta hai
//   /// (aur save se pehle).
//   void syncClinics(List<Map<String, dynamic>> summaries) {
//     final old = List<_ClinicAvailability>.from(_clinics);
//     final next = <_ClinicAvailability>[];

//     for (var i = 0; i < summaries.length; i++) {
//       final s = summaries[i];
//       final id = s['id'] as int;

//       _ClinicAvailability? e;
//       for (final o in old) {
//         if (o.id == id) {
//           e = o;
//           break;
//         }
//       }
//       // Pehli sync: API se prefill hui entries ka id null hota hai -> position se match.
//       if (e == null && i < old.length && old[i].id == null) e = old[i];

//       e ??= _ClinicAvailability(
//         name: s['name'] as String,
//         city: s['city'] as String,
//       );
//       e.id = id;
//       e.name = s['name'] as String;
//       e.city = s['city'] as String;
//       next.add(e);
//     }

//     setState(() {
//       _clinics
//         ..clear()
//         ..addAll(next);
//     });
//   }

//   // ═══════════════════════════════════════════════════════════════
//   // VALIDATION
//   // Parent save se pehle call kare. null = sab theek, warna error text.
//   // Message mein clinic aur din ka naam hota hai, jaise:
//   //   "City Clinic · Monday: Break must fall within working hours"
//   // ═══════════════════════════════════════════════════════════════
//   String? validate() {
//     for (final c in _clinics) {
//       for (final slot in c.days) {
//         final err = _breakError(slot);
//         if (err != null) return '${c.name} · ${slot.day}: $err';
//       }
//     }
//     return null;
//   }

//   String _fmt(TimeOfDay? t) {
//     if (t == null) return '--:--';
//     final h = t.hour.toString().padLeft(2, '0');
//     final m = t.minute.toString().padLeft(2, '0');
//     return '$h:$m';
//   }

//   /// "HH:mm" string for the API, ya '' agar time nahi hai.
//   String _apiTime(TimeOfDay? t) => t == null ? '' : _fmt(t);

//   Map<String, dynamic> _availabilityMap(_ClinicAvailability c) {
//     final daysMap = <String, dynamic>{};
//     for (var i = 0; i < c.days.length; i++) {
//       final slot = c.days[i];
//       daysMap[_dayKeys[i]] = {
//         'enabled': slot.enabled,
//         'startTime': slot.enabled ? _apiTime(slot.opensAt) : '',
//         'endTime': slot.enabled ? _apiTime(slot.closesAt) : '',
//         'breakStartTime': slot.enabled ? _apiTime(slot.breakFrom) : '',
//         'breakEndTime': slot.enabled ? _apiTime(slot.breakUntil) : '',
//       };
//     }
//     return {
//       ...daysMap,
//       'appointmentRequired': c.appointmentRequired,
//       'walkInsAccepted': c.walkInsAccepted,
//       'sameDayAppointment': c.sameDayAppointments,
//       'emergencyAvailability': c.emergencyAvailability,
//     };
//   }

//   /// Har clinic ki availability, ClinicsStep ke order mein.
//   List<Map<String, dynamic>> getData() =>
//       [for (final c in _clinics) _availabilityMap(c)];

//   // ─────────────────────────── actions ───────────────────────────

//   void _copyMondayToRest(_ClinicAvailability c) {
//     setState(() {
//       for (final slot in c.tuesdayToSaturday) {
//         slot.copyFrom(c.monday);
//       }
//     });
//   }

//   void _copyToAllClinics(_ClinicAvailability source) {
//     setState(() {
//       for (final other in _clinics) {
//         if (!identical(other, source)) other.copyFrom(source);
//       }
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Schedule of "${source.name}" copied to all clinics'),
//       ),
//     );
//   }

//   Future<void> _pickTime({
//     required TimeOfDay? current,
//     required void Function(TimeOfDay) onPicked,
//   }) async {
//     final t = await showTimePicker(
//       context: context,
//       initialTime: current ?? const TimeOfDay(hour: 9, minute: 0),
//     );
//     if (t == null) return;
//     setState(() => onPicked(t));
//   }

//   // ─────────────────────────── UI ───────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     if (_clinics.isEmpty) {
//       return Text(
//         'Add a clinic first to set its availability',
//         style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         for (final c in _clinics) ...[
//           KeyedSubtree(key: ObjectKey(c), child: _clinicCard(c)),
//           const SizedBox(height: 14),
//         ],
//       ],
//     );
//   }

//   Widget _clinicCard(_ClinicAvailability c) {
//     // Card band ho tab bhi header par error dikhe
//     final hasError = c.days.any((s) => _breakError(s) != null);

//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.04),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: hasError
//               ? Colors.red.shade300
//               : AppColors.primary.withOpacity(0.18),
//         ),
//       ),
//       child: Theme(
//         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//           initiallyExpanded: true,
//           shape: const Border(),
//           collapsedShape: const Border(),
//           tilePadding: const EdgeInsets.symmetric(horizontal: 14),
//           childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//           expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
//           title: Row(
//             children: [
//               Icon(Icons.storefront_outlined,
//                   size: 18, color: AppColors.primary),
//               const SizedBox(width: 8),
//               Flexible(
//                 child: Text(
//                   c.name,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontSize: 15, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               if (c.city.isNotEmpty) ...[
//                 const SizedBox(width: 8),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(c.city,
//                       style: const TextStyle(
//                           fontSize: 10, color: Colors.blueGrey)),
//                 ),
//               ],
//               if (hasError) ...[
//                 const SizedBox(width: 8),
//                 Icon(Icons.error_outline,
//                     size: 18, color: Colors.red.shade600),
//               ],
//             ],
//           ),
//           children: [
//             const SubHeading('Weekly schedule'),
//             Wrap(
//               spacing: 4,
//               children: [
//                 TextButton.icon(
//                   onPressed: () => _copyMondayToRest(c),
//                   icon: const Icon(Icons.copy_all, size: 16),
//                   label: const Text('Copy Monday to Tue – Sat'),
//                   style:
//                       TextButton.styleFrom(foregroundColor: AppColors.primary),
//                 ),
//                 if (_clinics.length > 1)
//                   TextButton.icon(
//                     onPressed: () => _copyToAllClinics(c),
//                     icon: const Icon(Icons.apartment_outlined, size: 16),
//                     label: const Text('Copy to all clinics'),
//                     style: TextButton.styleFrom(
//                         foregroundColor: AppColors.primary),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             for (final slot in [c.monday, ...c.tuesdayToSaturday])
//               _dayCard(slot),
//             _sundayRow(c.sunday),
//             const Divider(height: 32),
//             const SubHeading('Booking preferences'),
//             const SizedBox(height: 8),
//             _preferenceCard(
//               title: 'Appointment required',
//               subtitle: 'Patients must book before visiting',
//               value: c.appointmentRequired,
//               onChanged: (v) => setState(() => c.appointmentRequired = v),
//             ),
//             _preferenceCard(
//               title: 'Walk-ins accepted',
//               subtitle: 'Patients can visit without booking',
//               value: c.walkInsAccepted,
//               onChanged: (v) => setState(() => c.walkInsAccepted = v),
//             ),
//             _preferenceCard(
//               title: 'Same-day appointments',
//               subtitle: 'Patients can book for today',
//               value: c.sameDayAppointments,
//               onChanged: (v) => setState(() => c.sameDayAppointments = v),
//             ),
//             _preferenceCard(
//               title: 'Emergency availability',
//               subtitle: 'Available for urgent cases',
//               value: c.emergencyAvailability,
//               onChanged: (v) => setState(() => c.emergencyAvailability = v),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _timeField({
//     required String label,
//     required TimeOfDay? value,
//     required bool enabled,
//     required VoidCallback onTap,
//     bool hasError = false,
//   }) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 6),
//           InkWell(
//             onTap: enabled ? onTap : null,
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: hasError ? Colors.red.shade400 : Colors.grey.shade300,
//                   width: hasError ? 1.4 : 1,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//                 color: enabled ? Colors.white : Colors.grey.shade100,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _fmt(value),
//                     style: TextStyle(
//                       fontSize: 14,
//                       color:
//                           value == null ? Colors.grey.shade400 : Colors.black87,
//                     ),
//                   ),
//                   Icon(Icons.access_time,
//                       size: 16,
//                       color:
//                           hasError ? Colors.red.shade400 : Colors.grey.shade500),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _timeRows(_DaySlot slot) {
//     // Har build par live check: working hours ya break badalte hi error update
//     final breakErr = _breakError(slot);
//     final bad = breakErr != null;

//     return Column(
//       children: [
//         Row(
//           children: [
//             _timeField(
//               label: 'Opens at',
//               value: slot.opensAt,
//               enabled: slot.enabled,
//               onTap: () => _pickTime(
//                   current: slot.opensAt, onPicked: (t) => slot.opensAt = t),
//             ),
//             const SizedBox(width: 10),
//             _timeField(
//               label: 'Closes at',
//               value: slot.closesAt,
//               enabled: slot.enabled,
//               onTap: () => _pickTime(
//                   current: slot.closesAt, onPicked: (t) => slot.closesAt = t),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             _timeField(
//               label: 'Break from',
//               value: slot.breakFrom,
//               enabled: slot.enabled,
//               hasError: bad,
//               onTap: () => _pickTime(
//                   current: slot.breakFrom, onPicked: (t) => slot.breakFrom = t),
//             ),
//             const SizedBox(width: 10),
//             _timeField(
//               label: 'Break until',
//               value: slot.breakUntil,
//               enabled: slot.enabled,
//               hasError: bad,
//               onTap: () => _pickTime(
//                   current: slot.breakUntil,
//                   onPicked: (t) => slot.breakUntil = t),
//             ),
//           ],
//         ),
//         if (bad)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.error_outline,
//                     size: 15, color: Colors.red.shade600),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     breakErr,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.red.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _dayCard(_DaySlot slot) {
//     final bad = _breakError(slot) != null;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//           color: bad
//               ? Colors.red.shade300
//               : AppColors.primary.withOpacity(0.35),
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Switch(
//                 value: slot.enabled,
//                 activeColor: AppColors.primary,
//                 onChanged: (v) => setState(() => slot.enabled = v),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 slot.day,
//                 style:
//                     const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _timeRows(slot),
//         ],
//       ),
//     );
//   }

//   Widget _sundayRow(_DaySlot sunday) {
//     final bad = _breakError(sunday) != null;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: sunday.enabled ? Colors.white : Colors.grey.shade100,
//         border: sunday.enabled
//             ? Border.all(
//                 color: bad
//                     ? Colors.red.shade300
//                     : AppColors.primary.withOpacity(0.35),
//               )
//             : null,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Switch(
//                 value: sunday.enabled,
//                 activeColor: AppColors.primary,
//                 onChanged: (v) => setState(() => sunday.enabled = v),
//               ),
//               const SizedBox(width: 4),
//               Text(sunday.day,
//                   style: const TextStyle(
//                       fontSize: 15, fontWeight: FontWeight.w600)),
//               const SizedBox(width: 10),
//               if (!sunday.enabled)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     'OPTIONAL',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           if (!sunday.enabled) ...[
//             Text('Closed on Sunday',
//                 style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
//             const SizedBox(height: 10),
//           ] else ...[
//             const SizedBox(height: 10),
//             _timeRows(sunday),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _preferenceCard({
//     required String title,
//     required String subtitle,
//     required bool value,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: value ? AppColors.primary.withOpacity(0.06) : Colors.white,
//         border: Border.all(
//           color:
//               value ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade300,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 4),
//                 Text(subtitle,
//                     style:
//                         TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             activeColor: AppColors.primary,
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

const _dayKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

const _dayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _kTimingOrderMsg = 'Closing time must be after opening time';
const _kBreakOutsideMsg = 'Break must fall within working hours';
const _kBreakOrderMsg = 'Break end time must be after break start time';
const _kBreakBothMsg = 'Select both break start and break end time';

TimeOfDay? _parseTime(dynamic v) {
  if (v == null) return null;
  final p = v.toString().split(':');
  if (p.length != 2) return null;
  final h = int.tryParse(p[0]), m = int.tryParse(p[1]);
  return (h == null || m == null) ? null : TimeOfDay(hour: h, minute: m);
}

bool _bool(dynamic v, bool fallback) => v is bool ? v : fallback;

int _mins(TimeOfDay t) => t.hour * 60 + t.minute;

/// Break ka error message (null = sab theek).
/// Sirf tab check hota hai jab din enabled ho aur break set kiya gaya ho.
String? _breakError(_DaySlot s) {
  if (!s.enabled) return null;

  final from = s.breakFrom;
  final until = s.breakUntil;
  if (from == null && until == null) return null; // break optional hai

  if (from == null || until == null) return _kBreakBothMsg;

  final open = _mins(s.opensAt);
  final close = _mins(s.closesAt);
  final f = _mins(from);
  final u = _mins(until);

  // Break working hours ke andar hona chahiye (boundary allowed)
  if (f < open || u > close || f > close || u < open) {
    return _kBreakOutsideMsg;
  }
  if (u <= f) return _kBreakOrderMsg;

  return null;
}

/// Din ka poora error: pehle closing > opening (backend: timing.order),
/// phir break ke rules. null = sab theek.
String? _slotError(_DaySlot s) {
  if (!s.enabled) return null;
  if (_mins(s.closesAt) <= _mins(s.opensAt)) return _kTimingOrderMsg;
  return _breakError(s);
}

class _DaySlot {
  _DaySlot(this.day, this.enabled)
      : opensAt = const TimeOfDay(hour: 10, minute: 0),
        closesAt = const TimeOfDay(hour: 19, minute: 0),
        breakFrom = null,
        breakUntil = null;

  final String day;
  bool enabled;
  TimeOfDay opensAt;
  TimeOfDay closesAt;
  TimeOfDay? breakFrom;
  TimeOfDay? breakUntil;

  void copyFrom(_DaySlot o) {
    enabled = o.enabled;
    opensAt = o.opensAt;
    closesAt = o.closesAt;
    breakFrom = o.breakFrom;
    breakUntil = o.breakUntil;
  }
}

/// Ek clinic ki poori availability (7 din + booking preferences).
class _ClinicAvailability {
  _ClinicAvailability({required this.name, required this.city})
      : days = [
          for (var i = 0; i < _dayNames.length; i++)
            _DaySlot(_dayNames[i], i != 6), // Sunday default band
        ];

  int? id; // ClinicsStep ke _Clinic.uid se match hota hai (pehli sync tak null)
  String name;
  String city;
  final List<_DaySlot> days;

  bool appointmentRequired = true;
  bool walkInsAccepted = true;
  bool sameDayAppointments = false;
  bool emergencyAvailability = false;

  _DaySlot get monday => days.first;
  _DaySlot get sunday => days.last;
  List<_DaySlot> get tuesdayToSaturday => days.sublist(1, 6);

  void copyFrom(_ClinicAvailability o) {
    for (var i = 0; i < days.length; i++) {
      days[i].copyFrom(o.days[i]);
    }
    appointmentRequired = o.appointmentRequired;
    walkInsAccepted = o.walkInsAccepted;
    sameDayAppointments = o.sameDayAppointments;
    emergencyAvailability = o.emergencyAvailability;
  }
}

class AvailabilityStep extends StatefulWidget {
  const AvailabilityStep({super.key, this.initialData});

  /// API "clinics" list — har clinic ke andar apni `availability` hoti hai.
  final List? initialData;

  @override
  State<AvailabilityStep> createState() => AvailabilityStepState();
}

class AvailabilityStepState extends State<AvailabilityStep> {
  final List<_ClinicAvailability> _clinics = [];

  @override
  void initState() {
    super.initState();
    final list = widget.initialData;
    if (list == null) return;

    for (final raw in list) {
      if (raw is! Map) continue;
      final clinic = Map<String, dynamic>.from(raw);
      final entry = _ClinicAvailability(
        name: (clinic['clinicName'] ?? clinic['name'] ?? 'Clinic').toString(),
        city: (clinic['city'] ?? '').toString(),
      );
      _applyAvailability(entry, clinic['availability']);
      _clinics.add(entry);
    }
  }

  void _applyAvailability(_ClinicAvailability e, dynamic raw) {
    if (raw is! Map) return;
    final a = Map<String, dynamic>.from(raw);

    for (var i = 0; i < e.days.length; i++) {
      final d = a[_dayKeys[i]];
      if (d is! Map || d.isEmpty) continue;
      final day = Map<String, dynamic>.from(d);
      final slot = e.days[i];
      slot.enabled = day['enabled'] == true;
      slot.opensAt = _parseTime(day['startTime']) ?? slot.opensAt;
      slot.closesAt = _parseTime(day['endTime']) ?? slot.closesAt;
      slot.breakFrom = _parseTime(day['breakStartTime']);
      slot.breakUntil = _parseTime(day['breakEndTime']);
    }

    e.appointmentRequired =
        _bool(a['appointmentRequired'], e.appointmentRequired);
    e.walkInsAccepted = _bool(a['walkInsAccepted'], e.walkInsAccepted);
    e.sameDayAppointments =
        _bool(a['sameDayAppointment'], e.sameDayAppointments);
    e.emergencyAvailability =
        _bool(a['emergencyAvailability'], e.emergencyAvailability);
  }

  /// Parent isse tab call karta hai jab Availability step khulta hai
  /// (aur save se pehle).
  void syncClinics(List<Map<String, dynamic>> summaries) {
    final old = List<_ClinicAvailability>.from(_clinics);
    final next = <_ClinicAvailability>[];

    for (var i = 0; i < summaries.length; i++) {
      final s = summaries[i];
      final id = s['id'] as int;

      _ClinicAvailability? e;
      for (final o in old) {
        if (o.id == id) {
          e = o;
          break;
        }
      }
      // Pehli sync: API se prefill hui entries ka id null hota hai -> position se match.
      if (e == null && i < old.length && old[i].id == null) e = old[i];

      e ??= _ClinicAvailability(
        name: s['name'] as String,
        city: s['city'] as String,
      );
      e.id = id;
      e.name = s['name'] as String;
      e.city = s['city'] as String;
      next.add(e);
    }

    setState(() {
      _clinics
        ..clear()
        ..addAll(next);
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // VALIDATION
  // Parent save se pehle call kare. null = sab theek, warna error text.
  // Message mein clinic aur din ka naam hota hai, jaise:
  //   "City Clinic · Monday: Closing time must be after opening time"
  // ═══════════════════════════════════════════════════════════════
  String? validate() {
    for (final c in _clinics) {
      for (final slot in c.days) {
        final err = _slotError(slot);
        if (err != null) return '${c.name} · ${slot.day}: $err';
      }
    }
    return null;
  }

  String _fmt(TimeOfDay? t) {
    if (t == null) return '--:--';
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// "HH:mm" string for the API, ya '' agar time nahi hai.
  String _apiTime(TimeOfDay? t) => t == null ? '' : _fmt(t);

  Map<String, dynamic> _availabilityMap(_ClinicAvailability c) {
    final daysMap = <String, dynamic>{};
    for (var i = 0; i < c.days.length; i++) {
      final slot = c.days[i];
      daysMap[_dayKeys[i]] = {
        'enabled': slot.enabled,
        'startTime': slot.enabled ? _apiTime(slot.opensAt) : '',
        'endTime': slot.enabled ? _apiTime(slot.closesAt) : '',
        'breakStartTime': slot.enabled ? _apiTime(slot.breakFrom) : '',
        'breakEndTime': slot.enabled ? _apiTime(slot.breakUntil) : '',
      };
    }
    return {
      ...daysMap,
      'appointmentRequired': c.appointmentRequired,
      'walkInsAccepted': c.walkInsAccepted,
      'sameDayAppointment': c.sameDayAppointments,
      'emergencyAvailability': c.emergencyAvailability,
    };
  }

  /// Har clinic ki availability, ClinicsStep ke order mein.
  List<Map<String, dynamic>> getData() =>
      [for (final c in _clinics) _availabilityMap(c)];

  // ─────────────────────────── actions ───────────────────────────

  void _copyMondayToRest(_ClinicAvailability c) {
    setState(() {
      for (final slot in c.tuesdayToSaturday) {
        slot.copyFrom(c.monday);
      }
    });
  }

  void _copyToAllClinics(_ClinicAvailability source) {
    setState(() {
      for (final other in _clinics) {
        if (!identical(other, source)) other.copyFrom(source);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schedule of "${source.name}" copied to all clinics'),
      ),
    );
  }

  Future<void> _pickTime({
    required TimeOfDay? current,
    required void Function(TimeOfDay) onPicked,
  }) async {
    final t = await showTimePicker(
      context: context,
      initialTime: current ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (t == null) return;
    setState(() => onPicked(t));
  }

  // ─────────────────────────── UI ───────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_clinics.isEmpty) {
      return Text(
        'Add a clinic first to set its availability',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in _clinics) ...[
          KeyedSubtree(key: ObjectKey(c), child: _clinicCard(c)),
          const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _clinicCard(_ClinicAvailability c) {
    // Card band ho tab bhi header par error dikhe
    final hasError = c.days.any((s) => _slotError(s) != null);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? Colors.red.shade300
              : AppColors.primary.withOpacity(0.18),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          title: Row(
            children: [
              Icon(Icons.storefront_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  c.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              if (c.city.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(c.city,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.blueGrey)),
                ),
              ],
              if (hasError) ...[
                const SizedBox(width: 8),
                Icon(Icons.error_outline,
                    size: 18, color: Colors.red.shade600),
              ],
            ],
          ),
          children: [
            const SubHeading('Weekly schedule'),
            Wrap(
              spacing: 4,
              children: [
                TextButton.icon(
                  onPressed: () => _copyMondayToRest(c),
                  icon: const Icon(Icons.copy_all, size: 16),
                  label: const Text('Copy Monday to Tue – Sat'),
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
                if (_clinics.length > 1)
                  TextButton.icon(
                    onPressed: () => _copyToAllClinics(c),
                    icon: const Icon(Icons.apartment_outlined, size: 16),
                    label: const Text('Copy to all clinics'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            for (final slot in [c.monday, ...c.tuesdayToSaturday])
              _dayCard(slot),
            _sundayRow(c.sunday),
            const Divider(height: 32),
            const SubHeading('Booking preferences'),
            const SizedBox(height: 8),
            _preferenceCard(
              title: 'Appointment required',
              subtitle: 'Patients must book before visiting',
              value: c.appointmentRequired,
              onChanged: (v) => setState(() => c.appointmentRequired = v),
            ),
            _preferenceCard(
              title: 'Walk-ins accepted',
              subtitle: 'Patients can visit without booking',
              value: c.walkInsAccepted,
              onChanged: (v) => setState(() => c.walkInsAccepted = v),
            ),
            _preferenceCard(
              title: 'Same-day appointments',
              subtitle: 'Patients can book for today',
              value: c.sameDayAppointments,
              onChanged: (v) => setState(() => c.sameDayAppointments = v),
            ),
            _preferenceCard(
              title: 'Emergency availability',
              subtitle: 'Available for urgent cases',
              value: c.emergencyAvailability,
              onChanged: (v) => setState(() => c.emergencyAvailability = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeField({
    required String label,
    required TimeOfDay? value,
    required bool enabled,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasError ? Colors.red.shade400 : Colors.grey.shade300,
                  width: hasError ? 1.4 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: enabled ? Colors.white : Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fmt(value),
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          value == null ? Colors.grey.shade400 : Colors.black87,
                    ),
                  ),
                  Icon(Icons.access_time,
                      size: 16,
                      color:
                          hasError ? Colors.red.shade400 : Colors.grey.shade500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRows(_DaySlot slot) {
    // Har build par live check: working hours ya break badalte hi error update
    final err = _slotError(slot);
    final orderBad = err == _kTimingOrderMsg; // Opens/Closes fields red
    final breakBad = err != null && !orderBad; // Break fields red

    return Column(
      children: [
        Row(
          children: [
            _timeField(
              label: 'Opens at',
              value: slot.opensAt,
              enabled: slot.enabled,
              hasError: orderBad,
              onTap: () => _pickTime(
                  current: slot.opensAt, onPicked: (t) => slot.opensAt = t),
            ),
            const SizedBox(width: 10),
            _timeField(
              label: 'Closes at',
              value: slot.closesAt,
              enabled: slot.enabled,
              hasError: orderBad,
              onTap: () => _pickTime(
                  current: slot.closesAt, onPicked: (t) => slot.closesAt = t),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _timeField(
              label: 'Break from',
              value: slot.breakFrom,
              enabled: slot.enabled,
              hasError: breakBad,
              onTap: () => _pickTime(
                  current: slot.breakFrom, onPicked: (t) => slot.breakFrom = t),
            ),
            const SizedBox(width: 10),
            _timeField(
              label: 'Break until',
              value: slot.breakUntil,
              enabled: slot.enabled,
              hasError: breakBad,
              onTap: () => _pickTime(
                  current: slot.breakUntil,
                  onPicked: (t) => slot.breakUntil = t),
            ),
          ],
        ),
        if (err != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline,
                    size: 15, color: Colors.red.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    err,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _dayCard(_DaySlot slot) {
    final bad = _slotError(slot) != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: bad
              ? Colors.red.shade300
              : AppColors.primary.withOpacity(0.35),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Switch(
                value: slot.enabled,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => slot.enabled = v),
              ),
              const SizedBox(width: 4),
              Text(
                slot.day,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _timeRows(slot),
        ],
      ),
    );
  }

  Widget _sundayRow(_DaySlot sunday) {
    final bad = _slotError(sunday) != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: sunday.enabled ? Colors.white : Colors.grey.shade100,
        border: sunday.enabled
            ? Border.all(
                color: bad
                    ? Colors.red.shade300
                    : AppColors.primary.withOpacity(0.35),
              )
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Switch(
                value: sunday.enabled,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => sunday.enabled = v),
              ),
              const SizedBox(width: 4),
              Text(sunday.day,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              if (!sunday.enabled)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'OPTIONAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          if (!sunday.enabled) ...[
            Text('Closed on Sunday',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 10),
          ] else ...[
            const SizedBox(height: 10),
            _timeRows(sunday),
          ],
        ],
      ),
    );
  }

  Widget _preferenceCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value ? AppColors.primary.withOpacity(0.06) : Colors.white,
        border: Border.all(
          color:
              value ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}