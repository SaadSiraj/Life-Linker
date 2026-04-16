import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/base_navigation.dart';
import 'package:lifelinker/provider/dashboard.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:lifelinker/provider/location.dart';
import 'package:lifelinker/provider/login.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => LoginProvider()),
                ChangeNotifierProvider(create: (_) => BaseNavProvider()),
                ChangeNotifierProvider(create: (_) => DashboardProvider()),
                ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
                // ChangeNotifierProvider(create: (_) => PeopleProvider()),
                ChangeNotifierProvider(create: (_) => ProfileProvider()),
                ChangeNotifierProvider(create: (_) => LocationProvider()),
                // ChangeNotifierProvider(create: (_) => HealthProvider()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: RouteNames.splash,
                onGenerateRoute: AppRouter.generateRoute,
              ),
            );
          },
        );
      },
    );
  }
}
