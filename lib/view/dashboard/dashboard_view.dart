import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/model/dashboard.dart';
import 'package:lifelinker/provider/dashboard.dart';
import 'package:lifelinker/view/dashboard/components/card.dart';
import 'package:lifelinker/view/dashboard/components/header.dart';
import 'package:lifelinker/view/dashboard/components/loading.dart';
import 'package:lifelinker/view/dashboard/components/sos.dart';
import 'package:lifelinker/view/health_monitoring/health_data.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const DashboardLoadingView();
          if (provider.hasError) {
            return DashboardErrorView(onRetry: provider.refresh);
          }
          final data = provider.data!;
          return Column(
            children: [
              Expanded(child: _buildBody(context, provider, data)),
              SosBar(pulseAnimation: _pulseAnimation),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DashboardProvider provider,
    DashboardModel data,
  ) {
    return RefreshIndicator(
      onRefresh: () async => provider.refresh(),
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: DashboardHeader(data: data)),
          SliverToBoxAdapter(child: Gap.v(20)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 24.v),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                DashCard(
                  icon: Icons.location_on_rounded,
                  iconColor: AppColors.blue,
                  iconBg: AppColors.blueLight,
                  title: 'Location',
                  value: data.locationLabel,
                  subtitle: data.locationSub,
                  onTap: () {},
                ),
                DashCard(
                  icon: Icons.medication_rounded,
                  iconColor: AppColors.successDark,
                  iconBg: AppColors.successLight,
                  title: 'Medication',
                  value: data.medicationLabel,
                  subtitle: data.medicationSub,
                  onTap: () {},
                ),
                DashCard(
                  icon: Icons.people_alt_rounded,
                  iconColor: AppColors.amber,
                  iconBg: AppColors.amberLight,
                  title: 'Known People',
                  value: '${data.knownPeopleCount} contacts',
                  subtitle: data.knownPeopleSub,
                  onTap: () {},
                ),
                DashCard(
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.alert,
                  iconBg: AppColors.alertLight,
                  title: 'Health',
                  value: data.healthLabel,
                  subtitle: data.healthSub,
                  onTap: () =>
                    Navigator.pushReplacementNamed(context, RouteNames.healthView),
                  
                ),
              ]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.h,
                mainAxisSpacing: 10.v,
                childAspectRatio: 1.0,
              ),
            ),
          ),
          SliverToBoxAdapter(child: Image.asset(AppImages.building)),
        ],
      ),
    );
  }
}
