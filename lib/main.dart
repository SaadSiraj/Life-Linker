import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/firebase_options.dart';
import 'package:lifelinker/provider/add_edit_patient.dart';
import 'package:lifelinker/provider/camera.dart';
import 'package:lifelinker/provider/caregiver_base_nav.dart';
import 'package:lifelinker/provider/caregiver_patient.dart';
import 'package:lifelinker/provider/dashboard.dart';
import 'package:lifelinker/provider/edit_profile.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:lifelinker/provider/health_data.dart';
import 'package:lifelinker/provider/location.dart';
import 'package:lifelinker/provider/login.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/provider/patient_base_nave.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:lifelinker/provider/voice_message.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefsService.init();
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
                ChangeNotifierProvider(create: (_) => SignupProvider()),
                ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),

                ChangeNotifierProvider(
                  create: (_) => CareGiverBaseNavProvider(),
                ),

                ChangeNotifierProvider(create: (_) => DashboardProvider()),
                ChangeNotifierProvider(create: (_) => MedicationProvider()),
                ChangeNotifierProvider(create: (_) => LocationProvider()),
                ChangeNotifierProvider(create: (_) => HealthDataProvider()),
                ChangeNotifierProvider(
                  create: (_) => CaregiverPatientsProvider(),
                ),
                ChangeNotifierProvider(create: (_) => AddEditPatientProvider()),
                ChangeNotifierProvider(create: (_) => ProfileProvider()),
                ChangeNotifierProvider(create: (_) => EditProfileProvider()),
                ChangeNotifierProvider(create: (_) => PatientNavProvider()),
                ChangeNotifierProvider(create: (_) => VoiceMessageProvider()),
                ChangeNotifierProvider(create: (_) => SosProvider()),
                ChangeNotifierProvider(create: (_) => CameraProvider()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'Poppins',
                  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF2A7FFF),
                    brightness: Brightness.light,
                  ),
                ),
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
