import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class DateStrip extends StatelessWidget {
  const DateStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return SizedBox(
      height: 70.v,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, i) {
          final day = now.subtract(Duration(days: 3 - i));
          final isToday = i == 3;
          final dayLabel = days[day.weekday - 1];

          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 44.h,
              margin: EdgeInsets.only(right: 8.h),
              decoration: BoxDecoration(
                color: isToday ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: 4),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    dayLabel,
                    size: 11,
                    color: isToday ? Colors.white70 : AppColors.iconGrey,
                  ),
                  Gap.v(4),
                  AppText(
                    '${day.day}',
                    size: 15,
                    fontWeight: FontWeight.w700,
                    color: isToday ? Colors.white : AppColors.textDark,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}