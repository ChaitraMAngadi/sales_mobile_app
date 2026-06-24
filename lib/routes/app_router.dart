import 'package:auto_route/auto_route.dart';
 import 'package:flutter/material.dart';
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
        
      ];
}
