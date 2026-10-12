import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/availabilitySteps.dart';
import 'package:sales_mobile_app/pages/basicInfoSteps.dart';
import 'package:sales_mobile_app/pages/clinicsSteps.dart';
import 'package:sales_mobile_app/pages/feesSteps.dart';
import 'package:sales_mobile_app/pages/qualificationSteps.dart';
import 'package:sales_mobile_app/pages/specializationSteps.dart';
import 'package:sales_mobile_app/provider/marketingProvider.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

/// Uses only AppColors.primary, AppColors.primaryGradient and
/// AppColors.badgeBg from your own theme file.

const _pageBackground = Color(0xFFFEF6F6);

/// White rounded card with a soft shadow (replaces the commented-out
/// `appCardDecoration`).
BoxDecoration _cardDecoration([double radius = 12]) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );

class _StepMeta {
  const _StepMeta(this.label, this.title, this.subtitle, this.icon);
  final String label; // shown under the circle in the stepper
  final String title; // section heading inside the form card
  final String subtitle;
  final IconData icon;
}

const _steps = <_StepMeta>[
  _StepMeta('Basic info', 'Basic information',
      'Your name, photo and contact details as patients will see them',
      Icons.person_outline_rounded),
  _StepMeta('Qualifications', 'Qualifications',
      'Degrees and registration that build trust with patients',
      Icons.school_outlined),
  _StepMeta('Specialisation', 'Specialisation',
      'What you treat and the services you offer',
      Icons.medical_services_outlined),
  _StepMeta('Clinics', 'Clinics & hospitals', 'Where patients can visit you',
      Icons.apartment_outlined),
  _StepMeta('Fees', 'Consultation & fees',
      'What patients pay for each type of consultation',
      Icons.account_balance_wallet_outlined),
  _StepMeta('Availability', 'Availability',
      'The days and hours patients can book you',
      Icons.event_available_outlined),
];

class MarketingProfilePage extends StatefulWidget {
  const MarketingProfilePage({
    super.key,
    required this.id,
    this.initialData,
    this.isEdit = false,
  });

  final String id;
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  @override
  State<MarketingProfilePage> createState() => _MarketingProfilePageState();
}

class _MarketingProfilePageState extends State<MarketingProfilePage> {
  int _step = 0;
  double _strength = 0;
  bool _saving = false;

  final _scroll = ScrollController();

  // Bumped on every reset. Each step gets a fresh GlobalKey, so Flutter
  // throws away its state and rebuilds it from its initial values.
  int _resetCount = 0;

  // Only BasicInfoStep wraps its fields in a Form — this key is ONLY for
  // Form validation (fullName required, mobile 10 digits, etc). It has
  // nothing to do with reading data back out; that's what the
  // GlobalKey<XStepState> keys below are for.
  GlobalKey<FormState> _basicFormKey = GlobalKey<FormState>();

  // One GlobalKey per step, typed to that step's public State class.
  // Used after Save/Next to call step.currentState?.getData().
  GlobalKey<BasicInfoStepState> _basicKey = GlobalKey<BasicInfoStepState>();
  GlobalKey<QualificationsStepState> _qualKey =
      GlobalKey<QualificationsStepState>();
  GlobalKey<SpecialisationStepState> _specKey =
      GlobalKey<SpecialisationStepState>();
  GlobalKey<ClinicsStepState> _clinicsKey = GlobalKey<ClinicsStepState>();
  GlobalKey<ConsultationFeesStepState> _feesKey =
      GlobalKey<ConsultationFeesStepState>();
  GlobalKey<AvailabilityStepState> _availKey =
      GlobalKey<AvailabilityStepState>();

  late List<Widget> _bodies;
  late Future fetchdoctordetails;

  double _calculateStrength() {
    final d = widget.initialData;
    if (d == null) return 0;

    double sectionScore(List<bool> checks) {
      if (checks.isEmpty) return 0;
      final filled = checks.where((c) => c).length;
      return filled / checks.length;
    }

    bool notEmpty(dynamic v) {
      if (v == null) return false;
      if (v is String) return v.trim().isNotEmpty;
      if (v is List) return v.isNotEmpty;
      if (v is Map) return v.isNotEmpty;
      return true; // numbers, bools, etc.
    }

    // 1. Basic info
    final basic = d['basicInformation'] as Map<String, dynamic>?;
    final basicScore = sectionScore([
      notEmpty(basic?['fullName']),
      notEmpty(basic?['gender']),
      notEmpty(basic?['dateOfBirth']),
      notEmpty(basic?['mobileNumber']),
      notEmpty(basic?['email']),
      notEmpty(basic?['languagesSpoken']),
      notEmpty(basic?['yearsOfExperience']),
      notEmpty(basic?['medicalRegistrationNumber']),
      notEmpty(basic?['registrationYear']),
    ]);

    // 2. Qualifications
    final qual = d['qualifications'] as Map<String, dynamic>?;
    final qualScore = sectionScore([
      notEmpty(qual?['highestQualification']),
      notEmpty(qual?['qualificationDetails']),
    ]);

    // 3. Specialisation
    final spec = d['specialisation'] as Map<String, dynamic>?;
    final specScore = sectionScore([
      notEmpty(spec?['primarySpecialisation']),
      notEmpty(spec?['conditionsTreated']),
      notEmpty(spec?['areasOfExpertise']),
      notEmpty(spec?['keywords']),
    ]);

    // 4. Clinics
    final clinics = d['clinics'] as List?;
    final clinicsScore = notEmpty(clinics) ? 1.0 : 0.0;

    // 5. Consultation & fees
    final consult = d['consultation'] as Map<String, dynamic>?;
    final consultScore = sectionScore([
      consult?['inClinic'] == true ||
          consult?['video'] == true ||
          consult?['phone'] == true ||
          consult?['homeVisit'] == true ||
          consult?['hospital'] == true,
      notEmpty((consult?['fees'] as Map?)?['averageConsultationFee']),
    ]);

    // 6. Availability (at least one clinic has at least one enabled day)
    bool hasAvailability = false;
    if (clinics != null) {
      for (final c in clinics) {
        final avail = (c as Map)['availability'] as Map?;
        if (avail != null &&
            avail.values.any((v) => v is Map && v['enabled'] == true)) {
          hasAvailability = true;
          break;
        }
      }
    }
    final availScore = hasAvailability ? 1.0 : 0.0;

    final overall = (basicScore +
            qualScore +
            specScore +
            clinicsScore +
            consultScore +
            availScore) /
        6;

    return overall.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _bodies = _buildBodies();
    _strength = _calculateStrength();

    final marketingprovider = context.read<Marketingprovider>();
    fetchdoctordetails =
        marketingprovider.getdoctoralldetails(context, widget.id);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Widget> _buildBodies() {
    final d = widget.initialData;
    return [
      BasicInfoStep(
        key: _basicKey,
        formKey: _basicFormKey,
        initialData: d?['basicInformation'],
        doctorId: widget.id,
      ),
      QualificationsStep(key: _qualKey, initialData: d?['qualifications']),
      SpecialisationStep(key: _specKey, initialData: d?['specialisation']),
      ClinicsStep(key: _clinicsKey, initialData: d?['clinics']),
      ConsultationFeesStep(
        key: _feesKey,
        initialData: d?['consultation'],
        clinicsData: d?['clinics'],
      ),
      AvailabilityStep(key: _availKey, initialData: d?['clinics']),
    ];
  }

  bool get _isLast => _step == _steps.length - 1;

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ✅ CHANGED: Fees step (index 4) khulne par clinics list sync hoti hai.
  // Next, Previous aur stepper tap — teeno isi function se guzarte hain.
  // void _goTo(int i) {
  //   if (i == 4) {
  //     final summaries = _clinicsKey.currentState?.getSummaries();
  //     if (summaries != null) {
  //       _feesKey.currentState?.syncClinics(summaries);
  //     }
  //   }
  //   setState(() => _step = i);
  //   _scrollToTop();
  // }

  void _syncClinicSteps() {
  final summaries = _clinicsKey.currentState?.getSummaries();
  if (summaries == null) return;
  _feesKey.currentState?.syncClinics(summaries);
  _availKey.currentState?.syncClinics(summaries);
}

void _goTo(int i) {
  if (i >= 4) _syncClinicSteps(); // Fees (4) ya Availability (5) khulne par
  setState(() => _step = i);
  _scrollToTop();
}

  void _previous() {
    if (_step == 0) return;
    _goTo(_step - 1);
  }

  // ═══════════════════════════════════════════════════════════════
  // Har step ke getData() se combine karke ek final payload banao.
  // fees/availability per-clinic hoti hain API mein, isliye ClinicsStep
  // se aayi har clinic mein wahi (shared) fees/availability merge kar
  // rahe hain.
  // ═══════════════════════════════════════════════════════════════

  /// src List ho to i-th item lo, Map ho to wahi use karo, warna fallback.
  Map<String, dynamic> _objectFor(dynamic src, int i, [dynamic fallback]) {
    if (src is List && i < src.length && src[i] is Map) {
      return Map<String, dynamic>.from(src[i] as Map);
    }
    if (src is Map) return Map<String, dynamic>.from(src);
    if (fallback is Map) return Map<String, dynamic>.from(fallback);
    return <String, dynamic>{};
  }

  Map<String, dynamic> _buildPayload() {
    final basic = _basicKey.currentState?.getData() ?? {};
    final qual = _qualKey.currentState?.getData() ?? {};
    final spec = _specKey.currentState?.getData() ?? {};
    final clinicsList =
        (_clinicsKey.currentState?.getData() as List?) ?? const [];
    final feesState = _feesKey.currentState;
    final feesData = feesState?.getData() ?? {};
    final availData = _availKey.currentState?.getData();

    // 1) Fees: clinicFees[i] -> clinics[i].fees (always an object)
    final withFees = feesState != null
        ? feesState.mergeFeesInto(clinicsList)
        : [
            for (final c in clinicsList)
              if (c is Map) Map<String, dynamic>.from(c),
          ];

    // 2) Availability: per-clinic object (List or single Map, both handled)
    final mergedClinics = [
      for (int i = 0; i < withFees.length; i++)
        {
          ...withFees[i],
          'availability':
              _objectFor(availData, i, withFees[i]['availability']),
        },
    ];

    return {
      'basicInformation': basic,
      'qualifications': qual,
      'specialisation': spec,
      'clinics': mergedClinics,
      'consultation': feesData['consultation'] ?? {},
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // ✅ NEW: ek jagah se har step ki validation.
  // Next button aur Save button dono yahi use karte hain, isliye ab
  // koi step khali chhod ke Save nahi kar sakta.
  // ═══════════════════════════════════════════════════════════════

  /// true = is step ke saare fields theek hain.
  bool _validateStep(int step) {
    switch (step) {
      case 0:
        // BasicInfoStep ka Form seedha _basicFormKey se validate hota hai
        return _basicFormKey.currentState?.validate() ?? true;
      case 1:
        return _qualKey.currentState?.validate() ?? true;
      case 2:
        return _specKey.currentState?.validate() ?? true;
      case 3:
        return _clinicsKey.currentState?.validate() ?? true;
      case 4:
        return _feesKey.currentState?.validate() ?? true;
      default:
        return true; // Availability step me abhi koi validation nahi hai
    }
  }

  /// Saare steps check karta hai (sab ke error text ek saath set ho jaate
  /// hain) aur PEHLA fail hone wala step number return karta hai.
  /// null = sab theek.
  int? _firstInvalidStep() {
    int? first;
    for (var i = 0; i < _steps.length; i++) {
      if (!_validateStep(i) && first == null) first = i;
    }
    return first;
  }

  Future<void> _next() async {
    // Save profile (last step): pehle SAARE steps validate karo
    if (_isLast) {
      await _saveProfile();
      return;
    }

    // Normal Next: sirf current step validate karo
    if (!_validateStep(_step)) {
      _showFixSnack();
      return;
    }
    _goTo(_step + 1);
  }

  void _showFixSnack([String? stepName]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          stepName == null
              ? 'Please fix the highlighted fields'
              : 'Please fix the highlighted fields in "$stepName"',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // ✅ CHANGED: Basic info se Fees tak har step check hota hai.
    // Jo step pehle fail ho, user ko seedha us step par le jaate hain
    // (red error text wahan already dikh raha hota hai).


// _syncClinicSteps();
//   await WidgetsBinding.instance.endOfFrame; // naye cards build hone do, phir validate


_syncClinicSteps();
  await WidgetsBinding.instance.endOfFrame;

  // Availability: break working hours ke andar hona chahiye
  final availErr = _availKey.currentState?.validate();
  if (availErr != null) {
    setState(() => _step = 5); // Availability step ka index (apne hisaab se badlo)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(availErr)),
    );
    return;
  }

    final bad = _firstInvalidStep();
    if (bad != null) {
      _goTo(bad);
      _showFixSnack(_steps[bad].label);
      return;
    }
    setState(() => _saving = true);
    final marketingprovider = context.read<Marketingprovider>();
    final payload = _buildPayload();

    try {
      final ok = widget.isEdit
          ? await marketingprovider.updateMarketingProfile(
              context, widget.id, payload)
          : await marketingprovider.createMarketingProfile(
              context, widget.id, payload);

      if (!mounted) return;
      setState(() => _saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? (widget.isEdit ? 'Profile updated' : 'Marketing profile saved')
              : 'Something went wrong, try again'),
        ),
      );
      if (ok) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all steps?'),
        content: const Text(
          'Everything you changed in all 6 steps will be discarded and the '
          'form goes back to your last saved profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) _resetAll();
  }

  void _resetAll() {
    setState(() {
      _resetCount++;
      _basicFormKey = GlobalKey<FormState>();
      _basicKey = GlobalKey<BasicInfoStepState>();
      _qualKey = GlobalKey<QualificationsStepState>();
      _specKey = GlobalKey<SpecialisationStepState>();
      _clinicsKey = GlobalKey<ClinicsStepState>();
      _feesKey = GlobalKey<ConsultationFeesStepState>();
      _availKey = GlobalKey<AvailabilityStepState>();
      _bodies = _buildBodies();
      _strength = _calculateStrength();
      _step = 0;
    });
    _scrollToTop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All steps have been reset')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: const Text(
          'Marketing Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final wide = box.maxWidth >= 900;
          final pad = box.maxWidth >= 600 ? 40.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(pad, 32, pad, 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(wide: wide, strength: _strength),
                    const SizedBox(height: 32),
                    _StepperBar(current: _step, onSelect: _goTo),
                    const SizedBox(height: 32),
                    _buildFormCard(wide),
                    const SizedBox(height: 24),
                    _BottomBar(
                      step: _step,
                      total: _steps.length,
                      nextLabel: _isLast
                          ? (_saving ? 'Saving...' : 'Save profile')
                          : 'Next : ${_steps[_step + 1].label}',
                      isLast: _isLast,
                      onPrevious: _step > 0 ? _previous : null,
                      onReset: _confirmReset,
                      onNext: _saving ? null : _next,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFormCard(bool wide) {
    final meta = _steps[_step];
    final inner = wide ? 40.0 : 20.0;

    return Container(
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 4, color: AppColors.primary),
            Padding(
              padding: EdgeInsets.all(inner),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(meta: meta),
                  const SizedBox(height: 32),
                  // Offstage keeps every step mounted so typed data isn't
                  // lost when the user moves between steps.
                  for (var i = 0; i < _bodies.length; i++)
                    Offstage(offstage: i != _step, child: _bodies[i]),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.step,
    required this.total,
    required this.nextLabel,
    required this.isLast,
    required this.onPrevious,
    required this.onReset,
    required this.onNext,
  });

  final int step;
  final int total;
  final String nextLabel;
  final bool isLast;
  final VoidCallback? onPrevious; // null on the first step
  final VoidCallback onReset;
  final VoidCallback? onNext; // null while saving (disables the button)

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final narrow = box.maxWidth < 760;

      final status = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Step ${step + 1} of $total',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Fields marked * are required',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      );

      final previous = onPrevious == null
          ? null
          : OutlinedButton.icon(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 44),
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );

      final reset = TextButton.icon(
        onPressed: onReset,
        icon: const Icon(Icons.refresh_rounded, size: 22),
        label: const Text('Reset',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black54,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      );

      final next = _GradientButton(
        label: nextLabel,
        icon: isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
        onPressed: onNext,
      );

      return Container(
        padding:
            EdgeInsets.symmetric(horizontal: narrow ? 16 : 24, vertical: 14),
        decoration: _cardDecoration(14),
        child: narrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: status),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      previous ?? const SizedBox.shrink(),
                      reset,
                    ],
                  ),
                  const SizedBox(height: 8),
                  next,
                ],
              )
            : Row(
                children: [
                  if (previous != null) previous,
                  Expanded(child: Center(child: status)),
                  reset,
                  const SizedBox(width: 16),
                  next,
                ],
              ),
      );
    });
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    final disabled = onPressed == null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: radius,
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Opacity(
        opacity: disabled ? 0.6 : 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(icon, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Header ─────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.wide, required this.strength});

  final bool wide;
  final double strength;

  @override
  Widget build(BuildContext context) {
    final title = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Build the public profile patients see when they search for a doctor',
                style: TextStyle(fontSize: 17, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: title),
          const SizedBox(width: 16),
          SizedBox(width: 324, child: _StrengthCard(value: strength)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title,
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _StrengthCard(value: strength)),
          ],
        ),
      ],
    );
  }
}

class _StrengthCard extends StatelessWidget {
  const _StrengthCard({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      decoration: _cardDecoration(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Profile strength',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: AppColors.primary,
              backgroundColor: AppColors.badgeBg,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Stepper ─────────────────────────

class _StepperBar extends StatelessWidget {
  const _StepperBar({required this.current, required this.onSelect});

  final int current;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          _StepItem(
            index: i,
            meta: _steps[i],
            current: current,
            onTap: () => onSelect(i),
          ),
          if (i < _steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 8, right: 8),
              child: Container(
                height: 2,
                width: 12,
                decoration: BoxDecoration(
                  color:
                      i < current ? AppColors.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: _cardDecoration(),
      child: LayoutBuilder(builder: (context, box) {
        const minWidth = 500.0;
        if (box.maxWidth < minWidth) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: minWidth, child: row),
          );
        }
        return row;
      }),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.meta,
    required this.current,
    required this.onTap,
  });

  final int index;
  final _StepMeta meta;
  final int current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final done = index < current;

    final Widget circle = Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active ? AppColors.primaryGradient : null,
        color: active
            ? null
            : done
                ? AppColors.primary
                : Colors.white,
        border: active
            ? null
            : Border.all(
                color: done ? AppColors.primary : Colors.grey.shade300,
                width: 1.5,
              ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Icon(
        done ? Icons.check_rounded : meta.icon,
        size: 22,
        color: (active || done) ? Colors.white : Colors.grey,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            circle,
            const SizedBox(height: 10),
            Text(
              'Step ${index + 1}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              meta.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Section header ─────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.meta});
  final _StepMeta meta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(meta.icon, color: AppColors.primary, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meta.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 3),
              Text(
                meta.subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}