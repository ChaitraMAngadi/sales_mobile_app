// // advanced_payments_list_page_superadmin.dart
// //
// // pubspec.yaml dependencies:
// //   http: ^1.2.0
// //   intl: ^0.19.0
// //   (plus the ones needed by advance_payment_invoice_modal_superadmin.dart)
// //
// // Usage:
// //   AdvancedPaymentsListPageSuperadmin(
// //     accessToken: accessTokenSuperadmin,
// //     baseUrl: 'https://your-api-host/',
// //     onUnauthenticated: () => context.go('/'),
// //     onGoSuperadmin: () => context.go('/superadmin'),
// //   )

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:sales_mobile_app/pages/doctors/advanceInvoiceModel.dart';

// // The invoice modal converted earlier

// // ───────────────────────── Palette ─────────────────────────

// class _C {
//   static const green = Color(0xFF10B981);
//   static const greenLight = Color(0xFF34D399);
//   static const greenDark = Color(0xFF059669);
//   static const greenBg = Color(0xFFF0FDF4);
//   static const greenBg2 = Color(0xFFD1FAE5);

//   static const gray50 = Color(0xFFF7FAFC);
//   static const gray100 = Color(0xFFEDF2F7);
//   static const gray200 = Color(0xFFE2E8F0);
//   static const gray400 = Color(0xFFA0AEC0);
//   static const gray500 = Color(0xFF718096);
//   static const gray600 = Color(0xFF4A5568);
//   static const gray700 = Color(0xFF2D3748);
//   static const gray800 = Color(0xFF1A202C);

//   // Chakra green.50/200/700 and red.50/200/500/600
//   static const cGreen50 = Color(0xFFF0FFF4);
//   static const cGreen200 = Color(0xFF9AE6B4);
//   static const cGreen700 = Color(0xFF276749);
//   static const red50 = Color(0xFFFFF5F5);
//   static const red200 = Color(0xFFFEB2B2);
//   static const red500 = Color(0xFFE53E3E);
//   static const red600 = Color(0xFFC53030);
// }

// const _inter = 'Inter';

// TextStyle _ts(double size, Color color,
//         {FontWeight weight = FontWeight.w400,
//         double? letterSpacing,
//         String? family = _inter}) =>
//     TextStyle(
//       fontSize: size,
//       color: color,
//       fontWeight: weight,
//       letterSpacing: letterSpacing,
//       fontFamily: family,
//       height: 1.5,
//     );

// const _greenGradient = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [_C.green, _C.greenLight],
// );
// const _greenGradientHover = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [_C.greenDark, _C.green],
// );
// const _softGreenGradient = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [_C.greenBg2, _C.greenBg],
// );

// // ───────────────────────── Helpers ─────────────────────────

// final _inr =
//     NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

// String _formatINR(dynamic v) {
//   final n = v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
//   return _inr.format(n);
// }

// String _formatDateTime(dynamic iso) {
//   if (iso == null || '$iso'.isEmpty) return '—';
//   final d = DateTime.tryParse('$iso')?.toLocal();
//   if (d == null) return 'Invalid Date';
//   return DateFormat('dd MMM yyyy, hh:mm a')
//       .format(d)
//       .replaceAll('AM', 'am')
//       .replaceAll('PM', 'pm');
// }

// // local YYYY-MM-DD
// String _toYMD(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

// ({String startDate, String endDate}) _rangeFor(String value) {
//   final end = DateTime.now();
//   final start = value == 'today' ? end : end.subtract(Duration(days: int.parse(value)));
//   return (startDate: _toYMD(start), endDate: _toYMD(end));
// }

// // ───────────────────────── Reusable widgets ─────────────────────────

// class _GreenButton extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool small;
//   final bool expand;
//   const _GreenButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//     this.small = false,
//     this.expand = false,
//   });

//   @override
//   State<_GreenButton> createState() => _GreenButtonState();
// }

// class _GreenButtonState extends State<_GreenButton> {
//   bool _hover = false;
//   @override
//   Widget build(BuildContext context) => MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onEnter: (_) => setState(() => _hover = true),
//         onExit: (_) => setState(() => _hover = false),
//         child: GestureDetector(
//           onTap: widget.onTap,
//           child: Container(
//             height: widget.small ? 32 : 40,
//             width: widget.expand ? double.infinity : null,
//             padding: EdgeInsets.symmetric(horizontal: widget.small ? 12 : 16),
//             decoration: BoxDecoration(
//               gradient: _hover ? _greenGradientHover : _greenGradient,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Row(
//               mainAxisSize:
//                   widget.expand ? MainAxisSize.max : MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(widget.icon,
//                     size: widget.small ? 16 : 18, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text(widget.label,
//                     style: _ts(widget.small ? 14 : 16, Colors.white,
//                         weight: FontWeight.w600, family: null)),
//               ],
//             ),
//           ),
//         ),
//       );
// }

// class _GhostButton extends StatelessWidget {
//   final String label;
//   final VoidCallback? onTap;
//   const _GhostButton(this.label, this.onTap);
//   @override
//   Widget build(BuildContext context) => Opacity(
//         opacity: onTap == null ? 0.4 : 1,
//         child: TextButton(
//           onPressed: onTap,
//           style: TextButton.styleFrom(
//             foregroundColor: _C.gray800,
//             minimumSize: const Size(0, 32),
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//           ),
//           child:
//               Text(label, style: _ts(14, _C.gray800, weight: FontWeight.w600)),
//         ),
//       );
// }

// class _LabelText extends StatelessWidget {
//   final String text;
//   const _LabelText(this.text);
//   @override
//   Widget build(BuildContext context) => Text(text.toUpperCase(),
//       style:
//           _ts(12, _C.gray600, weight: FontWeight.w600, letterSpacing: 0.6));
// }

// class _TypeBadge extends StatelessWidget {
//   final String? type;
//   const _TypeBadge(this.type);
//   @override
//   Widget build(BuildContext context) {
//     final credit = type == 'Credit';
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: credit ? _C.cGreen50 : _C.red50,
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: credit ? _C.cGreen200 : _C.red200),
//       ),
//       child: Text(credit ? 'Credit' : 'Debit',
//           style: _ts(12, credit ? _C.cGreen700 : _C.red600,
//               weight: FontWeight.w600)),
//     );
//   }
// }

// class _TopBarCard extends StatelessWidget {
//   final Widget child;
//   final bool clip;
//   final double shadow;
//   const _TopBarCard(
//       {required this.child, this.clip = true, this.shadow = 12});

//   @override
//   Widget build(BuildContext context) {
//     final inner = Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           height: 3,
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [_C.green, _C.greenLight])),
//         ),
//         child,
//       ],
//     );
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.gray100),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.10),
//               blurRadius: shadow,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: clip
//           ? ClipRRect(borderRadius: BorderRadius.circular(11), child: inner)
//           : inner,
//     );
//   }
// }

// InputDecoration _fieldDecoration(
//     {String? hint, Widget? prefix, Widget? suffix, double radius = 6}) {
//   OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
//         borderRadius: BorderRadius.circular(radius),
//         borderSide: BorderSide(color: c, width: w),
//       );
//   return InputDecoration(
//     hintText: hint,
//     hintStyle: _ts(16, _C.gray400),
//     prefixIcon: prefix,
//     suffixIcon: suffix,
//     filled: true,
//     fillColor: Colors.white,
//     isDense: true,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//     enabledBorder: b(_C.gray200, 1),
//     focusedBorder: b(_C.green, 2),
//     border: b(_C.gray200, 1),
//   );
// }

// class _FieldLabel extends StatelessWidget {
//   final String text;
//   const _FieldLabel(this.text);
//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.only(bottom: 8),
//         child:
//             Text(text, style: _ts(14, _C.gray700, weight: FontWeight.w600)),
//       );
// }

// class _HScroll extends StatelessWidget {
//   final double minWidth;
//   final Widget child;
//   const _HScroll({required this.minWidth, required this.child});
//   @override
//   Widget build(BuildContext context) => LayoutBuilder(
//         builder: (context, cons) => SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SizedBox(
//               width: math.max(cons.maxWidth, minWidth), child: child),
//         ),
//       );
// }

// class _HoverRow extends StatefulWidget {
//   final Widget child;
//   const _HoverRow({required this.child});
//   @override
//   State<_HoverRow> createState() => _HoverRowState();
// }

// class _HoverRowState extends State<_HoverRow> {
//   bool _h = false;
//   @override
//   Widget build(BuildContext context) => MouseRegion(
//         onEnter: (_) => setState(() => _h = true),
//         onExit: (_) => setState(() => _h = false),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _h ? _C.gray50 : Colors.transparent,
//             border: const Border(bottom: BorderSide(color: _C.gray100)),
//           ),
//           child: widget.child,
//         ),
//       );
// }

// class _Pager extends StatelessWidget {
//   final int page;
//   final int pageCount;
//   final ValueChanged<int> onChange;
//   const _Pager(
//       {required this.page, required this.pageCount, required this.onChange});

//   @override
//   Widget build(BuildContext context) {
//     final canPrev = page > 0;
//     final canNext = page < pageCount - 1;
//     return Wrap(
//       alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       spacing: 8,
//       runSpacing: 4,
//       children: [
//         _GhostButton('First', canPrev ? () => onChange(0) : null),
//         _GhostButton('Prev', canPrev ? () => onChange(page - 1) : null),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: _C.greenLight),
//           ),
//           child: Text('${page + 1} / ${pageCount == 0 ? 1 : pageCount}',
//               style: _ts(14, _C.greenDark, weight: FontWeight.w700)),
//         ),
//         _GhostButton('Next', canNext ? () => onChange(page + 1) : null),
//         _GhostButton('Last', canNext ? () => onChange(pageCount - 1) : null),
//       ],
//     );
//   }
// }

// // ───────────────────────── Doctor menu (with search) ─────────────────────────

// class _DoctorFilter extends StatefulWidget {
//   final List<Map<String, dynamic>> doctors;
//   final bool loading;
//   final String selected;
//   final ValueChanged<String> onSelect;
//   const _DoctorFilter({
//     required this.doctors,
//     required this.loading,
//     required this.selected,
//     required this.onSelect,
//   });

//   @override
//   State<_DoctorFilter> createState() => _DoctorFilterState();
// }

// class _DoctorFilterState extends State<_DoctorFilter> {
//   final LayerLink _link = LayerLink();
//   OverlayEntry? _entry;
//   String _term = '';
//   bool _hover = false;

//   String get _selectedName {
//     if (widget.selected == 'all') return 'All Doctors';
//     final d =
//         widget.doctors.where((d) => d['userid'] == widget.selected).toList();
//     return d.isNotEmpty ? '${d.first['name']}' : 'Select Doctor';
//   }

//   @override
//   void didUpdateWidget(covariant _DoctorFilter old) {
//     super.didUpdateWidget(old);
//     _entry?.markNeedsBuild();
//   }

//   @override
//   void dispose() {
//     _close();
//     super.dispose();
//   }

//   void _close() {
//     _entry?.remove();
//     _entry = null;
//   }

//   void _open() {
//     if (widget.loading || _entry != null) return;
//     final width = (context.findRenderObject() as RenderBox).size.width;
//     _term = '';
//     _entry = OverlayEntry(builder: (_) => _buildMenu(width));
//     Overlay.of(context).insert(_entry!);
//   }

//   void _pick(String id) {
//     _close();
//     widget.onSelect(id);
//   }

//   Widget _item(bool selected, VoidCallback onTap, Widget child) => Material(
//         color: selected ? _C.greenBg : Colors.transparent,
//         child: InkWell(
//           hoverColor: _C.greenBg2,
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: child,
//           ),
//         ),
//       );

//   Widget _buildMenu(double width) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: GestureDetector(
//               behavior: HitTestBehavior.opaque, onTap: _close),
//         ),
//         CompositedTransformFollower(
//           link: _link,
//           showWhenUnlinked: false,
//           targetAnchor: Alignment.bottomLeft,
//           followerAnchor: Alignment.topLeft,
//           offset: const Offset(0, 4),
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: width,
//               child: Material(
//                 color: Colors.white,
//                 elevation: 8,
//                 borderRadius: BorderRadius.circular(6),
//                 clipBehavior: Clip.antiAlias,
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxHeight: 400),
//                   child: StatefulBuilder(builder: (context, setS) {
//                     final term = _term.trim().toLowerCase();
//                     final filtered = term.isEmpty
//                         ? widget.doctors
//                         : widget.doctors
//                             .where((d) =>
//                                 '${d['name']}'.toLowerCase().contains(term) ||
//                                 '${d['userid']}'.toLowerCase().contains(term))
//                             .toList();
//                     final allSel = widget.selected == 'all';

//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             border:
//                                 Border(bottom: BorderSide(color: _C.gray200)),
//                           ),
//                           child: SizedBox(
//                             height: 32,
//                             child: TextField(
//                               autofocus: true,
//                               style: _ts(14, _C.gray800),
//                               onChanged: (v) => setS(() => _term = v),
//                               decoration: _fieldDecoration(
//                                 hint: 'Search doctors...',
//                                 prefix: const Icon(Icons.search,
//                                     size: 16, color: _C.gray400),
//                               ).copyWith(
//                                 contentPadding:
//                                     const EdgeInsets.symmetric(vertical: 0),
//                                 hintStyle: _ts(14, _C.gray400),
//                               ),
//                             ),
//                           ),
//                         ),
//                         _item(
//                           allSel,
//                           () => _pick('all'),
//                           Row(
//                             children: [
//                               const Icon(Icons.people_alt_outlined,
//                                   size: 16, color: _C.green),
//                               const SizedBox(width: 8),
//                               Text('All Doctors',
//                                   style: _ts(16, _C.gray800,
//                                       weight: allSel
//                                           ? FontWeight.w600
//                                           : FontWeight.w400)),
//                             ],
//                           ),
//                         ),
//                         const Divider(
//                             height: 9, thickness: 1, color: _C.gray200),
//                         Flexible(
//                           child: filtered.isEmpty
//                               ? Padding(
//                                   padding: const EdgeInsets.all(16),
//                                   child: Center(
//                                     child: Text('No doctors found',
//                                         style: _ts(14, _C.gray500)),
//                                   ),
//                                 )
//                               : ListView(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.zero,
//                                   children: [
//                                     for (final d in filtered)
//                                       _item(
//                                         widget.selected == d['userid'],
//                                         () => _pick('${d['userid']}'),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text('${d['name']}',
//                                                 style: _ts(
//                                                     14,
//                                                     _C.gray800,
//                                                     weight: widget.selected ==
//                                                             d['userid']
//                                                         ? FontWeight.w600
//                                                         : FontWeight.w400)),
//                                             Text('${d['userid']}',
//                                                 style: _ts(12, _C.gray500)),
//                                           ],
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hovered = _hover && !widget.loading;
//     return CompositedTransformTarget(
//       link: _link,
//       child: Opacity(
//         opacity: widget.loading ? 0.4 : 1,
//         child: MouseRegion(
//           cursor: widget.loading
//               ? SystemMouseCursors.forbidden
//               : SystemMouseCursors.click,
//           onEnter: (_) => setState(() => _hover = true),
//           onExit: (_) => setState(() => _hover = false),
//           child: GestureDetector(
//             onTap: _open,
//             child: Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: hovered ? _C.gray200 : _C.gray100,
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(
//                     color: hovered ? _C.green : Colors.transparent),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.people_alt_outlined,
//                       size: 16, color: _C.green),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(_selectedName,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: _ts(16, _C.gray800)),
//                   ),
//                   const Icon(Icons.keyboard_arrow_down,
//                       size: 20, color: _C.gray800),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ───────────────────────── Page ─────────────────────────

// class AdvancedPaymentsListPageSuperadmin extends StatefulWidget {
//   /// Your existing authenticated GET helper (adds token, refreshes it, device headers...).
//   /// Pass it like: authGet: (url) => authGet(url)
//   final Future<http.Response?> Function(String url) authGet;
//   final String baseUrl; // Constants.baseUrl
//   final String apiPrefix; // 'api/v1/user' (superadmin) or 'api/v1/sales'
//   final String doctorsEndpoint;
//   final String paymentsEndpoint;
//   final String invoiceEndpoint;
//   final VoidCallback? onUnauthenticated; // navigate("/")
//   final VoidCallback? onGoSuperadmin; // navigate("/superadmin")

//   const AdvancedPaymentsListPageSuperadmin({
//     super.key,
//     required this.authGet,
//     required this.baseUrl,
//     this.apiPrefix = 'api/v1/user',
//     this.doctorsEndpoint = 'getalldoctornameuserid',
//     this.paymentsEndpoint = 'getalladvancedpayments',
//     this.invoiceEndpoint = 'advancedpaymentbyorderid',
//     this.onUnauthenticated,
//     this.onGoSuperadmin,
//   });

//   @override
//   State<AdvancedPaymentsListPageSuperadmin> createState() =>
//       _AdvancedPaymentsListPageSuperadminState();
// }

// class _AdvancedPaymentsListPageSuperadminState
//     extends State<AdvancedPaymentsListPageSuperadmin> {
//   List<Map<String, dynamic>> _payments = [];
//   bool _isLoading = true;
//   bool _isFetching = false;

//   // filters
//   String _dateRange = 'today';
//   late ({String startDate, String endDate}) _appliedRange = _rangeFor('today');
//   String _customStartDate = '';
//   String _customEndDate = '';
//   String _dateError = '';
//   String _type = 'all';
//   String _selectedDoctor = 'all';
//   final TextEditingController _searchCtrl = TextEditingController();
//   String _search = '';
//   Timer? _debounce;

//   // paging
//   int _page = 0;
//   int _pageCount = 0;
//   int _totalCount = 0;

//   // doctors
//   List<Map<String, dynamic>> _doctors = [];
//   bool _loadingDoctors = false;

//   int _requestId = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadDoctors();
//     _load();
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   // ── API ──

//   Future<Map<String, dynamic>> _get(String path) async {
//     final base = widget.baseUrl.endsWith('/')
//         ? widget.baseUrl.substring(0, widget.baseUrl.length - 1)
//         : widget.baseUrl;
//     final url = '$base/$path';
//     final res = await widget.authGet(url);
//     if (res == null) throw Exception('No response from server');
//     debugPrint('GET $url -> ${res.statusCode} ${res.body}');
//     if (res.statusCode == 401 || res.statusCode == 403) {
//       widget.onUnauthenticated?.call();
//       throw Exception('Unauthenticated');
//     }
//     print(jsonDecode(res.body) as Map<String, dynamic>);
//     return jsonDecode(res.body) as Map<String, dynamic>;
//   }

//   List<Map<String, dynamic>> _asList(dynamic v) => List<Map<String, dynamic>>.from(
//       ((v as List?) ?? []).map((e) => Map<String, dynamic>.from(e as Map)));

//   Future<void> _loadDoctors() async {
//     setState(() => _loadingDoctors = true);
//     try {
//       final result = await _get('${widget.apiPrefix}/${widget.doctorsEndpoint}');
//       if (!mounted) return;
//       if (result['success'] == true) {
//         setState(() => _doctors = _asList(result['data']));
//       } else {
//         widget.onGoSuperadmin?.call();
//       }
//     } catch (err) {
//       debugPrint('Error fetching doctors: $err');
//     } finally {
//       if (mounted) setState(() => _loadingDoctors = false);
//     }
//   }

//   /// Equivalent of the useEffect on [appliedRange, selectedDoctor, type, search, page].
//   Future<void> _load() async {
//     final id = ++_requestId;
//     setState(() => _isFetching = true);

//     try {
//       final params = <String, String>{
//         'startDate': _appliedRange.startDate,
//         'endDate': _appliedRange.endDate,
//         'doctorId': _selectedDoctor,
//         'page': '${_page + 1}',
//         if (_type != 'all') 'type': _type,
//         if (_search.isNotEmpty) 'search': _search,
//       };
//       final data = await _get(
//           '${widget.apiPrefix}/${widget.paymentsEndpoint}?${Uri(queryParameters: params).query}');

//       if (id != _requestId || !mounted) return; // a newer request replaced this one

//       if (data['success'] == true) {
//         final pg = data['pagination'] as Map?;
//         final totalPages = (pg?['totalPages'] as num?)?.toInt() ?? 0;
//         var reload = false;
//         setState(() {
//           _payments = _asList(data['data']);
//           _pageCount = totalPages;
//           _totalCount = (pg?['totalCount'] as num?)?.toInt() ?? 0;
//           if (pg != null && _page > totalPages - 1) {
//             final fixed = math.max(0, totalPages - 1);
//             if (fixed != _page) {
//               _page = fixed;
//               reload = true;
//             }
//           }
//         });
//         if (reload) _load();
//       } else {
//         widget.onGoSuperadmin?.call();
//       }
//     } catch (error) {
//       if (id != _requestId || !mounted) return;
//       debugPrint('$error');
//       setState(() {
//         _payments = [];
//         _pageCount = 0;
//         _totalCount = 0;
//       });
//     } finally {
//       if (id == _requestId && mounted) {
//         setState(() {
//           _isFetching = false;
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   // ── Handlers ──

//   void _onSearchChanged(String value) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 350), () {
//       final next = value.trim();
//       if (next == _search && _page == 0) return;
//       setState(() {
//         _search = next;
//         _page = 0;
//       });
//       _load();
//     });
//   }

//   void _handleDateRangeChange(String value) {
//     final pageChanged = _page != 0;
//     setState(() {
//       _dateRange = value;
//       _dateError = '';
//       _page = 0;
//       if (value == 'custom') {
//         final r = _rangeFor('7');
//         _customStartDate = r.startDate;
//         _customEndDate = r.endDate;
//       } else {
//         _appliedRange = _rangeFor(value);
//       }
//     });
//     if (value != 'custom' || pageChanged) _load();
//   }

//   void _handleCustomApply() {
//     setState(() => _dateError = '');
//     if (_customStartDate.isEmpty || _customEndDate.isEmpty) {
//       setState(() => _dateError = 'Please select both start and end dates');
//       return;
//     }
//     if (DateTime.parse(_customStartDate)
//         .isAfter(DateTime.parse(_customEndDate))) {
//       setState(() => _dateError = 'Start date cannot be after end date');
//       return;
//     }
//     setState(() {
//       _page = 0;
//       _appliedRange = (startDate: _customStartDate, endDate: _customEndDate);
//     });
//     _load();
//   }

//   void _changeDoctor(String userid) {
//     setState(() {
//       _selectedDoctor = userid;
//       _page = 0;
//     });
//     _load();
//   }

//   void _setPage(int p) {
//     setState(() => _page = p);
//     _load();
//   }

//   Future<void> _pickDate(bool isStart) async {
//     final current =
//         DateTime.tryParse(isStart ? _customStartDate : _customEndDate) ??
//             DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: current,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//             colorScheme: const ColorScheme.light(primary: _C.green)),
//         child: child!,
//       ),
//     );
//     if (picked == null) return;
//     final v = _toYMD(picked);
//     setState(() {
//       if (isStart) {
//         _customStartDate = v;
//       } else {
//         _customEndDate = v;
//       }
//       _dateError = '';
//     });
//   }

//   void _openInvoice(String orderId) {
//     AdvancePaymentInvoiceModalSuperadmin.show(
//       context,
//       orderId: orderId,
//       authGet: widget.authGet,
//       baseUrl: widget.baseUrl,
//       apiPrefix: widget.apiPrefix,
//       invoiceEndpoint: widget.invoiceEndpoint,
//       onUnauthenticated: widget.onUnauthenticated,
//     );
//   }

//   // ───────────────────────── Build ─────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 992; // Chakra "lg"
//     final isMdUp = width >= 768;
//     final gap = isMdUp ? 32.0 : 24.0;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFFFAFA), Color(0xFFFFFFFF)],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 1280),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: isMdUp ? 24 : 16, vertical: isMdUp ? 32 : 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     _buildHeader(isMdUp),
//                     SizedBox(height: gap),
//                     _buildFilters(width, isMdUp),
//                     SizedBox(height: gap),
//                     _buildSearch(),
//                     SizedBox(height: gap),
//                     _buildContent(isMobile, isMdUp),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Header ──

//   Widget _buildHeader(bool isMdUp) {
//     final box = isMdUp ? 64.0 : 48.0;
//     return Row(
//       children: [
//         Container(
//           width: box,
//           height: box,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.white, Color(0xFFF0FDF4)],
//             ),
//             borderRadius: BorderRadius.circular(isMdUp ? 16 : 12),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.10),
//                   blurRadius: 6,
//                   offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Icon(Icons.account_balance_wallet_outlined,
//               size: isMdUp ? 28 : 20, color: _C.green),
//         ),
//         SizedBox(width: isMdUp ? 16 : 12),
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ShaderMask(
//                 shaderCallback: (r) => const LinearGradient(
//                   colors: [_C.greenDark, _C.green],
//                 ).createShader(r),
//                 blendMode: BlendMode.srcIn,
//                 child: Text(
//                   'Advance Payments',
//                   style: _ts(isMdUp ? 30 : 20, Colors.white,
//                       weight: FontWeight.w800, letterSpacing: -0.4),
//                 ),
//               ),
//               Text('Wallet credits and debits for all doctors',
//                   style: _ts(isMdUp ? 14 : 12, _C.gray600,
//                       weight: FontWeight.w500)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Filters ──

//   Widget _dropdown({
//     required String label,
//     required double width,
//     required String value,
//     required List<DropdownMenuItem<String>> items,
//     required ValueChanged<String> onChanged,
//   }) =>
//       SizedBox(
//         width: width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _FieldLabel(label),
//             SizedBox(
//               height: 40,
//               child: DropdownButtonFormField<String>(
//                 value: value,
//                 isExpanded: true,
//                 style: _ts(16, _C.gray800),
//                 icon: const Icon(Icons.keyboard_arrow_down, size: 20),
//                 decoration: _fieldDecoration(),
//                 items: items,
//                 onChanged: (v) {
//                   if (v != null) onChanged(v);
//                 },
//               ),
//             ),
//           ],
//         ),
//       );

//   Widget _dateField(String label, String value, bool isStart, double w) =>
//       SizedBox(
//         width: w,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _FieldLabel(label),
//             SizedBox(
//               height: 40,
//               child: TextField(
//                 readOnly: true,
//                 controller: TextEditingController(text: value),
//                 style: _ts(16, _C.gray800),
//                 onTap: () => _pickDate(isStart),
//                 decoration: _fieldDecoration(
//                   suffix: const Icon(Icons.calendar_today_outlined,
//                       size: 16, color: _C.gray500),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );

//   Widget _buildFilters(double screenW, bool isMdUp) {
//     return _TopBarCard(
//       clip: false,
//       shadow: 15,
//       child: Padding(
//         padding: EdgeInsets.all(isMdUp ? 24 : 16),
//         child: LayoutBuilder(builder: (context, cons) {
//           final avail = cons.maxWidth;
//           double cap(double max) => isMdUp ? math.min(max, avail) : avail;
//           final dateW = screenW >= 480 ? math.min(200.0, avail) : avail;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Wrap(
//                 spacing: 16,
//                 runSpacing: 16,
//                 crossAxisAlignment: WrapCrossAlignment.end,
//                 children: [
//                   _dropdown(
//                     label: 'Date Range',
//                     width: cap(220),
//                     value: _dateRange,
//                     items: const [
//                       DropdownMenuItem(value: 'today', child: Text('Today')),
//                       DropdownMenuItem(
//                           value: '7', child: Text('Last 7 Days')),
//                       DropdownMenuItem(
//                           value: '30', child: Text('Last 30 Days')),
//                       DropdownMenuItem(
//                           value: '90', child: Text('Last 90 Days')),
//                       DropdownMenuItem(
//                           value: 'custom', child: Text('Custom Range')),
//                     ],
//                     onChanged: _handleDateRangeChange,
//                   ),
//                   _dropdown(
//                     label: 'Type',
//                     width: cap(180),
//                     value: _type,
//                     items: const [
//                       DropdownMenuItem(value: 'all', child: Text('All')),
//                       DropdownMenuItem(
//                           value: 'Credit', child: Text('Credit')),
//                       DropdownMenuItem(value: 'Debit', child: Text('Debit')),
//                     ],
//                     onChanged: (v) {
//                       setState(() {
//                         _type = v;
//                         _page = 0;
//                       });
//                       _load();
//                     },
//                   ),
//                   SizedBox(
//                     width: cap(320),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const _FieldLabel('Doctor'),
//                         _DoctorFilter(
//                           doctors: _doctors,
//                           loading: _loadingDoctors,
//                           selected: _selectedDoctor,
//                           onSelect: _changeDoctor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               if (_dateRange == 'custom') ...[
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 16,
//                   crossAxisAlignment: WrapCrossAlignment.end,
//                   children: [
//                     _dateField('Start Date', _customStartDate, true, dateW),
//                     _dateField('End Date', _customEndDate, false, dateW),
//                     SizedBox(
//                       width: screenW >= 480 ? null : avail,
//                       child: _GreenButton(
//                         label: 'Apply',
//                         icon: Icons.calendar_today_outlined,
//                         expand: screenW < 480,
//                         onTap: _handleCustomApply,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//               if (_dateError.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: _C.red50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: _C.red200),
//                   ),
//                   child: Text(_dateError,
//                       style: _ts(14, _C.red600, weight: FontWeight.w600)),
//                 ),
//               ],
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // ── Search (always visible) ──

//   Widget _buildSearch() => TextField(
//         controller: _searchCtrl,
//         onChanged: _onSearchChanged,
//         style: _ts(16, _C.gray800),
//         decoration: _fieldDecoration(
//           hint:
//               'Search by order ID, receipt, UTR, reference, mode, doctor or amount...',
//           prefix: const Icon(Icons.search, size: 16, color: _C.gray400),
//           radius: 12,
//         ).copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 12)),
//       );

//   // ── Content ──

//   Widget _buildContent(bool isMobile, bool isMdUp) {
//     if (_isLoading) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 64),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(
//                 width: 48,
//                 height: 48,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 4, color: _C.green),
//               ),
//               const SizedBox(height: 16),
//               Text('Loading advance payments...',
//                   style: _ts(16, _C.gray600, weight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_payments.isEmpty) {
//       final hasFilters =
//           _search.isNotEmpty || _type != 'all' || _selectedDoctor != 'all';
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 64),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 96,
//                 height: 96,
//                 decoration: BoxDecoration(
//                   gradient: _softGreenGradient,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 2,
//                         offset: const Offset(0, 1)),
//                   ],
//                 ),
//                 child: const Opacity(
//                   opacity: 0.6,
//                   child: Icon(Icons.description_outlined,
//                       size: 48, color: _C.greenLight),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text('No advance payments found',
//                   style: _ts(16, _C.gray600, weight: FontWeight.w600)),
//               const SizedBox(height: 4),
//               Text(
//                   hasFilters
//                       ? 'Try changing or clearing the filters'
//                       : 'Nothing recorded for this date range',
//                   style: _ts(14, _C.gray500)),
//             ],
//           ),
//         ),
//       );
//     }

//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 200),
//       opacity: _isFetching ? 0.6 : 1,
//       child: IgnorePointer(
//         ignoring: _isFetching,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Text(
//                   '$_totalCount ${_totalCount == 1 ? 'entry' : 'entries'}',
//                   style: _ts(14, _C.gray600, weight: FontWeight.w600)),
//             ),
//             if (isMobile) ...[
//               for (final p in _payments) _buildMobileCard(p),
//               _Pager(page: _page, pageCount: _pageCount, onChange: _setPage),
//             ] else
//               _buildTable(isMdUp),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Mobile card ──

//   Widget _buildMobileCard(Map<String, dynamic> p) {
//     final credit = p['type'] == 'Credit';
//     final orderId = '${p['orderId'] ?? ''}';
//     final mode = '${p['paymentMode'] ?? ''}';

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _C.gray100),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.10),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4)),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(11),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   (p['doctorName'] == null ||
//                                           '${p['doctorName']}'.isEmpty)
//                                       ? '—'
//                                       : '${p['doctorName']}',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: _ts(14, _C.gray800,
//                                       weight: FontWeight.w700)),
//                               Text('${p['doctoruserId'] ?? ''}',
//                                   style: _ts(12, _C.gray500)),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         _TypeBadge(p['type'] as String?),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: _C.gray50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: _C.gray100),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const _LabelText('Total'),
//                           Text(_formatINR(p['totalAmountReceived']),
//                               style: _ts(20, credit ? _C.green : _C.red500,
//                                   weight: FontWeight.w800)),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                             child: Divider(
//                                 height: 1, thickness: 1, color: _C.gray200),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const _LabelText('Mode'),
//                               Text(mode.isEmpty ? '—' : mode,
//                                   style: _ts(14, _C.gray700,
//                                       weight: FontWeight.w600)),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const _LabelText('Order ID'),
//                               const SizedBox(width: 12),
//                               Flexible(
//                                 child: Text(orderId.isEmpty ? '—' : orderId,
//                                     textAlign: TextAlign.right,
//                                     style: _ts(12, _C.green,
//                                         weight: FontWeight.w700)),
//                               ),
//                             ],
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                             child: Divider(
//                                 height: 1, thickness: 1, color: _C.gray200),
//                           ),
//                           Row(
//                             children: [
//                               const Icon(Icons.calendar_today_outlined,
//                                   size: 14, color: Color(0xFF6B7280)),
//                               const SizedBox(width: 8),
//                               Text(_formatDateTime(p['paymentDate']),
//                                   style: _ts(14, _C.gray700,
//                                       weight: FontWeight.w600)),
//                             ],
//                           ),
//                           if (credit && orderId.isNotEmpty) ...[
//                             const SizedBox(height: 10),
//                             _GreenButton(
//                               label: 'View Invoice',
//                               icon: Icons.visibility_outlined,
                            
//                               expand: true,
//                               onTap: () => _openInvoice(orderId),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 3,
//                   decoration: const BoxDecoration(
//                     gradient:
//                         LinearGradient(colors: [_C.green, _C.greenLight]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Desktop table ──

//   Widget _buildTable(bool isMdUp) {
//     Widget th(String t, int flex, {bool right = false}) => Expanded(
//           flex: flex,
//           child: Text(t.toUpperCase(),
//               textAlign: right ? TextAlign.right : TextAlign.left,
//               style: _ts(12, _C.gray700,
//                   weight: FontWeight.w700, letterSpacing: 0.6)),
//         );

//     return _TopBarCard(
//       shadow: 25,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _HScroll(
//             minWidth: 1000,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   color: _C.gray50,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   child: Row(
//                     children: [
//                       th('Doctor', 3),
//                       th('Type', 2),
//                       th('Mode', 2),
//                       th('Order ID', 3),
//                       th('Total', 2, right: true),
//                       th('Date & Time', 3),
//                       th('Action', 2),
//                     ],
//                   ),
//                 ),
//                 for (final p in _payments) _buildRow(p),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: isMdUp ? 24 : 16, vertical: 16),
//             decoration: const BoxDecoration(
//               gradient: _softGreenGradient,
//               border: Border(top: BorderSide(color: _C.gray200)),
//             ),
//             child: Wrap(
//               alignment: WrapAlignment.spaceBetween,
//               crossAxisAlignment: WrapCrossAlignment.center,
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 Text('Page ${_page + 1} of ${_pageCount == 0 ? 1 : _pageCount}',
//                     style: _ts(14, _C.gray700, weight: FontWeight.w600)),
//                 _Pager(
//                     page: _page, pageCount: _pageCount, onChange: _setPage),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRow(Map<String, dynamic> p) {
//     final credit = p['type'] == 'Credit';
//     final orderId = '${p['orderId'] ?? ''}';
//     final doctorName = '${p['doctorName'] ?? ''}';
//     final mode = '${p['paymentMode'] ?? ''}';

//     return _HoverRow(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(doctorName.isEmpty ? '—' : doctorName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: _ts(14, _C.gray800, weight: FontWeight.w600)),
//                   Text('${p['doctoruserId'] ?? ''}',
//                       style: _ts(12, _C.gray500)),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: _TypeBadge(p['type'] as String?),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Text(mode.isEmpty ? '—' : mode,
//                   style: _ts(14, _C.gray700)),
//             ),
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 12),
//                 child: Tooltip(
//                   message: orderId,
//                   child: Text(orderId.isEmpty ? '—' : orderId,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: _ts(14, orderId.isEmpty ? _C.gray400 : _C.green,
//                           weight: FontWeight.w600)),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Text(
//                   '${credit ? '+' : '−'} ${_formatINR(p['totalAmountReceived'])}',
//                   textAlign: TextAlign.right,
//                   style: _ts(16, credit ? _C.green : _C.red500,
//                       weight: FontWeight.w700)),
//             ),
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 24),
//                 child: Text(_formatDateTime(p['paymentDate']),
//                     style: _ts(14, _C.gray600, weight: FontWeight.w500)),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: (credit && orderId.isNotEmpty)
//                     ? _GreenButton(
//                         label: 'View Invoice',
//                         icon: Icons.visibility_outlined,
//                         small: true,
//                         onTap: () => _openInvoice(orderId),
//                       )
//                     : Text('—', style: _ts(14, _C.gray400)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// advanced_payments_list_page_superadmin.dart
//
// pubspec.yaml dependencies:
//   http: ^1.2.0
//   intl: ^0.19.0
//   (plus the ones needed by advance_payment_invoice_modal_superadmin.dart)
//
// Usage:
//   AdvancedPaymentsListPageSuperadmin(
//     authGet: (url) => authGet(url),
//     baseUrl: Constants.baseUrl,
//     apiPrefix: 'api/v1/sales',
//     onUnauthenticated: () => context.go('/'),
//     onGoSuperadmin: () => context.go('/superadmin'),
//   )

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:sales_mobile_app/pages/doctors/advanceInvoiceModel.dart';

// ───────────────────────── Palette ─────────────────────────

class _C {
  static const green = Color(0xFF10B981);
  static const greenLight = Color(0xFF34D399);
  static const greenDark = Color(0xFF059669);
  static const greenBg = Color(0xFFF0FDF4);
  static const greenBg2 = Color(0xFFD1FAE5);

  static const gray50 = Color(0xFFF7FAFC);
  static const gray100 = Color(0xFFEDF2F7);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray400 = Color(0xFFA0AEC0);
  static const gray500 = Color(0xFF718096);
  static const gray600 = Color(0xFF4A5568);
  static const gray700 = Color(0xFF2D3748);
  static const gray800 = Color(0xFF1A202C);

  // Chakra green.50/200/700 and red.50/200/500/600
  static const cGreen50 = Color(0xFFF0FFF4);
  static const cGreen200 = Color(0xFF9AE6B4);
  static const cGreen700 = Color(0xFF276749);
  static const red50 = Color(0xFFFFF5F5);
  static const red200 = Color(0xFFFEB2B2);
  static const red500 = Color(0xFFE53E3E);
  static const red600 = Color(0xFFC53030);
}

const _inter = 'Inter';

TextStyle _ts(double size, Color color,
        {FontWeight weight = FontWeight.w400,
        double? letterSpacing,
        String? family = _inter}) =>
    TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      fontFamily: family,
      height: 1.5,
    );

const _greenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_C.green, _C.greenLight],
);
const _greenGradientHover = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_C.greenDark, _C.green],
);
const _softGreenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_C.greenBg2, _C.greenBg],
);

// ───────────────────────── Helpers ─────────────────────────

final _inr =
    NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

String _formatINR(dynamic v) {
  final n = v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
  return _inr.format(n);
}

String _formatDateTime(dynamic iso) {
  if (iso == null || '$iso'.isEmpty) return '—';
  final d = DateTime.tryParse('$iso')?.toLocal();
  if (d == null) return 'Invalid Date';
  return DateFormat('dd MMM yyyy, hh:mm a')
      .format(d)
      .replaceAll('AM', 'am')
      .replaceAll('PM', 'pm');
}

// local YYYY-MM-DD
String _toYMD(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

({String startDate, String endDate}) _rangeFor(String value) {
  final end = DateTime.now();
  final start = value == 'today' ? end : end.subtract(Duration(days: int.parse(value)));
  return (startDate: _toYMD(start), endDate: _toYMD(end));
}

// ───────────────────────── Reusable widgets ─────────────────────────

class _GreenButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool small;
  final bool expand;
  const _GreenButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.small = false,
    this.expand = false,
  });

  @override
  State<_GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<_GreenButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: widget.small ? 32 : 40,
            width: widget.expand ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: widget.small ? 12 : 16),
            decoration: BoxDecoration(
              gradient: _hover ? _greenGradientHover : _greenGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize:
                  widget.expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: widget.small ? 16 : 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(widget.label,
                    style: _ts(widget.small ? 14 : 16, Colors.white,
                        weight: FontWeight.w600, family: null)),
              ],
            ),
          ),
        ),
      );
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _GhostButton(this.label, this.onTap);
  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: _C.gray800,
            minimumSize: const Size(0, 32),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child:
              Text(label, style: _ts(14, _C.gray800, weight: FontWeight.w600)),
        ),
      );
}

class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style:
          _ts(12, _C.gray600, weight: FontWeight.w600, letterSpacing: 0.6));
}

class _TypeBadge extends StatelessWidget {
  final String? type;
  const _TypeBadge(this.type);
  @override
  Widget build(BuildContext context) {
    final credit = type == 'Credit';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: credit ? _C.cGreen50 : _C.red50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: credit ? _C.cGreen200 : _C.red200),
      ),
      child: Text(credit ? 'Credit' : 'Debit',
          style: _ts(12, credit ? _C.cGreen700 : _C.red600,
              weight: FontWeight.w600)),
    );
  }
}

class _TopBarCard extends StatelessWidget {
  final Widget child;
  final bool clip;
  final double shadow;
  const _TopBarCard(
      {required this.child, this.clip = true, this.shadow = 12});

  @override
  Widget build(BuildContext context) {
    final inner = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 3,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_C.green, _C.greenLight])),
        ),
        child,
      ],
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.gray100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: shadow,
              offset: const Offset(0, 4)),
        ],
      ),
      child: clip
          ? ClipRRect(borderRadius: BorderRadius.circular(11), child: inner)
          : inner,
    );
  }
}

InputDecoration _fieldDecoration(
    {String? hint, Widget? prefix, Widget? suffix, double radius = 6}) {
  OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: _ts(16, _C.gray400),
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    enabledBorder: b(_C.gray200, 1),
    focusedBorder: b(_C.green, 2),
    border: b(_C.gray200, 1),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child:
            Text(text, style: _ts(14, _C.gray700, weight: FontWeight.w600)),
      );
}

class _HScroll extends StatelessWidget {
  final double minWidth;
  final Widget child;
  const _HScroll({required this.minWidth, required this.child});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, cons) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
              width: math.max(cons.maxWidth, minWidth), child: child),
        ),
      );
}

class _HoverRow extends StatefulWidget {
  final Widget child;
  const _HoverRow({required this.child});
  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: Container(
          decoration: BoxDecoration(
            color: _h ? _C.gray50 : Colors.transparent,
            border: const Border(bottom: BorderSide(color: _C.gray100)),
          ),
          child: widget.child,
        ),
      );
}

class _Pager extends StatelessWidget {
  final int page;
  final int pageCount;
  final ValueChanged<int> onChange;
  const _Pager(
      {required this.page, required this.pageCount, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final canPrev = page > 0;
    final canNext = page < pageCount - 1;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        _GhostButton('First', canPrev ? () => onChange(0) : null),
        _GhostButton('Prev', canPrev ? () => onChange(page - 1) : null),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _C.greenLight),
          ),
          child: Text('${page + 1} / ${pageCount == 0 ? 1 : pageCount}',
              style: _ts(14, _C.greenDark, weight: FontWeight.w700)),
        ),
        _GhostButton('Next', canNext ? () => onChange(page + 1) : null),
        _GhostButton('Last', canNext ? () => onChange(pageCount - 1) : null),
      ],
    );
  }
}

// ───────────────────────── Doctor menu (with search) ─────────────────────────

class _DoctorFilter extends StatefulWidget {
  final List<Map<String, dynamic>> doctors;
  final bool loading;
  final String selected;
  final ValueChanged<String> onSelect;
  const _DoctorFilter({
    required this.doctors,
    required this.loading,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_DoctorFilter> createState() => _DoctorFilterState();
}

class _DoctorFilterState extends State<_DoctorFilter> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  String _term = '';
  bool _hover = false;

  String get _selectedName {
    if (widget.selected == 'all') return 'All Doctors';
    final d =
        widget.doctors.where((d) => d['userid'] == widget.selected).toList();
    return d.isNotEmpty ? '${d.first['name']}' : 'Select Doctor';
  }

  @override
  void didUpdateWidget(covariant _DoctorFilter old) {
    super.didUpdateWidget(old);
    _entry?.markNeedsBuild();
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  void _open() {
    if (widget.loading || _entry != null) return;
    final width = (context.findRenderObject() as RenderBox).size.width;
    _term = '';
    _entry = OverlayEntry(builder: (_) => _buildMenu(width));
    Overlay.of(context).insert(_entry!);
  }

  void _pick(String id) {
    _close();
    widget.onSelect(id);
  }

  Widget _item(bool selected, VoidCallback onTap, Widget child) => Material(
        color: selected ? _C.greenBg : Colors.transparent,
        child: InkWell(
          hoverColor: _C.greenBg2,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: child,
          ),
        ),
      );

  Widget _buildMenu(double width) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque, onTap: _close),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: Material(
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.circular(6),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: StatefulBuilder(builder: (context, setS) {
                    final term = _term.trim().toLowerCase();
                    final filtered = term.isEmpty
                        ? widget.doctors
                        : widget.doctors
                            .where((d) =>
                                '${d['name']}'.toLowerCase().contains(term) ||
                                '${d['userid']}'.toLowerCase().contains(term))
                            .toList();
                    final allSel = widget.selected == 'all';

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border:
                                Border(bottom: BorderSide(color: _C.gray200)),
                          ),
                          child: SizedBox(
                            height: 32,
                            child: TextField(
                              autofocus: true,
                              style: _ts(14, _C.gray800),
                              onChanged: (v) => setS(() => _term = v),
                              decoration: _fieldDecoration(
                                hint: 'Search doctors...',
                                prefix: const Icon(Icons.search,
                                    size: 16, color: _C.gray400),
                              ).copyWith(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                hintStyle: _ts(14, _C.gray400),
                              ),
                            ),
                          ),
                        ),
                        _item(
                          allSel,
                          () => _pick('all'),
                          Row(
                            children: [
                              const Icon(Icons.people_alt_outlined,
                                  size: 16, color: _C.green),
                              const SizedBox(width: 8),
                              Text('All Doctors',
                                  style: _ts(16, _C.gray800,
                                      weight: allSel
                                          ? FontWeight.w600
                                          : FontWeight.w400)),
                            ],
                          ),
                        ),
                        const Divider(
                            height: 9, thickness: 1, color: _C.gray200),
                        Flexible(
                          child: filtered.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text('No doctors found',
                                        style: _ts(14, _C.gray500)),
                                  ),
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  children: [
                                    for (final d in filtered)
                                      _item(
                                        widget.selected == d['userid'],
                                        () => _pick('${d['userid']}'),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${d['name']}',
                                                style: _ts(
                                                    14,
                                                    _C.gray800,
                                                    weight: widget.selected ==
                                                            d['userid']
                                                        ? FontWeight.w600
                                                        : FontWeight.w400)),
                                            Text('${d['userid']}',
                                                style: _ts(12, _C.gray500)),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hovered = _hover && !widget.loading;
    return CompositedTransformTarget(
      link: _link,
      child: Opacity(
        opacity: widget.loading ? 0.4 : 1,
        child: MouseRegion(
          cursor: widget.loading
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: _open,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: hovered ? _C.gray200 : _C.gray100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: hovered ? _C.green : Colors.transparent),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_outlined,
                      size: 16, color: _C.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_selectedName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _ts(16, _C.gray800)),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: _C.gray800),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Page ─────────────────────────

class AdvancedPaymentsListPageSuperadmin extends StatefulWidget {
  /// Your existing authenticated GET helper (adds token, refreshes it, device headers...).
  /// Pass it like: authGet: (url) => authGet(url)
  final Future<http.Response?> Function(String url) authGet;
  final String baseUrl; // Constants.baseUrl
  final String apiPrefix; // 'api/v1/user' (superadmin) or 'api/v1/sales'
  final String doctorsEndpoint;
  final String paymentsEndpoint;
  final String invoiceEndpoint;
  final VoidCallback? onUnauthenticated; // navigate("/")
  final VoidCallback? onGoSuperadmin; // navigate("/superadmin")

  const AdvancedPaymentsListPageSuperadmin({
    super.key,
    required this.authGet,
    required this.baseUrl,
    this.apiPrefix = 'api/v1/user',
    this.doctorsEndpoint = 'getalldoctornameuserid',
    this.paymentsEndpoint = 'getalladvancedpayments',
    this.invoiceEndpoint = 'advancedpaymentbyorderid',
    this.onUnauthenticated,
    this.onGoSuperadmin,
  });

  @override
  State<AdvancedPaymentsListPageSuperadmin> createState() =>
      _AdvancedPaymentsListPageSuperadminState();
}

class _AdvancedPaymentsListPageSuperadminState
    extends State<AdvancedPaymentsListPageSuperadmin> {
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = true;
  bool _isFetching = false;

  // filters
  String _dateRange = 'today';
  late ({String startDate, String endDate}) _appliedRange = _rangeFor('today');
  String _customStartDate = '';
  String _customEndDate = '';
  String _dateError = '';
  final String _type = 'Credit'; // only credit entries are shown
  String _selectedDoctor = 'all';
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  Timer? _debounce;

  // paging
  int _page = 0;
  int _pageCount = 0;
  int _totalCount = 0;

  // doctors
  List<Map<String, dynamic>> _doctors = [];
  bool _loadingDoctors = false;

  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── API ──

  Future<Map<String, dynamic>> _get(String path) async {
    final base = widget.baseUrl.endsWith('/')
        ? widget.baseUrl.substring(0, widget.baseUrl.length - 1)
        : widget.baseUrl;
    final url = '$base/$path';
    final res = await widget.authGet(url);
    if (res == null) throw Exception('No response from server');
    debugPrint('GET $url -> ${res.statusCode} ${res.body}');
    if (res.statusCode == 401 || res.statusCode == 403) {
      widget.onUnauthenticated?.call();
      throw Exception('Unauthenticated');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  List<Map<String, dynamic>> _asList(dynamic v) => List<Map<String, dynamic>>.from(
      ((v as List?) ?? []).map((e) => Map<String, dynamic>.from(e as Map)));

  Future<void> _loadDoctors() async {
    setState(() => _loadingDoctors = true);
    try {
      final result = await _get('${widget.apiPrefix}/${widget.doctorsEndpoint}');
      if (!mounted) return;
      if (result['success'] == true) {
        setState(() => _doctors = _asList(result['data']));
      } else {
        widget.onGoSuperadmin?.call();
      }
    } catch (err) {
      debugPrint('Error fetching doctors: $err');
    } finally {
      if (mounted) setState(() => _loadingDoctors = false);
    }
  }

  /// Equivalent of the useEffect on [appliedRange, selectedDoctor, type, search, page].
  Future<void> _load() async {
    final id = ++_requestId;
    setState(() => _isFetching = true);

    try {
      final params = <String, String>{
        'startDate': _appliedRange.startDate,
        'endDate': _appliedRange.endDate,
        'doctorId': _selectedDoctor,
        'page': '${_page + 1}',
        if (_type != 'all') 'type': _type,
        if (_search.isNotEmpty) 'search': _search,
      };
      final data = await _get(
          '${widget.apiPrefix}/${widget.paymentsEndpoint}?${Uri(queryParameters: params).query}');

      if (id != _requestId || !mounted) return; // a newer request replaced this one

      if (data['success'] == true) {
        final pg = data['pagination'] as Map?;
        final totalPages = (pg?['totalPages'] as num?)?.toInt() ?? 0;
        var reload = false;
        setState(() {
          _payments = _asList(data['data']);
          _pageCount = totalPages;
          _totalCount = (pg?['totalCount'] as num?)?.toInt() ?? 0;
          if (pg != null && _page > totalPages - 1) {
            final fixed = math.max(0, totalPages - 1);
            if (fixed != _page) {
              _page = fixed;
              reload = true;
            }
          }
        });
        if (reload) _load();
      } else {
        widget.onGoSuperadmin?.call();
      }
    } catch (error) {
      if (id != _requestId || !mounted) return;
      debugPrint('$error');
      setState(() {
        _payments = [];
        _pageCount = 0;
        _totalCount = 0;
      });
    } finally {
      if (id == _requestId && mounted) {
        setState(() {
          _isFetching = false;
          _isLoading = false;
        });
      }
    }
  }

  // ── Handlers ──

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final next = value.trim();
      if (next == _search && _page == 0) return;
      setState(() {
        _search = next;
        _page = 0;
      });
      _load();
    });
  }

  void _handleDateRangeChange(String value) {
    final pageChanged = _page != 0;
    setState(() {
      _dateRange = value;
      _dateError = '';
      _page = 0;
      if (value == 'custom') {
        final r = _rangeFor('7');
        _customStartDate = r.startDate;
        _customEndDate = r.endDate;
      } else {
        _appliedRange = _rangeFor(value);
      }
    });
    if (value != 'custom' || pageChanged) _load();
  }

  void _handleCustomApply() {
    setState(() => _dateError = '');
    if (_customStartDate.isEmpty || _customEndDate.isEmpty) {
      setState(() => _dateError = 'Please select both start and end dates');
      return;
    }
    if (DateTime.parse(_customStartDate)
        .isAfter(DateTime.parse(_customEndDate))) {
      setState(() => _dateError = 'Start date cannot be after end date');
      return;
    }
    setState(() {
      _page = 0;
      _appliedRange = (startDate: _customStartDate, endDate: _customEndDate);
    });
    _load();
  }

  void _changeDoctor(String userid) {
    setState(() {
      _selectedDoctor = userid;
      _page = 0;
    });
    _load();
  }

  void _setPage(int p) {
    setState(() => _page = p);
    _load();
  }

  Future<void> _pickDate(bool isStart) async {
    final current =
        DateTime.tryParse(isStart ? _customStartDate : _customEndDate) ??
            DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: _C.green)),
        child: child!,
      ),
    );
    if (picked == null) return;
    final v = _toYMD(picked);
    setState(() {
      if (isStart) {
        _customStartDate = v;
      } else {
        _customEndDate = v;
      }
      _dateError = '';
    });
  }

  void _openInvoice(String orderId) {
    AdvancePaymentInvoiceModalSuperadmin.show(
      context,
      orderId: orderId,
      authGet: widget.authGet,
      baseUrl: widget.baseUrl,
      apiPrefix: widget.apiPrefix,
      invoiceEndpoint: widget.invoiceEndpoint,
      onUnauthenticated: widget.onUnauthenticated,
    );
  }

  // ───────────────────────── Build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 992; // Chakra "lg"
    final isMdUp = width >= 768;
    final gap = isMdUp ? 32.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAFA), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isMdUp ? 24 : 16, vertical: isMdUp ? 32 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(isMdUp),
                    SizedBox(height: gap),
                    _buildFilters(width, isMdUp),
                    SizedBox(height: gap),
                    _buildSearch(),
                    SizedBox(height: gap),
                    _buildContent(isMobile, isMdUp),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader(bool isMdUp) {
    final box = isMdUp ? 64.0 : 48.0;
    return Row(
      children: [
        Container(
          width: box,
          height: box,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF0FDF4)],
            ),
            borderRadius: BorderRadius.circular(isMdUp ? 16 : 12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(Icons.account_balance_wallet_outlined,
              size: isMdUp ? 28 : 20, color: _C.green),
        ),
        SizedBox(width: isMdUp ? 16 : 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (r) => const LinearGradient(
                  colors: [_C.greenDark, _C.green],
                ).createShader(r),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Advance Payments',
                  style: _ts(isMdUp ? 30 : 20, Colors.white,
                      weight: FontWeight.w800, letterSpacing: -0.4),
                ),
              ),
              Text('Wallet credits and debits for all doctors',
                  style: _ts(isMdUp ? 14 : 12, _C.gray600,
                      weight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Filters ──

  Widget _dropdown({
    required String label,
    required double width,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String> onChanged,
  }) =>
      SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(label),
            SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: value,
                isExpanded: true,
                style: _ts(16, _C.gray800),
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                decoration: _fieldDecoration(),
                items: items,
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ],
        ),
      );

  Widget _dateField(String label, String value, bool isStart, double w) =>
      SizedBox(
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(label),
            SizedBox(
              height: 40,
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: value),
                style: _ts(16, _C.gray800),
                onTap: () => _pickDate(isStart),
                decoration: _fieldDecoration(
                  suffix: const Icon(Icons.calendar_today_outlined,
                      size: 16, color: _C.gray500),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildFilters(double screenW, bool isMdUp) {
    return _TopBarCard(
      clip: false,
      shadow: 15,
      child: Padding(
        padding: EdgeInsets.all(isMdUp ? 24 : 16),
        child: LayoutBuilder(builder: (context, cons) {
          final avail = cons.maxWidth;
          double cap(double max) => isMdUp ? math.min(max, avail) : avail;
          final dateW = screenW >= 480 ? math.min(200.0, avail) : avail;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  _dropdown(
                    label: 'Date Range',
                    width: cap(220),
                    value: _dateRange,
                    items: const [
                      DropdownMenuItem(value: 'today', child: Text('Today')),
                      DropdownMenuItem(
                          value: '7', child: Text('Last 7 Days')),
                      DropdownMenuItem(
                          value: '30', child: Text('Last 30 Days')),
                      DropdownMenuItem(
                          value: '90', child: Text('Last 90 Days')),
                      DropdownMenuItem(
                          value: 'custom', child: Text('Custom Range')),
                    ],
                    onChanged: _handleDateRangeChange,
                  ),
                  SizedBox(
                    width: cap(320),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Doctor'),
                        _DoctorFilter(
                          doctors: _doctors,
                          loading: _loadingDoctors,
                          selected: _selectedDoctor,
                          onSelect: _changeDoctor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_dateRange == 'custom') ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    _dateField('Start Date', _customStartDate, true, dateW),
                    _dateField('End Date', _customEndDate, false, dateW),
                    SizedBox(
                      width: screenW >= 480 ? null : avail,
                      child: _GreenButton(
                        label: 'Apply',
                        icon: Icons.calendar_today_outlined,
                        expand: screenW < 480,
                        onTap: _handleCustomApply,
                      ),
                    ),
                  ],
                ),
              ],
              if (_dateError.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _C.red50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _C.red200),
                  ),
                  child: Text(_dateError,
                      style: _ts(14, _C.red600, weight: FontWeight.w600)),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  // ── Search (always visible) ──

  Widget _buildSearch() => TextField(
        controller: _searchCtrl,
        onChanged: _onSearchChanged,
        style: _ts(16, _C.gray800),
        decoration: _fieldDecoration(
          hint:
              'Search by order ID, receipt, UTR, reference, mode, doctor or amount...',
          prefix: const Icon(Icons.search, size: 16, color: _C.gray400),
          radius: 12,
        ).copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 12)),
      );

  // ── Content ──

  Widget _buildContent(bool isMobile, bool isMdUp) {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                    strokeWidth: 4, color: _C.green),
              ),
              const SizedBox(height: 16),
              Text('Loading advance payments...',
                  style: _ts(16, _C.gray600, weight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    if (_payments.isEmpty) {
      final hasFilters = _search.isNotEmpty || _selectedDoctor != 'all';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: _softGreenGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1)),
                  ],
                ),
                child: const Opacity(
                  opacity: 0.6,
                  child: Icon(Icons.description_outlined,
                      size: 48, color: _C.greenLight),
                ),
              ),
              const SizedBox(height: 16),
              Text('No advance payments found',
                  style: _ts(16, _C.gray600, weight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                  hasFilters
                      ? 'Try changing or clearing the filters'
                      : 'Nothing recorded for this date range',
                  style: _ts(14, _C.gray500)),
            ],
          ),
        ),
      );
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isFetching ? 0.6 : 1,
      child: IgnorePointer(
        ignoring: _isFetching,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                  '$_totalCount ${_totalCount == 1 ? 'entry' : 'entries'}',
                  style: _ts(14, _C.gray600, weight: FontWeight.w600)),
            ),
            if (isMobile) ...[
              for (final p in _payments) _buildMobileCard(p),
              _Pager(page: _page, pageCount: _pageCount, onChange: _setPage),
            ] else
              _buildTable(isMdUp),
          ],
        ),
      ),
    );
  }

  // ── Mobile card ──

  Widget _buildMobileCard(Map<String, dynamic> p) {
    final credit = p['type'] == 'Credit';
    final orderId = '${p['orderId'] ?? ''}';
    final mode = '${p['paymentMode'] ?? ''}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.gray100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  (p['doctorName'] == null ||
                                          '${p['doctorName']}'.isEmpty)
                                      ? '—'
                                      : '${p['doctorName']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: _ts(14, _C.gray800,
                                      weight: FontWeight.w700)),
                              Text('${p['doctoruserId'] ?? ''}',
                                  style: _ts(12, _C.gray500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeBadge(p['type'] as String?),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _C.gray50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.gray100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _LabelText('Total'),
                          Text(_formatINR(p['totalAmountReceived']),
                              style: _ts(20, credit ? _C.green : _C.red500,
                                  weight: FontWeight.w800)),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                                height: 1, thickness: 1, color: _C.gray200),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _LabelText('Mode'),
                              Text(mode.isEmpty ? '—' : mode,
                                  style: _ts(14, _C.gray700,
                                      weight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _LabelText('Order ID'),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(orderId.isEmpty ? '—' : orderId,
                                    textAlign: TextAlign.right,
                                    style: _ts(12, _C.green,
                                        weight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                                height: 1, thickness: 1, color: _C.gray200),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text(_formatDateTime(p['paymentDate']),
                                  style: _ts(14, _C.gray700,
                                      weight: FontWeight.w600)),
                            ],
                          ),
                          if (credit && orderId.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _GreenButton(
                              label: 'View Invoice',
                              icon: Icons.visibility_outlined,
                              expand: true,
                              onTap: () => _openInvoice(orderId),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: [_C.green, _C.greenLight]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Desktop table ──

  Widget _buildTable(bool isMdUp) {
    Widget th(String t, int flex, {bool right = false}) => Expanded(
          flex: flex,
          child: Text(t.toUpperCase(),
              textAlign: right ? TextAlign.right : TextAlign.left,
              style: _ts(12, _C.gray700,
                  weight: FontWeight.w700, letterSpacing: 0.6)),
        );

    return _TopBarCard(
      shadow: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HScroll(
            minWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: _C.gray50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      th('Doctor', 3),
                      th('Type', 2),
                      th('Mode', 2),
                      th('Order ID', 3),
                      th('Total', 2, right: true),
                      th('Date & Time', 3),
                      th('Action', 2),
                    ],
                  ),
                ),
                for (final p in _payments) _buildRow(p),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isMdUp ? 24 : 16, vertical: 16),
            decoration: const BoxDecoration(
              gradient: _softGreenGradient,
              border: Border(top: BorderSide(color: _C.gray200)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Text('Page ${_page + 1} of ${_pageCount == 0 ? 1 : _pageCount}',
                    style: _ts(14, _C.gray700, weight: FontWeight.w600)),
                _Pager(
                    page: _page, pageCount: _pageCount, onChange: _setPage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> p) {
    final credit = p['type'] == 'Credit';
    final orderId = '${p['orderId'] ?? ''}';
    final doctorName = '${p['doctorName'] ?? ''}';
    final mode = '${p['paymentMode'] ?? ''}';

    return _HoverRow(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName.isEmpty ? '—' : doctorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _ts(14, _C.gray800, weight: FontWeight.w600)),
                  Text('${p['doctoruserId'] ?? ''}',
                      style: _ts(12, _C.gray500)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _TypeBadge(p['type'] as String?),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(mode.isEmpty ? '—' : mode,
                  style: _ts(14, _C.gray700)),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Tooltip(
                  message: orderId,
                  child: Text(orderId.isEmpty ? '—' : orderId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _ts(14, orderId.isEmpty ? _C.gray400 : _C.green,
                          weight: FontWeight.w600)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                  '${credit ? '+' : '−'} ${_formatINR(p['totalAmountReceived'])}',
                  textAlign: TextAlign.right,
                  style: _ts(16, credit ? _C.green : _C.red500,
                      weight: FontWeight.w700)),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(_formatDateTime(p['paymentDate']),
                    style: _ts(14, _C.gray600, weight: FontWeight.w500)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: (credit && orderId.isNotEmpty)
                    ? _GreenButton(
                        label: 'View Invoice',
                        icon: Icons.visibility_outlined,
                        small: true,
                        onTap: () => _openInvoice(orderId),
                      )
                    : Text('—', style: _ts(14, _C.gray400)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}