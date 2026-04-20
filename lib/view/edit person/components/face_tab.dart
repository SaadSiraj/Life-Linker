import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/face_info_banner.dart';
import 'package:lifelinker/view/edit%20person/components/face_recognition_card.dart';
import 'package:lifelinker/view/edit%20person/components/face_register_card.dart';
import 'package:lifelinker/view/edit%20person/components/registered_face_card.dart';
import 'package:provider/provider.dart';

class EditPersonFaceTab extends StatelessWidget {
  const EditPersonFaceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 32.v),
          child: Column(
            children: [
              const FaceInfoBanner(),
              SizedBox(height: 16.v),
              const FaceRegisterCard(),
              SizedBox(height: 16.v),
              if (provider.person.faceEmbeddingIds.isNotEmpty) ...[
                const RegisteredFacesCard(),
                SizedBox(height: 16.v),
              ],
              const FaceRecognitionTestCard(),
            ],
          ),
        );
      },
    );
  }
}