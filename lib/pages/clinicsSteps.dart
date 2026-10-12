import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/formFeilds.dart';
import 'package:sales_mobile_app/provider/marketingProvider.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/services/auth.dart';
import 'package:sales_mobile_app/services/constants.dart';
import 'package:sales_mobile_app/services/secureStorage.dart';

const Color _rose = Color(0xFFE94360);
const int _kMaxClinics = 5;

/// Android emulator  -> http://10.0.2.2:5000
/// iOS sim / Web     -> http://localhost:5000
/// Real device       -> http://<your-pc-ip>:5000
const String _kBaseUrl = '${Constants.baseUrl}/api/v1/sales';

final RegExp _phoneRe = RegExp(r'^\d{10,12}$');
final RegExp _pinRe = RegExp(r'^\d{6}$');
final RegExp _linkRe = RegExp(r'^https?://.+');
final SecureStorage secureStorage = SecureStorage();

/// backend key -> UI label (same list as React FACILITIES)
const Map<String, String> _facilityKeyToLabel = {
  'parkingAvailable': 'Parking available',
  'accessibleParking': 'Accessible parking',
  'wheelchairAccessible': 'Wheelchair accessible',
  'liftAvailable': 'Lift available',
  'pharmacy': 'Pharmacy',
  'laboratory': 'Laboratory',
  'diagnosticCentre': 'Diagnostic centre',
  'acWaitingArea': 'AC waiting area',
  'waitingArea': 'Waiting area',
  'washroomAvailable': 'Washroom',
  'drinkingWater': 'Drinking water',
  'insuranceAccepted': 'Insurance accepted',
  'cashlessFacility': 'Cashless facility',
  'emergencyFacility': 'Emergency facility',
  'cleanliness': 'Cleanliness assured',
  'hygieneStandards': 'Hygiene standards',
  'childFriendly': 'Child friendly',
  'elderlyFriendly': 'Elderly friendly',
  'securityAvailable': 'Security',
  'receptionDesk': 'Reception desk',
};

/// ---------------------------------------------------------------------
/// ✅ NEW: field validators (Qualifications page jaisa — AppTextField ka
/// `validator:` use hota hai aur Form.validate() sabko ek saath check karta hai)
/// ---------------------------------------------------------------------
String? _validateClinicName(String? v) {
  if (v == null || v.trim().isEmpty) {
    return 'Please enter the clinic or hospital name';
  }
  return null;
}

String? _validateContact(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null; // optional
  return _phoneRe.hasMatch(t) ? null : 'Enter a valid contact number (10–12 digits)';
}

String? _validatePin(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null; // optional
  return _pinRe.hasMatch(t) ? null : 'PIN code should be 6 digits';
}

String? _validateMapsLink(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null; // optional
  return _linkRe.hasMatch(t) ? null : 'Enter a valid Google Maps link (https://...)';
}

/// ---------------------------------------------------------------------
/// Session token (React: newSessionToken)
/// Ek search journey = ek token. Pick ke baad naya token.
/// ---------------------------------------------------------------------
String _newSessionToken() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final r = Random();
  return List.generate(20, (_) => chars[r.nextInt(chars.length)]).join();
}

/// ---------------------------------------------------------------------
/// Models
/// ---------------------------------------------------------------------
class _AreaResult {
  const _AreaResult({
    required this.area,
    required this.city,
    required this.state,
    this.placeId = '',
    this.pinCode = '',
    this.lat,
    this.lng,
  });

  final String area;
  final String city;
  final String state;
  final String placeId;
  final String pinCode;
  final double? lat;
  final double? lng;

  /// Search box mein dikhne wala text (React: [area, city].join(', '))
  String get locationText =>
      [area].where((e) => e.isNotEmpty).join(', ');
}

class _Suggestion {
  const _Suggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });
  final String placeId;
  final String mainText;
  final String secondaryText;

  factory _Suggestion.fromJson(Map<String, dynamic> j) => _Suggestion(
        placeId: (j['placeId'] ?? '').toString(),
        mainText: (j['mainText'] ?? '').toString(),
        secondaryText: (j['secondaryText'] ?? '').toString(),
      );
}

/// Error with a message that is safe to show to the user.
class _PlacesException implements Exception {
  _PlacesException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// ---------------------------------------------------------------------
/// API layer (React: apiFetch + fetchPlaceSuggestions / fetchPlaceDetails)
/// ---------------------------------------------------------------------
class _PlacesApi {
  const _PlacesApi(
      {this.accessToken, this.onRefreshToken, this.onUnauthenticated});

  final String? accessToken;
  final Future<String?> Function()? onRefreshToken;
  final VoidCallback? onUnauthenticated;

  // Map<String, String> _headers(String token) => {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };

  // /// Returns true only if a new token was saved.
  // Future<bool> _refreshToken() async {
  //   try {
  //     final refresh =
  //         await secureStorage.readSecureData('refreshtoken') ?? '';
  //     Constants.refreshtoken = refresh;

  //     final response = await http
  //         .post(
  //           Uri.parse(
  //               '${Constants.baseUrl}/api/v1/sales/refreshtokensalesphone'),
  //           headers: {
  //             'Authorization': 'Bearer $refresh',
  //             'Content-Type': 'application/json',
  //           },
  //         )
  //         .timeout(const Duration(seconds: 15));

  //     debugPrint('[Places] refresh token -> ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       await secureStorage.writeSecureData('token', data['token']);
  //       await secureStorage.writeSecureData(
  //           'refreshtoken', data['refreshToken']);
  //       Constants.token = data['token'];
  //       Constants.refreshtoken = data['refreshToken'];
  //       return true;
  //     }

  //     if (response.statusCode == 401 || response.statusCode == 403) {
  //       await secureStorage.deleteSecureData('token');
  //       await secureStorage.deleteSecureData('refreshtoken');
  //       Constants.token = '';
  //       Constants.refreshtoken = '';
  //       onUnauthenticated?.call();
  //     } else {
  //       debugPrint('[Places] refresh failed: ${response.body}');
  //     }
  //   } catch (e) {
  //     debugPrint('[Places] refresh error: $e');
  //   }
  //   return false;
  // }

  // Future<http.Response> _call(Uri uri) async {
  //   Constants.token = await secureStorage.readSecureData('token') ?? '';
  //   return http
  //       .get(uri, headers: _headers(Constants.token))
  //       .timeout(const Duration(seconds: 15));
  // }

  // /// Throws _PlacesException with a readable message on any failure,
  // /// so the UI can show it instead of failing silently.
  // Future<Map<String, dynamic>> _get(
  //     String path, Map<String, String> query) async {
  //   final uri = Uri.parse('$_kBaseUrl/$path').replace(queryParameters: query);

  //   var res = await _call(uri);
  //   debugPrint('[Places] GET $uri -> ${res.statusCode}');

  //   // Expired token: refresh (AWAITED), then retry once.
  //   if (res.statusCode == 401 || res.statusCode == 403) {
  //     final refreshed = await _refreshToken();
  //     if (!refreshed) {
  //       throw _PlacesException('Session expired. Please log in again.');
  //     }
  //     res = await _call(uri);
  //     debugPrint('[Places] retry GET $uri -> ${res.statusCode}');
  //   }

  //   if (res.statusCode != 200) {
  //     debugPrint('[Places] body: ${res.body}');
  //     throw _PlacesException(
  //         'Search failed (server returned ${res.statusCode}).');
  //   }

  //   final body = jsonDecode(res.body);
  //   if (body is! Map<String, dynamic> || body['success'] != true) {
  //     debugPrint('[Places] unexpected body: ${res.body}');
  //     throw _PlacesException('Search failed. Unexpected server response.');
  //   }
  //   return body;
  // }

  Future<Map<String, dynamic>> _get(
    String path, Map<String, String> query) async {
  final uri = Uri.parse('$_kBaseUrl/$path').replace(queryParameters: query);

  final res =
      await authGet(uri.toString()).timeout(const Duration(seconds: 30));
  if (res == null) {
    throw _PlacesException('Session expired. Please log in again.');
  }
  debugPrint('[Places] GET $uri -> ${res.statusCode}');

  if (res.statusCode != 200) {
    debugPrint('[Places] body: ${res.body}');
    throw _PlacesException(
        'Search failed (server returned ${res.statusCode}).');
  }

  final body = jsonDecode(res.body);
  if (body is! Map<String, dynamic> || body['success'] != true) {
    debugPrint('[Places] unexpected body: ${res.body}');
    throw _PlacesException('Search failed. Unexpected server response.');
  }
  return body;
}

  /// GET /autocomplete?input=..&sessionToken=..
  Future<List<_Suggestion>> autocomplete(
      String input, String sessionToken) async {
    final body = await _get('autocomplete', {
      'input': input,
      'sessionToken': sessionToken,
    });
    return (body['suggestions'] as List? ?? [])
        .map((e) => _Suggestion.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// GET /getlocation?placeId=..&sessionToken=..
  Future<_AreaResult> getLocation(_Suggestion s, String sessionToken) async {
    final b = await _get('getlocation', {
      'placeId': s.placeId,
      'sessionToken': sessionToken,
    });

    final coords = (b['location']?['coordinates'] as List?) ?? const [];
    final area = (b['area'] ?? '').toString();
    return _AreaResult(
      area: area.isNotEmpty ? area : s.mainText,
      city: (b['city'] ?? '').toString(),
      state: (b['state'] ?? '').toString(),
      placeId: (b['placeId'] ?? s.placeId).toString(),
      pinCode: (b['pinCode'] ?? '').toString(),
      // GeoJSON: [lng, lat]
      lng: coords.length > 1 ? (coords[0] as num).toDouble() : null,
      lat: coords.length > 1 ? (coords[1] as num).toDouble() : null,
    );
  }
}

/// ---------------------------------------------------------------------
/// One clinic entry
/// ---------------------------------------------------------------------
class _Clinic {
  // Stable id — Fees step isse match karta hai, taaki rename/delete
  // karne par fees galat clinic se mix na hon.
  static int _counter = 0;
  final int uid = _counter++;

  _Clinic({
    String name = '',
    String branch = '',
    String contact = '',
    String pin = '',
    String address = '',
    String mapsLink = '',
    this.area,
    Set<String>? facilities,
  })  : name = TextEditingController(text: name),
        branch = TextEditingController(text: branch),
        contact = TextEditingController(text: contact),
        pincode = TextEditingController(text: pin),
        address = TextEditingController(text: address),
        mapsLink = TextEditingController(text: mapsLink),
        facilities = facilities ?? <String>{};

  final TextEditingController name;
  final TextEditingController branch;
  final TextEditingController contact;
  final TextEditingController pincode;
  final TextEditingController address;
  final TextEditingController mapsLink;
  _AreaResult? area;
  final Set<String> facilities; // UI labels

  /// ✅ Area box ek FormField nahi hai, isliye uska error alag se rakha hai.
  /// Baaki saare fields ke errors ab Form ke validators se aate hain.
  String? areaError;

  void dispose() {
    name.dispose();
    branch.dispose();
    contact.dispose();
    pincode.dispose();
    address.dispose();
    mapsLink.dispose();
  }
}

/// ---------------------------------------------------------------------
/// Main step
/// ---------------------------------------------------------------------
class ClinicsStep extends StatefulWidget {
  const ClinicsStep({
    super.key,
    this.initialData,
    this.accessToken,
    this.onRefreshToken,
    this.onUnauthenticated,
  });

  final List? initialData;

  /// React: accessTokenSuperadmin
  final String? accessToken;

  /// React: refreshSuperadminToken  (naya token return kare, fail pe null)
  final Future<String?> Function()? onRefreshToken;

  /// React: onUnauthenticated: () => navigate("/")
  final VoidCallback? onUnauthenticated;

  @override
  State<ClinicsStep> createState() => ClinicsStepState();
}

class ClinicsStepState extends State<ClinicsStep> {
  final List<_Clinic> _clinics = [];

  _PlacesApi get _api => _PlacesApi(
        accessToken: widget.accessToken,
        onRefreshToken: widget.onRefreshToken,
        onUnauthenticated: widget.onUnauthenticated,
      );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final list = widget.initialData;
    if (list == null || list.isEmpty) {
      _clinics.add(_Clinic());
      return;
    }
    for (final raw in list) {
      final c = Map<String, dynamic>.from(raw as Map);
      final fac = Map<String, dynamic>.from(c['facilities'] ?? {});
      final selected = <String>{
        for (final e in _facilityKeyToLabel.entries)
          if (fac[e.key] == true) e.value,
      };

      // React: location present hoga tabhi "selected" maana jaata hai
      _AreaResult? area;
      final loc = c['location'];
      if (loc is Map && loc['coordinates'] is List) {
        final co = loc['coordinates'] as List;
        if (co.length >= 2) {
          area = _AreaResult(
            area: (c['area'] ?? '').toString(),
            city: (c['city'] ?? '').toString(),
            state: (c['state'] ?? '').toString(),
            placeId: (c['placeId'] ?? '').toString(),
            lng: (co[0] as num).toDouble(),
            lat: (co[1] as num).toDouble(),
          );
        }
      }

      _clinics.add(_Clinic(
        name: (c['clinicName'] ?? '').toString(),
        branch: (c['branchName'] ?? '').toString(),
        contact: (c['contactNumber'] ?? '').toString(),
        pin: (c['pinCode'] ?? '').toString(),
        address: (c['fullAddress'] ?? '').toString(),
        mapsLink: (c['googleLocationLink'] ?? '').toString(),
        area: area,
        facilities: selected,
      ));
    }
  }

  @override
  void dispose() {
    for (final c in _clinics) {
      c.dispose();
    }
    super.dispose();
  }

  /// Live list for the Fees step: id + name (or "Clinic N") + city.
  List<Map<String, dynamic>> getSummaries() {
    return [
      for (var i = 0; i < _clinics.length; i++)
        {
          'id': _clinics[i].uid,
          'name': _clinics[i].name.text.trim().isEmpty
              ? 'Clinic ${i + 1}'
              : _clinics[i].name.text.trim(),
          'city': _clinics[i].area?.city ?? '',
        },
    ];
  }

  /// Backend payload ke same keys. Fees / availability parent merge karega.
  List<Map<String, dynamic>> getData() {
    return _clinics.map((c) {
      final a = c.area;
      return {
        'clinicName': c.name.text.trim(),
        'branchName': c.branch.text.trim(),
        'contactNumber': c.contact.text.trim(),
        'pinCode': c.pincode.text.trim(),
        'placeId': a?.placeId ?? '',
        'area': a?.area ?? '',
        'city': a?.city ?? '',
        'state': a?.state ?? '',
        if (a?.lat != null && a?.lng != null)
          'location': {
            'type': 'Point',
            'coordinates': [a!.lng, a.lat],
          },
        'googleLocationLink': c.mapsLink.text.trim(),
        'fullAddress': c.address.text.trim(),
        'facilities': {
          for (final e in _facilityKeyToLabel.entries)
            e.key: c.facilities.contains(e.value),
        },
      };
    }).toList();
  }

  /// ✅ CHANGED: Qualifications jaisa — Form.validate() se saare text fields
  /// (name, contact, PIN, Maps link) ek saath check hote hain, plus area
  /// selection alag se check hoti hai. true = sab theek.
  bool validate() {
    final formOk = _formKey.currentState?.validate() ?? true;

    var areaOk = true;
    for (final c in _clinics) {
      if (c.area == null) {
        c.areaError = 'Search and select the clinic location';
        areaOk = false;
      } else {
        c.areaError = null;
      }
    }
    setState(() {});
    return formOk && areaOk;
  }

  void _addClinic() => setState(() => _clinics.add(_Clinic()));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = TextStyle(fontSize: 11, color: Colors.grey.shade600);

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 700;

      // ✅ Poora step Form ke andar — validators typing ke baad khud clear ho jaate hain
      return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Your practice locations',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _rose.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_clinics.length}/$_kMaxClinics',
                    style: const TextStyle(
                      fontSize: 11,
                      color: _rose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed:
                      _clinics.length >= _kMaxClinics ? null : _addClinic,
                  icon: const Icon(Icons.add, size: 16, color: _rose),
                  label: const Text('Add clinic',
                      style: TextStyle(color: _rose, fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _rose),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Add each place you practise and your weekly timings there. You'll set fees for each clinic in the next step.",
              style: muted,
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < _clinics.length; i++) ...[
              _buildCard(i, wide),
              const SizedBox(height: 16),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCard(int i, bool wide) {
    final clinic = _clinics[i];
    final muted = TextStyle(fontSize: 11, color: Colors.grey.shade600);

    return ListenableBuilder(
      key: ObjectKey(clinic),
      // Sirf card ka title (naam / "Clinic N") live update karne ke liye
      listenable: clinic.name,
      builder: (context, _) {
        final typed = clinic.name.text.trim();
        return RepeatCard(
          title: typed.isEmpty ? 'Clinic ${i + 1}' : typed,
          onRemove: _clinics.length > 1
              ? () => setState(() => _clinics.removeAt(i).dispose())
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledField(
                label: 'Clinic / hospital name',
                isRequired: true,
                child: AppTextField(
                  controller: clinic.name,
                  hint: 'e.g. CareWell Heart Clinic',
                  validator: _validateClinicName,
                ),
              ),
              const SizedBox(height: 10),
              LabeledField(
                label: 'Branch name',
                child: AppTextField(
                  controller: clinic.branch,
                  hint: 'e.g. Salt Lake branch',
                ),
              ),
              const SizedBox(height: 10),
              LabeledField(
                label: 'Clinic contact number',
                child: AppTextField(
                  controller: clinic.contact,
                  hint: 'e.g. 03324567890',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.call_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  validator: _validateContact,
                ),
              ),
              const SizedBox(height: 10),
              LabeledField(
                label: 'PIN code',
                child: AppTextField(
                  controller: clinic.pincode,
                  hint: 'e.g. 700091',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: _validatePin,
                ),
              ),
              const SizedBox(height: 16),

              _AreaSearchField(
                key: ValueKey('area-${clinic.uid}'),
                api: _api,
                selected: clinic.area,
                wide: wide,
                errorText: clinic.areaError,
                onPicked: (r) => setState(() {
                  clinic.area = r;
                  clinic.areaError = null;
                  // React: API PIN de to hi overwrite (warna user ka PIN safe)
                  if (r.pinCode.isNotEmpty) clinic.pincode.text = r.pinCode;
                }),
                onCleared: () => setState(() => clinic.area = null),
              ),
              const SizedBox(height: 16),

              _grid(1, [
                LabeledField(
                  label: 'Full address',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: clinic.address,
                        hint: 'e.g. 123, MG Road, near Central Park',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'The full address a patient would need to actually find your door',
                        style: muted,
                      ),
                    ],
                  ),
                ),
                LabeledField(
                  label: 'Google Maps link',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: clinic.mapsLink,
                        hint: 'e.g. https://maps.app.goo.gl/...',
                        keyboardType: TextInputType.url,
                        prefixIcon: Icons.link,
                        validator: _validateMapsLink,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Open the clinic in Google Maps, tap Share and paste the link here.',
                        style: muted,
                      ),
                      Text(
                        'This link will be used to fetch Google reviews for this clinic.',
                        style: muted.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              _FacilitiesGrid(
                selected: clinic.facilities,
                columns: wide ? 4 : 2,
                onChanged: (updated) => setState(() {
                  clinic.facilities
                    ..clear()
                    ..addAll(updated);
                }),
              ),
              const SizedBox(height: 10),
              Text(
                "You'll set fees and weekly timings for each clinic in the next steps.",
                style: muted,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Err extends StatelessWidget {
  const _Err(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text,
            style: const TextStyle(fontSize: 11.5, color: Colors.red)),
      );
}

/// N-column responsive grid
Widget _grid(int cols, List<Widget> items, {double gap = 12}) {
  final rows = <Widget>[];
  for (var i = 0; i < items.length; i += cols) {
    final chunk = items.skip(i).take(cols).toList();
    rows.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var j = 0; j < cols; j++) ...[
          if (j > 0) SizedBox(width: gap),
          Expanded(child: j < chunk.length ? chunk[j] : const SizedBox()),
        ],
      ],
    ));
    if (i + cols < items.length) rows.add(const SizedBox(height: 16));
  }
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
}

/// ---------------------------------------------------------------------
/// Area search (React: LocationSearch)
///  - min 3 chars, 350ms debounce
///  - suggestions field ke neeche INLINE dikhte hain (Overlay nahi)
///  - ek session token poore journey ke liye, pick ke baad naya
///  - stale response ignore (requestId), cache per text
///  - text edit karte hi purani selection clear
/// ---------------------------------------------------------------------
class _AreaSearchField extends StatefulWidget {
  const _AreaSearchField({
    super.key,
    required this.api,
    required this.selected,
    required this.onPicked,
    required this.onCleared,
    required this.wide,
    this.errorText,
  });

  final _PlacesApi api;
  final _AreaResult? selected;
  final ValueChanged<_AreaResult> onPicked;
  final VoidCallback onCleared;
  final bool wide;
  final String? errorText;

  @override
  State<_AreaSearchField> createState() => _AreaSearchFieldState();
}

class _AreaSearchFieldState extends State<_AreaSearchField> {
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<_Suggestion> _suggestions = [];
  final Map<String, List<_Suggestion>> _cache = {};
  bool _loading = false;
  bool _showList = false; // true once a search finished for the current text
  String? _apiError; // network / server problem, shown under the field
  bool _suppress = false;
  String _lastText = '';
  int _requestId = 0;
  String _sessionToken = _newSessionToken();

  @override
  void initState() {
    super.initState();
    final s = widget.selected;
    if (s != null) _setText(s.locationText);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _setText(String t) {
    _suppress = true;
    _controller.text = t;
    _lastText = t;
    _suppress = false;
  }

  String _friendly(Object e) => e is _PlacesException
      ? e.message
      : 'Could not reach the server. Check your internet connection.';

  // ---------- typing -> /autocomplete ----------
  void _onTextChanged() {
    if (_suppress) return;
    if (_controller.text == _lastText) return; // focus/cursor change only
    _lastText = _controller.text;

    // Typing clears the previous selection (area/city/state/location).
    if (widget.selected != null) widget.onCleared();

    _debounce?.cancel();
    final text = _controller.text.trim();
    if (text.length < 3) {
      _requestId++;
      setState(() {
        _suggestions = [];
        _showList = false;
        _loading = false;
        _apiError = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(text));
  }

  Future<void> _search(String text) async {
    final cached = _cache[text];
    if (cached != null) {
      setState(() {
        _suggestions = cached;
        _showList = true;
        _apiError = null;
      });
      return;
    }

    final myRequest = ++_requestId;
    setState(() {
      _loading = true;
      _apiError = null;
    });
    try {
      final results = await widget.api.autocomplete(text, _sessionToken);
      if (!mounted || myRequest != _requestId) return; // newer keystroke fired
      _cache[text] = results;
      setState(() {
        _suggestions = results;
        _loading = false;
        _showList = true;
      });
    } catch (e) {
      if (!mounted || myRequest != _requestId) return;
      debugPrint('[Places] autocomplete error: $e');
      setState(() {
        _suggestions = [];
        _loading = false;
        _showList = false;
        _apiError = _friendly(e);
      });
    }
  }

  // ---------- select -> /getlocation ----------
  Future<void> _pick(_Suggestion s) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _showList = false;
      _suggestions = [];
      _loading = true;
      _apiError = null;
    });
    _setText(s.mainText);

    try {
      final result = await widget.api.getLocation(s, _sessionToken);
      if (!mounted) return;
      _setText(result.locationText);
      widget.onPicked(result);
    } catch (e) {
      debugPrint('[Places] getlocation error: $e');
      if (mounted) setState(() => _apiError = _friendly(e));
    } finally {
      // Session finished -> fresh token for the next search.
      _cache.clear();
      _sessionToken = _newSessionToken();
      if (mounted) setState(() => _loading = false);
    }
  }

  // ---------- inline suggestions ----------
  Widget _buildSuggestions() {
    if (!_showList) return const SizedBox.shrink();

    if (_suggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'No matching areas found. Try a different spelling.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      );
    }

    final items = _suggestions.take(6).toList();
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              InkWell(
                onTap: () => _pick(items[i]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.location_on_outlined,
                            size: 16, color: _rose),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[i].mainText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            if (items[i].secondaryText.isNotEmpty)
                              Text(items[i].secondaryText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    final muted = TextStyle(fontSize: 11, color: Colors.grey.shade600);
    final hasError = widget.errorText != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: hasError ? Colors.red.shade300 : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Area',
            isRequired: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _controller,
                  hint: 'Search by area (type at least 3 letters)',
                  prefixIcon: Icons.search,
                  suffixIcon: _loading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _rose),
                          ),
                        )
                      : null,
                ),
                _buildSuggestions(),
                if (_apiError != null) _Err(_apiError!),
                const SizedBox(height: 4),
                Text(
                  'Start typing and pick your area from the list — area, city, state fill in automatically',
                  style: muted,
                ),
                if (hasError) _Err(widget.errorText!),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (sel != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReadOnlyBox(label: 'Area', value: sel.area),
                const SizedBox(height: 4),
                _ReadOnlyBox(label: 'City', value: sel.city),
                const SizedBox(height: 4),
                _ReadOnlyBox(label: 'State', value: sel.state),
                if (widget.wide) const Spacer(),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _rose.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: _rose.withOpacity(0.8)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Area, city, state will appear here once you pick a location',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadOnlyBox extends StatelessWidget {
  const _ReadOnlyBox({required this.label, this.value});
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final has = value != null && value!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5FA),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFDDE5EF)),
          ),
          child: Text(
            has ? value! : '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              color: has ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------
/// Facilities grid
/// ---------------------------------------------------------------------
class _FacilitiesGrid extends StatelessWidget {
  const _FacilitiesGrid({
    required this.selected,
    required this.onChanged,
    this.columns = 4,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final int columns;

  void _toggle(String f) {
    final updated = Set<String>.from(selected);
    updated.contains(f) ? updated.remove(f) : updated.add(f);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final labels = _facilityKeyToLabel.values.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Facilities',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const Spacer(),
            Text('${selected.length} selected',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(builder: (context, c) {
          const spacing = 8.0;
          final w = (c.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: labels.map((f) {
              final on = selected.contains(f);
              return SizedBox(
                width: w,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _toggle(f),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: on ? _rose.withOpacity(0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: on ? _rose : Colors.grey.shade300,
                        width: on ? 1.2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Checkbox(
                            value: on,
                            activeColor: _rose,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (_) => _toggle(f),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  on ? FontWeight.w600 : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}