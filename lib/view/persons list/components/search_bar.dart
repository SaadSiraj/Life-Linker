import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/persons.dart';
import 'package:provider/provider.dart';

class PerspnsSearchBar extends StatelessWidget {
  const PerspnsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PersonsProvider>();

    return Container(
      height: SizeConfig.heightMultiplier * 5.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<PersonsProvider>(
        builder: (_, prov, __) => TextField(
          onChanged: prov.setSearchQuery,
          style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.6,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search by name or notes…',
            hintStyle: TextStyle(
              fontSize: SizeConfig.textMultiplier * 1.6,
              color: AppColors.iconGrey,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: SizeConfig.widthMultiplier * 5,
              color: AppColors.iconGrey,
            ),
            suffixIcon: prov.searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: provider.clearSearch,
                    child: Icon(
                      Icons.close_rounded,
                      size: SizeConfig.widthMultiplier * 4.5,
                      color: AppColors.iconGrey,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
