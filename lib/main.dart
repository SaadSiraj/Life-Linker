import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashView(),

      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}