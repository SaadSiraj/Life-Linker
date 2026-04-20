import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/person_section.dart';
import 'package:lifelinker/core/widgets/pserson_relationship_chip.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:provider/provider.dart';

class AddPersonRelationshipCard extends StatelessWidget {
  const AddPersonRelationshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, _) {
        return PersonSectionCard(
          title: 'Relationship',
          icon: Icons.people_alt_rounded,
          iconColor: AppColors.amber,
          iconBg: AppColors.amberLight,
          child: Wrap(
            spacing: 8.h,
            runSpacing: 8.v,
            children: PersonRelationship.values
                .map(
                  (r) => RelationshipChip(
                    relationship: r,
                    isSelected: provider.relationship == r,
                    onTap: () => provider.setRelationship(r),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}