// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_mobile_app/pages/appLockWrapper.dart';
// import 'package:sales_mobile_app/provider/authProvider.dart';
// import 'package:sales_mobile_app/provider/marketingProvider.dart';
// import 'package:sales_mobile_app/provider/salesProvider.dart';
// import 'package:sales_mobile_app/routes/app_router.dart';
// import 'package:sales_mobile_app/theme/app_colors.dart';


// final AppRouter appRouter = AppRouter();

// void main() {
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(create: (_) => Authprovider()),
//     ChangeNotifierProvider(create: (_) => Salesprovider()),
//     ChangeNotifierProvider(create: (_) => Marketingprovider()),
//   ], child: MyApp()));
// }



// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       theme: ThemeData(
//         useMaterial3: false,
//         primaryColor: AppColors.primary,
//         scaffoldBackgroundColor: Colors.white,
//         fontFamily: 'Roboto',
//         drawerTheme:  DrawerThemeData(
//       backgroundColor: Colors.white,
//     ),
//       ), 
//       title: 'Sales Management',
//       debugShowCheckedModeBanner: false,
//       routerConfig: appRouter.config(),
//     builder: (context, child) {
//         return AppLockWrapper(
//           child: child!,
//         );
//       },
    
//     );
//   }
// }


// lib/main.dart  (SALES APP)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_mobile_app/pages/appLockWrapper.dart';
import 'package:sales_mobile_app/provider/authProvider.dart';
import 'package:sales_mobile_app/provider/marketingProvider.dart';
import 'package:sales_mobile_app/provider/salesProvider.dart';
import 'package:sales_mobile_app/routes/app_router.dart';
import 'package:sales_mobile_app/services/tokenManager.dart';
import 'package:sales_mobile_app/theme/app_colors.dart';

final AppRouter appRouter = AppRouter();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Refresh token bhi invalid ho gaya => session khatam, Splash (-> Login) par bhejo.
  // Navigation frame ke baad chalta hai taaki build ke beech Navigator na toote.
  TokenManager.onSessionExpired = () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appRouter.replaceAll([const SplashRoute()]);
    });
  };

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Authprovider()),
    ChangeNotifierProvider(create: (_) => Salesprovider()),
    ChangeNotifierProvider(create: (_) => Marketingprovider()),
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
        drawerTheme: const DrawerThemeData(
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
