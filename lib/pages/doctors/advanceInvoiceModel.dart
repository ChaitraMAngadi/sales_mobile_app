// advance_payment_invoice_modal_superadmin.dart
//
// Shows the invoice as a real A4 PDF on a full page (Scaffold) with print / save / share.
//
// pubspec.yaml dependencies:
//   http: ^1.2.0
//   intl: ^0.19.0
//   pdf: ^3.11.0
//   printing: ^5.13.0
//
// pubspec.yaml assets (optional, used for the logo in the PDF):
//   flutter:
//     assets:
//       - assets/icon/1.png
//
// Usage:
//   AdvancePaymentInvoiceModalSuperadmin.show(
//     context,
//     orderId: orderId,
//     authGet: (url) => authGet(url),   // your existing authenticated GET helper
//     baseUrl: Constants.baseUrl,
//     apiPrefix: 'api/v1/sales',
//   );

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ───────────────────────── Colors ─────────────────────────

class _C {
  static const primary = Color(0xFFE23744);
  static const primaryDark = Color(0xFFB22433);
  static const gradientA = Color(0xFFE23744);
  static const gradientB = Color(0xFFFF7A85);
  static const gradientC = Color(0xFFFFB3B8);

  static const gray200 = Color(0xFFE2E8F0);
  static const gray500 = Color(0xFF718096);
  static const gray600 = Color(0xFF4A5568);
  static const gray800 = Color(0xFF1A202C);
}

const _gSans = 'Google Sans';

TextStyle _ts(double size, Color color,
        {FontWeight weight = FontWeight.w400}) =>
    TextStyle(fontSize: size, color: color, fontWeight: weight, height: 1.5);

// ───────────────────────── Helpers ─────────────────────────

// An invoice never changes, so keep each one for the rest of the session.
final Map<String, Map<String, dynamic>> _invoiceCache = {};

String? _str(Map? m, String key) {
  final v = m?[key];
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '-';
  final d = DateTime.tryParse(iso)?.toLocal();
  return d == null ? '-' : DateFormat('dd MMM yyyy').format(d);
}

String _formatDateTime(String? iso) {
  if (iso == null || iso.isEmpty) return '-';
  final d = DateTime.tryParse(iso)?.toLocal();
  if (d == null) return '-';
  return DateFormat('dd MMM yyyy, hh:mm a')
      .format(d)
      .replaceAll('AM', 'am')
      .replaceAll('PM', 'pm');
}

/// Uses your existing authenticated GET helper.
Future<Map<String, dynamic>> _apiFetch(
  Future<http.Response?> Function(String url) authGet,
  String baseUrl,
  String path, {
  VoidCallback? onUnauthenticated,
}) async {
  final base = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;
  final url = '$base/$path';
  final res = await authGet(url);
  if (res == null) throw Exception('No response from server');
  debugPrint('GET $url -> ${res.statusCode} ${res.body}');
  if (res.statusCode == 401 || res.statusCode == 403) {
    onUnauthenticated?.call();
    throw Exception('Unauthenticated');
  }
  return jsonDecode(res.body) as Map<String, dynamic>;
}

// ═════════════════════════ PDF builder ═════════════════════════

/// Your logo from the app's assets (must be listed under `flutter: assets:`).
const String _logoAsset = 'assets/1.png';

class _InvoicePdf {
  static pw.Font? _reg;
  static pw.Font? _bld;
  static bool _unicode = true;

  static const _red = PdfColor.fromInt(0xFFE23744);
  static const _g800 = PdfColor.fromInt(0xFF1A202C);
  static const _g700 = PdfColor.fromInt(0xFF2D3748);
  static const _g600 = PdfColor.fromInt(0xFF4A5568);
  static const _g500 = PdfColor.fromInt(0xFF718096);
  static const _g300 = PdfColor.fromInt(0xFFCBD5E0);
  static const _g200 = PdfColor.fromInt(0xFFE2E8F0);
  static const _g100 = PdfColor.fromInt(0xFFEDF2F7);
  static const _green100 = PdfColor.fromInt(0xFFC6F6D5);
  static const _green600 = PdfColor.fromInt(0xFF2F855A);
  static const _green700 = PdfColor.fromInt(0xFF276749);
  static const _blue50 = PdfColor.fromInt(0xFFEBF8FF);
  static const _blue400 = PdfColor.fromInt(0xFF4299E1);
  static const _pink = PdfColor.fromInt(0xFFFFF5F7);
  static const _pinkBorder = PdfColor.fromInt(0xFFFFB3B8);

  /// Needs a font that has the rupee glyph. Downloads Noto Sans once (needs internet);
  /// falls back to Helvetica with "Rs." when offline. To work fully offline, bundle a
  /// .ttf and load it with pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')).
  static Future<void> _loadFonts() async {
    if (_reg != null) return;
    try {
      _reg = await PdfGoogleFonts.notoSansRegular();
      _bld = await PdfGoogleFonts.notoSansBold();
      _unicode = true;
    } catch (_) {
      _reg = pw.Font.helvetica();
      _bld = pw.Font.helveticaBold();
      _unicode = false;
    }
  }

  static String _rupee(dynamic v) {
    final n = v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
    return '${_unicode ? '₹' : 'Rs. '}${n.toStringAsFixed(2)}';
  }

  static String _dash(String? s) => (s == null || s.isEmpty) ? (_unicode ? '—' : '-') : s;

  static pw.TextStyle _t(double size, PdfColor color,
          {bool bold = false, double? spacing}) =>
      pw.TextStyle(
        font: bold ? _bld : _reg,
        fontBold: _bld,
        fontSize: size,
        color: color,
        letterSpacing: spacing,
      );

  static pw.Widget _label(String t) =>
      pw.Text(t.toUpperCase(), style: _t(7.5, _g500, bold: true, spacing: 0.5));

  static pw.Widget _box(PdfColor bg, PdfColor border, pw.Widget child) =>
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: bg,
          border: pw.Border(left: pw.BorderSide(color: border, width: 3)),
        ),
        child: child,
      );

      /// Candidate paths: the first one that loads is used. Put your real path first.
static const List<String> _logoCandidates = [
  'assets/1.png',
];

static Future<pw.Widget> _loadLogo() async {
  for (final path in _logoCandidates) {
    try {
      if (path.toLowerCase().endsWith('.svg')) {
        final svg = await rootBundle.loadString(path);
        debugPrint('LOGO loaded: $path');
        return pw.SvgImage(svg: svg, width: 150);
      }
      final bytes = (await rootBundle.load(path)).buffer.asUint8List();
      final image = pw.MemoryImage(bytes); // decodes here, throws if unsupported
      debugPrint('LOGO loaded: $path (${bytes.length} bytes)');
      return pw.Image(image,
          width: 150,
          height: 60,
          fit: pw.BoxFit.contain,
          alignment: pw.Alignment.centerLeft);
    } catch (e) {
      debugPrint('LOGO failed for $path: $e');
    }
  }
  return pw.Text('ppldoc', style: pw.TextStyle(fontSize: 22, color: _red));
}

  static Future<Uint8List> build(Map<String, dynamic> payment) async {
    await _loadFonts();

    

    final hospital = payment['hospitalId'] as Map?;
    final doctor = payment['doctorId'] as Map?;

    // Logo from the app's assets (.png / .jpg / .webp / .svg); falls back to text.
    // pw.Widget logo;
    final pw.Widget logo = await _loadLogo();
  //   try {
  //   if (_logoAsset.toLowerCase().endsWith('.svg')) {
  //     final svg = await rootBundle.loadString(_logoAsset);
  //     logo = pw.SvgImage(svg: svg, width: 150);
  //   } else {
  //     final bytes = (await rootBundle.load(_logoAsset)).buffer.asUint8List();
  //     logo = pw.Image(pw.MemoryImage(bytes),
  //         width: 150, height: 60, fit: pw.BoxFit.contain,
  //         alignment: pw.Alignment.centerLeft);
  //   }
  // } catch (_) {
  //   logo = pw.Text('ppldoc', style:pw.TextStyle(
  //     fontSize: 22, color: _red, 
  //   ));
  // }

    final paymentDetails = <List<String>>[
      ['Payment mode', _str(payment, 'paymentMode') ?? ''],
      [
        'Payment date',
        _str(payment, 'paymentDate') != null
            ? _formatDateTime(_str(payment, 'paymentDate'))
            : ''
      ],
      ['UTR number', _str(payment, 'utrNumber') ?? ''],
      ['Transaction ref.', _str(payment, 'transactionReference') ?? ''],
      ['Bank', _str(payment, 'bankName') ?? ''],
      ['Cheque number', _str(payment, 'chequeNumber') ?? ''],
      ['Receipt number', _str(payment, 'receiptNumber') ?? ''],
      ['Received by', _str(payment, 'receivedBy') ?? ''],
    ].where((r) => r[1].isNotEmpty).toList();

    final providerFields = <List<String?>>[
      ['Doctor Name', 'Dr. ${_str(doctor, 'name') ?? ''}'],
      ['User ID', _str(doctor, 'userid')],
      ['Registration No.', _str(doctor, 'doctorRegistrationNumber')],
      ['Qualification', _str(doctor, 'qualification')],
      ['Specialization', _str(doctor, 'specialization')],
      ['Contact', _str(doctor, 'phone')],
    ];

    final amount = _rupee(payment['amountReceived']);

    pw.Widget infoRow(String l, String v) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 78, child: pw.Text(l, style: _t(8.5, _g600))),
              pw.Expanded(
                  child: pw.Text(v, style: _t(8.5, _g800, bold: true))),
            ],
          ),
        );

    pw.Widget th(String t, int flex, {bool right = false}) => pw.Expanded(
          flex: flex,
          child: pw.Text(t.toUpperCase(),
              textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
              style: _t(7.5, _g600, bold: true, spacing: 0.5)),
        );

    pw.Widget sumRow(String l, String v,
            {bool strong = false}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(l,
                  style: strong
                      ? _t(10, _g800, bold: true)
                      : _t(9, _g600)),
              pw.Text(v,
                  style: strong
                      ? _t(10, _g800, bold: true)
                      : _t(9, _g800)),
            ],
          ),
        );

    final theme = pw.ThemeData.withFont(base: _reg, bold: _bld);
    final doc = pw.Document(theme: theme, title: 'Tax Invoice');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 0, 32, 28),
        header: (_) => pw.Container(
          height: 4,
          margin: const pw.EdgeInsets.only(bottom: 20),
          decoration: const pw.BoxDecoration(
            gradient: pw.LinearGradient(colors: [
              PdfColor.fromInt(0xFFE23744),
              PdfColor.fromInt(0xFFFF7A85),
              PdfColor.fromInt(0xFFFFB3B8),
            ]),
          ),
        ),
        footer: (_) => pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: _g200, width: 0.8)),
          ),
          child: pw.Center(
            child: pw.Text('Thank you for your business',
                style: _t(8, _g500, bold: true)),
          ),
        ),
        build: (ctx) => [
          // Header
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              logo,
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('BlueMyth Technologies Private Limited',
                      style: _t(12.5, _g800, bold: true)),
                  pw.SizedBox(height: 3),
                  pw.Text('235, Binnamangala, 2nd Flr, 13th Cross',
                      style: _t(8.5, _g600)),
                  pw.Text('2nd Stage, Indiranagar', style: _t(8.5, _g600)),
                  pw.Text('Bangalore - 560038, Karnataka',
                      style: _t(8.5, _g600)),
                  pw.SizedBox(height: 5),
                  pw.Text('CIN: U62099KA2025PTC209106',
                      style: _t(7.5, _g500)),
                  pw.Text('GSTIN: 29AANCB9927B1ZC', style: _t(7.5, _g500)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 22),

          // Title
          pw.Text('Invoice', style: _t(24, _g700)),
          pw.Text('Advance payment (wallet credit)', style: _t(9, _g500)),
          pw.SizedBox(height: 18),

          // Bill To + Invoice info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('Bill To'),
                    pw.SizedBox(height: 6),
                    pw.Text(_str(hospital, 'name') ?? '',
                        style: _t(10.5, _g800, bold: true)),
                    pw.SizedBox(height: 2),
                    pw.Text(_str(hospital, 'address') ?? '',
                        style: _t(8.5, _g600)),
                    pw.Text(_str(hospital, 'email') ?? '',
                        style: _t(8.5, _g600)),
                    pw.Text('Phone: ${_str(hospital, 'phone') ?? ''}',
                        style: _t(8.5, _g600)),
                  ],
                ),
              ),
              pw.SizedBox(width: 24),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    infoRow('Invoice number:', _str(payment, 'orderId') ?? ''),
                    infoRow(
                        'Invoice date:',
                        _formatDate(_str(payment, 'createdAt') ??
                            _str(payment, 'paymentDate'))),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.SizedBox(
                            width: 78,
                            child: pw.Text('Payment status:',
                                style: _t(8.5, _g600))),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: pw.BoxDecoration(
                            color: _green100,
                            borderRadius: pw.BorderRadius.circular(3),
                          ),
                          child: pw.Text('PAID',
                              style: _t(7.5, _green700, bold: true)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 18),

          // Service Provider
          _box(
            _blue50,
            _blue400,
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _label('Service Provider'),
                pw.SizedBox(height: 6),
                for (var r = 0; r < providerFields.length; r += 3)
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: r == 0 ? 0 : 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        for (var c = r; c < r + 3; c++)
                          pw.Expanded(
                            child: c < providerFields.length
                                ? pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(providerFields[c][0]!,
                                          style: _t(7.5, _g600)),
                                      pw.Text(_dash(providerFields[c][1]),
                                          style: _t(
                                              8.5, _g800,
                                              bold: providerFields[c][0] ==
                                                  'Doctor Name')),
                                    ],
                                  )
                                : pw.SizedBox(),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Item table
          pw.Container(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: _g300, width: 1.5)),
            ),
            child: pw.Row(
              children: [
                th('Description', 5),
                th('Quantity', 2, right: true),
                th('Rate', 2, right: true),
                th('Amount', 2, right: true),
              ],
            ),
          ),
          pw.Container(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: _g100, width: 1)),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Ppldoc platform fee - advance payment',
                          style: _t(9, _g800)),
                      pw.SizedBox(height: 2),
                      pw.Text(
                          'Credited to wallet, adjusted against future bills',
                          style: _t(7.5, _g500)),
                    ],
                  ),
                ),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text('1',
                        textAlign: pw.TextAlign.right,
                        style: _t(9, _g800))),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(amount,
                        textAlign: pw.TextAlign.right,
                        style: _t(9, _g800))),
                pw.Expanded(
                    flex: 2,
                    child: pw.Text(amount,
                        textAlign: pw.TextAlign.right,
                        style: _t(9, _g800, bold: true))),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          // Payment details + Summary
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: paymentDetails.isEmpty
                    ? pw.SizedBox()
                    : _box(
                        _pink,
                        _pinkBorder,
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _label('Payment Details'),
                            pw.SizedBox(height: 6),
                            for (final r in paymentDetails)
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 4),
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                        width: 80,
                                        child: pw.Text(r[0],
                                            style: _t(8, _g600))),
                                    pw.Expanded(
                                        child: pw.Text(r[1],
                                            style: _t(8, _g800, bold: true))),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              pw.SizedBox(width: 24),
              pw.SizedBox(
                width: 195,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    sumRow('Subtotal', amount),
                    sumRow('GST (18%)', _rupee(payment['gstAmountReceived'])),
                    pw.Divider(color: _g300, thickness: 0.8, height: 8),
                    sumRow('Total', _rupee(payment['totalAmountReceived']),
                        strong: true),
                    pw.SizedBox(height: 6),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: _g100,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Amount paid',
                                  style: _t(9, _g700, bold: true)),
                              pw.Text(_rupee(payment['totalAmountReceived']),
                                  style: _t(9, _green600, bold: true)),
                            ],
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text('$amount credited to wallet',
                              style: _t(7.5, _g500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 24),
        ],
      ),
    );

    return doc.save();
  }
}

// ═════════════════════════ Page ═════════════════════════

class AdvancePaymentInvoiceModalSuperadmin extends StatefulWidget {
  final String orderId;
  final Future<http.Response?> Function(String url) authGet;
  final String baseUrl;
  final String apiPrefix;
  final String invoiceEndpoint;
  final VoidCallback? onUnauthenticated;

  const AdvancePaymentInvoiceModalSuperadmin({
    super.key,
    required this.orderId,
    required this.authGet,
    required this.baseUrl,
    this.apiPrefix = 'api/v1/user',
    this.invoiceEndpoint = 'advancedpaymentbyorderid',
    this.onUnauthenticated,
  });

  /// Opens the invoice as a full page (Scaffold + AppBar + A4 PDF preview).
  static Future<void> show(
    BuildContext context, {
    required String orderId,
    required Future<http.Response?> Function(String url) authGet,
    required String baseUrl,
    String apiPrefix = 'api/v1/sales',
    String invoiceEndpoint = 'advancedpaymentbyorderid',
    VoidCallback? onUnauthenticated,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdvancePaymentInvoiceModalSuperadmin(
          orderId: orderId,
          authGet: authGet,
          baseUrl: baseUrl,
          apiPrefix: apiPrefix,
          invoiceEndpoint: invoiceEndpoint,
          onUnauthenticated: onUnauthenticated,
        ),
      ),
    );
  }

  @override
  State<AdvancePaymentInvoiceModalSuperadmin> createState() =>
      _AdvancePaymentInvoiceModalSuperadminState();
}

class _AdvancePaymentInvoiceModalSuperadminState
    extends State<AdvancePaymentInvoiceModalSuperadmin> {
  int _requestId = 0;
  Map<String, dynamic>? _payment;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AdvancePaymentInvoiceModalSuperadmin old) {
    super.didUpdateWidget(old);
    if (old.orderId != widget.orderId) _load();
  }

  Future<void> _load({bool force = false}) async {
    if (widget.orderId.isEmpty) return;

    if (!force && _invoiceCache.containsKey(widget.orderId)) {
      setState(() {
        _payment = _invoiceCache[widget.orderId];
        _error = null;
        _isLoading = false;
      });
      return;
    }

    final id = ++_requestId;
    setState(() {
      _isLoading = true;
      _error = null;
      _payment = null;
    });

    try {
      final data = await _apiFetch(
        widget.authGet,
        widget.baseUrl,
        '${widget.apiPrefix}/${widget.invoiceEndpoint}/${Uri.encodeComponent(widget.orderId)}',
        onUnauthenticated: widget.onUnauthenticated,
      );
      if (id != _requestId || !mounted) return;

      if (data['success'] == true) {
        final p = Map<String, dynamic>.from(data['payment'] as Map);
        _invoiceCache[widget.orderId] = p;
        setState(() => _payment = p);
      } else {
        setState(
            () => _error = (data['msg'] as String?) ?? 'Invoice not found');
      }
    } catch (err) {
      if (id != _requestId || !mounted) return;
      debugPrint('$err');
      setState(() => _error = 'Could not load this invoice. Please try again.');
    } finally {
      if (id == _requestId && mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.gray200,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: _C.primary),
        title: const Text(
          'Tax Invoice',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: _C.primary, fontSize: 22),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [_C.gradientA, _C.gradientB, _C.gradientC]),
            ),
          ),
        ),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child:
                  CircularProgressIndicator(strokeWidth: 4, color: _C.primary),
            ),
            const SizedBox(height: 16),
            Text('Loading invoice details...',
                style: _ts(16, _C.gray800)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Couldn't load this invoice",
                  style: _ts(18, _C.gray600, weight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_error!,
                  textAlign: TextAlign.center, style: _ts(14, _C.gray500)),
              const SizedBox(height: 20),
              _GradientButton(label: 'Retry', onTap: () => _load(force: true)),
            ],
          ),
        ),
      );
    }

    if (_payment != null) {
      final payment = _payment!;
      return PdfPreview(
        build: (format) async {
          try {
            final bytes = await _InvoicePdf.build(payment);
            debugPrint('INVOICE PDF built OK: ${bytes.length} bytes');
            return bytes;
          } catch (e, st) {
            debugPrint('INVOICE PDF BUILD ERROR: $e\n$st');
            rethrow;
          }
        },
        pdfFileName: 'Advance_Invoice_${widget.orderId}.pdf',
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        maxPageWidth: 700,
        previewPageMargin: const EdgeInsets.all(12),
        scrollViewDecoration: const BoxDecoration(color: _C.gray200),
        pdfPreviewPageDecoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 2)),
          ],
        ),
        loadingWidget: const CircularProgressIndicator(
            strokeWidth: 4, color: _C.primary),
        onError: (context, error) {
          debugPrint('INVOICE PREVIEW ERROR: $error');
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Could not display the invoice PDF.\n$error',
                  textAlign: TextAlign.center,
                  style: _ts(14, _C.gray600)),
            ),
          );
        },
      );
    }

    return Center(
      child: Text('No invoice data available',
          style: _ts(18, _C.gray500)),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.onTap});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = _hover
        ? const [_C.primaryDark, _C.gradientA]
        : const [_C.gradientA, _C.gradientB];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(widget.label,
              style: _ts(16, Colors.white, weight: FontWeight.w600)),
        ),
      ),
    );
  }
}