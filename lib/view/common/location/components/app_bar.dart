import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class LocationAppBar extends StatelessWidget {
  const LocationAppBar({super.key});

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
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 1.5,
          ),
          child: Row(
            children: [
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Expanded(
                child: AppText(
                  'Patient Location',
                  size: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  align: TextAlign.center,
                ),
              ),
              Icon(
                Icons.my_location_rounded,
                color: Colors.white,
                size: SizeConfig.widthMultiplier * 5.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}