import 'package:flutter/material.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';


class _DaySlot {
  _DaySlot(this.day, this.enabled)
      : start = const TimeOfDay(hour: 9, minute: 0),
        end = const TimeOfDay(hour: 17, minute: 0);

  final String day;
  bool enabled;
  TimeOfDay start;
  TimeOfDay end;
}

class AvailabilityStep extends StatefulWidget {
  const AvailabilityStep({super.key});

  @override
  State<AvailabilityStep> createState() => _AvailabilityStepState();
}

class _AvailabilityStepState extends State<AvailabilityStep> {
  final List<_DaySlot> _days = [
    _DaySlot('Monday', true),
    _DaySlot('Tuesday', true),
    _DaySlot('Wednesday', true),
    _DaySlot('Thursday', true),
    _DaySlot('Friday', true),
    _DaySlot('Saturday', true),
    _DaySlot('Sunday', false),
  ];

  String _slotLength = '15 minutes';

  Future<void> _pick(_DaySlot slot, {required bool isStart}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: isStart ? slot.start : slot.end,
    );
    if (t == null) return;
    setState(() => isStart ? slot.start = t : slot.end = t);
  }

  Widget _timeButton(_DaySlot slot, {required bool isStart}) {
    final t = isStart ? slot.start : slot.end;
    return SizedBox(
      width: 130,
      child: OutlinedButton(
        onPressed: slot.enabled ? () => _pick(slot, isStart: isStart) : null,
        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
        child: Text(t.format(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TwoColumn(
          left: LabeledField(
            label: 'Appointment length',
            child: AppDropdown(
              value: _slotLength,
              items: const ['10 minutes', '15 minutes', '20 minutes', '30 minutes'],
              onChanged: (v) => setState(() => _slotLength = v ?? _slotLength),
            ),
          ),
          right: const SizedBox.shrink(),
        ),
        const SizedBox(height: 28),
        const SubHeading('Weekly schedule'),
        const SizedBox(height: 12),
        for (final slot in _days)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 14,
              runSpacing: 8,
              children: [
                Switch(
                  value: slot.enabled,
                  onChanged: (v) => setState(() => slot.enabled = v),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    slot.day,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: slot.enabled
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
                if (slot.enabled) ...[
                  _timeButton(slot, isStart: true),
                  const Text('to', style: TextStyle(color: Colors.grey)),
                  _timeButton(slot, isStart: false),
                ] else
                  const Text('Closed',
                      style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
      ],
    );
  }
}