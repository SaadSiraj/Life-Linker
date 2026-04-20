import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/persons.dart';
import 'package:provider/provider.dart';

class RelationshipFilterChips extends StatelessWidget {
  const RelationshipFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 4.3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(relationship: null, label: 'All'),
          ...PersonRelationship.values.map(
            (r) => _FilterChip(relationship: r, label: r.label),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final PersonRelationship? relationship;
  final String label;

  const _FilterChip({required this.relationship, required this.label});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonsProvider>(
      builder: (_, provider, _) {
        final selected = provider.filterRelationship == relationship;

        return GestureDetector(
          onTap: () => provider.setFilterRelationship(relationship),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(right: SizeConfig.widthMultiplier * 2),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 3.5,
              vertical: SizeConfig.heightMultiplier * 0.8,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderLight,
                width: 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: AppText(
              relationship != null
                  ? '${relationship!.emoji}  $label'
                  : '✦  $label',
              size: 12,
              color: selected ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
