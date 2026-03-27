import 'package:flutter/material.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/module/health_monitoring/health_data.dart';

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
      home: HealthDataView(),

      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}