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
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    RegisterNewDoctorRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterNewDoctorPage(),
      );
    },
    RegisterNewHospitalRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterNewHospitalPage(),
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
/// [RegisterNewDoctorPage]
class RegisterNewDoctorRoute extends PageRouteInfo<void> {
  const RegisterNewDoctorRoute({List<PageRouteInfo>? children})
      : super(
          RegisterNewDoctorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterNewDoctorRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
