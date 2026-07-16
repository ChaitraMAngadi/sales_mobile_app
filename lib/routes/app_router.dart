import 'package:auto_route/auto_route.dart';
 import 'package:flutter/material.dart';
import 'package:sales_mobile_app/authenticationScreen.dart';
import 'package:sales_mobile_app/dashBoard.dart';
import 'package:sales_mobile_app/loginPage.dart';
import 'package:sales_mobile_app/pages/admins/editAdminPage.dart';
import 'package:sales_mobile_app/pages/admins/registerNewAdmin.dart';
import 'package:sales_mobile_app/pages/doctors/editDoctorPage.dart';
import 'package:sales_mobile_app/pages/doctors/registerNewDoctor.dart';
import 'package:sales_mobile_app/pages/hospitals/editHospitalPage.dart';
import 'package:sales_mobile_app/pages/hospitals/registerNewHospital.dart';
import 'package:sales_mobile_app/pages/labtechnician/editLabTechnicianPage.dart';
import 'package:sales_mobile_app/pages/labtechnician/registerNewLabtechnician.dart';
import 'package:sales_mobile_app/splashPage.dart';

part 'app_router.gr.dart';

// dart run build_runner build --delete-conflicting-outputs

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: LoginRoute.page,
         
        ),
        AutoRoute(
          page: DashboardRoute.page,
         
        ),
        AutoRoute(
          page: RegisterNewHospitalRoute.page,
        ),
        AutoRoute(
          page: EditHospitalRoute.page,
        ),
        AutoRoute(
          page: RegisterNewDoctorRoute.page,
        ),
        AutoRoute(
          page: EditDoctorRoute.page,
        ),
        AutoRoute(
          page: RegisterNewAdminRoute.page,
        ),
         AutoRoute(
          page: EditAdminRoute.page,
        ),

        AutoRoute(
          page: RegisterNewLabtechnicianRoute.page,
        ),
         AutoRoute(
          page: EditLabTechnicianRoute.page,
        ),
        
      ];
}
