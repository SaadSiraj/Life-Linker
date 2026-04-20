import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/persons.dart';
import 'package:provider/provider.dart';

class PerspnsListError extends StatelessWidget {
  const PerspnsListError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: SizeConfig.widthMultiplier * 12,
            color: AppColors.iconGrey,
          ),
          Spacing.y(1.5),
          AppText(
            'Could not load people',
            size: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          Spacing.y(1),
          TextButton(
            onPressed: () => context.read<PersonsProvider>().fetchPeople(),
            child: AppText(
              'Retry',
              size: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
