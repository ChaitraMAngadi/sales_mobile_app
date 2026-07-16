// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthenticationRoute.name: (routeData) {
      final args = routeData.argsAs<AuthenticationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthenticationPage(
          key: args.key,
          email: args.email,
          password: args.password,
        ),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    EditAdminRoute.name: (routeData) {
      final args = routeData.argsAs<EditAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditAdminPage(
          key: args.key,
          adminData: args.adminData,
          alldoctors: args.alldoctors,
        ),
      );
    },
    EditDoctorRoute.name: (routeData) {
      final args = routeData.argsAs<EditDoctorRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditDoctorPage(
          key: args.key,
          doctorData: args.doctorData,
          allhospitals: args.allhospitals,
        ),
      );
    },
    EditHospitalRoute.name: (routeData) {
      final args = routeData.argsAs<EditHospitalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditHospitalPage(
          key: args.key,
          hospitalId: args.hospitalId,
          name: args.name,
          userid: args.userid,
          email: args.email,
          phone: args.phone,
          address: args.address,
        ),
      );
    },
    EditLabTechnicianRoute.name: (routeData) {
      final args = routeData.argsAs<EditLabTechnicianRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditLabTechnicianPage(
          key: args.key,
          technicianData: args.technicianData,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    RegisterNewAdminRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterNewAdminRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterNewAdminPage(
          key: args.key,
          alldoctors: args.alldoctors,
        ),
      );
    },
    RegisterNewDoctorRoute.name: (routeData) {
      final args = routeData.argsAs<RegisterNewDoctorRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RegisterNewDoctorPage(
          key: args.key,
          allhospitals: args.allhospitals,
        ),
      );
    },
    RegisterNewHospitalRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterNewHospitalPage(),
      );
    },
    RegisterNewLabtechnicianRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterNewLabtechnicianPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
  };
}

/// generated route for
/// [AuthenticationPage]
class AuthenticationRoute extends PageRouteInfo<AuthenticationRouteArgs> {
  AuthenticationRoute({
    Key? key,
    required String email,
    required String password,
    List<PageRouteInfo>? children,
  }) : super(
          AuthenticationRoute.name,
          args: AuthenticationRouteArgs(
            key: key,
            email: email,
            password: password,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthenticationRoute';

  static const PageInfo<AuthenticationRouteArgs> page =
      PageInfo<AuthenticationRouteArgs>(name);
}

class AuthenticationRouteArgs {
  const AuthenticationRouteArgs({
    this.key,
    required this.email,
    required this.password,
  });

  final Key? key;

  final String email;

  final String password;

  @override
  String toString() {
    return 'AuthenticationRouteArgs{key: $key, email: $email, password: $password}';
  }
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditAdminPage]
class EditAdminRoute extends PageRouteInfo<EditAdminRouteArgs> {
  EditAdminRoute({
    Key? key,
    required Map<String, dynamic> adminData,
    required List<Map<String, dynamic>> alldoctors,
    List<PageRouteInfo>? children,
  }) : super(
          EditAdminRoute.name,
          args: EditAdminRouteArgs(
            key: key,
            adminData: adminData,
            alldoctors: alldoctors,
          ),
          initialChildren: children,
        );

  static const String name = 'EditAdminRoute';

  static const PageInfo<EditAdminRouteArgs> page =
      PageInfo<EditAdminRouteArgs>(name);
}

class EditAdminRouteArgs {
  const EditAdminRouteArgs({
    this.key,
    required this.adminData,
    required this.alldoctors,
  });

  final Key? key;

  final Map<String, dynamic> adminData;

  final List<Map<String, dynamic>> alldoctors;

  @override
  String toString() {
    return 'EditAdminRouteArgs{key: $key, adminData: $adminData, alldoctors: $alldoctors}';
  }
}

/// generated route for
/// [EditDoctorPage]
class EditDoctorRoute extends PageRouteInfo<EditDoctorRouteArgs> {
  EditDoctorRoute({
    Key? key,
    required Map<String, dynamic> doctorData,
    required List<Map<String, dynamic>> allhospitals,
    List<PageRouteInfo>? children,
  }) : super(
          EditDoctorRoute.name,
          args: EditDoctorRouteArgs(
            key: key,
            doctorData: doctorData,
            allhospitals: allhospitals,
          ),
          initialChildren: children,
        );

  static const String name = 'EditDoctorRoute';

  static const PageInfo<EditDoctorRouteArgs> page =
      PageInfo<EditDoctorRouteArgs>(name);
}

class EditDoctorRouteArgs {
  const EditDoctorRouteArgs({
    this.key,
    required this.doctorData,
    required this.allhospitals,
  });

  final Key? key;

  final Map<String, dynamic> doctorData;

  final List<Map<String, dynamic>> allhospitals;

  @override
  String toString() {
    return 'EditDoctorRouteArgs{key: $key, doctorData: $doctorData, allhospitals: $allhospitals}';
  }
}

/// generated route for
/// [EditHospitalPage]
class EditHospitalRoute extends PageRouteInfo<EditHospitalRouteArgs> {
  EditHospitalRoute({
    Key? key,
    required String hospitalId,
    required String name,
    required String userid,
    required String email,
    required String phone,
    required String address,
    List<PageRouteInfo>? children,
  }) : super(
          EditHospitalRoute.name,
          args: EditHospitalRouteArgs(
            key: key,
            hospitalId: hospitalId,
            name: name,
            userid: userid,
            email: email,
            phone: phone,
            address: address,
          ),
          initialChildren: children,
        );

  static const String name = 'EditHospitalRoute';

  static const PageInfo<EditHospitalRouteArgs> page =
      PageInfo<EditHospitalRouteArgs>(name);
}

class EditHospitalRouteArgs {
  const EditHospitalRouteArgs({
    this.key,
    required this.hospitalId,
    required this.name,
    required this.userid,
    required this.email,
    required this.phone,
    required this.address,
  });

  final Key? key;

  final String hospitalId;

  final String name;

  final String userid;

  final String email;

  final String phone;

  final String address;

  @override
  String toString() {
    return 'EditHospitalRouteArgs{key: $key, hospitalId: $hospitalId, name: $name, userid: $userid, email: $email, phone: $phone, address: $address}';
  }
}

/// generated route for
/// [EditLabTechnicianPage]
class EditLabTechnicianRoute extends PageRouteInfo<EditLabTechnicianRouteArgs> {
  EditLabTechnicianRoute({
    Key? key,
    required Map<String, dynamic> technicianData,
    List<PageRouteInfo>? children,
  }) : super(
          EditLabTechnicianRoute.name,
          args: EditLabTechnicianRouteArgs(
            key: key,
            technicianData: technicianData,
          ),
          initialChildren: children,
        );

  static const String name = 'EditLabTechnicianRoute';

  static const PageInfo<EditLabTechnicianRouteArgs> page =
      PageInfo<EditLabTechnicianRouteArgs>(name);
}

class EditLabTechnicianRouteArgs {
  const EditLabTechnicianRouteArgs({
    this.key,
    required this.technicianData,
  });

  final Key? key;

  final Map<String, dynamic> technicianData;

  @override
  String toString() {
    return 'EditLabTechnicianRouteArgs{key: $key, technicianData: $technicianData}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterNewAdminPage]
class RegisterNewAdminRoute extends PageRouteInfo<RegisterNewAdminRouteArgs> {
  RegisterNewAdminRoute({
    Key? key,
    required List<Map<String, dynamic>> alldoctors,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterNewAdminRoute.name,
          args: RegisterNewAdminRouteArgs(
            key: key,
            alldoctors: alldoctors,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterNewAdminRoute';

  static const PageInfo<RegisterNewAdminRouteArgs> page =
      PageInfo<RegisterNewAdminRouteArgs>(name);
}

class RegisterNewAdminRouteArgs {
  const RegisterNewAdminRouteArgs({
    this.key,
    required this.alldoctors,
  });

  final Key? key;

  final List<Map<String, dynamic>> alldoctors;

  @override
  String toString() {
    return 'RegisterNewAdminRouteArgs{key: $key, alldoctors: $alldoctors}';
  }
}

/// generated route for
/// [RegisterNewDoctorPage]
class RegisterNewDoctorRoute extends PageRouteInfo<RegisterNewDoctorRouteArgs> {
  RegisterNewDoctorRoute({
    Key? key,
    required List<Map<String, dynamic>> allhospitals,
    List<PageRouteInfo>? children,
  }) : super(
          RegisterNewDoctorRoute.name,
          args: RegisterNewDoctorRouteArgs(
            key: key,
            allhospitals: allhospitals,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterNewDoctorRoute';

  static const PageInfo<RegisterNewDoctorRouteArgs> page =
      PageInfo<RegisterNewDoctorRouteArgs>(name);
}

class RegisterNewDoctorRouteArgs {
  const RegisterNewDoctorRouteArgs({
    this.key,
    required this.allhospitals,
  });

  final Key? key;

  final List<Map<String, dynamic>> allhospitals;

  @override
  String toString() {
    return 'RegisterNewDoctorRouteArgs{key: $key, allhospitals: $allhospitals}';
  }
}

/// generated route for
/// [RegisterNewHospitalPage]
class RegisterNewHospitalRoute extends PageRouteInfo<void> {
  const RegisterNewHospitalRoute({List<PageRouteInfo>? children})
      : super(
          RegisterNewHospitalRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterNewHospitalRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterNewLabtechnicianPage]
class RegisterNewLabtechnicianRoute extends PageRouteInfo<void> {
  const RegisterNewLabtechnicianRoute({List<PageRouteInfo>? children})
      : super(
          RegisterNewLabtechnicianRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterNewLabtechnicianRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
