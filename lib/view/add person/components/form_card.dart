import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/person_section.dart';
import 'package:lifelinker/core/widgets/pserson_form_field.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:provider/provider.dart';

class AddPersonFormCard extends StatelessWidget {
  const AddPersonFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, _) {
        return PersonSectionCard(
          title: 'Personal Info',
          icon: Icons.person_outline_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.primary.withOpacity(0.1),
          child: Column(
            children: [
              PersonFormField(
                controller: provider.nameController,
                hint: 'Full Name',
                icon: Icons.badge_outlined,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              SizedBox(height: 12.v),
              PersonFormField(
                controller: provider.phoneController,
                hint: 'Phone Number (optional)',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12.v),
              PersonFormField(
                controller: provider.notesController,
                hint: 'Notes (e.g. "visits every Sunday")',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
            ],
          ),
        );
      },
    );
  }
}