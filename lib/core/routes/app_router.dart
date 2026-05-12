import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/caregiver/caregiver%20base%20nav/care_giver_base_nav.dart';
import 'package:lifelinker/view/caregiver/dite/dite.dart';
import 'package:lifelinker/view/caregiver/health_monitoring/health.dart';
import 'package:lifelinker/view/caregiver/medication/medication.dart';
import 'package:lifelinker/view/caregiver/moniter/caregiver_moniter.dart';
import 'package:lifelinker/view/caregiver/patient%20details/patient_details.dart';
import 'package:lifelinker/view/caregiver/profile/caregiver_profile.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/sleep_routine.dart';
import 'package:lifelinker/view/common/edit_profile/edit_profile.dart';
import 'package:lifelinker/view/common/login/forgot_password.dart/forgot_password_view.dart';
import 'package:lifelinker/view/common/login/login/login_view.dart';
import 'package:lifelinker/view/common/onboarding/role_selection/role_selection.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/signup_flow.dart';
import 'package:lifelinker/view/common/splash/splash_view.dart';
import 'package:lifelinker/view/patient/dite/dite.dart';
import 'package:lifelinker/view/patient/helth/helth.dart';
import 'package:lifelinker/view/patient/home/patient_home.dart';
import 'package:lifelinker/view/patient/medication/medication.dart';
import 'package:lifelinker/view/patient/patient%20base%20nav/patient_base_nav.dart';
import 'package:lifelinker/view/patient/patient%20profile/patien_profile.dart';
import 'package:lifelinker/view/patient/sleep%20routine/sleep_routine.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case RouteNames.splash:
        builder = (_) => const SplashView();
        break;
      case RouteNames.login:
        builder = (_) => const LoginView();
        break;
      case RouteNames.roleSelection:
        builder = (_) => const RoleSelectionView();
        break;
      case RouteNames.signup:
        builder = (_) => const SignupFlowView();
        break;
      case RouteNames.forgotPassword:
        builder = (_) => const ForgotPasswordView();
        break;

      case RouteNames.caregiverHealth:
        final patient = settings.arguments as UserModel;
        builder = (_) => CaregiverHealthView(patient: patient);
        break;
      case RouteNames.patientHealth:
        builder = (_) => const PatientHealthView();
        break;
      case RouteNames.caregiverBase:
        builder = (_) => const CaregiverBaseView();
        break;
      case RouteNames.patientBase:
        builder = (_) => const PatientBaseView();
        break;

      case RouteNames.patientDetails:
        final patient = settings.arguments as UserModel;
        builder = (_) => PatientDetailsView(patient: patient);
        break;
      case RouteNames.profile:
        final role = SharedPrefsService.getUserRole();
        builder = (_) => role == 'caregiver'
            ? const CaregiverProfileView()
            : const PatientProfileView();
        break;
      case RouteNames.editProfile:
        builder = (_) => const EditProfileView();
        break;
      case RouteNames.patientHome:
        builder = (_) => const PatientHomeView();
        break;
      case RouteNames.caregiverMonitor:
        final args = settings.arguments as Map<String, dynamic>;
        builder = (_) => CaregiverMonitorView(
          patient: args['patient'] as UserModel,
          caregiverId: args['caregiverId'] as String,
        );
      case RouteNames.caregiverMedication:
        final patient = settings.arguments as UserModel;
        builder = (_) => CaregiverMedicationView(patient: patient);
        break;

      case RouteNames.patientMedication:
        builder = (_) => const PatientMedicationView();
        break;
      case RouteNames.caregiverDiet:
        final patient = settings.arguments as UserModel;
        builder = (_) => CaregiverDietView(patient: patient);
        break;
      case RouteNames.caregiverSleep:
        final patient = settings.arguments as UserModel;
        builder = (_) => CaregiverSleepView(patient: patient);
        break;

      case RouteNames.patientSleep:
        builder = (_) => const PatientSleepView();
        break;

      case RouteNames.patientDiet:
        builder = (_) => const PatientDietView();
        break;

      default:
        builder = (_) =>
            const Scaffold(body: Center(child: AppText('No route defined')));
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Future<dynamic> push(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }
}
