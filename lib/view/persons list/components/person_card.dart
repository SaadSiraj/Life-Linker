import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/known_person.dart';

class PerspnsCard extends StatelessWidget {
  final KnownPerson person;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PerspnsCard({
    super.key,
    required this.person,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowStrong,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3.5),
          child: Row(
            children: [
              _PersonAvatar(person: person),
              SizedBox(width: SizeConfig.widthMultiplier * 3.5),
              Expanded(child: _PersonInfo(person: person)),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              _PersonActions(onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonAvatar extends StatelessWidget {
  final KnownPerson person;

  const _PersonAvatar({required this.person});

  @override
  Widget build(BuildContext context) {
    final color = _relationshipColor(person.relationship);

    return Stack(
      children: [
        Container(
          width: SizeConfig.widthMultiplier * 14,
          height: SizeConfig.widthMultiplier * 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
          ),
          child: person.photoUrl != null
              ? ClipOval(
                  child: Image.network(person.photoUrl!, fit: BoxFit.cover),
                )
              : Center(
                  child: AppText(
                    person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
                    size: 22,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        if (person.hasFaceRegistered)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: SizeConfig.widthMultiplier * 5,
              height: SizeConfig.widthMultiplier * 5,
              decoration: BoxDecoration(
                color: AppColors.successDark,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.face_retouching_natural,
                size: SizeConfig.widthMultiplier * 2.5,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Color _relationshipColor(PersonRelationship r) {
    switch (r) {
      case PersonRelationship.family:
        return AppColors.purple;
      case PersonRelationship.friend:
        return AppColors.amber;
      case PersonRelationship.caregiver:
        return AppColors.successDark;
      case PersonRelationship.doctor:
        return AppColors.blue;
      case PersonRelationship.neighbour:
        return AppColors.orange;
      case PersonRelationship.other:
        return AppColors.iconGrey;
    }
  }
}

class _PersonInfo extends StatelessWidget {
  final KnownPerson person;

  const _PersonInfo({required this.person});

  @override
  Widget build(BuildContext context) {
    final color = _relationshipColor(person.relationship);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          person.name,
          size: 14,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        Spacing.y(0.4),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 2,
                vertical: SizeConfig.heightMultiplier * 0.4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppText(
                '${person.relationship.emoji}  ${person.relationship.label}',
                size: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (person.notes != null && person.notes!.isNotEmpty) ...[
          Spacing.y(0.6),
          AppText(
            person.notes!,
            size: 11,
            color: AppColors.iconGrey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Color _relationshipColor(PersonRelationship r) {
    switch (r) {
      case PersonRelationship.family:
        return AppColors.purple;
      case PersonRelationship.friend:
        return AppColors.amber;
      case PersonRelationship.caregiver:
        return AppColors.successDark;
      case PersonRelationship.doctor:
        return AppColors.blue;
      case PersonRelationship.neighbour:
        return AppColors.orange;
      case PersonRelationship.other:
        return AppColors.iconGrey;
    }
  }
}

class _PersonActions extends StatelessWidget {
  final VoidCallback onDelete;

  const _PersonActions({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onDelete,
          child: Container(
            width: SizeConfig.widthMultiplier * 8,
            height: SizeConfig.widthMultiplier * 8,
            decoration: BoxDecoration(
              color: AppColors.alertLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              size: SizeConfig.widthMultiplier * 4,
              color: AppColors.alert,
            ),
          ),
        ),
        Spacing.y(0.8),
        Container(
          width: SizeConfig.widthMultiplier * 8,
          height: SizeConfig.widthMultiplier * 8,
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.chevron_right_rounded,
            size: SizeConfig.widthMultiplier * 4.5,
            color: AppColors.iconGrey,
          ),
        ),
      ],
    );
  }
}
