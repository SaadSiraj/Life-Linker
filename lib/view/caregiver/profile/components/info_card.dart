import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<ProfileInfoRow> rows;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 8,
                height: SizeConfig.widthMultiplier * 8,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: SizeConfig.widthMultiplier * 4.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5),
              AppText(
                title,
                size: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Spacing.y(1.5),
          ...rows.map((row) => _buildRow(row)),
        ],
      ),
    );
  }

  Widget _buildRow(ProfileInfoRow row) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1.2),
      child: Row(
        children: [
          Icon(
            row.icon,
            size: SizeConfig.widthMultiplier * 4.5,
            color: AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          AppText(
            '${row.label}:  ',
            size: 12,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: AppText(
              row.value.isEmpty ? 'Not specified' : row.value,
              size: 13,
              color: row.value.isEmpty
                  ? AppColors.iconGrey
                  : AppColors.textDark,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoRow {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
}
