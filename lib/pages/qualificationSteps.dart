// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:sales_mobile_app/pages/formFeilds.dart';


// // // class _Degree {
// // //   _Degree(String degree, String institution, String year)
// // //       : degree = TextEditingController(),
// // //         institution = TextEditingController(),
// // //         year = TextEditingController();

// // //   final TextEditingController degree;
// // //   final TextEditingController institution;
// // //   final TextEditingController year;

// // //   void dispose() {
// // //     degree.dispose();
// // //     institution.dispose();
// // //     year.dispose();
// // //   }
// // // }

// // // class QualificationsStep extends StatefulWidget {
// // //   const QualificationsStep({super.key});

// // //   @override
// // //   State<QualificationsStep> createState() => _QualificationsStepState();
// // // }

// // // class _QualificationsStepState extends State<QualificationsStep> {
// // //   static const _councils = [
// // //     'National Medical Commission',
// // //     'Delhi Medical Council',
// // //     'Maharashtra Medical Council',
// // //     'Karnataka Medical Council',
// // //     'Tamil Nadu Medical Council',
// // //     'West Bengal Medical Council',
// // //   ];


// // // static const _qualifications = [
// // //   'MBBS',
// // //   'BDS',
// // //   'BAMS',
// // //   'BHMS',
// // //   'MD',
// // //   'MS',
// // //   'DNB',
// // //   'MDS',
// // //   'DM',
// // //   'Mch',
// // //   'Other'
// // //   ];


// // //   final _regNo = TextEditingController(text: 'DMC-2022-48213');
// // //   String _council = 'Delhi Medical Council';

// // //   final List<_Degree> _degrees = [
// // //     _Degree('MBBS', 'AIIMS Delhi', '2019'),
// // //     _Degree('MD (General Medicine)', 'AIIMS Delhi', '2022'),
// // //   ];

// // //   @override
// // //   void dispose() {
// // //     _regNo.dispose();
// // //     for (final d in _degrees) {
// // //       d.dispose();
// // //     }
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.stretch,
// // //       children: [
// // //         TwoColumn(
// // //           left: LabeledField(
// // //             label: 'Medical registration number',
// // //             isRequired: true,
// // //             child: AppTextField(controller: _regNo),
// // //           ),
// // //           right: LabeledField(
// // //             label: 'Registration council',
// // //             child: AppDropdown(
// // //               value: _council,
// // //               items: _councils,
// // //               onChanged: (v) => setState(() => _council = v ?? _council),
// // //             ),
// // //           ),
// // //         ),
// // //         const SizedBox(height: 32),
// // //         const SubHeading('Degrees'),
// // //         const SizedBox(height: 16),
// // //         for (var i = 0; i < _degrees.length; i++) ...[
// // //           RepeatCard(
// // //             title: 'Degree ${i + 1}',
// // //             onRemove: _degrees.length > 1
// // //                 ? () => setState(() => _degrees.removeAt(i).dispose())
// // //                 : null,
// // //             child: Column(
// // //               children: [
// // //                 TwoColumn(
// // //                   left: LabeledField(
// // //                     label: 'Degree',
// // //                     child: AppTextField(controller: _degrees[i].degree),
// // //                   ),
// // //                   right: LabeledField(
// // //                     label: 'Institution',
// // //                     child: AppTextField(controller: _degrees[i].institution),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 Align(
// // //                   alignment: Alignment.centerLeft,
// // //                   child: SizedBox(
// // //                     width: 220,
// // //                     child: LabeledField(
// // //                       label: 'Year of completion',
// // //                       child: AppTextField(
// // //                         controller: _degrees[i].year,
// // //                         keyboardType: TextInputType.number,
// // //                         inputFormatters: [
// // //                           FilteringTextInputFormatter.digitsOnly,
// // //                           LengthLimitingTextInputFormatter(4),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //         ],
// // //         AddEntryButton(
// // //           label: 'Add degree',
// // //           onPressed: () => setState(() => _degrees.add(_Degree('', '', ''))),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:sales_mobile_app/pages/formFeilds.dart';

// // class _Degree {
// //   _Degree()
// //       : degree = TextEditingController(),
// //         specialization = TextEditingController(),
// //         institution = TextEditingController(),
// //         year = TextEditingController();

// //   final TextEditingController degree;
// //   final TextEditingController specialization;
// //   final TextEditingController institution;
// //   final TextEditingController year;

// //   void dispose() {
// //     degree.dispose();
// //     specialization.dispose();
// //     institution.dispose();
// //     year.dispose();
// //   }
// // }

// // class QualificationsStep extends StatefulWidget {
// //   const QualificationsStep({super.key});

// //   @override
// //   State<QualificationsStep> createState() => _QualificationsStepState();
// // }

// // class _QualificationsStepState extends State<QualificationsStep> {
// //   static const _maxDegrees = 5;

// //   static const _highestQualifications = [
// //     'MBBS',
// //     'BDS',
// //     'BAMS',
// //     'BHMS',
// //     'MD',
// //     'MS',
// //     'DNB',
// //     'MDS',
// //     'DM',
// //     'MCh',
// //     'Other',
// //   ];

// //   // Empty by default — no pre-selected value, shows the hint instead.
// //   String? _highestQualification;

// //   // Starts with a single blank degree card, all fields empty.
// //   final List<_Degree> _degrees = [_Degree()];

// //   @override
// //   void dispose() {
// //     for (final d in _degrees) {
// //       d.dispose();
// //     }
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: [
// //         LabeledField(
// //           label: 'Highest qualification',
// //           isRequired: true,
// //           child: AppDropdown(
// //             value: _highestQualification,
// //             valiadtiontext: "Please select any highest qualification",
// //             hint: 'Select highest qualification',
// //             items: _highestQualifications,
// //             onChanged: (v) => setState(() => _highestQualification = v),
// //           ),
// //         ),
// //         const SizedBox(height: 32),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Row(
// //               children: [
// //                 const SubHeading('Degrees'),
// //                 const SizedBox(width: 8),
// //                 Text(
// //                   '${_degrees.length}/$_maxDegrees',
// //                   style: Theme.of(context)
// //                       .textTheme
// //                       .bodySmall
// //                       ?.copyWith(color: Colors.red),
// //                 ),
// //               ],
// //             ),
// //             AddEntryButton(
// //               label: 'Add degree',
// //               onPressed: () {
// //                 if (_degrees.length < _maxDegrees) {
// //                   setState(() => _degrees.add(_Degree()));
// //                 }
// //               },
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 16),
// //         for (var i = 0; i < _degrees.length; i++) ...[
// //           RepeatCard(
// //             title: 'Degree ${i + 1}',
// //             onRemove: _degrees.length > 1
// //                 ? () => setState(() => _degrees.removeAt(i).dispose())
// //                 : null,
// //             child: Column(
// //               children: [
// //                 TwoColumn(
// //                   left: LabeledField(
// //                     label: 'Degree',
// //                     isRequired: true,
// //                     child: AppTextField(
// //                       controller: _degrees[i].degree,
// //                       hint: 'e.g. MBBS',
// //                     ),
// //                   ),
// //                   right: LabeledField(
// //                     label: 'Specialization',
// //                     isRequired: true,
// //                     child: AppTextField(
// //                       controller: _degrees[i].specialization,
// //                       hint: 'e.g. General Surgery',
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 TwoColumn(
// //                   left: LabeledField(
// //                     label: 'Institution',
// //                     isRequired: true,
// //                     child: AppTextField(
// //                       controller: _degrees[i].institution,
// //                       hint: 'e.g. AIIMS Delhi',
// //                     ),
// //                   ),
// //                   right: LabeledField(
// //                     label: 'Year of completion',
// //                     child: AppTextField(
// //                       controller: _degrees[i].year,
// //                       hint: 'e.g. 2020',
// //                       keyboardType: TextInputType.number,
// //                       inputFormatters: [
// //                         FilteringTextInputFormatter.digitsOnly,
// //                         LengthLimitingTextInputFormatter(4),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //         ],
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sales_mobile_app/pages/formFeilds.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';

// class _Degree {
//   _Degree()
//       : degree = TextEditingController(),
//         specialization = TextEditingController(),
//         institution = TextEditingController(),
//         year = TextEditingController();

//   final TextEditingController degree;
//   final TextEditingController specialization;
//   final TextEditingController institution;
//   final TextEditingController year;

//   void dispose() {
//     degree.dispose();
//     specialization.dispose();
//     institution.dispose();
//     year.dispose();
//   }
// }

// class _Fellowship {
//   _Fellowship()
//       : name = TextEditingController(),
//         organization = TextEditingController(),
//         year = TextEditingController();

//   final TextEditingController name;
//   final TextEditingController organization;
//   final TextEditingController year;

//   void dispose() {
//     name.dispose();
//     organization.dispose();
//     year.dispose();
//   }
// }

// class QualificationsStep extends StatefulWidget {
//   const QualificationsStep({super.key});

//   @override
//   State<QualificationsStep> createState() => _QualificationsStepState();
// }

// class _QualificationsStepState extends State<QualificationsStep> {
//   static const _maxDegrees = 5;
//   static const _maxFellowships = 5;

//   static const _highestQualifications = [
//     'MBBS',
//     'BDS',
//     'BAMS',
//     'BHMS',
//     'MD',
//     'MS',
//     'DNB',
//     'MDS',
//     'DM',
//     'MCh',
//     'Other',
//   ];

//   // Empty by default — no pre-selected value, shows the hint instead.
//   String? _highestQualification;

//   // Both lists start empty — the empty-state placeholder shows until
//   // the user taps "Add degree" / "Add fellowship".
//   final List<_Degree> _degrees = [];
//   final List<_Fellowship> _fellowships = [];

//   @override
//   void dispose() {
//     for (final d in _degrees) {
//       d.dispose();
//     }
//     for (final f in _fellowships) {
//       f.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         LabeledField(
//           label: 'Highest qualification',
//           isRequired: true,
//           child: AppDropdown(
//             value: _highestQualification,
//             hint: 'Select highest qualification',
//             items: _highestQualifications,
//             onChanged: (v) => setState(() => _highestQualification = v),
//           ),
//         ),
//         const SizedBox(height: 32),

//         // ---------------- Degrees ----------------
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const SubHeading('Degrees'),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${_degrees.length}/$_maxDegrees',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall
//                       ?.copyWith(color: Colors.red),
//                 ),
//               ],
//             ),
//             AddEntryButton(
//               label: 'Add degree',
//               onPressed: () {
//                 if (_degrees.length < _maxDegrees) {
//                   setState(() => _degrees.add(_Degree()));
//                 }
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         if (_degrees.isEmpty)
//           _EmptyState(
//             icon: Icons.school_outlined,
//             message: 'Add the degrees you hold, starting with your latest',
//           )
//         else
//           for (var i = 0; i < _degrees.length; i++) ...[
//             RepeatCard(
//               title: 'Degree ${i + 1}',
//               onRemove: () => setState(() => _degrees.removeAt(i).dispose()),
//               child: Column(
//                 children: [
//                   TwoColumn(
//                     left: LabeledField(
//                       label: 'Degree',
//                       isRequired: true,
//                       child: AppTextField(
//                         controller: _degrees[i].degree,
//                         hint: 'e.g. MBBS',
//                       ),
//                     ),
//                     right: LabeledField(
//                       label: 'Specialization',
//                       isRequired: true,
//                       child: AppTextField(
//                         controller: _degrees[i].specialization,
//                         hint: 'e.g. General Surgery',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TwoColumn(
//                     left: LabeledField(
//                       label: 'Institution',
//                       isRequired: true,
//                       child: AppTextField(
//                         controller: _degrees[i].institution,
//                         hint: 'e.g. AIIMS Delhi',
//                       ),
//                     ),
//                     right: LabeledField(
//                       label: 'Year of completion',
//                       child: AppTextField(
//                         controller: _degrees[i].year,
//                         hint: 'e.g. 2020',
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(4),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],

//         const SizedBox(height: 16),

//         // ---------------- Fellowships & certifications ----------------
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const SubHeading('Fellowships &\n certifications'),
//                 const SizedBox(width: 16),
//                 Text(
//                   '${_fellowships.length}/$_maxFellowships',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall
//                       ?.copyWith(color: AppColors.primary),
//                 ),
//               ],
//             ),
//             AddEntryButton(
//               label: 'Add fellowship',
//               onPressed: () {
//                 if (_fellowships.length < _maxFellowships) {
//                   setState(() => _fellowships.add(_Fellowship()));
//                 }
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         if (_fellowships.isEmpty)
//           _EmptyState(
//             icon: Icons.workspace_premium_outlined,
//             message:
//                 'No fellowships added yet. Add any extra training or certifications.',
//           )
//         else
//           for (var i = 0; i < _fellowships.length; i++) ...[
//             RepeatCard(
//               title: 'Fellowship ${i + 1}',
//               onRemove: () =>
//                   setState(() => _fellowships.removeAt(i).dispose()),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   LabeledField(
//                     label: 'Fellowship / certification name',
//                     child: AppTextField(
//                       controller: _fellowships[i].name,
//                       hint: 'e.g. Fellowship in Diabetology',
//                     ),
//                   ),
//                   const SizedBox(height: 8,),
//                   LabeledField(
//                     label: 'Awarding organization',
//                     child: AppTextField(
//                       controller: _fellowships[i].organization,
//                       hint: 'e.g. Royal College of Physicians',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   LabeledField(
//                     label: 'Year',
//                     child: AppTextField(
//                       controller: _fellowships[i].year,
//                       hint: 'e.g. 2023',
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(4),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//       ],
//     );
//   }
// }

// /// Placeholder shown inside a section (Degrees / Fellowships) when its
// /// list is empty — matches the pink empty-state card in the design.
// class _EmptyState extends StatelessWidget {
//   const _EmptyState({required this.icon, required this.message});

//   final IconData icon;
//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFCEEF0),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.red, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium
//                 ?.copyWith(color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

class _Degree {
  _Degree()
      : degree = TextEditingController(),
        specialization = TextEditingController(),
        institution = TextEditingController(),
        year = TextEditingController();

  final TextEditingController degree;
  final TextEditingController specialization;
  final TextEditingController institution;
  final TextEditingController year;

  void dispose() {
    degree.dispose();
    specialization.dispose();
    institution.dispose();
    year.dispose();
  }
}

class _Fellowship {
  _Fellowship()
      : name = TextEditingController(),
        organization = TextEditingController(),
        year = TextEditingController();

  final TextEditingController name;
  final TextEditingController organization;
  final TextEditingController year;

  void dispose() {
    name.dispose();
    organization.dispose();
    year.dispose();
  }
}

class QualificationsStep extends StatefulWidget {
  const QualificationsStep({super.key, this.initialData});
  final Map<String, dynamic>? initialData;

  @override
  State<QualificationsStep> createState() => QualificationsStepState();
}

class QualificationsStepState extends State<QualificationsStep> {
  static const _maxDegrees = 5;
  static const _maxFellowships = 5;
  final _formKey = GlobalKey<FormState>();


  static const _highestQualifications = [
    'MBBS',
    'BDS',
    'BAMS',
    'BHMS',
    'MD',
    'MS',
    'DNB',
    'MDS',
    'DM',
    'MCh',
    'Other',
  ];

  // Empty by default — no pre-selected value, shows the hint instead.
  String? _highestQualification;

  // Both lists start empty — the empty-state placeholder shows until
  // the user taps "Add degree" / "Add fellowship". Because the degree
  // fields are only built when a card exists, an empty list never
  // triggers a validation error — only cards the user actually added do.
  final List<_Degree> _degrees = [];
  final List<_Fellowship> _fellowships = [];

  bool validate() {
    // Highest qualification ka dropdown bhi Form ke andar hai,
    // isliye ek hi call se sab validate ho jayega.
    return _formKey.currentState?.validate() ?? true;
  }

  @override
void initState() {
  super.initState();
  final data = widget.initialData;
  if (data == null) return;

  _highestQualification = data['highestQualification'] as String?;

  for (final raw in (data['qualificationDetails'] as List? ?? [])) {
    final e = Map<String, dynamic>.from(raw as Map);
    final degree = _Degree()
      ..degree.text = (e['degree'] ?? '').toString()
      ..specialization.text = (e['specialization'] ?? '').toString()
      ..institution.text = (e['institution'] ?? '').toString()
      ..year.text = e['year']?.toString() ?? '';
    _degrees.add(degree);
  }

  for (final raw in (data['fellowshipsCertifications'] as List? ?? [])) {
    final e = Map<String, dynamic>.from(raw as Map);
    final f = _Fellowship()
      ..name.text = (e['name'] ?? '').toString()
      ..organization.text = (e['organization'] ?? '').toString()
      ..year.text = e['year']?.toString() ?? '';
    _fellowships.add(f);
  }
}

  @override
  void dispose() {
    for (final d in _degrees) {
      d.dispose();
    }
    for (final f in _fellowships) {
      f.dispose();
    }
    super.dispose();
  }

  String? _requiredValidator(String? label, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════
  // NEW: is step ka latest data. Keys "qualifications" ke API shape
  // se match karte hain.
  // ═══════════════════════════════════════════════════════════════
  Map<String, dynamic> getData() {
    return {
      'highestQualification': _highestQualification ?? '',
      'qualificationDetails': _degrees
          .map((d) => {
                'degree': d.degree.text.trim(),
                'specialization': d.specialization.text.trim(),
                'institution': d.institution.text.trim(),
                if (d.year.text.trim().isNotEmpty)
                  'year': int.tryParse(d.year.text.trim()) ?? d.year.text.trim(),
              })
          .toList(),
      'fellowshipsCertifications': _fellowships
          .map((f) => {
                'name': f.name.text.trim(),
                'organization': f.organization.text.trim(),
                if (f.year.text.trim().isNotEmpty)
                  'year': int.tryParse(f.year.text.trim()) ?? f.year.text.trim(),
              })
          .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Highest qualification',
            isRequired: true,
            child: AppDropdown(
              value: _highestQualification,
              valiadtiontext: 'Please select any highest qualification',
              hint: 'Select highest qualification',
              items: _highestQualifications,
              onChanged: (v) => setState(() => _highestQualification = v),
            ),
          ),
          const SizedBox(height: 32),
      
          // ---------------- Degrees ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SubHeading('Degrees'),
                  const SizedBox(width: 8),
                  Text(
                    '${_degrees.length}/$_maxDegrees',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.red),
                  ),
                ],
              ),
              AddEntryButton(
                label: 'Add degree',
                onPressed: () {
                  if (_degrees.length < _maxDegrees) {
                    setState(() => _degrees.add(_Degree()));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_degrees.isEmpty)
            _EmptyState(
              icon: Icons.school_outlined,
              message: 'Add the degrees you hold, starting with your latest',
            )
          else
            for (var i = 0; i < _degrees.length; i++) ...[
              RepeatCard(
                title: 'Degree ${i + 1}',
                onRemove: () => setState(() => _degrees.removeAt(i).dispose()),
                child: Column(
                  children: [
                    TwoColumn(
                      left: LabeledField(
                        label: 'Degree',
                        isRequired: true,
                        child: AppTextField(
                          controller: _degrees[i].degree,
                          hint: 'e.g. MBBS',
                          validator: (v) => _requiredValidator('the degree', v),
                        ),
                      ),
                      right: LabeledField(
                        label: 'Specialisation',
                        isRequired: true,
                        child: AppTextField(
                          controller: _degrees[i].specialization,
                          hint: 'e.g. General Surgery',
                          validator: (v) =>
                              _requiredValidator('the specialization', v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TwoColumn(
                      left: LabeledField(
                        label: 'Institution',
                        isRequired: true,
                        child: AppTextField(
                          controller: _degrees[i].institution,
                          hint: 'e.g. AIIMS Delhi',
                          validator: (v) =>
                              _requiredValidator('the institution', v),
                        ),
                      ),
                      right: LabeledField(
                        label: 'Year of completion',
                        child: AppTextField(
                          controller: _degrees[i].year,
                          hint: 'e.g. 2020',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: validateYear,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
      
          const SizedBox(height: 16),
      
          // ---------------- Fellowships & certifications ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SubHeading('Fellowships &\n certifications'),
                  const SizedBox(width: 16),
                  Text(
                    '${_fellowships.length}/$_maxFellowships',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              AddEntryButton(
                label: 'Add fellowship',
                onPressed: () {
                  if (_fellowships.length < _maxFellowships) {
                    setState(() => _fellowships.add(_Fellowship()));
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_fellowships.isEmpty)
            _EmptyState(
              icon: Icons.workspace_premium_outlined,
              message:
                  'No fellowships added yet. Add any extra training or certifications.',
            )
          else
            for (var i = 0; i < _fellowships.length; i++) ...[
              RepeatCard(
                title: 'Fellowship ${i + 1}',
                onRemove: () =>
                    setState(() => _fellowships.removeAt(i).dispose()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledField(
                      label: 'Fellowship / certification name',
                      child: AppTextField(
                        controller: _fellowships[i].name,
                        hint: 'e.g. Fellowship in Diabetology',
                      ),
                    ),
                    const SizedBox(height: 8),
                    LabeledField(
                      label: 'Awarding organization',
                      child: AppTextField(
                        controller: _fellowships[i].organization,
                        hint: 'e.g. Royal College of Physicians',
                      ),
                    ),
                    const SizedBox(height: 8),
                    LabeledField(
                      label: 'Year',
                      child: AppTextField(
                        controller: _fellowships[i].year,
                        hint: 'e.g. 2023',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: validateYear,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
        ],
      ),
    );
  }
}

/// Placeholder shown inside a section (Degrees / Fellowships) when its
/// list is empty — matches the pink empty-state card in the design.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEEF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.red, size: 28),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}