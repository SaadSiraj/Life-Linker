import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:lifelinker/view/add%20person/components/form_card.dart';
import 'package:lifelinker/view/add%20person/components/header.dart';
import 'package:lifelinker/view/add%20person/components/photo_section.dart';
import 'package:lifelinker/view/add%20person/components/relationship_card.dart';
import 'package:lifelinker/view/add%20person/components/save_button.dart';
import 'package:provider/provider.dart';

class AddPersonView extends StatelessWidget {
  const AddPersonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          const AddPersonHeader(),
          Expanded(
            child: Consumer<AddPersonProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.h, 20.v, 16.h, 32.v),
                  child: Form(
                    key: provider.formKey,
                    child: Column(
                      children: [
                        const AddPersonPhotoSection(),
                        SizedBox(height: 24.v),
                        const AddPersonFormCard(),
                        SizedBox(height: 16.v),
                        const AddPersonRelationshipCard(),
                        SizedBox(height: 28.v),
                        AddPersonSaveButton(
                          onSave: (savedPerson) =>
                              Navigator.pop(context, savedPerson),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
