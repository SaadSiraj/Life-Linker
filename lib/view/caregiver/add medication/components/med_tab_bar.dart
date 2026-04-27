import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

class MedTabBar extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int> onTap;

  const MedTabBar({
    super.key,
    required this.tabController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      padding: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4),
        ],
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTap,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.iconGrey,
        labelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Today'),
          Tab(text: 'Schedule'),
          Tab(text: 'History'),
        ],
      ),
    );
  }
}