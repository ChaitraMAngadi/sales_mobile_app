import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';

// ─────────────────────────────────────────────────────────────
// Constants & helpers
// ─────────────────────────────────────────────────────────────
const double kGstRate = 0.18;

const Color kPrimary = Color(0xFFE23744);
const Color kPrimaryDark = Color(0xFFB22433);
const Color kPrimaryLight = Color(0xFFFF7A85);
const Color kPrimarySoft = Color(0xFFFFB3B8);
const Color kPanelBg = Color(0xFFFFF5F7);
const Color kPanelBorder = Color(0xFFFFE4E6);

const List<String> kPaymentModes = [
  'Cash',
  'UPI',
  'NEFT',
  'RTGS',
  'IMPS',
  'Bank Transfer (Generic)',
  'Cheque',
  'Demand Draft (DD)',
  'Internal adjustment',
  'Approval Reference',
  'Advance/Deposit Adjustment',
  'Credit Note',
  'Billing adjustment',
  'Write-off',
  'Approved bad debt',
  'Online',
  'Other',
];

double round2(double n) => (n * 100).round() / 100;
String formatMoney(num? n) => '₹${(n ?? 0).toStringAsFixed(2)}';
DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

String _fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// API function type. In DoctorsPage it is connected to
/// Salesprovider.advancePaymentRequest (which uses authPost + token).
typedef ApiFetch = Future<Map<String, dynamic>> Function(
  String path, {
  String method,
  Map<String, dynamic>? body,
});

// ─────────────────────────────────────────────────────────────
// Public entry point
// ─────────────────────────────────────────────────────────────
// Future<void> showAdvancePaymentModal(
//   BuildContext context, {
//   required String doctorUserid,
//   String? doctorName,
//   required ApiFetch apiFetch,
//   VoidCallback? onSuccess, // equivalent of setFetchAgain
// }) {
// final provider = context.read<Salesprovider>();
//   final isMobile = MediaQuery.of(context).size.width < 768;
//   return showDialog(
//     context: context,
//     barrierColor: Colors.black.withOpacity(0.6),
//     barrierDismissible: false,
//     builder: (_) => Dialog(
//       insetPadding: isMobile
//           ? EdgeInsets.zero
//           : const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: isMobile ? double.infinity : 768,
//           maxHeight: isMobile
//               ? MediaQuery.of(context).size.height
//               : MediaQuery.of(context).size.height * 0.9,
//         ),
//         child: AdvancePaymentModal(
//           doctorUserid: doctorUserid,
//           doctorName: doctorName,
//          apiFetch: (path, {method = 'GET', body}) =>
//         provider.advancePaymentRequest(path, body: body),
//           onSuccess: onSuccess,
//         ),
//       ),
//     ),
//   );
// }

Future<void> showAdvancePaymentModal(
  BuildContext context, {
  required String doctorUserid,
  String? doctorName,
  VoidCallback? onSuccess,
}) {
  final isMobile = MediaQuery.of(context).size.width < 768;
  final provider = context.read<Salesprovider>();
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    barrierDismissible: false,
    builder: (_) => ChangeNotifierProvider.value(
      value: provider, // keeps provider available inside the dialog
      child: Dialog(
        insetPadding: isMobile
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 768,
            maxHeight: isMobile
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height * 0.9,
          ),
          child: AdvancePaymentModal(
            doctorUserid: doctorUserid,
            doctorName: doctorName,
            onSuccess: onSuccess,
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// Modal content
// ─────────────────────────────────────────────────────────────
class AdvancePaymentModal extends StatefulWidget {
  final String doctorUserid;
  final String? doctorName;
  // final ApiFetch apiFetch;
  final VoidCallback? onSuccess;

  const AdvancePaymentModal({
    super.key,
    required this.doctorUserid,
    this.doctorName,
    // required this.apiFetch,
    this.onSuccess,
  });

  @override
  State<AdvancePaymentModal> createState() => _AdvancePaymentModalState();
}

class _AdvancePaymentModalState extends State<AdvancePaymentModal> {
  final _formKey = GlobalKey<FormState>();

  String? _paymentMode;
  DateTime? _paymentDate;

  final _totalCtrl = TextEditingController();
  final _paymentDateCtrl = TextEditingController();
  final _txnRefCtrl = TextEditingController();
  final _utrCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _chequeCtrl = TextEditingController();
  final _receivedByCtrl = TextEditingController();
  final _receiptCtrl = TextEditingController();
  final _proofCtrl = TextEditingController();

  bool _isPurseLoading = false;
  double? _purseAmount;

  // @override
  // void initState() {
  //   super.initState();
  //   _totalCtrl.addListener(() => setState(() {})); // live GST breakdown
  //   _fetchPurse();
  // }

  @override
void initState() {
  super.initState();
  _totalCtrl.addListener(() => setState(() {}));
  // run after first frame so notifyListeners doesn't fire during build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<Salesprovider>().fetchDoctorPurse(widget.doctorUserid);
  });
}

Future<String?> _submitPayment() {
  return context.read<Salesprovider>().addAdvancePayment(
        doctorUserid: widget.doctorUserid,
        paymentMode: _paymentMode!,
        totalAmount: _total,
        paymentDate: _paymentDate,
        transactionReference: _txnRefCtrl.text.trim(),
        utrNumber: _utrCtrl.text.trim(),
        bankName: _bankCtrl.text.trim(),
        chequeNumber: _chequeCtrl.text.trim(),
        receivedBy: _receivedByCtrl.text.trim(),
        receiptNumber: _receiptCtrl.text.trim(),
        paymentProof: _proofCtrl.text.trim(),
      );
}

  @override
  void dispose() {
    for (final c in [
      _totalCtrl,
      _paymentDateCtrl,
      _txnRefCtrl,
      _utrCtrl,
      _bankCtrl,
      _chequeCtrl,
      _receivedByCtrl,
      _receiptCtrl,
      _proofCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── API ────────────────────────────────────────────────────
  

  // /// Returns null on success, or an error message on failure.
  // Future<String?> _submitPayment() async {
  //   final body = <String, dynamic>{
  //     'paymentMode': _paymentMode,
  //     'totalAmountReceived': _total,
  //     'transactionReference': _txnRefCtrl.text.trim(),
  //     'utrNumber': _utrCtrl.text.trim(),
  //     'bankName': _bankCtrl.text.trim(),
  //     'chequeNumber': _chequeCtrl.text.trim(),
  //     'receivedBy': _receivedByCtrl.text.trim(),
  //     'receiptNumber': _receiptCtrl.text.trim(),
  //     'paymentProof': _proofCtrl.text.trim(),
  //   };
  //   if (_paymentDate != null) {
  //     body['paymentDate'] = DateTime.utc(
  //             _paymentDate!.year, _paymentDate!.month, _paymentDate!.day)
  //         .toIso8601String();
  //   }

  //   try {
  //     final data = await widget.apiFetch(
  //       '/api/v1/sales/advancedpayment/${widget.doctorUserid}',
  //       method: 'POST',
  //       body: body,
  //     );

  //     if (data['success'] == true) return null; // success

  //     final errs = data['errors'];
  //     return (errs is List && errs.isNotEmpty)
  //         ? errs.first.toString()
  //         : (data['message']?.toString() ??
  //             'Advance payment could not be added');
  //   } catch (e) {
  //     debugPrint('Error adding advance payment: $e');
  //     return 'Something went wrong. Please try again.';
  //   }
  // }

  // ── Calculations (total is GST-inclusive) ──────────────────
  double get _total => double.tryParse(_totalCtrl.text) ?? 0;
  double get _amountReceived =>
      _total > 0 ? round2(_total / (1 + kGstRate)) : 0;
  double get _gstAmount => _total > 0 ? round2(_total - _amountReceived) : 0;

  // ── Actions ────────────────────────────────────────────────
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Confirm dialog stays open while the API call runs.
    // It returns true only when the payment was added successfully.
    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ConfirmDialog(
        name: widget.doctorName ?? widget.doctorUserid,
        amount: _amountReceived,
        gst: _gstAmount,
        total: _total,
        onConfirm: _submitPayment,
      ),
    );

    if (success == true && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      widget.onSuccess?.call(); // same as setFetchAgain
      Navigator.of(context).pop(); // close main modal (onClose)
      messenger.showSnackBar(const SnackBar(
        content: Text('Advance payment added successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate ?? _today(),
      firstDate: DateTime(2000),
      lastDate: _today(), // no future dates
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: kPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _paymentDate = picked;
        _paymentDateCtrl.text = _fmtDate(picked);
      });
    }
  }

  // ── UI helpers ─────────────────────────────────────────────
  InputDecoration _decoration(String hint, {String? prefixText}) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(Colors.grey.shade300),
      focusedBorder: b(kPrimary, 1.5),
      errorBorder: b(Colors.red.shade400),
      focusedErrorBorder: b(Colors.red.shade400, 1.5),
    );
  }

  Widget _label(IconData icon, String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kPrimary),
          const SizedBox(width: 8),
          Flexible(
            child: Text.rich(TextSpan(children: [
              TextSpan(
                text: text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.grey.shade800,
                ),
              ),
              if (required)
                const TextSpan(
                  text: ' *',
                  style:
                      TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
                ),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _textField(
      TextEditingController c, String label, IconData icon, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(icon, label),
        TextFormField(controller: c, decoration: _decoration(hint)),
      ],
    );
  }

  /// 2 columns on wide screens, 1 on mobile (like SimpleGrid).
  Widget _grid(List<Widget> children, bool twoCols) {
    if (!twoCols) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 16),
          ]
        ],
      );
    }
    final rows = <Widget>[];
    for (int i = 0; i < children.length; i += 2) {
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: children[i]),
          const SizedBox(width: 16),
          Expanded(
              child: i + 1 < children.length
                  ? children[i + 1]
                  : const SizedBox.shrink()),
        ],
      ));
      if (i + 2 < children.length) rows.add(const SizedBox(height: 16));
    }
    return Column(children: rows);
  }

  Widget _panel({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kPanelBg,
          border: Border.all(color: kPanelBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      );

  Widget _stat(String label, String value, {Color? color}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color ?? Colors.grey.shade900)),
        ],
      );

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 768;
    final hPad = wide ? 32.0 : 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // top gradient bar
        Container(
          height: 4,
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [kPrimary, kPrimaryLight, kPrimarySoft]),
          ),
        ),

        // header
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 20, 12, 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kPrimary, kPrimaryLight],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.payments_outlined,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (r) => const LinearGradient(
                        colors: [kPrimaryDark, kPrimary],
                      ).createShader(r),
                      child: Text(
                        'Add Advance Payment',
                        style: TextStyle(
                          fontSize: wide ? 20 : 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.doctorName != null
                          ? '${widget.doctorName} (${widget.doctorUserid})'
                          : widget.doctorUserid,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: kPrimary),
              ),
            ],
          ),
        ),

        // scrollable body
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // wallet balance
                  _panel(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.account_balance_wallet,
                              size: 16, color: kPrimary),
                          const SizedBox(width: 8),
                          Text('Current Wallet Balance',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade800)),
                        ]),
                        // _isPurseLoading
                        //     ? const SizedBox(
                        //         width: 18,
                        //         height: 18,
                        //         child: CircularProgressIndicator(
                        //             strokeWidth: 2, color: kPrimary),
                        //       )
                        //     : Text(formatMoney(_purseAmount),
                        //         style: const TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w800,
                        //             color: kPrimary)),

                        Consumer<Salesprovider>(
  builder: (_, p, __) => p.isPurseLoading
      ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: kPrimary),
        )
      : Text(formatMoney(p.purseAmount),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: kPrimary)),
),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // required fields
                  _grid([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(Icons.money, 'Payment Mode', required: true),
                        DropdownButtonFormField<String>(
                          value: _paymentMode,
                          isExpanded: true,
                          decoration: _decoration('Select payment mode'),
                          items: kPaymentModes
                              .map((m) =>
                                  DropdownMenuItem(value: m, child: Text(m)))
                              .toList(),
                          onChanged: (v) => setState(() => _paymentMode = v),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Payment mode is required'
                              : null,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(Icons.currency_rupee, 'Total Amount (incl. GST)',
                            required: true),
                        TextFormField(
                          controller: _totalCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: _decoration('0.00', prefixText: '₹ '),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Total amount is required';
                            }
                            final n = double.tryParse(v);
                            if (n == null || !(n > 0)) {
                              return 'Amount must be greater than 0';
                            }
                            if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(v)) {
                              return 'Amount can have at most 2 decimals';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ], wide),
                  const SizedBox(height: 20),

                  // GST breakdown
                  _panel(
                    child: Row(
                      children: [
                        Expanded(
                            child: _stat('Amount (to wallet)',
                                formatMoney(_amountReceived))),
                        Expanded(
                            child:
                                _stat('GST (18%)', formatMoney(_gstAmount))),
                        Expanded(
                            child: _stat('Total', formatMoney(_total),
                                color: kPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // optional fields
                  _grid([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(Icons.calendar_today_outlined, 'Payment Date'),
                        TextFormField(
                          controller: _paymentDateCtrl,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: _decoration('YYYY-MM-DD').copyWith(
                            suffixIcon: _paymentDate == null
                                ? const Icon(Icons.event, size: 18)
                                : IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () => setState(() {
                                      _paymentDate = null;
                                      _paymentDateCtrl.clear();
                                    }),
                                  ),
                          ),
                          validator: (_) {
                            if (_paymentDate != null &&
                                _paymentDate!.isAfter(_today())) {
                              return 'Payment date cannot be in the future';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    _textField(_txnRefCtrl, 'Transaction Reference', Icons.tag,
                        'Enter transaction reference'),
                    _textField(
                        _utrCtrl, 'UTR Number', Icons.tag, 'Enter UTR number'),
                    _textField(_bankCtrl, 'Bank Name', Icons.account_balance,
                        'Enter bank name'),
                    _textField(_chequeCtrl, 'Cheque Number',
                        Icons.payments_outlined, 'Enter cheque number'),
                    _textField(_receivedByCtrl, 'Received By',
                        Icons.how_to_reg_outlined, 'Enter name of receiver'),
                    _textField(_receiptCtrl, 'Receipt Number',
                        Icons.receipt_long_outlined, 'Enter receipt number'),
                  ], wide),
                  const SizedBox(height: 16),

                  // payment proof
                  _label(Icons.upload_file, 'Payment Proof (URL / Reference)'),
                  TextFormField(
                    controller: _proofCtrl,
                    decoration:
                        _decoration('Paste payment proof link or reference'),
                  ),
                  const SizedBox(height: 4),
                  Text('Only Payment Mode and Total Amount are required.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 20),

                  // buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kPrimary,
                              side: const BorderSide(color: kPrimary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [kPrimary, kPrimaryLight],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Add Payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Confirmation dialog (AlertDialog equivalent)
// ─────────────────────────────────────────────────────────────
class _ConfirmDialog extends StatefulWidget {
  final String name;
  final double amount;
  final double gst;
  final double total;
  final Future<String?> Function() onConfirm; // null = success, else error text

  const _ConfirmDialog({
    required this.name,
    required this.amount,
    required this.gst,
    required this.total,
    required this.onConfirm,
  });

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _loading = false;
  String? _error;

  Future<void> _confirm() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final error = await widget.onConfirm();
    if (!mounted) return;

    if (error == null) {
      Navigator.pop(context, true); // success
    } else {
      setState(() {
        _loading = false;
        _error = error; // dialog stays open so user can retry
      });
    }
  }

  Widget _row(String l, String v, {bool big = false, Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: const TextStyle(fontSize: 14)),
            Text(v,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: big ? FontWeight.w800 : FontWeight.w700,
                    color: color)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading, // block back button while loading
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: const Text('Confirm Advance Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(children: [
              const TextSpan(
                  text:
                      'Are you sure you want to add this advance payment for '),
              TextSpan(
                  text: widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: '?'),
            ])),
            const SizedBox(height: 12),
            _row('Amount (to wallet)', formatMoney(widget.amount)),
            _row('GST (18%)', formatMoney(widget.gst)),
            _row('Total', formatMoney(widget.total),
                big: true, color: kPrimary),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(_error!,
                    style:
                        TextStyle(color: Colors.red.shade800, fontSize: 13)),
              ),
            ],
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: _loading ? null : () => Navigator.pop(context, false),
            child: const Text('No, Go Back'),
          ),
          ElevatedButton(
            onPressed: _loading ? null : _confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: kPrimary.withOpacity(0.6),
            ),
            child: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Yes, Confirm'),
          ),
        ],
      ),
    );
  }
}