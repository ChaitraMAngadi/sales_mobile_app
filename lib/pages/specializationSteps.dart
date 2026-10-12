import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';


class SpecialisationStep extends StatefulWidget {
  const SpecialisationStep({super.key, this.initialData});
  final Map<String, dynamic>? initialData;

  @override
  State<SpecialisationStep> createState() => SpecialisationStepState();
}

class SpecialisationStepState extends State<SpecialisationStep> {
  
  List<String> _initialSub = [];
List<String> _initialConditions = [];
List<String> _initialKeywords = [];


// NEW: yahi lists ab live state rakhti hain (TagInputField ke onChanged
  // se update hoti hain), taaki getData() ko latest tags mil sakein.
  List<String> _subSpecialisation = [];
  List<String> _conditionsTreated = [];
  List<String> _keywords = [];

    final _formKey = GlobalKey<FormState>();

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
  primary.text = (data['primarySpecialisation'] ?? '').toString();
  _services.text = (data['areasOfExpertise'] ?? '').toString();
  _initialSub = List<String>.from(data['subSpecialisation'] ?? const []);
  _initialConditions = List<String>.from(data['conditionsTreated'] ?? const []);
  _initialKeywords = List<String>.from(data['keywords'] ?? const []);

  
    // live state ko bhi initial values se bhar do
    _subSpecialisation = List.from(_initialSub);
    _conditionsTreated = List.from(_initialConditions);
    _keywords = List.from(_initialKeywords);
}
  
  static const _specialities = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Paediatrics',
    'Orthopaedics',
    'Gynaecology',
    'ENT',
    'Neurology',
    'Psychiatry',
    'Ophthalmology',
  ];

  static const _interests = [
    'Diabetes',
    'Hypertension',
    'Thyroid disorders',
    'Fever & infections',
    'Asthma',
    'Preventive health',
    'Lifestyle diseases',
    'Geriatric care',
  ];

  String _primary = 'General Medicine';
  final Set<String> _selected = {'Diabetes', 'Hypertension'};
  final _services = TextEditingController(
  );
  final primary = TextEditingController();

  @override
  void dispose() {
    _services.dispose();
    primary.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  // NEW: is step ka latest data. Keys "specialisation" ke API shape
  // se match karte hain.
  // ═══════════════════════════════════════════════════════════════
  Map<String, dynamic> getData() {
    return {
      'primarySpecialisation': primary.text.trim(),
      'subSpecialisation': _subSpecialisation,
      'conditionsTreated': _conditionsTreated,
      'areasOfExpertise': _services.text.trim(),
      'keywords': _keywords,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TwoColumn(
            left: LabeledField(
              label: 'Primary specialisation',
              isRequired: true,
              child: AppTextField(
                controller: primary,
                hint: 'e.g. Cardiologist',
               validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Primary specialisation is required'
                    : null,
              ),
            ),
            right: const SizedBox.shrink(),
          ),
          // const SizedBox(height: 28),
         LabeledField(
        label: 'Sub-specialisations',
        child: TagInputField(
      initialTags: _initialSub, 
      hint: 'e.g. Interventional Cardiology, press Enter',
      onChanged: (tags) {
        // save to your state, e.g. _subSpecialisations = tags;
      },
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Press Enter after each condition',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      
      const SizedBox(height: 20),
      
      LabeledField(
        label: 'Conditions treated',
        child: TagInputField(
      initialTags: _initialConditions,
      hint: 'e.g. Hypertension, Diabetes, Thyroid disorders',
      onChanged: (tags) {
        // save to your state, e.g. _conditionsTreated = tags;
      },
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Press Enter or comma after each condition',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
          
          const SizedBox(height: 28),
          LabeledField(
            label: 'Areas of expertise',
            child: AppTextField(
  controller: _services,
  maxLines: 6,
  maxLength: 250,
  hint: '...',
  validator: (v) =>
      (v ?? '').trim().length > 250 ? 'Maximum 250 characters allowed' : null,
),
            // child: 
            // AppTextField(
            //   controller: _services,
            //   maxLines: 6,
            //   hint: 'e.g. Over 12 years of experience managing heart failure and complex hypertension,with a focus on preventive cardiology.',
            // ),
          ),
          const SizedBox(height: 4),
      const Text(
        'A short summary shown at the top of your profile',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
      
      const SizedBox(height: 28),
      
      LabeledField(
        label: 'Search keywords',
        child: TagInputField(
        initialTags: _initialKeywords,      // search keywords field mein
      hint: 'e.g. heart specialist,ECG, chest pain',
      onChanged: (tags) {
        // save to your state, e.g. _conditionsTreated = tags;
      },
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Words patients might type when looking for a doctor',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
        
        ],
      ),
    );
  }
}



class TagInputField extends StatefulWidget {
  final List<String> initialTags;
  final String hint;
  final ValueChanged<List<String>>? onChanged;

  const TagInputField({
    super.key,
    this.initialTags = const [],
    required this.hint,
    this.onChanged,
  });

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  late List<String> _tags;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty) return;
    if (_tags.contains(tag)) {
      _controller.clear();
      return;
    }
    setState(() {
      _tags.add(tag);
      _controller.clear();
    });
    widget.onChanged?.call(_tags);
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onChanged?.call(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        // Backspace on empty field removes the last tag
        if (event is KeyDownEvent &&
            event.logicalKey.keyLabel == 'Backspace' &&
            _controller.text.isEmpty &&
            _tags.isNotEmpty) {
          _removeTag(_tags.last);
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: _focusNode.hasFocus ? AppColors.primary : Colors.grey.shade300,
            width: _focusNode.hasFocus ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in _tags)
              Chip(
                label: Text(tag, style: const TextStyle(fontSize: 13)),
                deleteIcon: const Icon(Icons.close, size: 15),
                onDeleted: () => _removeTag(tag),
                backgroundColor: AppColors.cardBg,
                labelStyle: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
                shape: StadiumBorder(
                  side: BorderSide(color: AppColors.accent.withOpacity(0.3)),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            IntrinsicWidth(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: _tags.isEmpty ? widget.hint : 'Add more...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                ),
                onSubmitted: (v) {
                  _addTag(v);
                  _focusNode.requestFocus(); // keep typing after Enter
                },
                onChanged: (value) {
                  if (value.endsWith(',')) {
                    _addTag(value.substring(0, value.length - 1));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}