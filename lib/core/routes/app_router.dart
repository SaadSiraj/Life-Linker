import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/view/add%20medication/add_medication.dart';
import 'package:lifelinker/view/auth/forgot_password.dart/forgot_password_view.dart';
import 'package:lifelinker/view/auth/login/login_view.dart';
import 'package:lifelinker/view/health_monitoring/health_data.dart';
import 'package:lifelinker/view/splash/splash_view.dart';

import '../widgets/app_text.dart';

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
      case RouteNames.forgotPassword:
        builder = (_) => const ForgotPasswordView();
        break;
      case RouteNames.healthView:
        builder = (_) => const HealthDataView();
        break;
      case RouteNames.addMedication:
        builder = (_) => const AddMedicationView();
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
