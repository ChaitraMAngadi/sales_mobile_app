import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// "Consultation & fees" screen:
/// - Consultation modes (In-clinic / Video / Phone / Home visit / Hospital)
/// - Fees at each clinic (First consultation / Follow-up / Emergency, per clinic)
/// - Other consultation fees (Video / Phone / Home visit / Hospital – only enabled modes)
/// - Average consultation fee + Average waiting time
class ConsultationFeesStep extends StatefulWidget {
  const ConsultationFeesStep({super.key, this.initialData, this.clinicsData});

  /// API "consultation" object.
  final Map<String, dynamic>? initialData;

  /// API "clinics" list (each clinic has name, city, fees{...}).
  final List? clinicsData;

  @override
  State<ConsultationFeesStep> createState() => ConsultationFeesStepState();
}

/// Data model for one consultation mode card.
class ConsultationMode {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  bool enabled;
  final bool alwaysAvailable;

  ConsultationMode({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.enabled = false,
    this.alwaysAvailable = false,
  });
}

/// Controllers + display info for one clinic's fee card.
class _ClinicFeeEntry {
  int? id; // ClinicsStep ke _Clinic.uid se match hota hai (pehli sync tak null)
  String name;
  String city;
  final TextEditingController first = TextEditingController();
  final TextEditingController followUp = TextEditingController();
  final TextEditingController emergency = TextEditingController();

  _ClinicFeeEntry({required this.name, required this.city});

  void dispose() {
    first.dispose();
    followUp.dispose();
    emergency.dispose();
  }
}

class ConsultationFeesStepState extends State<ConsultationFeesStep> {
  static const _primaryRed = Color(0xFFE8615C);
  static final _digitsOnly = [FilteringTextInputFormatter.digitsOnly];

  // ✅ NEW: Qualifications jaisa Form key
  final _formKey = GlobalKey<FormState>();

  late final List<ConsultationMode> _modes;
  final List<_ClinicFeeEntry> _clinics = [];

  // Other consultation fees (consultation.fees.*)
  final _videoFee = TextEditingController();
  final _phoneFee = TextEditingController();
  final _homeVisitFee = TextEditingController();
  final _hospitalFee = TextEditingController();
  final _avgConsultationFee = TextEditingController();
  final _avgWaitingTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    _modes = [
      ConsultationMode(
        key: 'in_clinic',
        title: 'In-clinic',
        subtitle: 'Always available',
        icon: Icons.local_hospital_outlined,
        enabled: true,
        alwaysAvailable: true,
      ),
      ConsultationMode(
        key: 'video',
        title: 'Video',
        subtitle: 'Online video consultations',
        icon: Icons.videocam_outlined,
      ),
      ConsultationMode(
        key: 'phone',
        title: 'Phone',
        subtitle: 'Audio call consultations',
        icon: Icons.call_outlined,
      ),
      ConsultationMode(
        key: 'home_visit',
        title: 'Home visit',
        subtitle: "You visit the patient's home",
        icon: Icons.home_outlined,
      ),
      ConsultationMode(
        key: 'hospital',
        title: 'Hospital',
        subtitle: 'Consultations at a hospital',
        icon: Icons.apartment_outlined,
      ),
    ];

    _prefillConsultation();
    _prefillClinics();
  }

  String _feeText(dynamic feeObj) {
    if (feeObj is Map && feeObj['fee'] != null) return feeObj['fee'].toString();
    return '';
  }

  void _prefillConsultation() {
    final c = widget.initialData;
    if (c == null) return;

    const apiKeyFor = {
      'video': 'video',
      'phone': 'phone',
      'home_visit': 'homeVisit',
      'hospital': 'hospital',
    };
    for (final m in _modes) {
      if (m.alwaysAvailable) continue;
      final k = apiKeyFor[m.key];
      if (k != null && c[k] == true) m.enabled = true;
    }

    final fees = c['fees'] is Map ? c['fees'] as Map : const {};
    // Backend disabled mode ki fee 0 bhejta hai -> field khali dikhao.
    String modeFee(dynamic f) {
      final t = _feeText(f);
      return t == '0' ? '' : t;
    }

    _videoFee.text = modeFee(fees['video']);
    _phoneFee.text = modeFee(fees['phone']);
    _homeVisitFee.text = modeFee(fees['homeVisit']);
    _hospitalFee.text = modeFee(fees['hospital']);
    _avgConsultationFee.text = _feeText(fees['averageConsultationFee']);

    if (c['averageWaitingDuration'] != null) {
      _avgWaitingTime.text = c['averageWaitingDuration'].toString();
    }
  }

  void _prefillClinics() {
    final list = widget.clinicsData;
    if (list == null) return;
    for (final raw in list) {
      if (raw is! Map) continue;
      final clinic = Map<String, dynamic>.from(raw);
      final address =
          clinic['address'] is Map ? clinic['address'] as Map : const {};
      final entry = _ClinicFeeEntry(
        name: (clinic['name'] ?? clinic['clinicName'] ?? 'Clinic').toString(),
        city: (clinic['city'] ?? address['city'] ?? '').toString(),
      );
      final fees = clinic['fees'] is Map ? clinic['fees'] as Map : const {};
      entry.first.text = _feeText(fees['firstConsultation']);
      entry.followUp.text = _feeText(fees['followUp']);
      entry.emergency.text = _feeText(fees['emergency']);
      _clinics.add(entry);
    }
  }

  /// Parent isse tab call karta hai jab Fees step khulta hai.
  /// - jo clinics pehle se hain unki typed fees safe rehti hain
  /// - nayi add hui clinic ka card ban jata hai
  /// - delete hui clinic ka card hat jata hai
  /// - naam/city update hote hain, aur order ClinicsStep jaisa hi rehta hai
  void syncClinics(List<Map<String, dynamic>> summaries) {
    final old = List<_ClinicFeeEntry>.from(_clinics);
    final next = <_ClinicFeeEntry>[];

    for (var i = 0; i < summaries.length; i++) {
      final s = summaries[i];
      final id = s['id'] as int;

      _ClinicFeeEntry? e;
      for (final o in old) {
        if (o.id == id) {
          e = o;
          break;
        }
      }
      // Pehli sync: API se prefill hui entries ka id null hota hai -> position se match.
      if (e == null && i < old.length && old[i].id == null) e = old[i];

      e ??= _ClinicFeeEntry(
        name: s['name'] as String,
        city: s['city'] as String,
      );
      e.id = id;
      e.name = s['name'] as String;
      e.city = s['city'] as String;
      next.add(e);
    }

    for (final o in old) {
      if (!next.contains(o)) o.dispose();
    }

    setState(() {
      _clinics
        ..clear()
        ..addAll(next);
    });
  }

  @override
  void dispose() {
    for (final c in _clinics) {
      c.dispose();
    }
    _videoFee.dispose();
    _phoneFee.dispose();
    _homeVisitFee.dispose();
    _hospitalFee.dispose();
    _avgConsultationFee.dispose();
    _avgWaitingTime.dispose();
    super.dispose();
  }

  void _toggleMode(ConsultationMode mode, bool value) {
    if (mode.alwaysAvailable) return;
    setState(() => mode.enabled = value);
  }

  bool _modeEnabled(String key) =>
      _modes.firstWhere((m) => m.key == key).enabled;

  int? _int(TextEditingController c) =>
      c.text.trim().isEmpty ? null : int.tryParse(c.text.trim());

  /// Returns:
  ///  - 'consultation': modes + other fees + avg fee + avg waiting time
  ///  - 'clinicFees'  : List, same order as the clinics list. Each item is
  ///                    {firstConsultation:{fee}, followUp:{fee}, emergency:{fee}}
  Map<String, dynamic> getData() {
    // Disabled mode ki fee 0 bhejte hain.
    int feeFor(String modeKey, TextEditingController c) =>
        _modeEnabled(modeKey) ? (_int(c) ?? 0) : 0;

    return {
      'consultation': {
        'inClinic': true,
        'video': _modeEnabled('video'),
        'phone': _modeEnabled('phone'),
        'homeVisit': _modeEnabled('home_visit'),
        'hospital': _modeEnabled('hospital'),
        'fees': {
          'video': {'fee': feeFor('video', _videoFee)},
          'phone': {'fee': feeFor('phone', _phoneFee)},
          'homeVisit': {'fee': feeFor('home_visit', _homeVisitFee)},
          'hospital': {'fee': feeFor('hospital', _hospitalFee)},
          'averageConsultationFee': {'fee': _int(_avgConsultationFee) ?? 0},
        },
        // Backend Joi number null allow nahi karta -> khali ho to key hi mat bhejo.
        if (_int(_avgWaitingTime) != null)
          'averageWaitingDuration': _int(_avgWaitingTime),
      },
      'clinicFees': [
        for (final c in _clinics)
          {
            'firstConsultation': {'fee': _int(c.first) ?? 0},
            'followUp': {'fee': _int(c.followUp) ?? 0},
            'emergency': {'fee': _int(c.emergency) ?? 0},
          },
      ],
    };
  }

  /// Ready-made merge: clinics list lo, har clinic ki `fees` ko Map bana ke do.
  List<Map<String, dynamic>> mergeFeesInto(List clinics) {
    final clinicFees = getData()['clinicFees'] as List;
    return [
      for (int i = 0; i < clinics.length; i++)
        () {
          final clinic = clinics[i] is Map
              ? Map<String, dynamic>.from(clinics[i] as Map)
              : <String, dynamic>{};
          final existing = clinic['fees'] is Map
              ? Map<String, dynamic>.from(clinic['fees'] as Map)
              : <String, dynamic>{};
          clinic['fees'] = {
            ...existing,
            if (i < clinicFees.length)
              ...Map<String, dynamic>.from(clinicFees[i] as Map),
          };
          return clinic;
        }(),
    ];
  }

  /// ✅ CHANGED: Qualifications jaisa — Form.validate() se saare fee fields
  /// ek saath check hote hain aur red error text dikhta hai.
  /// Required: har clinic ki first consultation fee + average consultation fee.
  bool validate() {
    return _formKey.currentState?.validate() ?? true;
  }

  // ✅ NEW: validators
  String? _requiredFee(String label, String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Please enter $label';
    if ((int.tryParse(t) ?? 0) <= 0) return 'Enter an amount greater than 0';
    return null;
  }

  // ─────────────────────────── UI ───────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _sectionTitle('Consultation modes'),
              const SizedBox(height: 12),
              _buildModesGrid(),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildClinicFeesSection(),
              ..._buildOtherFeesSection(),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildAverageSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.medical_services_outlined,
              color: _primaryRed, size: 20),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Consultation & fees',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('How patients can consult you and what each visit costs',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ],
      ],
    );
  }

  // ── Modes ──

  Widget _buildModesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 520;
        if (!isWide) {
          return Column(
            children: _modes
                .map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ModeCard(
                        mode: m,
                        primaryColor: _primaryRed,
                        onChanged: (v) => _toggleMode(m, v),
                      ),
                    ))
                .toList(),
          );
        }
        const spacing = 12.0;
        final cardWidth = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _modes
              .map((m) => SizedBox(
                    width: cardWidth,
                    child: _ModeCard(
                      mode: m,
                      primaryColor: _primaryRed,
                      onChanged: (v) => _toggleMode(m, v),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  // ── Fees at each clinic ──

  Widget _buildClinicFeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Fees at each clinic',
            subtitle: 'What a patient pays for a visit at each location'),
        const SizedBox(height: 14),
        if (_clinics.isEmpty)
          const Text('Add a clinic first to set its fees',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey))
        else
          for (final c in _clinics) ...[
            KeyedSubtree(key: ObjectKey(c), child: _buildClinicCard(c)),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  Widget _buildClinicCard(_ClinicFeeEntry clinic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryRed.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 16, color: _primaryRed),
              const SizedBox(width: 6),
              Flexible(
                child: Text(clinic.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              if (clinic.city.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(clinic.city,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.blueGrey)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          _responsiveRow([
            _feeField(
              label: 'First consultation',
              subtitle: 'New patient visit',
              controller: clinic.first,
              required: true,
              validator: (v) =>
                  _requiredFee('the first consultation fee', v),
            ),
            _feeField(
              label: 'Follow-up',
              subtitle: 'Returning patient visit',
              controller: clinic.followUp,
            ),
            _feeField(
              label: 'Emergency',
              subtitle: 'Urgent or after-hours care',
              controller: clinic.emergency,
            ),
          ], columns: 3),
        ],
      ),
    );
  }

  // ── Other consultation fees ──

  List<Widget> _buildOtherFeesSection() {
    final fields = <Widget>[
      if (_modeEnabled('video'))
        _feeField(
          label: 'Video consultation',
          subtitle: 'Online consultation',
          controller: _videoFee,
        ),
      if (_modeEnabled('phone'))
        _feeField(
          label: 'Phone consultation',
          subtitle: 'Audio call consultation',
          controller: _phoneFee,
        ),
      if (_modeEnabled('home_visit'))
        _feeField(
          label: 'Home visit consultation',
          subtitle: "Visit at the patient's home",
          controller: _homeVisitFee,
        ),
      if (_modeEnabled('hospital'))
        _feeField(
          label: 'Hospital consultation',
          subtitle: 'Consultation at a hospital',
          controller: _hospitalFee,
        ),
    ];
    if (fields.isEmpty) return const [];

    return [
      const SizedBox(height: 24),
      const Divider(height: 1),
      const SizedBox(height: 20),
      _sectionTitle('Other consultation fees',
          subtitle:
              "For consultations that don't happen at one of your clinics"),
      const SizedBox(height: 14),
      _responsiveRow(fields, columns: 2),
    ];
  }

  // ── Average fee + waiting time ──

  Widget _buildAverageSection() {
    return _responsiveRow([
      _feeField(
        label: 'Average consultation fee',
        subtitle: 'A typical fee across your consultations, shown as a guide',
        controller: _avgConsultationFee,
        required: true,
        validator: (v) => _requiredFee('the average consultation fee', v),
      ),
      _minutesField(),
    ], columns: 2);
  }

  Widget _minutesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Average waiting time',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        const Text('Helps show patients a realistic waiting time',
            style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
  child: TextFormField(
    controller: _avgWaitingTime,
    keyboardType: TextInputType.number,
    inputFormatters: _digitsOnly,
    validator: (v) {
      final t = v?.trim() ?? '';
      if (t.isEmpty) return null; // optional
      if ((int.tryParse(t) ?? 0) < 1) return 'Must be at least 1 minute';
      return null;
    },
    decoration: _inputDecoration(
      prefixIcon: const Icon(Icons.access_time, size: 18),
      hint: 'e.g. 12',
    ),
  ),
),
            // Expanded(
            //   child: TextFormField(
            //     controller: _avgWaitingTime,
            //     keyboardType: TextInputType.number,
            //     inputFormatters: _digitsOnly,
            //     decoration: _inputDecoration(
            //       prefixIcon: const Icon(Icons.access_time, size: 18),
            //       hint: 'e.g. 12',
            //     ),
            //   ),
            // ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _primaryRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('min',
                  style: TextStyle(
                      fontSize: 12,
                      color: _primaryRed,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  // ── Helpers ──

  /// Wide screen pe `columns` ke hisaab se rows, narrow pe ek ke neeche ek.
  Widget _responsiveRow(List<Widget> children, {required int columns}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 520;
        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                children[i],
              ],
            ],
          );
        }
        const spacing = 16.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: [
            for (final c in children) SizedBox(width: width, child: c),
          ],
        );
      },
    );
  }

  Widget _feeField({
    required String label,
    required String subtitle,
    required TextEditingController controller,
    bool required = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            children: [
              if (required)
                const TextSpan(
                    text: ' *', style: TextStyle(color: _primaryRed)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        // ✅ CHANGED: TextField -> TextFormField so Form.validate() can check it
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: _digitsOnly,
          validator: validator,
          decoration: _inputDecoration(prefixText: '₹   ', hint: 'e.g. 600'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? prefixText,
    Widget? prefixIcon,
    String? hint,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        );
    return InputDecoration(
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: border(Colors.grey.shade300),
      enabledBorder: border(Colors.grey.shade300),
      focusedBorder: border(_primaryRed),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }
}

/// A single toggleable consultation-mode card.
class _ModeCard extends StatelessWidget {
  final ConsultationMode mode;
  final Color primaryColor;
  final ValueChanged<bool> onChanged;

  const _ModeCard({
    required this.mode,
    required this.primaryColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = mode.enabled;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? primaryColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? primaryColor : Colors.grey.shade300,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: selected
                  ? primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(mode.icon,
                size: 18,
                color: selected ? primaryColor : Colors.blueGrey.shade700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  mode.subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: mode.enabled,
            onChanged: mode.alwaysAvailable ? null : onChanged,
            activeColor: Colors.white,
            activeTrackColor: primaryColor,
          ),
        ],
      ),
    );
  }
}