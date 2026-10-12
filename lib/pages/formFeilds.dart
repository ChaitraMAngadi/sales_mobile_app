import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';


/// Label above a field, with an optional red asterisk.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  final String label;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color:Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Standard text input using the app's input theme.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: Colors.grey),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Input with a tinted "+91" style prefix and/or "years" style suffix box.
class AffixField extends StatelessWidget {
  const AffixField({
    super.key,
    required this.controller,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.hint,
  });

  final TextEditingController controller;
  final String? prefixText;
  final String? suffixText;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  Widget _affix(String text, {required bool isPrefix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent,
        border: Border(
          right: isPrefix
              ? const BorderSide()
              : BorderSide.none,
          left: isPrefix
              ? BorderSide.none
              : const BorderSide(),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => validator?.call(controller.text),
      builder: (state) {
        final hasError = state.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasError ? Colors.red.shade400 :Colors.grey,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (prefixText != null) _affix(prefixText!, isPrefix: true),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        inputFormatters: inputFormatters,
                        onChanged: state.didChange,
                        style: const TextStyle(fontSize: 17),
                        decoration: InputDecoration(
                          hintText: hint,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    if (suffixText != null)
                      _affix(suffixText!, isPrefix: false),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                ),
              ),
          ],
        );
      },
    );
  }
}

final int _kCurrentYear = DateTime.now().year;

/// Backend: integer, 1900..current year (optional)
String? validateYear(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  final y = int.tryParse(t);
  if (y == null || y < 1900 || y > _kCurrentYear) {
    return 'Enter a year between 1900 and $_kCurrentYear';
  }
  return null;
}

// /// Dropdown of plain strings.
// class AppDropdown extends StatelessWidget {
//   const AppDropdown({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     this.hint,
//      this.valiadtiontext = "can't be empty please fill the feild",
//   });

//   final String? value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//   final String? hint;
//   final String? valiadtiontext;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       initialValue: value,
//       isExpanded: true,
//       borderRadius: BorderRadius.circular(8),
//       icon: const Icon(Icons.keyboard_arrow_down_rounded),
//        validator: (v) => (v == null || v.trim().isEmpty)
//                   ? valiadtiontext
//                   : null,
//       style: Theme.of(context)
//           .textTheme
//           .bodyLarge
//           ?.copyWith(fontSize: 17, color: Colors.black),
//           decoration: InputDecoration(
//                                 hintText: hint,
//                                 border: OutlineInputBorder(),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 15),
//                               ),
//       // decoration: InputDecoration(hintText: hint),
//       items: [
//         for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
//       ],
//       onChanged: onChanged,
//     );
//   }
// }

/// Dropdown of plain strings.
class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.allowEmpty = false, // false = validation lagegi (default)
    this.valiadtiontext = "can't be empty please fill the feild",
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool allowEmpty;
  final String? valiadtiontext;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      // allowEmpty true ho to koi check nahi, warna khaali par error
      validator: allowEmpty
          ? null
          : (v) => (v == null || v.trim().isEmpty) ? valiadtiontext : null,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontSize: 17, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      items: [
        for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
      ],
      onChanged: onChanged,
    );
  }
}

/// Two fields side by side on wide layouts, stacked on narrow ones.
class TwoColumn extends StatelessWidget {
  const TwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.gap = 24,
  });

  final Widget left;
  final Widget right;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      if (box.maxWidth < 560) {
        return Column(children: [left, SizedBox(height: gap), right]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          SizedBox(width: gap),
          Expanded(child: right),
        ],
      );
    });
  }
}

/// Bordered card for repeatable entries (degrees, clinics, ...).
class RepeatCard extends StatelessWidget {
  const RepeatCard({
    super.key,
    required this.title,
    required this.child,
    this.onRemove,
  });

  final String title;
  final Widget child;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (onRemove != null)
                IconButton(
                  tooltip: 'Remove',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.black),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: AppColors.primary),
        label: Text(label, style: const TextStyle(color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class SubHeading extends StatelessWidget {
  const SubHeading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      );
}