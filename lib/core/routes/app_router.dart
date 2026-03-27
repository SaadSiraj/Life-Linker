import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/module/auth/views/login_view.dart';
import 'package:lifelinker/module/splash/splash_view.dart';
import '../shared/app_text.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      // Splash

      case RouteNames.splash:
        builder = (_) => const SplashView();
        break;
      // case RouteNames.onboarding:
      //   builder = (_) => const OnboardingScreen();
      //   break;
      // Auth
      case RouteNames.login:
        builder = (_) => const LoginView();
        break;
      // case RouteNames.register:
      //   builder = (_) => const RegisterView();
      //   break;
      // case RouteNames.home:
      //   builder = (_) => const HomeView();
      //   break;
      // case RouteNames.setting:
      //   builder = (_) => const ProfileSettingsView();
      //   break;
      // case RouteNames.account:
      //   builder = (_) => const AccountView();
      //   break;
      // case RouteNames.editProfile:
      //   builder = (_) => const EditProfileView();
      //   break;
      // case RouteNames.myOrders:
      //   builder = (_) => const MyOrdersView();
      //   break;
      // case RouteNames.tumblerView:
      //   builder = (_) => const TumblerView();
      //   break;
      // case RouteNames.missionsRewards:
      //   builder = (_) => const MissionsRewardsView();
      //   break;
      // case RouteNames.myVouchers:
      //   builder = (_) => const MyVoucherView();
      //   break;
      // case RouteNames.settingView:
      //   builder = (_) => const SettingView();
      //   break;
      // case RouteNames.termsandCondition:
      //   builder = (_) => const TermsandConditionView();
      //   break;
      // case RouteNames.giftCard:
      //   builder = (_) => const GiftCardView();
      //   break;
      // case RouteNames.giftCardHistory:
      //   builder = (_) => const GiftCardHistoryView();
      //   break;
      // case RouteNames.helpCentre:
      //   builder = (_) => const HelpCentreView();
      //   break;
      // case RouteNames.faqs:
      //   builder = (_) => const HelpCenterFaqsView();
      //   break;
      // case RouteNames.faqDetail:
      //   final question = settings.arguments is String ? settings.arguments as String : '';
      //   builder = (_) => FaqDetailView(question: question);
      //   break;
      // case RouteNames.rewardsFaq:
      //   builder = (_) => const RewardsFaqView();
      //   break;
      // case RouteNames.rewardDetail:
      //   builder = (_) => const RewardDetailView();
      //   break;
      // case RouteNames.sendGiftCard:
      //   builder = (_) => const SendGiftCardView();
      //   break;
      // case RouteNames.paymentMethods:
      //   builder = (_) => const PaymentMethodsView();
      //   break;
      // case RouteNames.deleteAccount:
      //   builder = (_) => const DeleteAccountView();
      //   break;
      // case RouteNames.sendGiftTermsAndAgreement:
      //   builder = (_) => const SendGiftTermsAndAgreementView();
      //   break;
      // case RouteNames.balanceTopupIntro:
      //   builder = (_) => const VirginBalanceTopUpIntroView();
      //   break;
      // case RouteNames.virginBalanceTopUp:
      //   builder = (_) => const VirginBalanceTopUpView();
      //   break;
      // case RouteNames.topUpGiftVoucher:
      //   builder = (_) => const TopUpGiftVoucherView();
      //   break;
      // case RouteNames.virginBalance:
      //   builder = (_) => const VirginBalanceView();
      //   break;
      // case RouteNames.selectOutlet:
      //   builder = (_) => const SelectOutletView();
      //   break;
      // case RouteNames.virginClub:
      //   builder = (_) => const VirginClubView();
      //   break;
      // case RouteNames.virginClubFaq:
      //   builder = (_) => const VirginClubFaqsView();
      //   break;
      // case RouteNames.cupCountHistory:
      //   builder = (_) => const CupCountHistoryView();
      //   break;
      // case RouteNames.virginPointsHistory:
      //   builder = (_) => const VirginPointsHistoryView();
      //   break;
      //   // case RouteNames.authSelection:
      // //   builder = (_) => const AuthSelectionView();
      // //   break;
      // // case RouteNames.signIn:
      // //   builder = (_) => const LoginView();
      // //   break;
      // // case RouteNames.signUp:
      // //   builder = (_) => const SignUpView();
      // //   break;
        

      // // //user
      // // case RouteNames.mainNavigation:
      // //   builder = (_) => const MainNavigationView();
      // //   break;


      default:
        builder =
            (_) => const Scaffold(
              body: Center(child: AppText("🚫 No route defined")),
            );
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// 🟢 Push new screen
  static Future<dynamic> push(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// 🟡 Replace current screen
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

  /// 🔴 Clear all and go to new screen
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

  /// ⬅️ Pop screen
  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }
}
