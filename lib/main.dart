import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/appLockWrapper.dart';
import 'package:sales_mobile_app/provider/authProvider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';


final AppRouter appRouter = AppRouter();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Authprovider()),
    ChangeNotifierProvider(create: (_) => Salesprovider()),
  ], child: MyApp()));
}



class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        drawerTheme:  DrawerThemeData(
      backgroundColor: Colors.white,
    ),
      ), 
      title: 'Sales Management',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
    builder: (context, child) {
        return AppLockWrapper(
          child: child!,
        );
      },
    
    );
  }
}


