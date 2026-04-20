import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/firebase_options.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:lifelinker/provider/base_navigation.dart';
import 'package:lifelinker/provider/dashboard.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:lifelinker/provider/health_data.dart';
import 'package:lifelinker/provider/location.dart';
import 'package:lifelinker/provider/login.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/provider/persons.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
                ChangeNotifierProvider(create: (_) => MedicationProvider()),
                ChangeNotifierProvider(create: (_) => ProfileProvider()),
                ChangeNotifierProvider(create: (_) => LocationProvider()),
                ChangeNotifierProvider(create: (_) => HealthDataProvider()),
                ChangeNotifierProvider(create: (_) => PersonsProvider()),
                ChangeNotifierProvider(create: (_) => AddPersonProvider()),
                ChangeNotifierProvider(create: (_) => EditPersonProvider()),
                ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
