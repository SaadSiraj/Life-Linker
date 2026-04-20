import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class HealthAppBar extends StatelessWidget {
  const HealthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4DA3FF), Color(0xFF2A7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.chevron_left_rounded,
                    color: Colors.white, size: 28.h),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: AppText(
                  'Health Data',
                  size: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  align: TextAlign.center,
                ),
              ),
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 22.h),
            ],
          ),
        ),
      ),
    );
  }
}