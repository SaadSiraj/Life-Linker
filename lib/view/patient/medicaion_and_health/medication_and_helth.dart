import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/view/patient/helth/helth.dart';
import 'package:lifelinker/view/patient/medication/medication.dart';

class PatientMedHealthView extends StatefulWidget {
  const PatientMedHealthView({super.key});

  @override
  State<PatientMedHealthView> createState() => _PatientMedHealthViewState();
}

class _PatientMedHealthViewState extends State<PatientMedHealthView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [PatientMedicationBody(), PatientHealthBody()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isMed = _tabController.index == 0;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title row
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4,
                right: SizeConfig.widthMultiplier * 4,
                top: SizeConfig.heightMultiplier * 1.8,
                bottom: SizeConfig.heightMultiplier * 0.5,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.widthMultiplier * 10,
                    decoration: BoxDecoration(
                      color: isMed
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.alert.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isMed
                            ? Icons.medication_rounded
                            : Icons.favorite_rounded,
                        key: ValueKey(isMed),
                        color: isMed ? AppColors.primary : AppColors.alert,
                        size: SizeConfig.widthMultiplier * 5.5,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 3),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      key: ValueKey(isMed),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          isMed ? 'My Medications' : 'My Health',
                          size: 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                        AppText(
                          isMed ? "Today's Schedule" : 'Health Records',
                          size: 12,
                          color: AppColors.iconGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab selector
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4,
                vertical: SizeConfig.heightMultiplier * 1,
              ),
              child: Container(
                height: SizeConfig.heightMultiplier * 5.5,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    _TabItem(
                      icon: Icons.medication_rounded,
                      label: 'Medications',
                      activeColor: AppColors.primary,
                      isActive: _tabController.index == 0,
                    ),
                    _TabItem(
                      icon: Icons.favorite_rounded,
                      label: 'Health',
                      activeColor: AppColors.alert,
                      isActive: _tabController.index == 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color activeColor;
  final bool isActive;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: SizeConfig.heightMultiplier * 5.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: SizeConfig.widthMultiplier * 4.5,
            color: isActive ? activeColor : AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1.5),
          AppText(
            label,
            size: 13,
            color: isActive ? activeColor : AppColors.iconGrey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
